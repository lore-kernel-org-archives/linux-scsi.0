Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F13B413783;
	Tue, 28 Jul 2026 21:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785273097; cv=none; b=U2RIp7tEij3El3kU+c4ZIvaNFvkxax4diaMUyHEAebrD/ErJW6IZYaAIf5zOAeA5C8m46+8Wz0xoZm7w8ZNVvbldJ84I9a+gS43bAluiOrpfSaOtjjEPNwd0J6Vh15Gv3BdumSf3SUzZb82uonjmNgplxN7th3jEaw9+0lRi/sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785273097; c=relaxed/simple;
	bh=k4jxbQoZpbJDl9jnENxkOrfT0RguNu8VljtjEl/1F6s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ksdYaxXW/nLk9RQPg1ESPsUyCP5DcczirEz2uJxkob+AGaevTa41X99XTPH7G6GVMGw05IEuKinCGxPz1WLXzSCPiSGUQobioFxTZ7sNjw7tbNRsMdyYiyJSBC5+Qh93MmSToODbvlkenAdg6MKPC7sqLYlwGpxfVWkhgw84Exc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=aKXaEXt7; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="aKXaEXt7"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4h8p6p68VmzlfsXm;
	Tue, 28 Jul 2026 21:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1785273085; x=1787865086; bh=k4jxbQoZpbJDl9jnENxkOrfT
	0RguNu8VljtjEl/1F6s=; b=aKXaEXt7FjGa8YWk7y3DYTpqO89VlNMmvnd8lkKI
	Os+fVhDZUwAXWYyNPUZaBAsnIYCeOlHxyPGTpnWaJyUvb00ZflLpedxIxE4Wgdj2
	KHKUwSJtLSIvRIGcshnYi70W/dFSr6h5v07xRrDL0wFdtIENo1piqWdCDNm0Ofcq
	NQsqMJLKjRYiHYVe5G94862YCJ1INGHpLQcvg+GoSodnlUBn6Xpity5zYknB1BMb
	aFSixH09GaINUAct2RnTNdWhSt7VhJxoga45ZuH77S1tQULrkr+OjgYL6NTjgzq8
	cm2XFknx7knWimRH4DBXp7iEJHovDezVqsnOm3Qj2yMzGQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ShJ3p02zEh2P; Tue, 28 Jul 2026 21:11:25 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4h8p6d4pXQzlfwgP;
	Tue, 28 Jul 2026 21:11:21 +0000 (UTC)
Message-ID: <22266661-47d6-47bf-bb08-a3d851e07778@acm.org>
Date: Tue, 28 Jul 2026 14:11:20 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] scsi: ufs: Add support for the aggregated read
 query opcode
To: hyenc.jeong@samsung.com,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: ALIM AKHTAR <alim.akhtar@samsung.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Jinyoung Choi <j-young.choi@samsung.com>,
 Dukhyun Kwon <d_hyun.kwon@samsung.com>, Jeuk Kim <jeuk20.kim@samsung.com>,
 Keoseong Park <keosung.park@samsung.com>,
 Jaemyung Lee <jaemyung.lee@samsung.com>, Jieon Seol
 <jieon.seol@samsung.com>, Gyusun Lee <gyusun.lee@samsung.com>,
 Yunjae Jo <yunjae00.jo@samsung.com>
References: <20260728092208epcms2p881b17276fb41c006a4229c1d073b4ad0@epcms2p8>
 <CGME20260728092208epcms2p881b17276fb41c006a4229c1d073b4ad0@epcms2p8>
 <20260728092741epcms2p8c53432ef3c2f0d6a63dd980ad5ef9f00@epcms2p8>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260728092741epcms2p8c53432ef3c2f0d6a63dd980ad5ef9f00@epcms2p8>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/28/26 2:27 AM, Hyeoncheol Jeong wrote:
> UFS 5.0 / JEDEC 220H introduces the AGGREGATED READ query opcode (0x9),
> which retrieves an aggregated data packet in a single query request. The
> packet may bundle multiple Descriptors, Attributes and Flags as
> group-headed groups, returned in the Data Segment of the QUERY RESPONSE
> UPIU.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
