From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 1/1] dpt_i2o: delete unnecessary null test on array
Date: Sat, 9 Aug 2014 08:26:04 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1408090825250.2016@localhost6.localdomain6>
References: <1407321551-27479-1-git-send-email-Julia.Lawall@lip6.fr>   <1407321551-27479-2-git-send-email-Julia.Lawall@lip6.fr>  <1407517179.2044.13.camel@jarvis.lan>  <alpine.DEB.2.10.1408081902400.2348@hadrien>
 <1407518045.1686.0.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:23258
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750939AbaHIG0K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Aug 2014 02:26:10 -0400
In-Reply-To: <1407518045.1686.0.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, joe@perches.com

>From nobody Sat Aug  9 08:17:15 CEST 2014
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Adaptec OEM Raid Solutions <aacraid@adaptec.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,linux-scsi@vger.kernel.org,linux-kernel@vger.kernel.org
Subject: [PATCH] dpt_i2o: delete unnecessary null test on array

From: Julia Lawall <Julia.Lawall@lip6.fr>

Convert a NULL test on an array to a NULL test on its element.  Delete a
redundant test and clean up the code a little.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r@
type T;
T [] e;
position p;
@@
e ==@p NULL

@ disable fld_to_ptr@
expression e;
identifier f;
position r.p;
@@
* e.f ==@p NULL
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
v2: Test instead the array element, and clean up the code a bit.

 drivers/scsi/dpt_i2o.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 67283ef..4647c93 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -1169,15 +1169,14 @@ static struct adpt_device* adpt_find_device(adpt_hba* pHba, u32 chan, u32 id, u6
 	if(chan < 0 || chan >= MAX_CHANNEL)
 		return NULL;
 	
-	if( pHba->channel[chan].device == NULL){
-		printk(KERN_DEBUG"Adaptec I2O RAID: Trying to find device before they are allocated\n");
+	d = pHba->channel[chan].device[id];
+	if (!d) {
+		printk(KERN_DEBUG "Adaptec I2O RAID: Trying to find device before they are allocated\n");
 		return NULL;
 	}
 
-	d = pHba->channel[chan].device[id];
-	if(!d || d->tid == 0) {
+	if (d->tid == 0)
 		return NULL;
-	}
 
 	/* If it is the only lun at that address then this should match*/
 	if(d->scsi_lun == lun){

