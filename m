Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913621C4EE3;
	Tue, 27 Aug 2024 15:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724773947; cv=none; b=Rtkhu9BnbH5cuKe+0W8zxhtXB0zwIJm1GoxO9mEcXPdlJHE77ScZvjmiC+iJjPyJcJU2GwLBHLnzjVwMZG9HcD+9sKxalmoznh43kQp3ALYhs65/mczk/kAyufOyRZHXXcEIDg/TvAMTDZZ3/DADzU+ilHfzrjloYnpNpPW8Wg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724773947; c=relaxed/simple;
	bh=0Vo4GnU/h3M3K1jWnYOrEc1dy12RZqxDX2LQX4mlL3w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oIY7pU4+fFCzmBL3Yt9zG1XiMdadt1koQoEzuOlRIwiPl4YRGMk8/QK8THWP8KOPqWi3afm/s70lYqffS9Kxa+JravSsBh6zPuOkhMZOu/2+STV/Ysy1WTkab515AT1uMQx/2tDP7cRcJPjB628gruk3MsH38eKLaINqZ2phdvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ztapJpgI; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ztapJpgI"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WtX9h5XBBz6ClY97;
	Tue, 27 Aug 2024 15:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724773938; x=1727365939; bh=0Vo4GnU/h3M3K1jWnYOrEc1d
	y12RZqxDX2LQX4mlL3w=; b=ztapJpgICCnsXGCJu7kgE0+enJV1LzHbwWNGlzmx
	auGf9hOOGL+UGoKbrTAgScgPk1OD0j6sw+swwydeZZ7gw63oSkHYmYRWmHWk4oJi
	qQ3Yg1Q6FKoik9XoCycETbaURLYPuozjVOoyVrQ9vcVbSwK4eZGz/jnhnttqOXsh
	iyk57fa9YUONwaEmyYxlbrM7zL7agA7IzJs1i/ukCaTytGfPhnUO15bV/PGbRep6
	8irOJ1rpUb510XiDy7G/IaDYsqCHm5wyNjRXpkKWbeXox1h3sDRwezaTr2tXHZdL
	NydiTksKCQTvYc7EToU5FpRq8TUho+zvNaalyx3GC3KwJw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id V4rI_lcFRZEJ; Tue, 27 Aug 2024 15:52:18 +0000 (UTC)
Received: from [172.16.58.82] (modemcable170.180-37-24.static.videotron.ca [24.37.180.170])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WtX9T39Txz6ClY91;
	Tue, 27 Aug 2024 15:52:12 +0000 (UTC)
Message-ID: <d2916681-09df-4fe3-9c19-397edd488aa5@acm.org>
Date: Tue, 27 Aug 2024 11:52:11 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] ufs: core: complete scsi command after release
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com, powen.kao@mediatek.com,
 qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, chu.stanley@gmail.com,
 stable@vger.kernel.org
References: <20240826034509.17677-1-peter.wang@mediatek.com>
 <20240826034509.17677-2-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240826034509.17677-2-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/25/24 8:45 PM, peter.wang@mediatek.com wrote:
> When the error handler successfully aborts a MCQ request,
> it only releases the command and does not notify the SCSI layer.
> This may cause another abort after 30 seconds timeout.
> This patch notifies the SCSI layer to requeue the request.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
