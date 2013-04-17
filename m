From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH 2/4] Accelerated CRC T10 DIF computation with PCLMULQDQ
 instruction
Date: Wed, 17 Apr 2013 11:20:06 -0700
Message-ID: <1366222806.27102.107.camel@schen9-DESK>
References: <cover.1366120266.git.tim.c.chen@linux.intel.com>
	 <5227e0b295142e1fbb3c7e0241646eb65319b18a.1366120266.git.tim.c.chen@linux.intel.com>
	 <516EE2C6.6010901@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <516EE2C6.6010901@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "H. Peter Anvin" <hpa@zytor.com>, "David S. Miller" <davem@davemloft.net>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Wilcox <willy@linux.intel.com>, Jim Kukunas <james.t.kukunas@linux.intel.com>, Keith Busch <keith.busch@intel.com>, Erdinc Ozturk <erdinc.ozturk@intel.com>, Vinodh Gopal <vinodh.gopal@intel.com>, James Guilford <james.guilford@intel.com>, Wajdi Feghali <wajdi.k.feghali@intel.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2013-04-17 at 20:58 +0300, Jussi Kivilinna wrote:
> On 16.04.2013 19:20, Tim Chen wrote:
> > This is the x86_64 CRC T10 DIF transform accelerated with the PCLMULQDQ
> > instructions.  Details discussing the implementation can be found in the
> > paper:
> > 
> > "Fast CRC Computation for Generic Polynomials Using PCLMULQDQ Instruction"
> > URL: http://download.intel.com/design/intarch/papers/323102.pdf
> 
> URL does not work.

Thanks for catching this. Will update.

> 
> > 
> > Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> > Tested-by: Keith Busch <keith.busch@intel.com>
> > ---
> >  arch/x86/crypto/crct10dif-pcl-asm_64.S | 659 +++++++++++++++++++++++++++++++++
> >  1 file changed, 659 insertions(+)
> >  create mode 100644 arch/x86/crypto/crct10dif-pcl-asm_64.S
> <snip>
> > +
> > +	# Allocate Stack Space
> > +	mov     %rsp, %rcx
> > +	sub	$16*10, %rsp
> > +	and     $~(0x20 - 1), %rsp
> > +
> > +	# push the xmm registers into the stack to maintain
> > +	movdqa %xmm10, 16*2(%rsp)
> > +	movdqa %xmm11, 16*3(%rsp)
> > +	movdqa %xmm8 , 16*4(%rsp)
> > +	movdqa %xmm12, 16*5(%rsp)
> > +	movdqa %xmm13, 16*6(%rsp)
> > +	movdqa %xmm6,  16*7(%rsp)
> > +	movdqa %xmm7,  16*8(%rsp)
> > +	movdqa %xmm9,  16*9(%rsp)
> 
> You don't need to store (and restore) these, as 'crc_t10dif_pcl' is called between kernel_fpu_begin/_end.

That's true.  Will skip the xmm save/restore in update to the patch.

> 
> > +
> > +
> > +	# check if smaller than 256
> > +	cmp	$256, arg3
> > +
> <snip>
> > +_cleanup:
> > +	# scale the result back to 16 bits
> > +	shr	$16, %eax
> > +	movdqa	16*2(%rsp), %xmm10
> > +	movdqa	16*3(%rsp), %xmm11
> > +	movdqa	16*4(%rsp), %xmm8
> > +	movdqa	16*5(%rsp), %xmm12
> > +	movdqa	16*6(%rsp), %xmm13
> > +	movdqa	16*7(%rsp), %xmm6
> > +	movdqa	16*8(%rsp), %xmm7
> > +	movdqa	16*9(%rsp), %xmm9
> 
> Registers are overwritten by kernel_fpu_end.
> 
> > +	mov     %rcx, %rsp
> > +	ret
> > +ENDPROC(crc_t10dif_pcl)
> > +
> 
> You should move ENDPROC at end of the full function.
> 
> > +########################################################################
> > +
> > +.align 16
> > +_less_than_128:
> > +
> > +	# check if there is enough buffer to be able to fold 16B at a time
> > +	cmp	$32, arg3
> <snip>
> > +	movdqa	(%rsp), %xmm7
> > +	pshufb	%xmm11, %xmm7
> > +	pxor	%xmm0 , %xmm7   # xor the initial crc value
> > +
> > +	psrldq	$7, %xmm7
> > +
> > +	jmp	_barrett
> 
> Move ENDPROC here.
> 

Will do.

Tim
