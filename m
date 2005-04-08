From: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
Subject: Re: [PATCH] aacraid 2.6: Address sparse warnings
Date: Fri, 8 Apr 2005 21:16:40 +0100
Message-ID: <20050408201638.GH8859@parcelfarce.linux.theplanet.co.uk>
References: <60807403EABEB443939A5A7AA8A7458B010A9E60@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:48770 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S262947AbVDHUQt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Apr 2005 16:16:49 -0400
Content-Disposition: inline
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B010A9E60@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mark Haverkamp <markh@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Apr 08, 2005 at 02:41:58PM -0400, Salyzyn, Mark wrote:
> As long as this is guaranteed on all platforms to do the right thing ...
> paranoid about compiler optimizations. MarkH, this should be an easy
> regroup :-)

Well, let's see.

cpu_to_le32(~0U) -> __cpu_to_le32(~0U) ->
[on little-endian]
	((__force __le32)(__u32)(~0U)) -> ((__le32)(__u32)(~0U))
[on big-endian]
	((__force __le32)__swab32((~0U))) ->
	((__le32)__swab32((~0U))) ->
((__le32) (__builtin_constant_p((__u32)((~0U))) ?
	 ___swab32(((~0U)))
: __fswab32(((~0U))))) ->
((__le32) (__builtin_constant_p((__u32)((~0U))) ?
({
        __u32 __x = ((~0U));
        ((__u32)(
                (((__u32)(__x) & (__u32)0x000000ffUL) << 24) |
                (((__u32)(__x) & (__u32)0x0000ff00UL) <<  8) |
                (((__u32)(__x) & (__u32)0x00ff0000UL) >>  8) |
                (((__u32)(__x) & (__u32)0xff000000UL) >> 24) ));
})
: __fswab32(((~0U)))))

And that's enough - __builtin_constant_p((__u32)((~0U)) is known at compile
time and is non-zero.  The rest is obvious and yes, gcc does understand
that __x is constant and so is the expression above.


IOW, all cpu_to_...(<constant>) will be simplified to constants at compile
time.  They will not be _constant_ _expressions_ from C point of view (IOW,
you can't say e.g.
	enum {
		A = cpu_to_le32(~0U)
	};
- that's what __constant_cpu_to_le32() is for), but they certainly will be
evaluated by compiler.
