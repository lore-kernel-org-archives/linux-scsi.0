From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/4] Wrap crc_t10dif function all to use crypto
 transform framework
Date: Tue, 30 Apr 2013 11:27:33 +0800
Message-ID: <20130430032733.GB20471@gondor.apana.org.au>
References: <cover.1366214842.git.tim.c.chen@linux.intel.com>
 <ea4271721b5ca130849b03da4f172f12f66e5628.1366214842.git.tim.c.chen@linux.intel.com>
 <20130425132203.GA29501@gondor.apana.org.au>
 <1366910910.27102.126.camel@schen9-DESK>
 <20130426125224.GA4855@gondor.apana.org.au>
 <1366994657.27102.129.camel@schen9-DESK>
 <20130428001122.GA6973@gondor.apana.org.au>
 <1367268030.27102.172.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1367268030.27102.172.camel@schen9-DESK>
Sender: linux-kernel-owner@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "David S. Miller" <davem@davemloft.net>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Wilcox <willy@linux.intel.com>, Jim Kukunas <james.t.kukunas@linux.intel.com>, Keith Busch <keith.busch@intel.com>, Erdinc Ozturk <erdinc.ozturk@intel.com>, Vinodh Gopal <vinodh.gopal@intel.com>, James Guilford <james.guilford@intel.com>, Wajdi Feghali <wajdi.k.feghali@intel.com>, Jussi Kivilinna <jussi.kivilinna@iki.fi>, linux-kernel <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 29, 2013 at 01:40:30PM -0700, Tim Chen wrote:
>
> If I allocate the transform under the mod init instead, how can I make
> sure that the fast version is already registered if I have it compiled
> in?  It is not clear to me how that's done looking at the libcrc32c
> code.  

This is only an issue when everything is built-in to the kernel.

In that case we could make the crc implementations register at a
point earlier than device_initcall, but no earlier than subsys_initcall
since that's where cryptomgr sits.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
