Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38DC9499F15
	for <linux-scsi@vger.kernel.org>; Mon,  5 Oct 2026 14:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791209386; cv=none; b=bN5HbzK2VF63vUj4XNghH8iPun/7yVWKRyNFY4E9G985AqLztk4asumKasOWZGFu3+4tnzMaOhiMVUDetiSj6dxBUxZe6Tpgon8n647/lhQSrmi4QaxHAnj/xU2D10sL4FS3Q96F4XXmyc365HoxsGupcpctbfgl8sboPe4raIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791209386; c=relaxed/simple;
	bh=0y2EFnWLqY4sRDLWt+zvNH4eikkE6qZYmGsErTpNqf0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nMqY6hf/7TrMBZ+fc/NMu1/2/G4fc8iDS2OfMs70uzMRxF93xdRIubMVBspBFi8yDbfWJVVnL0tjSnA9X3rNeb7t6PBxvhPPRq0jcjtrLUpglOYdAOKc2M0cJZCT3/5g/J3+7C9NzS3c5oMxYd24K2oWHQKDngNSDGSRSdVxge0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bllkZWF1; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bllkZWF1"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49b912d822dso15655005e9.2
        for <linux-scsi@vger.kernel.org>; Mon, 05 Oct 2026 07:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791209383; x=1791814183; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vq5Hi5+WboGt8dWZLLlgdEJdIoq3FZnGz5TdS8VWTXc=;
        b=bllkZWF1Q9P0E6hnc3R/KFYN0STv2ATrYZLCGS88JHqNx1xhfV/f5/tzQV9dCZ6DOG
         p5Dg+THuJlmyIZqwNBNk6qvxPizSXhwBUCzHaqi+VTsJBlVEmaHp55Xxk1NV/aWeqB4G
         iu9sr1Qnsf+RnusYk0ALSN9ON8yn7u6zQh/uMRx/u2YKT3zHqdgHpAtJCV+2aOIuHo9K
         3vWUQNeIITexRGXGl71uluiUblb2fUkNLpviL73wQNMDa2tp2ltEXIAsHh9wfMiuDQc2
         w6FflQXxeYSBRlLkoMRLuYJ2rlZAb8j9esSHn3cF20Fz0603tySabRVjoB8PBUyuuYAL
         6M6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791209383; x=1791814183;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vq5Hi5+WboGt8dWZLLlgdEJdIoq3FZnGz5TdS8VWTXc=;
        b=0GxYtH+mlCoc06dKB/J1LE9iagjgM/th9539ysmUoLeLE9BoAkMHdcPcF4yVeIBKHS
         mAzjyAeD6cye6Bc41X4YZgUe/XkyT5Ukuk2yVKccjDs09ukXmUlo+P3eguLmgnpttwX2
         vDMWs9aHaRIwRf/xwsIziIgRMgIPr18jkonUvBIXPr3CWXdw67iDdmsxj8UzTRr2Kgrl
         StXxrQJQSNF1MK9C70apcte1XmxgN4ZKenRL1tEuar/046atIMWexmDHqUBAZ41jU7DF
         V/S/6xDD3/aL9ZogKYB0MSOBvJPFs71+ygShHzq829tdl0GbY9ia79ULykrCVO+EuQGW
         hr4A==
X-Forwarded-Encrypted: i=1; AKwUvBzQks5stMyyA6zXEuvzb6SHwj6gX9zDgb5d+kF0ayM7qovjHFT27zJXTsK5Gjn+U8APDvM4sS88AGCx@vger.kernel.org
X-Gm-Message-State: AFuF++lgdTU2hjh7tqV4PjRagseevOqzHqf6Ao72a3YHEdA55ORKs7oq
	XXbO8zM8IEvTM1lFHj1mIUhf1ukzdoWQfi5TLbJuCbINtSqVi6W5o924avsmPjVOmVs=
X-Gm-Gg: AYBFou1dZlHLGVU3ScM5cqLHs016UjqzKbhf5pw1tBgfOkkh2RhUVZxf05SjsvnA8C4
	SRWZRuktif9egJN9sv/VEKJe9LAMZm0y9cXvnX3TOnA6etlaytIsqo0Kj3orRqqc+45XPaKrI4M
	XXWxAR1avCE4/g/01NaXUGtAc71hOXMZ1ASP5GV2s/1RCJCr81Dlc43+e2tm8qcAESI4naXn4Yi
	BBw1xZGmGYrUAFLJTPC/ZeX2edv5w7eiUiPjekKp7yWVj9/T/VapH0h57DsHDqbElCySYk1L/qH
	najL0csIuMDeudmVEuC2+TD9Di9g/9dQWOyEV6x/okZeDRyWDqEq2EbopGHMVk8ZOdLTlngscag
	t3uCvrKTA38JN/vncqNXSN/4l+xOWCVFFwA6WfZbCy0ERnkSiAUOZqwwOTpctM8DxZZ9LMess4g
	UAKf76yGdSCloNanXzAqbW9mYL5zBxEhtfL5Y0WPo1Usws7LOLXK9eNR3QH+vkAx8McObP1aNnq
	pDd9FQ+FMEZ/CkbR0bhUzHbZ3YEtjiAo4db+t01Mg==
X-Received: by 2002:a05:600c:37cd:b0:49d:1840:4fd2 with SMTP id 5b1f17b1804b1-4a0275a1d84mr192922805e9.23.1791209383347;
        Mon, 05 Oct 2026 07:09:43 -0700 (PDT)
Received: from ?IPV6:2001:a61:139b:3801:fa57:89a5:c5ae:c89c? ([2001:a61:139b:3801:fa57:89a5:c5ae:c89c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a0280ceaf0sm374240735e9.12.2026.10.05.07.09.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 07:09:43 -0700 (PDT)
Message-ID: <cf1b312d-66d0-4651-8419-e838a531a7f5@suse.com>
Date: Mon, 5 Oct 2026 16:09:42 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] usb: uas: quiesce SCSI before stopping endpoints on
 unbind
To: Michal Pecio <michal.pecio@gmail.com>
Cc: Jiayi Li <lijiayi@kylinos.cn>, Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
 linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
 linux-kernel@vger.kernel.org
References: <d3639d68-0213-4b70-a771-aa5dc3ec9767@suse.com>
 <20260930013332.829717-1-lijiayi@kylinos.cn>
 <813dcf3a-0615-4152-baa7-47b0046ca113@suse.com>
 <20261002145112.3ee2b500.michal.pecio@gmail.com>
Content-Language: en-US
From: Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20261002145112.3ee2b500.michal.pecio@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 02.10.26 14:51, Michal Pecio wrote:
> On Wed, 30 Sep 2026 09:22:49 +0200, Oliver Neukum wrote:
>>> When URB submission or completion returns -ENODEV or -ESHUTDOWN,
>>> it marks the transport dead, stops further submissions, clears
>>
>> Why this specific trigger?
>> I am asking because -ENODEV comes relatively late in the process.
>> URBs tend to fail long before that.
> 
> But it's sufficient, right? Apparently all we need is to detect
> USB disconnection before disconnect() runs. This will do.

I am not sure you will necessarily see anything fail with
ENODEV

> But UAS driver infamously has no URB error handling; if anything
> goes wrong it just waits for SCSI core to abort the command. Not
> sure why things are this way.

Good question.

	Regards
		Oliver

