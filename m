From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/2] kernel.h: Add DIV_ROUND_UP_ULL usage
Date: Tue, 26 Jul 2011 00:53:41 -0700
Message-ID: <1311666821.26957.13.camel@Joe-Laptop>
References: <1311664225-20172-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:4285 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861Ab1GZHxn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jul 2011 03:53:43 -0400
In-Reply-To: <1311664225-20172-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>

On Tue, 2011-07-26 at 07:10 +0000, Nicholas A. Bellinger wrote:
> Add new DIV_ROUND_UP_ULL macro usage for 32-bit architectures requiring
> unsigned long long division of sectors * dev_max_sectors.
[]
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
[]
> +#define DIV_ROUND_UP_ULL(ll,d) \
> +	({ unsigned long long _tmp = (ll)+(d)-1; do_div(_tmp, d); _tmp; })

Maybe use uint64_t and a temporary for d?

#define DIV_ROUND_UP_ULL(ll, d)				\
({							\
	typeof(d) _d = d;				\
	uint64_t _tmp = (uint64_t)(ll) + _d - 1;	\
	do_div(_tmp, _d);				\
	_tmp;						\
})


