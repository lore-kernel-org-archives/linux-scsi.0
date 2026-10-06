Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C59B4A1DE4;
	Tue,  6 Oct 2026 16:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791304331; cv=none; b=st0PAowaqlaZghI/7/mNSqOXbdskE8XxOVyH3U9Nj7ncMvmUAOTxlkdPgbyu0RjTDSA0QB7qivgAWQRLYdeEh41pfeD2VXCzylQtXIrfJxEJx74sz0VuDb0t2336OE8+SPkEY8r9g+74zZrvq6y1Xp+valiNZVRy6YjNM9oIru0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791304331; c=relaxed/simple;
	bh=pjCc01+8pIFjZj+7YZaCRosgmuQ8UUGJvr/un9aHyMI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nCv9KPxNwHN4336BBm67nUoqtfO/DOw1n+7FbZl3sMjlLy56ztds2TyRCx9yecicQPLs+dgRG06P0Z3jl3fCC05aEsrHq8sVhjAPi5qAY1bnICz1tpckbwZ1Isc4D+DEW6v6MiIjEOxOyUj8dHfo4oWXRh86OTHS4oqjPHvTCfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=C7A8sobV; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="C7A8sobV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1791303159;
	bh=pjCc01+8pIFjZj+7YZaCRosgmuQ8UUGJvr/un9aHyMI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=C7A8sobVI71uEloi6+/JxxFjzCKO3FQYOq1YsMxvjsRRXcg0LjO/6S2PblqIVo+e1
	 v3H5Lm+xLFS4/1gDjgui/rhUo73bQOb58qY21gJKxxF777VL/k67bwLxJIHIgPEMN8
	 SZ0ILzZetkYXK/pDDD9JSZRaU65v1ARiS1XtnRys=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 4A588BD334;
	Tue,  6 Oct 2026 16:12:39 +0000 (UTC)
Received: from [10.0.0.32] (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 0105E5FBAF;
	Tue,  6 Oct 2026 17:12:39 +0100 (BST)
Message-ID: <0a7bba64-c0fb-43c7-bcaa-d806f2377afd@philpem.me.uk>
Date: Tue, 6 Oct 2026 17:12:38 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/6] libata-scsi: multi-LUN ATAPI device support
To: Niklas Cassel <cassel@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Hannes Reinecke <hare@suse.de>
References: <20260731213503.2379771-1-philpem@philpem.me.uk>
 <apVF22SjDzqkzEkm@ryzen>
Content-Language: en-GB
From: Phil Pemberton <philpem@philpem.me.uk>
In-Reply-To: <apVF22SjDzqkzEkm@ryzen>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 31/08/2026 10:14, Niklas Cassel wrote:
> On Fri, Jul 31, 2026 at 10:34:57PM +0100, Phil Pemberton wrote:
> 
> (snip)
> 
> Hello Phil,
> 
> 
> There are quite a few comments from Sashiko both on v7 and v8
> (which is just v7 rebased).
> 
> Note that Sashiko's output is probabilistic: it might find or not find bugs
> (or find other bugs) with the same input.
> 
> So please look at both the comments on v7 and on v8.
> You don't need to fix all pre-existing issues, but we would prefer to not
> introduce new issues that have been flagged by Sashiko (unless they are
> false positives).
> 
> 
> Kind regards,
> Niklas

Hi Niklas,

Thanks for the comments - sorry for the delay on my part. I saw the 
automated Sashiko reviews but was pulled away onto something else.

Would it help if I responded to the Sashiko emails individually, or is 
responding on the next patch covering note enough?

I've also reviewed the guidance on use of coding assistants 
(<https://docs.kernel.org/process/coding-assistants.html#attribution>) 
and added "Assisted-By: LLM" to the patches.

For full disclosure this round involved GPT-6.1-Sol, GLM and DeepSeek4 
for review. V9 will be on its way once I've finished testing locally, 
and should address all of Sashiko's comments.

Thanks,
-- 
Phil.
philpem@philpem.me.uk
https://www.philpem.me.uk/
