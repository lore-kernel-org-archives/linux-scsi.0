From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Spinup of SCSI Disks: allow_restart won't work on 2.6.18
Date: Tue, 21 Nov 2006 00:53:45 +0100
Message-ID: <45624009.3040208@s5r6.in-berlin.de>
References: <455DF39A.6090209@fbihome.de> <455E2D44.5030903@gmx.de> <455E4703.3080005@s5r6.in-berlin.de> <456188FD.3020108@fbihome.de> <45619611.5020502@s5r6.in-berlin.de> <45622CF5.507@fbihome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:7297 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S966885AbWKTXzd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Nov 2006 18:55:33 -0500
In-Reply-To: <45622CF5.507@fbihome.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joern Quillman <quillman@fbihome.de>
Cc: linux-scsi@vger.kernel.org

Joern Quillman wrote:
>>> One problem left. I still can't set or unset the flag with echo even
>>> on 2.6.19-rc6 (as root).
...
> Permissions of the file are -rw-r--r--. Owner is of course root.
> As I wrote before I can set/unset the flag without any problems when I
> connect a dumb USB<->IDE
> converter with kernel 2.6.18. Same with 2.6.19-rc6.
> 
> The complete error message (sorry it's in german here) is:
> "-bash: echo: write error: Das Argument ist ungueltig"
> 
> Is there a way to do some debug on the internals to see why the
> attribute isn't actually writeable? Do you need parts of the kernel log?

The responsible kernel code is drivers/scsi/sd.c::sd_store_allow_restart().

static ssize_t sd_store_allow_restart(struct class_device *cdev, const
char *buf,
				      size_t count)
{
	struct scsi_disk *sdkp = to_scsi_disk(cdev);
	struct scsi_device *sdp = sdkp->device;

	if (!capable(CAP_SYS_ADMIN))
		return -EACCES;

	if (sdp->type != TYPE_DISK)
		return -EINVAL;

	sdp->allow_restart = simple_strtoul(buf, NULL, 10);

	return count;
}


I think the solution is easy: Replace if (sdp->type != TYPE_DISK) by

	if (sdp->type != TYPE_DISK && sdp->type != TYPE_RBC)

As you can see further below in your log, most SBP-2 disks implement the
RBC command set, i.e. are a somewhat special kind of SCSI HDD. I suppose
I grabbed one of the rare SBP-2 disks which pose as TYPE_DISK when I
tested to write to the allow_restart attribute.

I will try this modification here too and send a proper patch to the
list if my line of thinking is correct.

> A new problem just arised:
> When I switch on the external enclosure with 3 bridges and 3 disks a few
> seconds "before" I plug the firewire connector into the PC everything
> works.
> But when I first plug in the connector and turn on the external
> enclosure later, 2.6.19-rc6 hangs on the first disk and throws a BUG
> message.
> I have to reboot the PC then and I reproduced it serveral times.
> 
> ------------------snip----------------------------------
> ieee1394: Error parsing configrom for node 0-00:1023
> ieee1394: Error parsing configrom for node 0-01:1023
> ieee1394: Error parsing configrom for node 0-02:1023
> ieee1394: Node changed: 0-00:1023 -> 0-03:1023
> ieee1394: Node added: ID:BUS[0-00:1023]  GUID[0001d20000091ab2]
> ieee1394: Node added: ID:BUS[0-01:1023]  GUID[0001d20000093c4d]
> ieee1394: Error parsing configrom for node 0-02:1023
> scsi0 : SBP-2 IEEE-1394
> ieee1394: sbp2: Logged into SBP-2 device
> ieee1394: Node 0-00:1023: Max speed [S400] - Max payload [1024]
> scsi 0:0:0:0: Direct-Access-RBC Maxtor 4 D080H4           DAK0 PQ: 0
> ANSI: 4
> scsi1 : SBP-2 IEEE-1394
> SCSI device sda: 160086528 512-byte hdwr sectors (81964 MB)
> sda: Write Protect is off
> sda: Mode Sense: 11 00 00 00
> SCSI device sda: drive cache: write back
> SCSI device sda: 160086528 512-byte hdwr sectors (81964 MB)
> sda: Write Protect is off
> sda: Mode Sense: 11 00 00 00
> SCSI device sda: drive cache: write back
> sda: sda1
> sd 0:0:0:0: Attached scsi disk sda
> ieee1394: sbp2: Error logging into SBP-2 device - timed out
> sbp2: probe of 0001d20000093c4d-0 failed with error -16

This should not be a problem per se, although it won't be possible to
actually use the disk after a login failure of course.

I see from the GUIDs that the bridges were made by MacPower. They used
to build them with the fine Oxford Semi SBP-2 bridges only, but some
time ago they also used Prolific PL3507 for IEEE 1394A + USB 2.0 combo
devices. I have 3 Oxford based MacPower enclosures and 1 Prolific based,
and the latter behaves quite crappy. I get a lot of login failures on a
1394b host and occasional login failures on a 1394a host. Somebody else
with, I believe, the same device as mine could fix this with a firmware
update from http://www.prolific.com.tw/eng/downloads.asp?ID=44 (site is
down right now, once again).

You said you have OXFW bridges, but do you know this from looking at the
chips or merely from a spec sheet?

> ------------[ cut here ]------------
> kernel BUG at fs/sysfs/file.c:460!
> invalid opcode: 0000 [#1]
> SMP
> Modules linked in: sd_mod nfs nfsd exportfs lockd nfs_acl sunrpc button
> ac battery ipv6 de4x5 dm_snapshot dm_mirror dm_mod sr_mod sbp2 scsi_mod
> ehci_hcd ohci_hcd tulip joydev tsdev pcmcia firmware_class evdev
> i810_audio ac97_codec psmouse serio_raw floppy snd_intel8x0 yenta_socket
> snd_ac97_codec snd_ac97_bus rsrc_nonstatic pcmcia_core snd_pcm snd_timer
> snd soundcore snd_page_alloc parport_pc parport i2c_piix4 pcspkr
> i2c_core rtc ext3 jbd mbcache ide_generic ide_cd cdrom ide_disk uhci_hcd
> piix generic ide_core usbcore ohci1394 ieee1394 thermal processor fan
> CPU:    0
> EIP:    0060:[<c01966c6>]    Not tainted VLI
> EFLAGS: 00010202   (2.6.19-rc6 #1)
> EIP is at sysfs_create_file+0x19/0x31
> eax: c7d03800   ebx: cc85f12c   ecx: c7d038b0   edx: cc85f101
> esi: cc85f12c   edi: 00000000   ebp: c7d03800   esp: cb5f1eb8
> ds: 007b   es: 007b   ss: 0068
> Process knodemgrd_0 (pid: 549, ti=cb5f0000 task=cb595ab0 task.ti=cb5f0000)
> Stack: c7d03838 c021ed64 c7d03838 00000001 c7d03994 cc84f029 c7d03a14 00000014
>       cc853f32 cae3f0f4 00000000 cae3f000 fffffffc c7d03800 ccc6b000 00000000
>       00000000 cc84f45c fffffffc ccafd058 cae3f000 cb65d3f8 00000000 01afd058
> Call Trace:
> [<c021ed64>] device_create_file+0x1c/0x2b
> [<cc84f029>] nodemgr_register_device+0xd0/0x150 [ieee1394]
> [<cc84f45c>] nodemgr_process_unit_directory+0x333/0x348 [ieee1394]
> [<cc84f668>] nodemgr_probe_ne+0x183/0x37a [ieee1394]
> [<cc850204>] nodemgr_host_thread+0x827/0x970 [ieee1394]
> [<cc84f9dd>] nodemgr_host_thread+0x0/0x970 [ieee1394]
> [<c01304d2>] kthread+0xc2/0xf0
> [<c0130410>] kthread+0x0/0xf0
> [<c01038bb>] kernel_thread_helper+0x7/0x10
> =======================
> Code: 83 c0 74 e8 65 08 10 00 89 e8 83 c4 10 5b 5e 5f 5d c3 85 c0 89 c1
> 53 89 d3 74 10 83 78 30 00 0f 94 c2 85 db 0f 94 c0 08 c2 74 08 <0f> 0b
> cc 01 d0 56 2b c0 8b 41 30 89 da b9 04 00 00 00 5b e9 5e
> EIP: [<c01966c6>] sysfs_create_file+0x19/0x31 SS:ESP 0068:cb5f1eb8

Hmm. This is not good. Maybe the ieee1394 driver received garbage data
from the device's configuration ROM and sysfs blew up subsequently. I'm
not sure if this is a realistic scenario and if so, which kinds of
sanity checks might be missing in ieee1394. I'll check this
eventually... Although if you can reproduce this bug, I could send you a
patch with a bunch of printk's to narrow the offending sysfs attribute down.
-- 
Stefan Richter
-=====-=-==- =-== =-=-=
http://arcgraph.de/sr/
