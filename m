From: Joe Lawrence <joe.lawrence@redhat.com>
Subject: Spurious DISK_EVENT_MEDIA_CHANGE on USB DVD hotplug?
Date: Thu, 10 Aug 2017 10:45:54 -0400
Message-ID: <c22ebffe-cf80-c3ef-2bd9-6b3b66271226@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49798 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752317AbdHJOp6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Aug 2017 10:45:58 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, Kay Sievers <kay@vrfy.org>, linux-scsi@vger.kernel.org

Hi Tejun, Kay,

I'm investigating a customer report which manifests itself all the way
up in gnome-session when a BMC hotplug-adds a simulated DVD device.  The
user logs into their server's BMC and enables "media redirection", an
emulated DVD device + .iso is dynamically added to the bus... in the
past this has worked well, however, they are now noticing a timing
condition on RHEL7 that prevents gnome from successfully auto-mounting
the DVD media.

With Harald's help, I've done some debugging and we've found out that on
hotplug-add, the kernel sends two uevents (ADD, CHANGE) in short
succession.

(Example with an ordinary, physical USB DVD device on my laptop, is
very similar):

% udevadm monitor -k -e

  KERNEL[2409061.130338] add      /devices/pci0000:00/0000:00:14.0/usb3/3-9/3-9.3/3-9.3:1.0/host20/target20:0:0/20:0:0:0/block/sr1 (block)
  ACTION=add
  DEVNAME=/dev/sr1
  DEVPATH=/devices/pci0000:00/0000:00:14.0/usb3/3-9/3-9.3/3-9.3:1.0/host20/target20:0:0/20:0:0:0/block/sr1
  DEVTYPE=disk
  MAJOR=11
  MINOR=1
  SEQNUM=5885
  SUBSYSTEM=block

  ...

  KERNEL[2409061.134076] change   /devices/pci0000:00/0000:00:14.0/usb3/3-9/3-9.3/3-9.3:1.0/host20/target20:0:0/20:0:0:0/block/sr1 (block)
  ACTION=change
  DEVNAME=/dev/sr1
  DEVPATH=/devices/pci0000:00/0000:00:14.0/usb3/3-9/3-9.3/3-9.3:1.0/host20/target20:0:0/20:0:0:0/block/sr1
  DEVTYPE=disk
> DISK_MEDIA_CHANGE=1
  MAJOR=11
  MINOR=1
  SEQNUM=5889
  SUBSYSTEM=block

(Both of these events trigger a call out to the 'cdrom_id' userspace
program, the latter of which interferes with the gnome-session
auto-mounting feature.)

With a systemtap probe, I can also see that there are four userspace
openers of the cdrom when it is added:

  (parent)            -> (child)             : system-tap probe-point
-----------------------------------------------------------------------
> systemd-udevd(849)  -> systemd-udevd(6783) : module("cdrom").function("cdrom_open@drivers/cdrom/cdrom.c:980")
  systemd-udevd(6783) -> cdrom_id(6791)      : module("cdrom").function("cdrom_open@drivers/cdrom/cdrom.c:980")
  systemd-udevd(849)  -> systemd-udevd(6783) : module("cdrom").function("cdrom_open@drivers/cdrom/cdrom.c:980")
  systemd-udevd(6783) -> cdrom_id(6794)      : module("cdrom").function("cdrom_open@drivers/cdrom/cdrom.c:980")

where on the first opener, the kernel eventually invokes
sr_mod::sr_check_events() and gets a DISK_EVENT_MEDIA_CHANGE return
code.

In the case of my USB DVD -> laptop example, there is no media in my
device, however I still see the DISK_EVENT_MEDIA_CHANGE event.  This is
a bit confusing, and I was wondering if there was an explanation for
the following:

drivers/scsi/sr.c :: sr_probe()

        disk->events = DISK_EVENT_MEDIA_CHANGE | DISK_EVENT_EJECT_REQUEST;
        ...
        cd->media_present = 1;

DISK_EVENT_MEDIA_CHANGE events will pass through to userspace and
for some reason cd->media_present defaults to 1?  More on that below...


drivers/scsi/sr.c :: sr_check_events()

        ...
do_tur:
        /* let's see whether the media is there with TUR */
        last_present = cd->media_present;
        ret = scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr);

        /*
         * Media is considered to be present if TUR succeeds or fails with
         * sense data indicating something other than media-not-present
         * (ASC 0x3a).
         */
        cd->media_present = scsi_status_is_good(ret) ||
                (scsi_sense_valid(&sshdr) && sshdr.asc != 0x3a);

        if (last_present != cd->media_present)
                cd->device->changed = 1;

        if (cd->device->changed) {
                events |= DISK_EVENT_MEDIA_CHANGE;
                cd->device->changed = 0;
                cd->tur_changed = true;
        }
        ...

sr_check_events() compares the previous (in this case, default)
media_present value with what the TUR returns.  If it has changed, then
turn on the DISK_EVENT_MEDIA_CHANGE event bit.

In my laptop USB DVD case, !scsi_status_is_good and sshdr.asc == 0x3a,
so last_present (1) and cd->media_present (0) mis-compare and the change
event is set.  That does not seem intuitive to me, is this a bug?

Bringing this back to the reported BMC case, which presumably does have
"media" present in the virtual device... is it reasonable to expect a
DISK_EVENT_MEDIA_CHANGE even for a new device that contains media?  (I
haven't verified, but in this case GET_EVENT_STATUS_NOTIFICATION might
be enough to set media present.)

If there is documentation that explains DISK_EVENT_MEDIA_CHANGE conditions
somewhere, feel free to point me there.

Thanks,

-- Joe
