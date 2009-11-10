From: Takahiro Yasui <tyasui@redhat.com>
Subject: [PATCH][RESEND] scsi_devinfo: update Hitachi entries (v2)
Date: Tue, 10 Nov 2009 16:22:19 -0500
Message-ID: <4AF9D98B.9030605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265AbZKJQWS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Nov 2009 11:22:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org

Hi James,

I posted the updated patch to update the Hitachi entries of scsi devinfo
on September 29th. Could you tell me if the patch is acceptable or I need
to do something for it? Please let me resend it.


On 06/26/09 20:18, Takahiro Yasui wrote:
> I will evaluate BLIST_ATTACH_PQ3 flags on our storages, and post
> the result here. Please give me some time.

On the test with the BLIST_ATTACH_PQ3 flag on Hitachi storages,
existing disks were detected as expected, However, LU#0 is also
recognized like a existing disk and it is displayed as follows in
/proc/scsi/scsi.

Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: HITACHI  Model: DISK-SUBSYSTEM   Rev: 6006
  Type:   Unknown                          ANSI SCSI revision: 02

In addition, LU#0 is detected as sg0 and the real devices are assigned
to sg1, sg2...

<with the BLIST_ATTACH_PQ3 flag>
kernel: scsi 1:0:0:0: Attached scsi generic sg0 type 31
kernel: sd 1:0:0:1: Attached scsi generic sg1 type 0
...

<without the BLIST_ATTACH_PQ3 flag>
kernel: sd 1:0:0:1: Attached scsi generic sg0 type 0
kernel: sd 1:0:0:2: Attached scsi generic sg1 type 0
...

This behavior is not consistent with other disks, and it is better that
noexistent disk, LU#0, is not detected. Once again, I appreciate your
comments on the necessity of the BLIST_ATTACH_PQ3 flag.

In addition, I added one more flag change about the DISK-SUBSYSTEM model
in my patch. The DISK-SUBSYSTEM is a special model name returned when LUs
are not installed. For example, when LU#0 is not installed in "OPEN-"
models, LU#0 is detected as the DISK-SUBSYSTEM model. The DISK-SUBSYSTEM
model also requires the BLIST_REPORTLUN2 flag.


-----
This is scsi_devinfo flag updates for the Hitachi storages.

Four models, OPEN-/DF400/DF500/DISK-SUBSYSTEM, can handle REPORT_LUN,
and the BLIST_REPORTLUN2 flag needs to be set. And DF600 doesn't require
any flags because it returns ANSI 03h (SPC).


Signed-off-by: Takahiro Yasui <tyasui@redhat.com>
---
 drivers/scsi/scsi_devinfo.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

Index: linux-2.6.31.1/drivers/scsi/scsi_devinfo.c
===================================================================
--- linux-2.6.31.1.orig/drivers/scsi/scsi_devinfo.c
+++ linux-2.6.31.1/drivers/scsi/scsi_devinfo.c
@@ -168,11 +168,10 @@ static struct {
 	{"Generic", "USB SD Reader", "1.00", BLIST_FORCELUN | BLIST_INQUIRY_36},
 	{"Generic", "USB Storage-SMC", "0180", BLIST_FORCELUN | BLIST_INQUIRY_36},
 	{"Generic", "USB Storage-SMC", "0207", BLIST_FORCELUN | BLIST_INQUIRY_36},
-	{"HITACHI", "DF400", "*", BLIST_SPARSELUN},
-	{"HITACHI", "DF500", "*", BLIST_SPARSELUN},
-	{"HITACHI", "DF600", "*", BLIST_SPARSELUN},
-	{"HITACHI", "DISK-SUBSYSTEM", "*", BLIST_ATTACH_PQ3 | BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"HITACHI", "OPEN-E", "*", BLIST_ATTACH_PQ3 | BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"HITACHI", "DF400", "*", BLIST_REPORTLUN2},
+	{"HITACHI", "DF500", "*", BLIST_REPORTLUN2},
+	{"HITACHI", "DISK-SUBSYSTEM", "*", BLIST_REPORTLUN2},
+	{"HITACHI", "OPEN-", "*", BLIST_REPORTLUN2},
 	{"HITACHI", "OP-C-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"HITACHI", "3380-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"HITACHI", "3390-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},

Regards,
-- 
Takahiro Yasui
Hitachi Computer Products (America), Inc.

