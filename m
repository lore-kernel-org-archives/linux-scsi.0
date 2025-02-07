Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F67F155345;
	Fri,  7 Feb 2025 02:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738895848; cv=none; b=Y/J87nywRJWPQqquITtslTubF5GCYAfYboHTqR4WR+81NC0k64CudY6SJHLwCaxhSySS968OyUSuAJmeUQFmh7G4QyM6WWrcO51RkxEjXmvuHpkp18eQV/wr9spjuuRlQpjW0TZ96H3Pxx2amKKDGcjQNYcxJSoGe7EdQ5ewzsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738895848; c=relaxed/simple;
	bh=3MhgtvavbTSXW6MkC8R4dDYEwIMFhGFGO1iDqu57M+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IqP6/kroNqPHE7R56oghN+dw7wWkcDyruoTh0yRAjLuc4OttwM2G7sDjIvQ/9/+ROTCVf/rNLKEMgYE1U/TOc6lBT73lWRdOpLk2ULAdCurrt+nLvhzTvJ9wrBr6A+HuErayeNAmAS4l/j8r51X63Fw8q38CSh2E1snIExSkah0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dr9cCOp/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dr9cCOp/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E9E1C4CEDD;
	Fri,  7 Feb 2025 02:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738895848;
	bh=3MhgtvavbTSXW6MkC8R4dDYEwIMFhGFGO1iDqu57M+w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Dr9cCOp/zbVJ7rJ9uQpsRrcC0qHhGFHha9D6kP9YMm3Kb9b+hbLuu/rv1LU7jf20L
	 ktjX9o/Uxj8cog2qZxL+vWdOMYZ1ih/32NFpdYr3p4m2zDZwZBBio4SIYxalOQJ/D8
	 zwExSzg9OOnhy7XiKDhBe0+RAkuOSmoqRl+239UoaUAC3ElE188Atu5bOuvwU03MGT
	 AKfe3xxSuIZ/8oVJmTH/8gfLF2SWFUq7WnvkgttYHLvt2eGW0etSe+9XqShbCCFABx
	 wOR+EC455LLVSPyBGP7vm5EvcEW3hr3BPLUBWhRVqZXsh1wiAnvnO9qHUo0yQHd7wN
	 2mwEHFsb3a+VQ==
Date: Thu, 6 Feb 2025 18:37:27 -0800
From: Kees Cook <kees@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Andy Shevchenko <andy@kernel.org>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	linux-coco@lists.linux.dev,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Nilesh Javali <njavali@marvell.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Sven Eckelmann <sven@narfation.org>,
	Tadeusz Struk <tadeusz.struk@linaro.org>,
	kernel test robot <lkp@intel.com>,
	Erick Archer <erick.archer@outlook.com>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	linux-kernel@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	linux-hardening@vger.kernel.org, linux-nilfs@vger.kernel.org
Subject: Re: [PATCH 06/10] x86/tdx: Mark message.str as nonstring
Message-ID: <202502061835.F57547B@keescook>
References: <20250207005832.work.324-kees@kernel.org>
 <20250207010022.749952-6-kees@kernel.org>
 <b4f08d43-c421-4e8d-9bbb-c954c4472f8a@intel.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4f08d43-c421-4e8d-9bbb-c954c4472f8a@intel.com>

On Thu, Feb 06, 2025 at 05:12:11PM -0800, Dave Hansen wrote:
> On 2/6/25 17:00, Kees Cook wrote:
> > +++ b/arch/x86/coco/tdx/tdx.c
> > @@ -170,7 +170,7 @@ static void __noreturn tdx_panic(const char *msg)
> >  		/* Define register order according to the GHCI */
> >  		struct { u64 r14, r15, rbx, rdi, rsi, r8, r9, rdx; };
> >  
> > -		char str[64];
> > +		char str[64] __nonstring;
> >  	} message;
> 
> So, the patch itself makes sense. But it does end up looking kinda
> funky. We call it a "str"ing and then annotate it as not a string.

Yeah, this is true all over the place. It's a string, just not a
NUL-terminated string: *sob*

> It doesn't have to be done in this patch, but it does seem like we
> should probably not be using 'char' and also shouldn't call it anything
> close to "string". Maybe:
> 
>	 	u8 message[64] __nonstring;
> 	} message;

message.message ;)

message.chars?
message.bytes?

> In any case, feel free to carry the annotation in your tree:
> 
> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>

Thanks!

-Kees

-- 
Kees Cook
