From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [PATCH ]  mptfusion - Bad SCSI performance Fix
Date: Fri, 18 Nov 2005 10:10:28 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C04F85BDE@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C5EC62.F9548580"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:31963 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1030186AbVKRRKe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2005 12:10:34 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id jAIH5lSW026716
	for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2005 09:05:47 -0800 (PST)
Received: from nacos172.ad.lsil.com (cos1.co.lsil.com [172.21.35.122])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id jAIHATRl021868
	for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2005 09:10:29 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C5EC62.F9548580
Content-Type: text/plain

This should solve all the bad perf woes for 
mptfusion - for U320.  

* They syncronization between domain validation
and bring up of the 2nd channel has moved; around
mptscsih_doDv().  

*The syncronization timeout is increased to 30 seconds, 
to be in line with the port enble timeout.

This patch is to be applied over the 7 patches I posted
earlier this weeek; at this URL:

http://marc.theaimsgroup.com/?l=linux-scsi&m=113219282203417&w=2

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>




------_=_NextPart_000_01C5EC62.F9548580
Content-Type: application/octet-stream;
	name="8-perf-fix2.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="8-perf-fix2.patch"

diff -uarN b/drivers/message/fusion/mptbase.c =
a/drivers/message/fusion/mptbase.c=0A=
--- b/drivers/message/fusion/mptbase.c	2005-11-16 18:20:14.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/mptbase.c	2005-11-18 09:54:27.000000000 =
-0700=0A=
@@ -1125,7 +1125,7 @@=0A=
 int=0A=
 mpt_alt_ioc_wait(MPT_ADAPTER *ioc)=0A=
 {=0A=
-	int loop_count =3D 15 * 4;  /* Wait 15 seconds */=0A=
+	int loop_count =3D 30 * 4;  /* Wait 30 seconds */=0A=
 	int status =3D -1; /* -1 means failed to get board READY */=0A=
 =0A=
 	do {=0A=
diff -uarN b/drivers/message/fusion/mptscsih.c =
a/drivers/message/fusion/mptscsih.c=0A=
--- b/drivers/message/fusion/mptscsih.c	2005-11-16 18:13:35.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/mptscsih.c	2005-11-18 09:48:15.000000000 =
-0700=0A=
@@ -3717,20 +3717,11 @@=0A=
 		return -EFAULT;=0A=
 	}=0A=
 =0A=
-	if(mpt_alt_ioc_wait(hd->ioc)!=3D0) {=0A=
-		ddvprintk((MYIOC_s_WARN_FMT "alt_ioc busy!\n",=0A=
-		    hd->ioc->name));=0A=
-		return -EBUSY;=0A=
-	}=0A=
-=0A=
 	/* Get and Populate a free Frame=0A=
 	 */=0A=
 	if ((mf =3D mpt_get_msg_frame(hd->ioc->InternalCtx, hd->ioc)) =3D=3D =
NULL) {=0A=
 		ddvprintk((MYIOC_s_WARN_FMT "No msg frames!\n",=0A=
 					hd->ioc->name));=0A=
-		spin_lock(&hd->ioc->initializing_hba_lock);=0A=
-		hd->ioc->initializing_hba_lock_flag=3D0;=0A=
-		spin_unlock(&hd->ioc->initializing_hba_lock);=0A=
 		return -EBUSY;=0A=
 	}=0A=
 =0A=
@@ -3820,9 +3811,6 @@=0A=
 	add_timer(&hd->timer);=0A=
 	mpt_put_msg_frame(hd->ioc->InternalCtx, hd->ioc, mf);=0A=
 	wait_event(hd->scandv_waitq, hd->scandv_wait_done);=0A=
-	spin_lock(&hd->ioc->initializing_hba_lock);=0A=
-	hd->ioc->initializing_hba_lock_flag=3D0;=0A=
-	spin_unlock(&hd->ioc->initializing_hba_lock);=0A=
 =0A=
 	if (hd->pLocal) {=0A=
 		rc =3D hd->pLocal->completion;=0A=
@@ -4094,6 +4082,12 @@=0A=
 						}=0A=
 					}=0A=
 =0A=
+					if(mpt_alt_ioc_wait(hd->ioc)!=3D0) {=0A=
+						ddvprintk((MYIOC_s_WARN_FMT "alt_ioc busy!\n",=0A=
+						    hd->ioc->name));=0A=
+						continue;=0A=
+					}=0A=
+=0A=
 					if (mptscsih_doDv(hd, 0, id) =3D=3D 1) {=0A=
 						/* Untagged device was busy, try again=0A=
 						 */=0A=
@@ -4105,6 +4099,10 @@=0A=
 						hd->ioc->spi_data.dvStatus[id] &=3D ~(MPT_SCSICFG_DV_NOT_DONE | =
MPT_SCSICFG_DV_PENDING);=0A=
 					}=0A=
 =0A=
+					spin_lock(&hd->ioc->initializing_hba_lock);=0A=
+					hd->ioc->initializing_hba_lock_flag=3D0;=0A=
+					spin_unlock(&hd->ioc->initializing_hba_lock);=0A=
+=0A=
 					if (isPhysDisk) {=0A=
 						for (ii=3D0; ii < MPT_MAX_SCSI_DEVICES; ii++) {=0A=
 							if (hd->ioc->raid_data.isRaid & (1 << ii)) {=0A=

------_=_NextPart_000_01C5EC62.F9548580--
