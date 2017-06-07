From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] scsi: remove useless variable assignment
Date: Wed, 07 Jun 2017 15:27:47 -0500
Message-ID: <20170607152747.Horde.8JNiGUjUVmaDvwXKaBUwN0t@gator4166.hostgator.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_cGxQJIzBomwWQpu0miXoyFf"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

This message is in MIME format.

--=_cGxQJIzBomwWQpu0miXoyFf
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Content-Disposition: inline


Remove both variable assignments once the value stored in variable _reqlen_
is overwritten at some point either by line 2321: reqlen = mptr - msg;
or by line 2330: reqlen = 12;

Addresses-Coverity-ID: 1226930
Addresses-Coverity-ID: 1226931
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
  drivers/scsi/dpt_i2o.c | 3 ---
  1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 256dd67..acad668 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -2292,11 +2292,8 @@ static s32 adpt_scsi_to_i2o(adpt_hba* pHba,  
struct scsi_cmnd* cmd, struct adpt_d
  	mptr+=4;
  	lenptr=mptr++;		/* Remember me - fill in when we know */
  	if (dpt_dma64(pHba)) {
-		reqlen = 16;		// SINGLE SGE
  		*mptr++ = (0x7C<<24)+(2<<16)+0x02; /* Enable 64 bit */
  		*mptr++ = 1 << PAGE_SHIFT;
-	} else {
-		reqlen = 14;		// SINGLE SGE
  	}
  	/* Now fill in the SGList and command */

--
2.5.0





--=_cGxQJIzBomwWQpu0miXoyFf
Content-Type: message/rfc822; name="Forwarded Message"

Return-Path: <garsilva@embeddedor.com>
Delivered-To: garsilva@embeddedor.com
Received: from gator4166.hostgator.com
	by gator4166.hostgator.com (Dovecot) with LMTP id oWH4BTHyHFnxgAAAA8MJhg
	for <garsilva@embeddedor.com>; Wed, 17 May 2017 20:00:33 -0500
Return-path: <garsilva@embeddedor.com>
Envelope-to: garsilva@embeddedor.com
Delivery-date: Wed, 17 May 2017 20:00:33 -0500
Received: from [189.152.179.187] (port=60472 helo=embeddedgus)
	by gator4166.hostgator.com with esmtpa (Exim 4.87)
	(envelope-from <garsilva@embeddedor.com>)
	id 1dB9ns-0008tH-T9; Wed, 17 May 2017 20:00:32 -0500
Date: Wed, 17 May 2017 20:00:32 -0500
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Adaptec OEM Raid Solutions <aacraid@adaptec.com>,
	"James E.J. Bottomley" <jejb@linux.vnet.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] scsi: remove useless variable assignment
Message-ID: <20170518010032.GA12354@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)

Remove both variable assignments once the value stored in variable _reqlen_
is overwritten at some point either by line 2321: reqlen = mptr - msg;
or by line 2330: reqlen = 12;

Addresses-Coverity-ID: 1226930
Addresses-Coverity-ID: 1226931
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/scsi/dpt_i2o.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 256dd67..acad668 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -2292,11 +2292,8 @@ static s32 adpt_scsi_to_i2o(adpt_hba* pHba, struct scsi_cmnd* cmd, struct adpt_d
 	mptr+=4;
 	lenptr=mptr++;		/* Remember me - fill in when we know */
 	if (dpt_dma64(pHba)) {
-		reqlen = 16;		// SINGLE SGE
 		*mptr++ = (0x7C<<24)+(2<<16)+0x02; /* Enable 64 bit */
 		*mptr++ = 1 << PAGE_SHIFT;
-	} else {
-		reqlen = 14;		// SINGLE SGE
 	}
 	/* Now fill in the SGList and command */
 
-- 
2.5.0


--=_cGxQJIzBomwWQpu0miXoyFf--
