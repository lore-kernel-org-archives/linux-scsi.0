Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD273939A7
	for <linux-scsi@vger.kernel.org>; Wed,  7 Jan 2026 17:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767805802; cv=none; b=WLgOm8tRCxF3PoD1yLEfdxoALMOc2d7IESw9hzwDJypV4Anj6EtKVN42NvWdf+0pGLL+pDD4I5R9R/Pw/Am3WcpeYfBKEF102EagHcdQlYRTA6fD95WpmbEIfKSgby+RHd3BIMnEtO72Kj5afWzfD7823ukJC19EFo0PuuR2b4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767805802; c=relaxed/simple;
	bh=mSw3I2OICPe89s9P0Q7sMbENj/OTZRRzZkZvQ63Qr2w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gt4gVAFalY7u0IfXZHqdn3FjPINxGMSemt+3aRaAeP3m1e+929szJwj+n2gfY4N4t2cfi/IizL2ouJqsCEtahYpeTZUk5zb/VcPMb/h4I99I01VrDeFZjt4gUewGCdh+QrB+YVZMMP9U//lTLhlC6vtTnNoNY2FBeo02ri2tR/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=fail smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=SuQwebfH; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="SuQwebfH"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dmZKG0bt8z1XPpVG;
	Wed,  7 Jan 2026 17:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1767805792; x=1770397793; bh=jA92ZfuYul+RGVXXc3m9JtZ6
	l+nWsVJUfTF17k/wdk0=; b=SuQwebfHrg/dXCAUGCIXr9pXQlaB910/5BcprCmj
	j37XvBAOzPqS8svIwOy1gGvjrnnWpESlP96Vc+jqIKwV9ZH9iBrTi4emJCEqON0J
	A/N6xJL7Lddd8SQ356e0BcDzW13riZP4LBArXwEl9x8sbQBXp8RyplTr1J1XNuPC
	2exOVPYzegaC3/r+Hn8RCg6iHgSHRUJLvynN/7VE7fzrRyLK5636s0meKKxJMR0S
	tbfSuq5Wiq/bJgskeQJnN9/x0GNRw8RQeHhJxamaCMo8W24bczC30Xuov2wPag74
	ia1Vn6AouHuaQmA+cf+Bc4/ZwxroZwXLvMltRsbMufbUXw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6blFYXMS4s4v; Wed,  7 Jan 2026 17:09:52 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dmZKC5Jqnz1XMFjC;
	Wed,  7 Jan 2026 17:09:51 +0000 (UTC)
Message-ID: <0a831985-a52d-4b93-8aa1-ad67b99af88c@acm.org>
Date: Wed, 7 Jan 2026 09:09:51 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: Change the return type of the .queuecommand()
 callback
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
 John Garry <john.g.garry@oracle.com>
References: <20260106185310.2524290-1-bvanassche@acm.org>
 <f9f4833e9667e9e0a0e94d656fe8138c06705e93.camel@HansenPartnership.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <f9f4833e9667e9e0a0e94d656fe8138c06705e93.camel@HansenPartnership.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/7/26 5:36 AM, James Bottomley wrote:
> On Tue, 2026-01-06 at 11:52 -0700, Bart Van Assche wrote:
>> Let the compiler verify whether a valid value is returned by the
>> .queuecommand() implementations by changing their return type from
>> 'int' into 'enum scsi_qc_status'.
> 
> What makes you think the C compiler checks enum values?  Traditionally
> the opposite has been true: enum is just a fancy #define, which is how
> we use it in a lot of the kernel code.  Even if the compiler people
> came up with a switch to turn on this behaviour, we'd likely have
> trouble turning it on without eliminating all the fancy #define use.

If I revert commit e414748b7e83 ("scsi: aacraid: Improve code 
readability") and build the kernel with the git HEAD of clang with this
patch applied then following error message appears:

drivers/scsi/aacraid/linit.c:245:29: error: implicit conversion from 
enumeration
       type 'enum scsi_disposition' to different enumeration type
       'enum scsi_qc_status' [-Werror,-Wimplicit-enum-enum-cast]
   245 |         return aac_scsi_cmd(cmd) ? FAILED : 0;
       |         ~~~~~~                     ^~~~~~

This patch also helps those who build the kernel with gcc because the
zero-day infrastructure builds the kernel with both gcc and clang and
hence will spot it if an incorrect value is returned from a queuecommand
function.

I will improve the patch description when I repost this patch and will
change "compiler" into "clang 21.1 or later".

Thanks,

Bart.
