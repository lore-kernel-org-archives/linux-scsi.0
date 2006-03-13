From: Adrian Bunk <bunk@stusta.de>
Subject: [RFC: -mm patch] remove drivers/message/fusion/mptscsih.c:mptscsih_setDevicePage1Flags()
Date: Mon, 13 Mar 2006 22:16:59 +0100
Message-ID: <20060313211659.GI13973@stusta.de>
References: <20060312031036.3a382581.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:15 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S932240AbWCMVRA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Mar 2006 16:17:00 -0500
Content-Disposition: inline
In-Reply-To: <20060312031036.3a382581.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, support@lsil.com
Cc: linux-kernel@vger.kernel.org, mpt_linux_developer@lsil.com, linux-scsi@vger.kernel.org

On Sun, Mar 12, 2006 at 03:10:36AM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.16-rc5-mm3:
>...
>  git-scsi-misc.patch
>...
>  git trees
>...


This function no longer has any user.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/message/fusion/mptscsih.c |   49 ------------------------------
 1 file changed, 49 deletions(-)

--- linux-2.6.16-rc6-mm1-full/drivers/message/fusion/mptscsih.c.old	2006-03-13 21:28:56.000000000 +0100
+++ linux-2.6.16-rc6-mm1-full/drivers/message/fusion/mptscsih.c	2006-03-13 21:29:10.000000000 +0100
@@ -2783,55 +2783,6 @@
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/*
- *  SCSI Config Page functionality ...
- */
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/*	mptscsih_setDevicePage1Flags  - add Requested and Configuration fields flags
- *	based on width, factor and offset parameters.
- *	@width: bus width
- *	@factor: sync factor
- *	@offset: sync offset
- *	@requestedPtr: pointer to requested values (updated)
- *	@configurationPtr: pointer to configuration values (updated)
- *	@flags: flags to block WDTR or SDTR negotiation
- *
- *	Return: None.
- *
- *	Remark: Called by writeSDP1 and _dv_params
- */
-static void
-mptscsih_setDevicePage1Flags (u8 width, u8 factor, u8 offset, int *requestedPtr, int *configurationPtr, u8 flags)
-{
-	u8 nowide = flags & MPT_TARGET_NO_NEGO_WIDE;
-	u8 nosync = flags & MPT_TARGET_NO_NEGO_SYNC;
-
-	*configurationPtr = 0;
-	*requestedPtr = width ? MPI_SCSIDEVPAGE1_RP_WIDE : 0;
-	*requestedPtr |= (offset << 16) | (factor << 8);
-
-	if (width && offset && !nowide && !nosync) {
-		if (factor < MPT_ULTRA160) {
-			*requestedPtr |= (MPI_SCSIDEVPAGE1_RP_IU + MPI_SCSIDEVPAGE1_RP_DT);
-			if ((flags & MPT_TARGET_NO_NEGO_QAS) == 0)
-				*requestedPtr |= MPI_SCSIDEVPAGE1_RP_QAS;
-			if (flags & MPT_TAPE_NEGO_IDP)
-				*requestedPtr |= 0x08000000;
-		} else if (factor < MPT_ULTRA2) {
-			*requestedPtr |= MPI_SCSIDEVPAGE1_RP_DT;
-		}
-	}
-
-	if (nowide)
-		*configurationPtr |= MPI_SCSIDEVPAGE1_CONF_WDTR_DISALLOWED;
-
-	if (nosync)
-		*configurationPtr |= MPI_SCSIDEVPAGE1_CONF_SDTR_DISALLOWED;
-
-	return;
-}
-
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*	mptscsih_writeIOCPage4  - write IOC Page 4
  *	@hd: Pointer to a SCSI Host Structure
  *	@target_id: write IOC Page4 for this ID & Bus

