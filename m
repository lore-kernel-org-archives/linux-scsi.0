From: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: Re: [PATCH v3 1/6] ilog2: create truly constant version for sparse
Date: Wed, 18 Apr 2018 10:30:13 +0200
Message-ID: <20180418083012.3r4z7lwojgpw2lws@ltop.local>
References: <20180417233511.6573-1-mwilck@suse.com>
 <20180417233511.6573-2-mwilck@suse.com>
 <CA+55aFxLY2=RVAD8m-3bf4vKWpPKWSmjN_tLVWwb4Y7w81UTbA@mail.gmail.com>
 <1524039174.3028.24.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1524039174.3028.24.camel@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Martin Wilck <mwilck@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, James Bottomley <jejb@linux.vnet.ibm.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 18, 2018 at 10:12:54AM +0200, Martin Wilck wrote:
> On Tue, 2018-04-17 at 17:07 -0700, Linus Torvalds wrote:
> > On Tue, Apr 17, 2018 at 4:35 PM, Martin Wilck <mwilck@suse.com>
> > wrote:
> > > Sparse emits errors about ilog2() in array indices because of the
> > > use of
> > > __ilog2_32() and __ilog2_64(),
> > 
> > If sparse warns about it, then presumably gcc with -Wvla warns about
> > it too?
> 
> No, it doesn't (gcc 7.3.0). -> https://paste.opensuse.org/27471594
> It doesn't even warn on an expression like this:
> 
>   #define SIZE (1<<10)
>   static int foo[ilog2(SIZE)];
> 
> sparse 0.5.2 doesn't warn about that either. It emits "error: bad
> integer constant expression" only if ilog2 is used in an array

sparse supports VLAs at syntaxic level but not much more. Anything
needing directly or indirectly the array size will give this error.

-- Luc Van Oostenryck
