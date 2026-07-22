Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A3D2F6596
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 14:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784729350; cv=none; b=QN0gxh2lyfzH4X0z04cGQLHSqENw6sO2OVfQrPNN6GeIGoShdCYmjLui8A1aFFqJqn3ISev1N2bWs+UqFnJcSRAqJPjirZZ31vDEvTaPxWiioV76DCj6LZ8VFkpCzOFTU+o9qW4gXPJXT5yVY+2g50bb/Z/v3R4f7mmbSrGy5A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784729350; c=relaxed/simple;
	bh=+Il7aPUChEdhFvAeoaNLs0rO35a5R2YkhDm+oIEKVWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uxpAOa30a0EJ9yD5lfiisQWNVkA8BH8LaNri5vdmcPLHEh46bwniOvRBB2df7me5GFfccBm7C2IniiwFkxDCxxtez9IK9aaKeZ6mBByPUyYmNHpxu9zG1jTjrAxOsyjOINeLOA7IV6Jidca7L3sKVoc4DbgbGknL58L6+8dJdho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=gSNeLcdj; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="gSNeLcdj"
Received: from macsyma.thunk.org ([104.135.218.88])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66ME8nZp021174
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 10:08:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784729332; bh=zDgIK2+O/87NoLwHMSMPGB+OQP4ARWVrKZ/oRxnG0N8=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=gSNeLcdjEmNLgFdC8P7qNfLiGlEXKUFEnc7LCld2Sfx4EksGZt8yOo8uE4SMCStX+
	 VLIVIURd0LUjV5KLWuEAF2IdU6lYVacbnTA5lAAs2HapRiaLdE8l2YTwJeuW/PqviV
	 A4WeoOtPB4aGfC1ymFiz7VC+8d8PPaGiWU/BCQXM8RRk3B93bKFj6TsPDMQXhDIg2w
	 /X9uMMi27AAi8oO8PFnPYI83XTna5lRmhThZ6BmBzFQnSRsAdo3gEOj8SwEs3YJsho
	 On4e7GVgLsKZsfPGhmnbTEj/+zyf1bJ4rBpOrgOUyvQavSK5yQmQyl78ilmB2zVDs/
	 7vbslVeKDHrlg==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 150F2BA381A; Wed, 22 Jul 2026 10:08:49 -0400 (EDT)
Date: Wed, 22 Jul 2026 10:08:49 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, sashiko-reviews@lists.linux.dev,
        Chris Mason <clm@fb.com>, Roman Gushchin <roman.gushchin@linux.dev>,
        linux-scsi@vger.kernel.org, ksummit@lists.linux.dev
Subject: Re: How to fix problems with the sashiko review model
Message-ID: <amDNVMsOjIPcXP2y@mit.edu>
References: <20260722041257.1557-1-pengpeng@iscas.ac.cn>
 <20260722042744.5C1B01F000E9@smtp.kernel.org>
 <dcadf40a07a616de931c484bbe68f4b3f1f83b80.camel@HansenPartnership.com>
 <2026072224-moisture-gonad-409f@gregkh>
 <2026072205-unsealed-emcee-b243@gregkh>
 <ed0f74db3342ead9a36a0367b8a5cf694b0decf3.camel@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed0f74db3342ead9a36a0367b8a5cf694b0decf3.camel@HansenPartnership.com>

On Wed, Jul 22, 2026 at 09:45:48AM -0500, James Bottomley wrote:
> So you're thinking of this file:
> 
> Documentation/process/threat-model.rst
> 
> ?  It's already mostly in there, it's just that sashiko doesn't seem to
> be picking it up (otherwise it wouldn't have suggested the problem I
> noted), which is why I was thinking it needed to be a direct prompt ...
> unless the prompt should be to read that file?

The threat-model.md is relatively new (May 2026), and there are
various security people who have asserted on linux-kernel that we need
to be afraid of malicious hardware.

I'll note that I and other file system developers have asserted that
mounting malicious corrupted file system images is not in our threat
model (and if you want it to be part of the threat model then fund the
engineers; if it doesn't impact performances, patches gratefully
accepted).  And it yet it took **years** to convince the Syzbot
security folks that this was something We Didn't Care About and to
please stop generating the noise.  (And even now, root can modify the
loop device using loop the device ioctls, cause a kernel oops, and
this gets reportred as a security issue.  Sigh...)  So this problem is
not unique to LLM's.  Syzbot and oss-fuzz generates a huge amount of
noise, and I've just learned to ignore it.

The bottom line is that there are differences of opinion of security
people who like to opine that we need to adhere to the most expansive
threat models --- but they don't actually fund the engineering work;
they just like to dump work on the kernel development community.  And
that opinion has probably infected Sashiko's training data.

The approach is probably to adjust Sashiko's prompts to have it
explicitly read our threat model, and to have that take precedence
over its training data.

Cheers,

						- Ted
