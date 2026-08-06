Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665D12E6CB3
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2026 00:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785976505; cv=none; b=JtxfWoCc969nILrQsR2BViAYOSWxWCzcVNBJnFgUEsqqlpHj0UFT2BOjvzO2K79kh2Jjwaf/rGFD2gT1gjMgKnEhsmU5QknhsCLgGVNonVJrx6hvGuDbqcK5EMNyhhu95iFBt4MssZVTcGhQ96rn38VtK2ZouwFi1h40Nsurs1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785976505; c=relaxed/simple;
	bh=7+uEFYt3X8Ro5kT0HvHI0upULZhLG/Yt0Zf2o3mecBI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=mj2tMPgKaWUXCxQZ8LJEr41uhx3gt6qo5AMpGwqzoG0MjBe8q+04lylvOaXj2v8bNr50ZQwQUfnWLBQE5QhWhlW/jbZtAvNXxJifq9I5hi4Ad4UlmciNhil0ZRSuKqL6ZuKHZeYlg/mISqGAltIrcxfMrbfGIJkC3GSWtk7ayl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=CvRXcXp1; arc=none smtp.client-ip=202.12.124.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="CvRXcXp1"
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 13DAD7A014E;
	Wed,  5 Aug 2026 20:35:02 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Wed, 05 Aug 2026 20:35:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1785976501; x=1786062901; bh=/RguXtSiY8TcTEHUxk+xDP3RpTdxYi4H7Ma
	A1+aqXCI=; b=CvRXcXp1bW0N0rgmd9ssdkXTtA03WARadgZGWZwLwrGEut96kbF
	JxDZ2Um9Hzxu+7lv67561qOLFdg+SheVdsJjr7QEiAjdMZ9rs71jklPUcogoItHY
	WwAF4kWncNyop+rXW/Ax9H7hfhOECgZw1pEI2WBjWDLHV66XPJnbhSpvGD4uBu6q
	8+rOio4VG0njszUn/8U9V4J/Yc/WHhTU1pGh8tpWbNg25LbWgiBJebWmxBdypV2K
	RtZxyH2KB1giqS6LHUGjHFWa30nneFX8aGj0CcgFdrPCPWv1IkNYl6Y9w6WAR+ll
	mNMIOpcY6yfLHnv/Ls9GO4cz4RvkcQGUWuA==
X-ME-Sender: <xms:tNZzaiE5Zdheq59Jv8NpKsDSMkmayiAVKZwi2jvk_XwmulLWVSg5Yw>
    <xme:tNZzaoSuZWqg6rJsM994f9SC7kbYNqGWwQbJMKPgI15BWJrE24IhgXum1KcCbtq8l
    TaqEaZM170FvrbuYu2lZj1q_67ZBtZsqu8VPFJC7bJrsXJYHEDMtQ>
X-ME-Received: <xmr:tNZzagYWRoO5Rwo8iGOM0BVIvWdNHLPL7fGY2evs6aKMinMgGw_g0wXE0hXQ9h-6OV3c82gBB0atDTAsa5l8AdlnMDcqA2O2QcE>
X-ME-Proxy-Cause: dmFkZTEp/rD9v3eR3CkJhIu2UlCOD8SNwqxyNr2P3MvQ7Dq82jPYIgn/4mJ0ROSY2Wq9b+
    8Q1WyLXWWYN24M+lO5S9px5zxHau54DIBbCJTzocWNjLuHSuaqa0jCsU3jSh7XbKl+zj5L
    F4gyU2qNXOtDv7CF9RGQiqqiLs3vkFG8qrknjZgCip3AermvhYiaFQjsm94r3ctIl1frIR
    S1MCfCL+fo/vds2Y1ynM0x4n6Lbj8NgMkxMVC41qGXMxd5m6D0V8vipTTwpZrrAHwlkbKd
    wduHA2bb+854IbrncXWHVAN4eCkvauEhtVHb9198+1COtbZHqpra+a/b5s6AeLBSvXcaA8
    +mTRrtNGizNfeeAlJDp9jW4L9nQTO0j3GJnoAn5kGOB8FcOX/EzvgSb4BwSqUb/LbMz5Fw
    6IbGz++fWl59ESueoLDF9i/27r2xTCWjoBpvXPpVw1sabk8XbqVgLfFMpP4Bc8tKLD6YRB
    TkjaDmMDDEVb4lIdRFwIXodBq5IgwbEzeczBojGKtzCS4MA/JUhViLdXLUAc5i7hr96LW2
    qkizTpMq9k5dkapnWoRhJPm6J5OzF2rtSHGABXAEdi8SA5VyD5nsUtAwgCKOGXFgO8QUK+
    A5MYgdBPAUSD9YATYzPhMf8tnr1N02qsGIxNly7Q8pdI0uBLA2e9I4EHeTag
X-ME-Proxy: <xmx:tNZzar16ym8N1C8IcppIkBnBE1X1eMs4K_r0IRsuHrUawRU61pvPUA>
    <xmx:tNZzaroMv1gtTA4EpWFTjsyrFCA7brepp6JC9gz4rM8vRJbAm7jsjA>
    <xmx:tNZzaiNuC-4wYqA30qUS-BKTN6tPPoahSqhKZoumXzWBbVrqwXWeZA>
    <xmx:tNZzasqPu_XuiILYFC79zp6YPADtbYndZCO63R2HUqiK6Ss2SF1I0w>
    <xmx:tdZzap0yJfScmcBbuxON77HnMCQmVAo6g_-EG_yRgYNoYUkL9VPwVEk->
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 5 Aug 2026 20:34:58 -0400 (EDT)
Date: Thu, 6 Aug 2026 10:35:25 +1000 (AEST)
From: Finn Thain <fthain@linux-m68k.org>
To: Russell King <linux@armlinux.org.uk>, 
    Michael Schmitz <schmitzmic@gmail.com>, 
    John Garry <john.g.garry@oracle.com>
cc: Bart Van Assche <bvanassche@acm.org>, 
    James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, 
    linux-scsi@vger.kernel.org, hch@lst.de, John Garry <john.garry@linux.dev>
Subject: Re: [RFC PATCH] scsi: core: Drop Scsi_Host.default_lock
In-Reply-To: <18de6750-7668-4855-b24d-515760a31032@oracle.com>
Message-ID: <095e7779-6c40-5257-a684-63cc054c0e20@linux-m68k.org>
References: <20260804113436.2373404-1-john.g.garry@oracle.com> <efff8e1d-0eb9-47eb-ba20-6bdbeeea15e1@acm.org> <7ab3dca8-83f3-4ec7-8bb4-e9c3508a5c59@oracle.com> <9a4ed570-5b19-44ca-9d22-41ab37d21014@acm.org> <18de6750-7668-4855-b24d-515760a31032@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii


On Wed, 5 Aug 2026, John Garry wrote:

> On 04/08/2026 21:08, Bart Van Assche wrote:
> >> Cool, I'll go through this. But how does it handle the arm v3-related
> >> drivers, like fas216? At a glance, the script requires gnu-
> >> a/10.3-2021.07/binrel/gcc-arm-10.3-2021.07 - but I thought that HW like
> >> this requires an even earlier toolchain version.
> > Correct. I think that gcc-8 or older is required to generate correct
> > code. But generating correct code is not required to do build testing.
> > Hence the following hack in my script for 32-bit ARM architectures that
> > deletes a GCC version check from a Kconfig file:
> > 
> >        if [ "${arch%-*}" = "arm" ]; then
> >  # gcc-9 and later do not support armv3m. Hence the sed commands below.
> >  local f
> >  for f in arch/arm/Kconfig arch/arm/mach-rpc/Kconfig; do
> >      if [ -e "$f" ]; then
> >      	sed -i 's/GCC_VERSION < 90100 && //' "$f"
> >      fi
> >  done
> >  sed -i 's/select CPU_32v3/select CPU_32v4/' arch/arm/mm/Kconfig
> >        fi
> 
> ok, I'll try it, thanks!
> 
> I do have to question why we maintain support on modern kernels for such 
> obsolete HW. The maintenance burden is not zero, as we see here ...
> 

The non-zero maintenance burden is a two-way street. That's just the 
downside of the "open" part of "open source", of course.

The maintainer for the relevant hardware port is Russell King whom you 
forgot to Cc. But Linux on obsolete hardware is quite normal in my 
experience, and the issue here is actually the compiler.

I'm not going to attempt to fix the compiler. I don't have the talent, 
time, hardware etc. And yet the MAINTAINERS file lists Michael and I as 
maintainers for two RISCPC drivers:

F:      drivers/scsi/arm/cumana_1.c 
F:      drivers/scsi/arm/oak.c 

Given the compiler problem, which I too have long had to work around when 
build-testing NCR5380 drivers, and given that I have no ability to test 
this hardware, I'm thinking of sending a patch to shift the responsibility 
for these files from the NCR5380 entry to Russell's RISCPC entry in 
MAINTAINERS.

Russell and Michael -- do you have any thoughts about this issue?
