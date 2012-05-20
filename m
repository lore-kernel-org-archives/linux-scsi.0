From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 12/12] scsi_transport_sas: fix delete vs scan race
Date: Sun, 20 May 2012 12:20:06 -0700
Message-ID: <CAA9_cmeL5h_5xESis06pyT-7bt+K2eQrN5SR6_b25qLBSDVXvA@mail.gmail.com>
References: <20120413233343.8025.18101.stgit@dwillia2-linux.jf.intel.com>
	<20120413233752.8025.97983.stgit@dwillia2-linux.jf.intel.com>
	<1335091115.13208.14.camel@dabdike.lan>
	<CABE8wwssa-_MsCTe0FJeCLY5KTk1sRcsmUjF8Sb-5sofc=zuFQ@mail.gmail.com>
	<1335114924.13208.27.camel@dabdike.lan>
	<CAA9_cmcCQtyRBEt-c8EP6wuSukqZn0Mswxi3nDG7R-88L57BjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmcCQtyRBEt-c8EP6wuSukqZn0Mswxi3nDG7R-88L57BjA@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Dariusz Majchrzak <dariusz.majchrzak@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, May 5, 2012 at 2:52 PM, Dan Williams <dan.j.williams@intel.com>=
 wrote:
> On Sun, Apr 22, 2012 at 10:15 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
>> Async scan here means any scan in a different thread, right ... it j=
ust
>> has to be asynchronous relative to us? =A0So that includes the manua=
lly
>> initiated ones and hotplug ones, doesn't it?
>
> [ resend since I notice this never hit the lists ]
>
> Hmm, well no I don't think so. =A0This literally means the initial as=
ync
> scan, and the
> failure window is between when we skip the call to
> scsi_sysfs_add_sdev() (in scsi_add_lun() under the scan_mutex) and
> finally call scsi_sysfs_add_sdev() again via scsi_finish_async_scan()=
=2E
> I don't see how that fixes it because when we fail the sequence goes:
>
> mutex_lock(scan_mutex)
> starget->parent =3D end_device;
> scsi_add_lun()
> mutex_unlock(scan_mutex)
>
> device_del(end_device)
>
> mutex_lock(scan_mutex)
> device_add(starget)
> <crash>
>
> As far as I can see taking the scan_mutex in sas_rphy_remove() does
> not change this failure window. =A0Unless I missed something?
>
> I am going to re-submit this patch as is with the proposed libsas bat=
ch for 3.5.

It turns out this patch can cause a deadlock in the scenario where we
have two hosts scanning and the "previous" host (according to the
async scan queue), experiences a device removal event.  I think the
following should be all we need:

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 01b0374..8906557 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1714,6 +1714,9 @@ static void scsi_sysfs_add_devices(struct
Scsi_Host *shost)
 {
        struct scsi_device *sdev;
        shost_for_each_device(sdev, shost) {
+               /* target removed before the device could be added */
+               if (sdev->sdev_state =3D=3D SDEV_DEL)
+                       continue;
                if (!scsi_host_scan_allowed(shost) ||
                    scsi_sysfs_add_sdev(sdev) !=3D 0)
                        __scsi_remove_device(sdev);

=2E..since starget removal will mark the sdevs as deleted under
scan_mutex.  scsi_sysfs_add_devices can simply ignore deleted devices.
 I'll post this patch after Darek has a chance to try it out.

--
Dan
