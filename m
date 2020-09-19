Return-Path: <SRS0=lXoO=C4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3277C43465
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Sep 2020 05:26:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2A1520773
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Sep 2020 05:26:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SOUFFPyI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgISF00 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Sep 2020 01:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgISF00 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Sep 2020 01:26:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6F5C0613CE;
        Fri, 18 Sep 2020 22:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5qgRLv5u9MXkFL0qplf6x5U3elV06ZRwP3O6lsNG86c=; b=SOUFFPyIbCMmQ1RFjPcg8a5BkB
        D2jERuOFVFDXy5tSQ15XuRobB4eo8xzDO46ZGJ3aH86lhyvfQHbbyNsePMpDJO1RZq9R8wA+453+8
        Vai70hUPRNDUi7BtByrmk2IodzKtZrFXe9IfIau3B/afp73GkFhMaMTgxZbvX9xHCvZWRjyA945tI
        iy4fLcB8D1PrVldelyXE9h45ISLOL4pZfMEBaPpcjbu6G2ftJ6No1gd4Mr3m4Q7dPqSZKQfMdtAFs
        wRk28xpu5Zilr+RqxGT+g1sdFkzbnhKn/vj5+VxE9tQ+xADz8cn+2lrEI5mTm/6y2d2EmvkQbEHzV
        TBMtrY6A==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kJVOA-0000IA-5Y; Sat, 19 Sep 2020 05:26:22 +0000
Date:   Sat, 19 Sep 2020 06:26:22 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        anand.lodnoor@broadcom.com, megaraidlinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] scsi: megaraid_sas: simplify compat_ioctl handling
Message-ID: <20200919052622.GE30063@infradead.org>
References: <20200918120955.1465510-1-arnd@arndb.de>
 <20200918121543.1466090-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918121543.1466090-1-arnd@arndb.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 18, 2020 at 02:15:43PM +0200, Arnd Bergmann wrote:
> There have been several attempts to fix serious problems
> in the compat handling in megasas_mgmt_compat_ioctl_fw(),
> and it also uses the compat_alloc_user_space() function.
> 
> Folding the compat handling into the regular ioctl
> function with in_compat_syscall() simplifies it a lot and
> avoids some of the remaining problems:
> 
> - missing handling of unaligned pointers
> - overflowing the ioc->frame.raw array from
>   invalid input
> - compat_alloc_user_space()
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> v2: address review comments from hch
> ---
>  drivers/scsi/megaraid/megaraid_sas.h      |   2 -
>  drivers/scsi/megaraid/megaraid_sas_base.c | 117 +++++++++-------------
>  include/linux/compat.h                    |  10 +-
>  3 files changed, 50 insertions(+), 79 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
> index 5e4137f10e0e..0f808d63580e 100644
> --- a/drivers/scsi/megaraid/megaraid_sas.h
> +++ b/drivers/scsi/megaraid/megaraid_sas.h
> @@ -2605,7 +2605,6 @@ struct megasas_aen {
>  	u32 class_locale_word;
>  } __attribute__ ((packed));
>  
> -#ifdef CONFIG_COMPAT
>  struct compat_megasas_iocpacket {
>  	u16 host_no;
>  	u16 __pad1;
> @@ -2621,7 +2620,6 @@ struct compat_megasas_iocpacket {
>  } __attribute__ ((packed));
>  
>  #define MEGASAS_IOC_FIRMWARE32	_IOWR('M', 1, struct compat_megasas_iocpacket)
> -#endif
>  
>  #define MEGASAS_IOC_FIRMWARE	_IOWR('M', 1, struct megasas_iocpacket)
>  #define MEGASAS_IOC_GET_AEN	_IOW('M', 3, struct megasas_aen)
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index c3de69f3bee8..d91951ee16ab 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -8279,16 +8279,18 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
>  	 * copy out the sense
>  	 */
>  	if (ioc->sense_len) {
> +		void __user *uptr;
>  		/*
>  		 * sense_ptr points to the location that has the user
>  		 * sense buffer address
>  		 */
> +		sense_ptr = (void *)ioc->frame.raw + ioc->sense_off;
> +		if (in_compat_syscall())
> +			uptr = compat_ptr(get_unaligned((u32 *)sense_ptr));

should the u32 * here by a compat_uptr *? Not tat it would make a
difference, just better document what we are doing.

> +	for (i = 0; i < MAX_IOCTL_SGE; i++) {
> +		compat_uptr_t iov_base;
> +		if (get_user(iov_base, &cioc->sgl[i].iov_base) ||
> +		    get_user(ioc->sgl[i].iov_len, &cioc->sgl[i].iov_len)) {
> +			goto out;
> +		}

I don't think we need the braces here.

> +	return ioc;
> +out:
> +	kfree(ioc);
> +
> +	return ERR_PTR(err);

spurious empty line.

> --- a/include/linux/compat.h
> +++ b/include/linux/compat.h
> @@ -91,6 +91,11 @@
>  	static inline long __do_compat_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__))
>  #endif /* COMPAT_SYSCALL_DEFINEx */
>  
> +struct compat_iovec {
> +	compat_uptr_t	iov_base;
> +	compat_size_t	iov_len;
> +};
> +
>  #ifdef CONFIG_COMPAT
>  
>  #ifndef compat_user_stack_pointer
> @@ -248,11 +253,6 @@ typedef struct compat_siginfo {
>  	} _sifields;
>  } compat_siginfo_t;
>  
> -struct compat_iovec {
> -	compat_uptr_t	iov_base;
> -	compat_size_t	iov_len;
> -};

This should probably go into a separate patch instead of being hidden
in a driver patch.

But except for these nitpicks the change looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
