From: "Ke Wei" <kewei.mv@gmail.com>
Subject: Re: [PATCH] mvsas: fix default can_queue
Date: Thu, 6 Mar 2008 22:46:56 +0800
Message-ID: <6b2481670803060646m54675625g729a82c4da33ce05@mail.gmail.com>
References: <1204308113.4003.45.camel@localhost.localdomain>
	 <1204504945.3069.30.camel@localhost.localdomain>
	 <6b2481670803030017h43da68bcxd78a6142f8f5c6bb@mail.gmail.com>
	 <1204556371.3043.7.camel@localhost.localdomain>
	 <1204682849.3091.95.camel@localhost.localdomain>
	 <1204750960.3047.67.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:47330 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760934AbYCFOq5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 09:46:57 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2268138wah.23
        for <linux-scsi@vger.kernel.org>; Thu, 06 Mar 2008 06:46:56 -0800 (PST)
In-Reply-To: <1204750960.3047.67.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, jgarzik <jgarzik@redhat.com>

On Thu, Mar 6, 2008 at 5:02 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:

1.
> >
> > OK, I instrumented more ... you're right, the first failing command is
> > REPORT_LUNS.  The failure isn't because the DVD doesn't accept the
> > command, but because it gets errored and we fail to report back the
> > error data.

First, I noticed that scsi_probe_and_add_lun function has changed
since v2.6.17-git4.
It will cause bflagsp to miss BLIST_NOREPORTLUN flag after calling scsi_add_lun.
On the other hand,  Even though mvsas driver can succeed in reporting
back the error data, scsi subsystem also will force device to reset
because of wrong REPORTLUN status. But Error again, then reset.
Maybe I may write simulation codes for this command.


 2.6.17-git4:
 /**
  * scsi_probe_and_add_lun - probe a LUN, if a LUN is found add it
@@ -880,10 +906,12 @@ static int scsi_probe_and_add_lun(struct
    if (scsi_probe_lun(sdev, result, result_len, &bflags))
       goto out_free_result;

+   if (bflagsp)
+      *bflagsp = bflags;
    /*
     * result contains valid SCSI INQUIRY data.
     */
-   if ((result[0] >> 5) == 3) {
+   if (((result[0] >> 5) == 3) && !(bflags & BLIST_ATTACH_PQ3)) {
       /*
        * For a Peripheral qualifier 3 (011b), the SCSI
        * spec says: The device server is not capable of
@@ -894,9 +922,22 @@ static int scsi_probe_and_add_lun(struct
        * logical disk configured at sdev->lun, but there
        * is a target id responding.
        */
-      SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
-               "scsi scan: peripheral qualifier of 3,"
-               " no device added\n"));
+      SCSI_LOG_SCAN_BUS(2, sdev_printk(KERN_INFO, sdev, "scsi scan:"
+               " peripheral qualifier of 3, device not"
+               " added\n"))
+      if (lun == 0) {
+         SCSI_LOG_SCAN_BUS(1, {
+            unsigned char vend[9];
+            unsigned char mod[17];
+
+            sdev_printk(KERN_INFO, sdev,
+               "scsi scan: consider passing scsi_mod."
+               "dev_flags=%s:%s:0x240 or 0x800240\n",
+               scsi_inq_str(vend, result, 8, 16),
+               scsi_inq_str(mod, result, 16, 32));
+         });
+      }
+
       res = SCSI_SCAN_TARGET_PRESENT;
       goto out_free_result;
    }
@@ -920,8 +961,6 @@ static int scsi_probe_and_add_lun(struct
          sdev->lockable = 0;
          scsi_unlock_floptical(sdev, result);
       }
-      if (bflagsp)
-         *bflagsp = bflags;
    }


2.
> As a work around until the NCQ issue is fixed, this will allow can_queue
> to be raised while still forcing all ATA devices to the non-NCQ case.
>
> Also, can can_queue be set to MVS_CHIP_SLOT_SZ - 1?  It seems like a
> reasonable default.

I also test failed. By far, can_queue only be set to 1. I will keep on
investigating.

3.
> The good news is that with this change, I'm getting a respectable
> throughput on the fio hammer test; plus zapping random phy resets across
> the disk triggers error handler recovery correctly (so far).

I fixed it because of a register mistake. And I'm testing for the follow patch.

-- 
Best Regards,
Ke Wei
