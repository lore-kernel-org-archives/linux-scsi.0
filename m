Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB0424397D;
	Sat,  8 Feb 2025 21:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739049391; cv=none; b=sNCch8XECrSgdTJuQmuZBj0px5h5EN7godq1axJgQf22aSCbah2vPdqe12tseEHi5Abh0pQWz5HfWHkxOI7KH7yUi5/gR0948tCFt+wjCXXq8ZonGAhLLp/z0iLFg7n0yvgPdsNKATpMYGYfFLQAon2PG2ojufwVqwJVmPD0VZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739049391; c=relaxed/simple;
	bh=d3mqXUweMLtIwF7cqK0D9d7xXW7fETio5Z7vD3LR6K0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oGp7jRBAXyK7Ixvzv1CPEb1M2kyigrpieiDwQtala89IBQ0G9PK6Bu07IQKLLV975F4riI66ZL+nYsB5crATPKS1Oo6Kr7+54x80hRAFlweYEqf5ATB7CY2hrxkSrUy5EUh1hmoU27DY/PSn1ZFIlIgu/eF92acmjsV738ZJ/kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=od8d311X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="od8d311X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B3F6C4CED6;
	Sat,  8 Feb 2025 21:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739049390;
	bh=d3mqXUweMLtIwF7cqK0D9d7xXW7fETio5Z7vD3LR6K0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=od8d311X5ydXxaJ1xKNdqIZCSDJ6CWsK+uTR2WfUt6yhT48ivwrRHU9qeAF3JrgRi
	 pdyJ/WfOnyl6o+n8AtPQqGS10bzbIp8VO3+gKFkbvopovMcftf7CyoG7P4lsre/UcI
	 xHDqDZkFoPxc4eME1M5wQ/EGXt3x+F7bQOaXnsqt4KCB6OXEvIEQb5s08fl5bVIcRg
	 hCOed0/qBvJgXDJPsOBkX4sral8TqNsF79elkRljdBh1dafWchwIt1CDgyFQRlsI6n
	 QQ8Cu04Kr0XGXex48ch9SfG3YW5plEA2WAExJkVUaJogjyySbW4Fw8VIcySzLm7dv9
	 syTn8t7X830XA==
Date: Sat, 8 Feb 2025 13:16:30 -0800
From: Kees Cook <kees@kernel.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Dave Hansen <dave.hansen@intel.com>, Andy Shevchenko <andy@kernel.org>,
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
Message-ID: <202502081316.685D547624@keescook>
References: <20250207005832.work.324-kees@kernel.org>
 <20250207010022.749952-6-kees@kernel.org>
 <b4f08d43-c421-4e8d-9bbb-c954c4472f8a@intel.com>
 <202502061835.F57547B@keescook>
 <CAHp75Vf4R73_GMNvsEWd3nyUKM8UEP22=9umArVsHYOA=dycWg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHp75Vf4R73_GMNvsEWd3nyUKM8UEP22=9umArVsHYOA=dycWg@mail.gmail.com>

On Fri, Feb 07, 2025 at 02:09:12PM +0200, Andy Shevchenko wrote:
> On Fri, Feb 7, 2025 at 4:37 AM Kees Cook <kees@kernel.org> wrote:
> > On Thu, Feb 06, 2025 at 05:12:11PM -0800, Dave Hansen wrote:
> > > On 2/6/25 17:00, Kees Cook wrote:
> 
> ...
> 
> > > So, the patch itself makes sense. But it does end up looking kinda
> > > funky. We call it a "str"ing and then annotate it as not a string.
> >
> > Yeah, this is true all over the place. It's a string, just not a
> > NUL-terminated string: *sob*
> 
> Maybe call it respectively, e.g., __nontermstr ?

I don't want to change its name from the GCC attribute. I think that's
just asking more more confusion.

-- 
Kees Cook
