Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9BB2222C5
	for <linux-scsi@vger.kernel.org>; Wed,  3 Dec 2025 05:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764740802; cv=none; b=X0OUfvHMWVDECmGWhj4U5TWyOvn8+TneeP4olANFHTYPdCXBnP/cfp1l74FLT4AFkMlblrb9eh2ewRtYZ37wgLEnTWAbc4j8azCP0UMH5/6IMXliF34piTLBnC890T/YSlzjpQpp2y7FcyuglZSZeA3dVRo2ilySldQj75x30fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764740802; c=relaxed/simple;
	bh=uMNPLYS2O/6i0KivwO1nSzMjZAYj9lmknQb9rZt30yo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MlZeR8tyHv7gTZOwpk8Vqt/9IFyuZazrAZiPU1Ukq3lsuaVKvQmXnbZHpWCYK1bHT1aHX3Hibq8rArttsGr+AtVDaY3TaPrZsyGZj/hq2fCbZJmALz1jQpPakK6BWQ3QFSSF4KpkQUhRm3tRNiTfXdV9OX3cSuqKlycd+QYuRAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=FCQvamOZ; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="FCQvamOZ"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dLmq41sHHzlkCQ2;
	Wed,  3 Dec 2025 05:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1764740798; x=1767332799; bh=UbIv3jBuQCeZKUbkoJJ1eHJG
	7J0/DUGhgVsWp76Cthg=; b=FCQvamOZ+CyafWmzeHQdDbg6SA7fHfWd2guDpUaL
	4GDU1Ywdpfi9zg9+DjXPJYhjOJK1UBGATgoPJCkZktLyYmL0lF+550vKrAZyCwAW
	eWs8qYkO4ytKTSeFMIljQGNXP/rUYTWHEWl26ZJXa8xGBYhaAur955rUijF7Mz1o
	TusApsLv/inIhheGvMY798uJ2uYO0Shv/SVAIuybR4rCwcxWFVmlEdqk4yNxvuTn
	g8261ycGI99FQmmyJlb18lvZSSgCxceRdK5ANRLBOfHYKdcdnFQyVv4lZqnCIPZp
	OOnsnZJNVfhqgspg+Efhj1mnMY0dLHEAEMQXlmiRavYFXQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id qyGLygLQNLfU; Wed,  3 Dec 2025 05:46:38 +0000 (UTC)
Received: from [10.25.100.213] (syn-098-147-059-154.biz.spectrum.com [98.147.59.154])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dLmpz75dtzlfftv;
	Wed,  3 Dec 2025 05:46:35 +0000 (UTC)
Message-ID: <84b00b56-e775-43e6-a829-85e5da43508e@acm.org>
Date: Tue, 2 Dec 2025 19:46:32 -1000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 21/28] ufs: core: Make the reserved slot a reserved
 request
To: Roger Shimizu <rosh@debian.org>
Cc: Manivannan Sadhasivam <mani@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Nitin Rawat <nitin.rawat@oss.qualcomm.com>
References: <20251031204029.2883185-1-bvanassche@acm.org>
 <20251031204029.2883185-22-bvanassche@acm.org>
 <ehorjaflathzab5oekx2nae2zss5vi2r36yqkqsfjb2fgsifz2@yk3us5g3igow>
 <5f75d98a-2c0a-4fdf-a2a9-89bfe09fe751@acm.org>
 <6fw4oikdxwkzbamtvu55fn2gqxr3ngfzymvxr6nxcrjpnpdb2s@v325mijraxmg>
 <75cf6698-9ce9-4e6d-8b3c-64a7f9ef8cfc@acm.org>
 <in3muo5gco75eenvfjif3bcauyj2ilx3d6qgriifwnyj657fyq@eftlas3z3jiu>
 <d7579c22-40d0-4228-b539-4dfe4e25b771@acm.org>
 <nso6f36ozpad36yd3dlrqoujsxcvz4znvr6snqwgxihb3uxyya@gs6vuu76n6sx>
 <5c142a9d-7b41-422a-bbff-638fda1939dc@acm.org>
 <CAEQ9gEkz=Y1ksXL0wCumb7zbqXTREqJ6Vn29P-7FWS_e=iuuVQ@mail.gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAEQ9gEkz=Y1ksXL0wCumb7zbqXTREqJ6Vn29P-7FWS_e=iuuVQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 12/2/25 2:56 PM, Roger Shimizu wrote:
> On Tue, Dec 2, 2025 at 8:03=E2=80=AFAM Bart Van Assche <bvanassche@acm.=
org> wrote:
>> Can you please help with the following:
>> * Verify whether or not Martin's for-next branch boots fine on the
>>     Qcom RB3Gen2 board (I expect this not to be the case). Martin's
>>     Linux kernel git repository is available at
>>     git://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git.
>=20
> No, same boot issue for mkp/for-next branch.
>=20
>> * If Martin's for-next branch boots fine, bisect linux-next.
>> * If the boot hang is reproducible with Martin's for-next branch,
>>     bisect that branch. After every bisection step, apply the patch
>>     below to work around bisectability issues in this patch series.
>>     If any part of that patch fails to apply, ignore the failures.
>>     We already know that the boot hang does not occur with commit
>>     1d0af94ffb5d ("scsi: ufs: core: Make the reserved slot a reserved
>>     request"). There are only 35 UFS patches on Martin's for-next bran=
ch
>>     past that commit:
>>     $ git log 1d0af94ffb5d..mkp-scsi/for-next */ufs|grep -c ^commit
>>     35
>=20
> First I want to clarify 1d0af94ffb5d ("scsi: ufs: core: Make the
> reserved slot a reserved request")
> has boot issue.
> But applying for the debugging patch from your email, it boots fine.
> So the bisecting start from here.
>=20
> Bisecting result is:
> 08b12cda6c44 ("scsi: ufs: core: Switch to scsi_get_internal_cmd()") is
> the first bad commit.
>=20
> And this commit can apply the debugging patch (below) without any confl=
ict.
> Hope it helps, and thank you!
Thanks Roger for having taken the time to bisect this issue!
Unfortunately this information is not sufficient to identify the root
cause. This is what we can conclude from the information that has been
shared so far:
- The boot hang can't be caused by a ufshcd_get_dev_mgmt_cmd() hang
   because that function specifies the flag BLK_MQ_REQ_NOWAIT. That flag
   makes scsi_get_internal_cmd() return immediately if no reserved tag is
   available. If scsi_get_internal_cmd() would fail, the caller would
   emit a kernel warning. I haven't seen any kernel warnings in any of
   the kernel logs that have been shared so far.
- The boot hang can't be caused by a device management command timeout
   because blk_execute_rq() is used for submitting device management
   commands. blk_execute_rq() uses rq->timeout as timeout. Even if
   rq->timeout wouldn't be set, the block layer would initialize that
   timeout value. I haven't seen any data in any of the kernel logs that
   indicates a device management request timeout.

Could anyone share the call traces produced by
"echo w >/proc/sysrq-trigger" and also the output produced by
"echo t >/proc/sysrq-trigge"" after having reproduced the boot hang?

Thanks,

Bart.
