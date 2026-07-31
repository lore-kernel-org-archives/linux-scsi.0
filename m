Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E2232F76D;
	Fri, 31 Jul 2026 21:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785534631; cv=none; b=KhSO7F6p2FOy+E35j5IWdLUccrpOONq+FVhaDv/6Uzk3YM4MZd4C8ilTj0JmHAhfk3uvRieEEpd2fiJLJrIy/OCBhhsm+ruXOc9o8DiHrKQafNtT1hIqZcK5QfwfRmBfrRFB0WIDEptvtdOQBujsbZ4c0Fx/Zu+Hb4LTx9q2ijE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785534631; c=relaxed/simple;
	bh=ZBfCcBlhQfQLGzcbpbbCbt4RLmo56UqCeE7uuUbNFCs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BO0xTHvQ6AT+KA6sKo0z3j9Md4wf02AgL5z74RivK9bTPa0wFpN1bF+8Ptd4Wz6flkMYUz9agoDV6bHZqiJI6bQoYyEDe51ecmoi6MfcR7UNS7jCKWWtKvRYBfm5rrhF9Ia1V3HDBO2tHREqoPTfTKexMDIFFCs9o1vJ6JoRQIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=que3Ik0U; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="que3Ik0U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1785534628;
	bh=ZBfCcBlhQfQLGzcbpbbCbt4RLmo56UqCeE7uuUbNFCs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=que3Ik0UUHi7FhnzXiwhw/fu8NnkszZw/dojd6PYB9C7gfgsEIVn1SxDkApL6fNHv
	 OnTdQaDgt5TOkj0dm99+sAXg08qHfeIA4+pYV5kjthg9npS8XF1TkZNSzFLvVuwVTo
	 dRO+St2CvZ7bGMnFunblrQBtLOoCTVOIHwq10hDM=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id BA7CCBE6E2;
	Fri, 31 Jul 2026 21:50:28 +0000 (UTC)
Received: from [172.23.0.2] (unknown [172.23.0.2])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 27EAE5FB3B;
	Fri, 31 Jul 2026 22:50:28 +0100 (BST)
Message-ID: <ce7ec9dc-5650-421f-934e-452518a40b60@philpem.me.uk>
Date: Fri, 31 Jul 2026 22:50:25 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/6] libata-scsi: multi-LUN ATAPI device support
To: Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org,
 linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Hannes Reinecke <hare@suse.de>
References: <20260611024356.2769320-1-philpem@philpem.me.uk>
 <b889d380-1767-4b83-847e-7d9cda3e27e3@kernel.org>
Content-Language: en-US
From: Philip Pemberton <philpem@philpem.me.uk>
In-Reply-To: <b889d380-1767-4b83-847e-7d9cda3e27e3@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Damien,

I've re-sent them as v8, rebased as requested with review tags.

Message-ID: <20260731213503.2379771-1-philpem@philpem.me.uk>

Thanks,
Phil.


On 18/07/2026 04:09, Damien Le Moal wrote:
> On 6/11/26 11:43, Phil Pemberton wrote:
>> Some ATAPI devices expose more than one logical unit behind a single ATA
>> target: Panasonic/COMPAQ PD/CD combo drives (LUN 0 = CD-ROM, LUN 1 =
>> PD), and Nakamichi CD changers (one LUN per disc slot, up to 7).
>>
>> libata has historically hard-coded shost->max_lun = 1, so the SCSI
>> layer never scans past LUN 0 on any ATA-attached device.  This series
>> lifts that restriction for ATAPI devices gated by BLIST_FORCELUN.
> 
> Phil,
> 
> I lost track of this series.
> Could you resend the latest rebased on for-next with review tags etc added?
> 

-- 
Phil.
philpem@philpem.me.uk
https://www.philpem.me.uk

