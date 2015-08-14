From: Michael Neuling <mikey@neuling.org>
Subject: Re: [PATCH v5 3/3] cxlflash: Virtual LUN support
Date: Fri, 14 Aug 2015 11:08:26 +1000
Message-ID: <1439514506.2641.2.camel@neuling.org>
References: <1439423476-15687-1-git-send-email-mrochs@linux.vnet.ibm.com>
	 <1439467402.21643.50.camel@neuling.org>
	 <55CD2BA0.6040005@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:47377 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955AbbHNBI2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Aug 2015 21:08:28 -0400
In-Reply-To: <55CD2BA0.6040005@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: manoj@linux.vnet.ibm.com
Cc: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, dja@ozlabs.au.ibm.com, benh@kernel.crashing.org, hch@infradead.org, imunsie@au1.ibm.com

On Thu, 2015-08-13 at 18:43 -0500, Manoj Kumar wrote:
> Mikey:
> 
> Thanks for your review. See comment inline below.
> 
> - Manoj Kumar
> 
> On 8/13/2015 7:03 AM, Michael Neuling wrote:
> > Thanks for integrating my suggestions.  create_context() has the same
> > freeing bug as 2/3 but if you fix that I'm happy if you add my
> > reviewed by:
> >
> > Reviewed-by: Michael Neuling <mikey@neuling.org>
> 
> I believe create_context() is in 2/3, not here. I did not find the same
> issue in this patch.
> 

This is the section I referring to from this patch.  Seems to be
building on the 2/3 issue.


@@ -693,11 +737,13 @@ static struct ctx_info *create_context(struct cxlflash_cfg *cfg,
 	struct afu *afu = cfg->afu;
 	struct ctx_info *ctxi = NULL;
 	struct llun_info **lli = NULL;
+	bool *ws = NULL;
 	struct sisl_rht_entry *rhte;
 
 	ctxi = kzalloc(sizeof(*ctxi), GFP_KERNEL);
 	lli = kzalloc((MAX_RHT_PER_CONTEXT * sizeof(*lli)), GFP_KERNEL);
-	if (unlikely(!ctxi || !lli)) {
+	ws = kzalloc((MAX_RHT_PER_CONTEXT * sizeof(*ws)), GFP_KERNEL);
+	if (unlikely(!ctxi || !lli || !ws)) {
 		dev_err(dev, "%s: Unable to allocate context!\n", __func__);
 		goto out;
 	}

