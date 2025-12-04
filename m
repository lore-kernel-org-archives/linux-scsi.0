Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525AA1E2614;
	Thu,  4 Dec 2025 02:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764814069; cv=none; b=sPlVdZG5yH/aku1wzUNEIJnpYMeD0xKtwevjoWZ9z1QCdkweNc3LxiTAdh1J7o1edfXcPHFbnfPVG4sR3Sddav12m9hutQhNgmG8fOD12uw/RJo5GRo5F0zvd5LSplyv1xMTXZ500ic/L1+GwxaQYGf+KK3i2/fv08xb2FCIY4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764814069; c=relaxed/simple;
	bh=zdKFLeCMVqhr2CF2O+YwK9MjLgn/XXi+hpYMDKRvYUE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nUToczr4de9Vxgt6RcZ4R58BUf9eTf2p6i/ppZ3UXEZLkpZE6RUri5s5r/wmw9ujrtKukAO3jbNrwwART4hI/zPdMVGlWqDXsWsDTyEbCP5JHW061TcwQ32hVGFPw1Wv7ZPlI0PfvUra3Za7ytRu+sxBEb/mj4SZdNOqYydRb7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=EYsWiEni; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="EYsWiEni"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dMHqP3LD4zlqfHR;
	Thu,  4 Dec 2025 02:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1764813823; x=1767405824; bh=E+xVTwpeA1DPxqvARqwqMeMt
	y38gkdi/WiDqbaNCkaQ=; b=EYsWiEniO1cFhRXDk89/Akhk9XPsfwmy6qeVEy3V
	RpO47QiT+x4Ufk7CgcN0Pz81FWk/UFagsdkBFnCboEEkWp61wUeoQEUAed4altba
	8mAeXOFccYHA3F1H+EnbHRuof4R4vyhlo48GWObzmDDo/uddO9vFVUG2qWFVHT1t
	yLH+AfBFg1zeNxjAsI6pH+TUeIjrPp+urZ1zbGpBOSnUYIFWVok4H36k/XtSSixs
	5F3xC7WvZVk5tv7SGGSym9S3yfY3iEVuJwgeNZ9jlHRi8Gs+wRvn4HX1GrzQ0J+x
	L8g7tfAEWGTTQxJdluJhHQsp3WFFLBYOyMuFcNpI/WQVZA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id KRFGWJRhGB81; Thu,  4 Dec 2025 02:03:43 +0000 (UTC)
Received: from [10.25.100.213] (syn-098-147-059-154.biz.spectrum.com [98.147.59.154])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dMHqH1FLCzlqfHQ;
	Thu,  4 Dec 2025 02:03:38 +0000 (UTC)
Message-ID: <de6e39f9-476b-4867-ad55-1f3f3bfbe25d@acm.org>
Date: Wed, 3 Dec 2025 16:03:36 -1000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 1/2] scsi: sd: fix write_same16 and write_same10 for
 sector size > PAGE_SIZE
To: sw.prabhu6@gmail.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mcgrof@kernel.org, kernel@pankajraghav.com,
 Swarna Prabhu <s.prabhu@samsung.com>, Pankaj Raghav <p.raghav@samsung.com>
References: <20251203230546.1275683-2-sw.prabhu6@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251203230546.1275683-2-sw.prabhu6@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/3/25 1:05 PM, sw.prabhu6@gmail.com wrote:
> -	if (sector_size != 512 &&
> -	    sector_size != 1024 &&
> -	    sector_size != 2048 &&
> -	    sector_size != 4096) {
> +	if (sector_size < 512 || sector_size > BLK_MAX_BLOCK_SIZE ||
> +	    !is_power_of_2(sector_size)) {
>   		sd_printk(KERN_NOTICE, sdkp, "Unsupported sector size %d.\n",
>   			  sector_size);
>   		/*

Please use blk_validate_block_size() instead of open-coding it.

Thanks,

Bart.
