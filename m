From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] iscsi: Simplify serial number comparisons
Date: Mon, 11 Apr 2011 23:55:35 -0700
Message-ID: <1302591335.25449.32.camel@haakon2.linux-iscsi.org>
References: <20110407212615.20399.18029.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:51455 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756577Ab1DLHDH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2011 03:03:07 -0400
In-Reply-To: <20110407212615.20399.18029.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-iscsi-target-dev@googlegroups.com
Cc: open-iscsi@googlegroups.com, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2011-04-07 at 14:26 -0700, Mark Rustad wrote:
> Unsigned serial number comparison is very simple if you simply put the
> difference into a signed integer of the same size and then compare that
> value with zero. All the complexity and confusion fall away.
> 
> Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
> ---
>  include/scsi/iscsi_proto.h |   21 ++++++++++++---------
>  1 files changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/include/scsi/iscsi_proto.h b/include/scsi/iscsi_proto.h
> index 0c6c1d6..98ebc3d 100644
> --- a/include/scsi/iscsi_proto.h
> +++ b/include/scsi/iscsi_proto.h
> @@ -35,30 +35,33 @@
>  /*
>   * Serial Number Arithmetic, 32 bits, RFC1982
>   */
> -#define SNA32_CHECK 2147483648UL
>  
>  static inline int iscsi_sna_lt(u32 n1, u32 n2)
>  {
> -	return n1 != n2 && ((n1 < n2 && (n2 - n1 < SNA32_CHECK)) ||
> -			(n1 > n2 && (n2 - n1 < SNA32_CHECK)));
> +	s32 diff = n1 - n2;
> +
> +	return diff < 0;
>  }
>  
>  static inline int iscsi_sna_lte(u32 n1, u32 n2)
>  {
> -	return n1 == n2 || ((n1 < n2 && (n2 - n1 < SNA32_CHECK)) ||
> -			(n1 > n2 && (n2 - n1 < SNA32_CHECK)));
> +	s32 diff = n1 - n2;
> +
> +	return diff <= 0;
>  }
>  
>  static inline int iscsi_sna_gt(u32 n1, u32 n2)
>  {
> -	return n1 != n2 && (((n1 < n2) && ((n2 - n1) > SNA32_CHECK)) ||
> -			((n1 > n2) && ((n1 - n2) < SNA32_CHECK)));
> +	s32 diff = n1 - n2;
> +
> +	return diff > 0;
>  }
>  
>  static inline int iscsi_sna_gte(u32 n1, u32 n2)
>  {
> -	return n1 == n2 || (((n1 < n2) && ((n2 - n1) > SNA32_CHECK)) ||
> -			((n1 > n2) && ((n1 - n2) < SNA32_CHECK)));
> +	s32 diff = n1 - n2;
> +
> +	return diff >= 0;
>  }

Hi Mark,

My apolgies for the delayed response on this patch.

I think this simplification to use s32 for iSCSI Command Serial Number
arithmetic looks perfectly reasonable, and am including this into
lio-core-2.6.git/lio-4.1.  Thank you for your contribution!!

Mike, Hannes and Co, do you have any objections here for mainline
Open-iSCSI and iSCSI-Target code for .40 code..?

Best Regards,

--nab

