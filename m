From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH 1/2] replace sizeof sense_buffer with SCSI_SENSE_BUFFERSIZE
Date: Thu, 3 Jan 2008 11:10:04 -0500
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01010A4697@otce2k301.adaptec.com>
References: <5dc13e4823ec8c254e5164a51249f05983fa00c2.tomof@acm.org> <20080103135905X.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:43541 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217AbYACQKG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jan 2008 11:10:06 -0500
Content-class: urn:content-classes:message
In-Reply-To: <20080103135905X.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, benh@kernel.crashing.org, fujita.tomonori@lab.ntt.co.jp

ACK on aacraid/ips/dpt_i2o bits. Inspected others, this patch IS inert.

NitMeBeingStupidAndAddingARiderToTheBill: I know it was a grep/replace.
If you need to respin because of Boaz and do not mind, do not hesitate
to optimize (?) and instead do:

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 70f48a1..c6380c0 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -2298,7 +2298,6 @@ static s32 adpt_i2o_to_scsi(void __iomem *reply,
struct scsi_cmnd* cmd)
 		// copy over the request sense data if it was a check
 		// condition status
-		if(dev_status == 0x02 /*CHECK_CONDITION*/) {
-			u32 len = sizeof(cmd->sense_buffer);
-			len = (len > 40) ?  40 : len;
+		if (dev_status == 0x02 /*CHECK_CONDITION*/) {
+			u32 len = (SCSI_SENSE_BUFFERSIZE > 40) ?  40 :
SCSI_SENSE_BUFFERSIZE;
 			// Copy over the sense data
 			memcpy_fromio(cmd->sense_buffer, (reply+28) ,
len);

Sincerely -- Mark Salyzyn
 
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of FUJITA Tomonori
> Sent: Wednesday, January 02, 2008 11:57 PM
> To: James.Bottomley@HansenPartnership.com
> Cc: linux-scsi@vger.kernel.org; benh@kernel.crashing.org; 
> fujita.tomonori@lab.ntt.co.jp
> Subject: [PATCH 1/2] replace sizeof sense_buffer with 
> SCSI_SENSE_BUFFERSIZE
> 
> To remove sense_buffer array in scsi_cmnd structure, this replaces
> sizeof sense_buffer with SCSI_SENSE_BUFFERSIZE in several LLDs.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
. . .
>  drivers/scsi/aacraid/aachba.c       |   12 ++++++------
. . .
>  drivers/scsi/dpt_i2o.c              |    2 +-
. . .
>  drivers/scsi/ips.c                  |   10 ++++------
