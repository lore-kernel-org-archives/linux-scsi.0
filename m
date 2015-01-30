From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/8] lib/iovec: Add memcpy_fromiovec_out library function
Date: Fri, 30 Jan 2015 10:33:32 +0100
Message-ID: <54CB4FEC.7080908@redhat.com>
References: <1422605552-24797-1-git-send-email-nab@daterainc.com> <1422605552-24797-2-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:63206 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039AbbA3Jdi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Jan 2015 04:33:38 -0500
In-Reply-To: <1422605552-24797-2-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>



On 30/01/2015 09:12, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch adds a new memcpy_fromiovec_out() library function which modifies
> the passed *iov following memcpy_fromiovec(), but also returns the next current
> iovec pointer via **iov_out.
> 
> This is useful for vhost ANY_LAYOUT support when guests are allowed to generate
> incoming virtio request headers combined with subsequent SGL payloads into a
> single iovec.
> 
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>  include/linux/uio.h |  2 ++
>  lib/iovec.c         | 27 +++++++++++++++++++++++++++
>  2 files changed, 29 insertions(+)
> 
> diff --git a/include/linux/uio.h b/include/linux/uio.h
> index 1c5e453..3e4473d 100644
> --- a/include/linux/uio.h
> +++ b/include/linux/uio.h
> @@ -136,6 +136,8 @@ size_t csum_and_copy_to_iter(void *addr, size_t bytes, __wsum *csum, struct iov_
>  size_t csum_and_copy_from_iter(void *addr, size_t bytes, __wsum *csum, struct iov_iter *i);
>  
>  int memcpy_fromiovec(unsigned char *kdata, struct iovec *iov, int len);
> +int memcpy_fromiovec_out(unsigned char *kdata, struct iovec *iov,
> +			 struct iovec **iov_out, int len);
>  int memcpy_fromiovecend(unsigned char *kdata, const struct iovec *iov,
>  			int offset, int len);
>  int memcpy_toiovecend(const struct iovec *v, unsigned char *kdata,
> diff --git a/lib/iovec.c b/lib/iovec.c
> index 2d99cb4..6a813dd 100644
> --- a/lib/iovec.c
> +++ b/lib/iovec.c
> @@ -28,6 +28,33 @@ int memcpy_fromiovec(unsigned char *kdata, struct iovec *iov, int len)
>  EXPORT_SYMBOL(memcpy_fromiovec);
>  
>  /*
> + *	Copy iovec to kernel, saving the current iov to *iov_out.
> + *	Returns -EFAULT on error.

Perhaps document that iov is modified, zeroing everything in [iov,
*iov_out) and possibly removing the front of *iov_out?

Paolo

> + */
> +
> +int memcpy_fromiovec_out(unsigned char *kdata, struct iovec *iov,
> +			 struct iovec **iov_out, int len)
> +{
> +	while (len > 0) {
> +		if (iov->iov_len) {
> +			int copy = min_t(unsigned int, len, iov->iov_len);
> +			if (copy_from_user(kdata, iov->iov_base, copy))
> +				return -EFAULT;
> +			len -= copy;
> +			kdata += copy;
> +			iov->iov_base += copy;
> +			iov->iov_len -= copy;
> +		}
> +		if (!iov->iov_len)
> +			iov++;
> +	}
> +	*iov_out = iov;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(memcpy_fromiovec_out);
> +
> +/*
>   *	Copy kernel to iovec. Returns -EFAULT on error.
>   */
>  
> 
