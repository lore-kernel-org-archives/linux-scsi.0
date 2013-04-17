From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH 4/4] Simple correctness and speed test for CRCT10DIF
 hash
Date: Wed, 17 Apr 2013 11:07:13 -0700
Message-ID: <1366222033.27102.104.camel@schen9-DESK>
References: <cover.1366120266.git.tim.c.chen@linux.intel.com>
	 <de2e172b3c5b5d2ce77978be56aaa8b84272f5d6.1366120266.git.tim.c.chen@linux.intel.com>
	 <516EE2D7.5040301@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <516EE2D7.5040301@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "H. Peter Anvin" <hpa@zytor.com>, "David S. Miller" <davem@davemloft.net>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Wilcox <willy@linux.intel.com>, Jim Kukunas <james.t.kukunas@linux.intel.com>, Keith Busch <keith.busch@intel.com>, Erdinc Ozturk <erdinc.ozturk@intel.com>, Vinodh Gopal <vinodh.gopal@intel.com>, James Guilford <james.guilford@intel.com>, Wajdi Feghali <wajdi.k.feghali@intel.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2013-04-17 at 20:58 +0300, Jussi Kivilinna wrote:
> On 16.04.2013 19:20, Tim Chen wrote:
> > These are simple tests to do sanity check of CRC T10 DIF hash.  The
> > correctness of the transform can be checked with the command
> > 	modprobe tcrypt mode=47
> > The speed of the transform can be evaluated with the command
> > 	modprobe tcrypt mode=320
> > 
> > Set the cpu frequency to constant and turn turbo off when running the
> > speed test so the frequency governor will not tweak the frequency and
> > affects the measurements.
> > 
> > Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> > Tested-by: Keith Busch <keith.busch@intel.com>
> <snip>
> >  
> > +#define CRCT10DIF_TEST_VECTORS	2
> > +static struct hash_testvec crct10dif_tv_template[] = {
> > +	{
> > +		.plaintext = "abc",
> > +		.psize  = 3,
> > +#ifdef __LITTLE_ENDIAN
> > +		.digest = "\x3b\x44",
> > +#else
> > +		.digest = "\x44\x3b",
> > +#endif
> > +	}, {
> > +		.plaintext =
> > +		"abcddddddddddddddddddddddddddddddddddddddddddddddddddddd",
> > +		.psize  = 56,
> > +#ifdef __LITTLE_ENDIAN
> > +		.digest = "\xe3\x9c",
> > +#else
> > +		.digest = "\x9c\xe3",
> > +#endif
> > +		.np     = 2,
> > +		.tap    = { 28, 28 }
> > +	}
> > +};
> > +
> 
> Are these large enough to test all code paths in the PCLMULQDQ implementation?

We have tested the implementation exhaustively for large number of code paths.
The tcrypt tests here are only meant for sanity check, and not for
exhaustive tests.

Tim
