From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] megaraid_sas: fix for 32bit apps
Date: Wed, 10 Feb 2010 14:36:41 -0500
Message-ID: <1265830601.2769.346.camel@mulgrave.site>
References: <4B6C4F81.6090806@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:44053 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755699Ab0BJTgs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Feb 2010 14:36:48 -0500
In-Reply-To: <4B6C4F81.6090806@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org, "Yang, Bo" <Bo.Yang@lsi.com>, hch@infradead.org

On Fri, 2010-02-05 at 18:04 +0100, Tomas Henzl wrote:
> It looks like this patch -
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=7b2519afa1abd1b9f63aa1e90879307842422dae
> has caused a problem for 32bit programs with 64bit os - 
> http://bugzilla.kernel.org/show_bug.cgi?id=15001
> 
> megaraid: convert user space 32bit pointer 
> to a 64 bit one when needed.
> 
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
> index 708ea31..7617b8e 100644
> --- a/drivers/scsi/megaraid/megaraid_sas.c
> +++ b/drivers/scsi/megaraid/megaraid_sas.c
> @@ -3781,6 +3781,8 @@ static int megasas_mgmt_compat_ioctl_fw(struct file *file, unsigned long arg)
>  	    compat_alloc_user_space(sizeof(struct megasas_iocpacket));
>  	int i;
>  	int error = 0;
> +	compat_uptr_t ptr;
> +	u8 *sense_ptr;
>  
>  	if (clear_user(ioc, sizeof(*ioc)))
>  		return -EFAULT;
> @@ -3793,9 +3795,19 @@ static int megasas_mgmt_compat_ioctl_fw(struct file *file, unsigned long arg)
>  	    copy_in_user(&ioc->sge_count, &cioc->sge_count, sizeof(u32)))
>  		return -EFAULT;
>  
> -	for (i = 0; i < MAX_IOCTL_SGE; i++) {
> -		compat_uptr_t ptr;
> +	/*
> +	 * The sense_ptr is used in megasas_mgmt_fw_ioctl only when
> +	 * sense_len is not null, so prepare the 64bit value under
> +	 * the same condition.
> +	 */
> +	if (ioc->sense_len) {
> +		sense_ptr = ioc->frame.raw + ioc->sense_off;
> +		if (get_user(ptr, (compat_uptr_t *)sense_ptr) ||
> +		    put_user(ptr, (unsigned long *)sense_ptr))

This should be put_user(compat_ptr(ptr) ...) to make sure we get proper
warn free promotion.

For symmetry, shouldn't we be reading from cioc?  I know technically the
copy_in_user(ioc->frame.raw, cioc->frame.raw, 128) above did this, but
it might look confusing to someone coming to the code for the first
time.

To be honest, I also don't think ioc->frame.raw + ioc->sense_off is
legal: it's dereferencing a userspace pointer (ioc->sense_off), which
will fault on non-x86 boxes, but this isn't a criticism of the patch so
much as the whole driver.

Bo, this looks like a security fix, because userspace can cause
arbitrary data scribble currently by stuffing carefully crafted values
into the four bytes after the 32 bit sense pointer, so I'd like to apply
it asap.

Thanks,

James


