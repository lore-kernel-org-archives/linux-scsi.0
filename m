Return-Path: <SRS0=de5d=CV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06EB1C433E2
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Sep 2020 07:48:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 901A8214F1
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Sep 2020 07:48:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Hd5tTi7+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725814AbgILHsJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Sep 2020 03:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgILHsE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Sep 2020 03:48:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27591C061573;
        Sat, 12 Sep 2020 00:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IH5DArEEUQKAhama86We+J3idWYzbB7Kr/M6CMlyXsM=; b=Hd5tTi7+OX5kB1HDk6IIpB97Nx
        flc+UUqoHVRy1GRLfNQ4DZeWaVZwNDYlH+FEOwgXlinTuVYdcrVsdmsqm5oAUcZaJ+2mhmB33Rfrg
        QfcQ8Axh9Ierh4HypbtllM5w414Po0CRM9GN16CKxnBrqbLMWItRkAzk6c5Msha7V1kGXN703Dlfs
        DWqStT5e3qxTrOa3WtNS6ufGwEvCpWGG+Ikal4HtPYIBAd7ic9RJiNXS32nhZcaKIpxCtKsHWRIfq
        B4NfrOxe0sSbU2w8N52qLBWO9dJjSMX0PRwVO3hKbKnAeW24nL6d8FzUxccDkqUJ1UKVdrAZOwNhG
        gMWEn0FQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kH0GL-0002UJ-Hb; Sat, 12 Sep 2020 07:47:57 +0000
Date:   Sat, 12 Sep 2020 08:47:57 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        hch@infradead.org, Anand Lodnoor <anand.lodnoor@broadcom.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, megaraidlinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] scsi: megaraid_sas: simplify compat_ioctl handling
Message-ID: <20200912074757.GA6688@infradead.org>
References: <20200908213715.3553098-1-arnd@arndb.de>
 <20200908213715.3553098-3-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908213715.3553098-3-arnd@arndb.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Sep 08, 2020 at 11:36:23PM +0200, Arnd Bergmann wrote:
> There have been several attempts to fix serious problems
> in the compat handling in megasas_mgmt_compat_ioctl_fw(),
> and it also uses the compat_alloc_user_space() function.

I just looked into this a few weeks ago but didn't get that far..

> +static struct megasas_iocpacket *megasas_compat_iocpacket_get_user(void __user *arg)

Pointlessly long line.

> +{
> +	int err = -EFAULT;
> +#ifdef CONFIG_COMPAT

I find the ifdef inside the function a little weird.  Doing it in the
caller would be a little less bad.  What I ended up doing in my
unfinished patch was to move the compat handling into a new
megaraid_sas_compat.c file, so we'd always get the prototypes in a
header, but given that all the calls are eliminated for the !COMPAT
case we'd avoid ifdefs entirely, but having that file for a single
function is also rather silly.

> +	struct megasas_iocpacket *ioc;
> +	struct compat_megasas_iocpacket __user *cioc = arg;
> +	int i;
> +
> +	ioc = kzalloc(sizeof(*ioc), GFP_KERNEL);

Missing NULL check here.

> +	if (copy_from_user(ioc, arg,
> +			   offsetof(struct megasas_iocpacket, frame) + 128))
> +		goto out;

the 128 here while copied from the original code should probably be
replaced with a sizeof(frame->raw).

> +	if (ioc->sense_len) {
> +		compat_uptr_t *sense_ioc_ptr;
> +		void __user *sense_cioc;
> +
> +		/* make sure the pointer is inside of frame.raw */
> +		if (ioc->sense_off >
> +		    (sizeof(ioc->frame.raw) - sizeof(void __user*))) {
> +			err = -EINVAL;
> +			goto out;
> +		}
> +
> +		sense_ioc_ptr = (compat_uptr_t *)&ioc->frame.raw[ioc->sense_off];
> +		sense_cioc = compat_ptr(get_unaligned(sense_ioc_ptr));
> +		put_unaligned((unsigned long)sense_cioc, (void **)sense_ioc_ptr);

I think we should really handle this where the sense point is set up.
This is the untested hunk I had:


diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 48fad675b5ed02..c3ddcfce86df50 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -8231,7 +8231,12 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 			goto out;
 		}
 
-		sense_ptr = (void *)cmd->frame + ioc->sense_off;
+		if (in_compat_syscall())
+			sense_ptr = compat_ptr((uintptr_t)cmd->frame) +
+					ioc->sense_off;
+		else
+			sense_ptr = (void *)cmd->frame + ioc->sense_off;
+
 		if (instance->consistent_mask_64bit)
 			put_unaligned_le64(sense_handle, sense_ptr);
 		else

The same might make sense for the iovecs, but I didn't get to that
yet..


>  static long
>  megasas_mgmt_compat_ioctl(struct file *file, unsigned int cmd,
>  			  unsigned long arg)
>  {
>  	switch (cmd) {
>  	case MEGASAS_IOC_FIRMWARE32:
> -		return megasas_mgmt_compat_ioctl_fw(file, arg);
> +		return megasas_mgmt_ioctl_fw(file, arg);
>  	case MEGASAS_IOC_GET_AEN:
>  		return megasas_mgmt_ioctl_aen(file, arg);
>  	}

We should be able to kill off megasas_mgmt_compat_ioctl entirely now.
