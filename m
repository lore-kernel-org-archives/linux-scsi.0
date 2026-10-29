Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.209.128.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793235168;
	b=1S9+BXcmxSUXdehSrRXgqeKKVT0cwgHkUEcYEAw968n+XvOHbNwieGQMthtYYMUIi/wE
	 nQ1SGMLdnbb549KoGuOqutUv4+x0dB5MaS/cN9kDVw2sk1ZN04v6R7MpASQNL6ed8PBYk
	 VWmwz5ORaA5KhWkedEUV+XKHt2h6vBaHb2keDtHYgYI+2MALMvziJ2GE6ywrmwMRlU/J4
	 jaPYGr49HnpIycy8lbCMhWUoYrFcf+iema+KtapBDgLNTb+6Pf1WNzrI0wsN8YCdPpwjf
	 ORvRFAiJvgaSpJQ6OvAhJJ3TiC0OzvbzJvcSyKN5RE63rPMO1ls1c18d7CzwIYmJh/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793235168;
	h=DMARC-Filter:Received:Message-ID:Date:MIME-Version:User-Agent:Cc:
	 Subject:To:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-HM-Tid:X-HM-MType:X-HM-Spam-Status:
	 DKIM-Signature;
	bh=jOrhTVEfgHemb3Re8uZ153gCT4ldGKVvOgMhkeZdfa8=;
	b=ewQo3jJAUCqvt+9z4P7ij4Pvlg7WpFott7PVqwLTAv6rJ7/n2RPSjH5oWgEhg0mpEKmu
	 Ln63c2gPr09PcwKR0ycU+l0qgb+yXESSMi28vLg4UxcHml+oFdLZmdzI4Vlk6gqWtv/GW
	 Y5hjJYA8F812yLLQmwmSgFqPIt/rVXLl3E+xWjHb6Zbai+mdSEG95Zdg9o4kShmsrPE8H
	 V/FVdf1MBgCoQgTORhuO6LvJCeOeHvn37s5t/Zf8v/uJ/x7N2/paHOH1a09cQ9PBXwStT
	 JVKG1byun/YhegIDgiDi+3dr4rauuQLxwiff7KGlDFyU+FRrFr0XffDJtcD0a9P1v0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=rock-chips.com;
	spf=pass smtp.mailfrom=rock-chips.com;
	dkim=pass header.d=rock-chips.com header.i=@rock-chips.com header.a=rsa-sha256 header.s=default header.b=W+TkivZ5;
	arc=none smtp.remote-ip=103.209.128.11
Received: from mail-m12811.netease.com (mail-m12811.netease.com [103.209.128.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E876606A31A
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 00:52:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E876606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=rock-chips.com header.i=@rock-chips.com header.a=rsa-sha256 header.s=default header.b=W+TkivZ5
Received: from [172.16.12.48] (unknown [61.154.14.86])
	by smtp.qiye.163.com (Hmail) with ESMTP id 52b6f1694;
	Thu, 29 Oct 2026 08:52:37 +0800 (GMT+08:00)
Message-ID: <317c3705-b492-4a1e-a764-1e632a85e2bf@rock-chips.com>
Date: Thu, 29 Oct 2026 08:52:33 +0800
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: shawn.lin@rock-chips.com, Bean Huo <beanhuo@micron.com>,
 Heiko Stuebner <heiko@sntech.de>, Stanley Jhu <stanleyjhu@google.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, linux-rockchip@lists.infradead.org,
 linux-scsi@vger.kernel.org,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <mkp@kernel.org>
Subject: Re: [PATCH] scsi: ufs: core: Retry the full device init on fatal link
 loss
To: Bart Van Assche <bvanassche@acm.org>
References: <20261028073129.1661829-1-shawn.lin@rock-chips.com>
 <c494f758-e3ad-4638-a17e-44d5f9234ef2@acm.org>
From: Shawn Lin <shawn.lin@rock-chips.com>
In-Reply-To: <c494f758-e3ad-4638-a17e-44d5f9234ef2@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa18525005103a4kunm7f81231710029b
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCGEtLVkJLGk1JHksZHk8ZHlYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlNSlVKTk9VSk9VQ01ZV1kWGg8SFR0UWUFZT0tIVUJCSU
	5LVUpLS1VKQktCWQY+
DKIM-Signature: a=rsa-sha256;
	b=W+TkivZ5H4rLaGT/KPr6tsKTjsqkX/f+RSa18XpOk5s9JiVF7Owc6lhj6p2dZHfO3hh9CEzjt7aRymM0diriBLewsk1UeI13fcV0LsdTGVEplkh8MzdSnhe9KR/GTIEDCJ4ueIQ2IKkJd/FXKkdeLX/z7Pd+dWim95Ekh27pL9Q=; s=default; c=relaxed/relaxed; d=rock-chips.com; v=1;
	bh=jOrhTVEfgHemb3Re8uZ153gCT4ldGKVvOgMhkeZdfa8=;
	h=date:mime-version:subject:message-id:from;

Hi Bart

在 2026/10/29 星期四 4:16, Bart Van Assche 写道:
> On 10/28/26 12:31 AM, Shawn Lin wrote:
>> +retry_init:
>>       hba->ufshcd_state = UFSHCD_STATE_RESET;
>>       err = ufshcd_link_startup(hba);
>>       if (err)
>> -        goto out_release;
>> +        goto retry_device_init;
> 
> Move the code that needs to be repeated into a new function in a first
> patch and add a loop around the call site of that new function in a
> second patch. Don't change ufshcd_init() into a goto-spaghetti.
> 

Will do, thanks.

> Bart.
> 
> 

