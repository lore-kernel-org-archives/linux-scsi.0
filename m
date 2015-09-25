From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 31/32] cxlflash: Fix to avoid corrupting adapter fops
Date: Fri, 25 Sep 2015 16:23:59 -0500
Message-ID: <5605BB6F.1030905@linux.vnet.ibm.com>
References: <1443123193-16498-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1443123851-17893-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:52989 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933230AbbIYVYG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Sep 2015 17:24:06 -0400
Received: from localhost
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Fri, 25 Sep 2015 15:24:06 -0600
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 826DF1FF0042
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2015 15:15:13 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8PLO4nG3604944
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2015 14:24:04 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8PLO2G4028443
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2015 15:24:04 -0600
In-Reply-To: <1443123851-17893-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

On 09/24/2015 02:44 PM, Matthew R. Ochs wrote:
> @@ -1293,8 +1291,8 @@ static int cxlflash_disk_attach(struct scsi_device *sdev,
> 
>  	int fd = -1;
> 
> -	/* On first attach set fileops */
> -	if (atomic_read(&cfg->num_user_contexts) == 0)
> +	/* On very first attach set fileops for adapter */
> +	if (cfg->cxl_fops.owner != THIS_MODULE)
>  		cfg->cxl_fops = cxlflash_cxl_fops;

Hmm... Why not just set this up once at probe time instead?

> 
>  	if (attach->num_interrupts > 4) {
> 


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

