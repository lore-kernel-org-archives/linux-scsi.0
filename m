Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F704D5BD;
	Thu, 27 Jun 2024 09:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719480009; cv=none; b=DJv+ZFgExWEuG5DEKzoCfVlHFABRSSsqzMbkpeovtYmeShIPy3S7eNphf6uJNjbZHstL+EX/w8S6gu2S+YIUvkoaYb8RP0bb2hgjCo4Gv5FiJLQ7noN67Bo0Ig9H8FRSleRehhkh/gZUw8zsWsCPoybpJl10o4nkUsJTURXPUN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719480009; c=relaxed/simple;
	bh=MQLSZlmH3qjJ6RpohjgJZOR7RPGiFHW+m36Q4B31n2E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jNl8Zg1rz4Vc1Asnn4Y27eOX94CZX2bVVRP/CAyjuweRk7B2U6gg7rsV7BI8Mc83Pj4/9LvEFjHV+jnufFBUaXfk4QjToc40BsqTtu193jKHc8iVKrsWMeKFU2/LOQ+S0PCuwxgnkx/fFulRBPl0gOXfSxFj1EmTqEWXRcyW1Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=enwhNREi; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="enwhNREi"
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-3d5d7fa3485so243029b6e.1;
        Thu, 27 Jun 2024 02:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719480006; x=1720084806; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0ETjSuiBGz/j4BOauY9/duKhstSMiIxQ7/voA5iz9AU=;
        b=enwhNREiaTiTDqeFHuSwzJjBX0FQQtT9yUcn7hGIuzkkZBJq/xUStK1V6xT6+Z25gf
         iBb0QojsozeXzLhKQN4HS+3OUqQKZlS6HJVXwp0JJ2JhQ813850dyi3yickRk+wDr/t7
         Cc+hhiPhYqPWoZhEiz5o4qVs6KD7MTuY+Cj74vgyQOhxQQbJYnt8G8jt+HTLJYjFi8sR
         Gw9rM9Ds3GO+8cDrpoCQdb23wV+tw3zjtgncbtHU6q1329YMtBXhneWG3AfHpxbaRFMx
         i0pi7T9KkEP5bs77sH2MxDFwi5JKgblraMYJofSuhxPn0kNS78WFb/3JD8UYEL18w4YO
         3sgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719480006; x=1720084806;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0ETjSuiBGz/j4BOauY9/duKhstSMiIxQ7/voA5iz9AU=;
        b=NtIoU5Vu5X7rxk0o756+HaTMJTyi1o1RAfioFew1G4VHkio8C9nXQmBM6eBFZl4P2i
         1bLevg5Ww9ao/UW29srz2A+Tn81+wbDZhKVGM7wNLf27JpZx0YHEEBEtnsho1UnDgZlA
         sFRVJepCxRIDJ3QZ0mEcmsJpJqp8hJVOfz/Rwh0+fyk9+7TXlZgmRh9CjvdE+UqkcMoH
         Et6fBMHbZMyjU/ovM+WHS5IIlOsl9DEgOcvpKUAbsKkegTjb6BLKvqJbCQ120XBQ+Ach
         Ei7Cg+LwqW3uAP00jjyzGkqkAhuWi13VZRPRlwVt5FnBEqBZjxGo0kPdmqbqmJZVNdM+
         o+Eg==
X-Forwarded-Encrypted: i=1; AJvYcCV4u+Q07RxPVQknGhucQpOyPEabDISM0476jMTfKz6PXSqNTmXwvWevEHqgu06u9CBsEgOiVNp3hY+nsGDx1ktvjpegtYj3Tditu7BVcqk/xCphuPj4Jmok6jsBm3dlwHQi3A==
X-Gm-Message-State: AOJu0YzHL2vKsFj8h77E6FEQE8UsB889ExWQxy4t91owsd+588T63Yrl
	Rev+FczipreFjit9ns3UcTFzU23MPBJx8bkmEbjPYmbjhX2bunMm
X-Google-Smtp-Source: AGHT+IHjdpOyBFenniHMqFqVjKBOxZ6X632fUyQ+pzaAHZpGbnal/OLNuPUb9R3gz3dfs+8P38opOA==
X-Received: by 2002:a05:6808:13c4:b0:3d5:5e88:d125 with SMTP id 5614622812f47-3d55e88d5edmr6027659b6e.21.1719480006568;
        Thu, 27 Jun 2024 02:20:06 -0700 (PDT)
Received: from [0.0.0.0] (97.64.23.41.16clouds.com. [97.64.23.41])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-72745d074adsm617213a12.36.2024.06.27.02.20.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jun 2024 02:20:06 -0700 (PDT)
Message-ID: <54f5df88-ca0a-40dd-92ef-3f64c170ba55@gmail.com>
Date: Thu, 27 Jun 2024 17:19:57 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ufs: core: fix ufshcd_abort_all racing issue
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>,
 =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "jejb@linux.ibm.com" <jejb@linux.ibm.com>
Cc: "linux-mediatek@lists.infradead.org"
 <linux-mediatek@lists.infradead.org>,
 =?UTF-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
 =?UTF-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
 =?UTF-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
 =?UTF-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
 wsd_upstream <wsd_upstream@mediatek.com>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 =?UTF-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
 =?UTF-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>,
 =?UTF-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
 "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
 =?UTF-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
 <Chaotian.Jing@mediatek.com>, =?UTF-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
 <Powen.Kao@mediatek.com>, =?UTF-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
 <Naomi.Chu@mediatek.com>, =?UTF-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
 <Qilin.Tan@mediatek.com>
References: <20240624121158.21354-1-peter.wang@mediatek.com>
 <eec48c95-aa1c-4f07-a1f3-fdc3e124f30e@acm.org>
 <4c4d10aae216e0b6925445b0317e55a3dd0ce629.camel@mediatek.com>
 <795a89bb-12eb-4ac8-93df-6ec5173fb679@acm.org>
 <0e1e0c0a4303f53a50a95aa0672311015ddeaee2.camel@mediatek.com>
 <b5ee63bb-4db9-47fc-9b09-1fde0447f6f8@acm.org>
From: Wenchao Hao <haowenchao22@gmail.com>
In-Reply-To: <b5ee63bb-4db9-47fc-9b09-1fde0447f6f8@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2024/6/27 1:13, Bart Van Assche wrote:
> On 6/25/24 8:56 PM, Peter Wang (王信友) wrote:
>> Sorry I have not explain root-cause clearly.
>> I will add more clear root-cause analyze next version.
>>
>> And it is not an invalid pointer is passed to blk_mq_unique_tag(),
>> I means blk_mq_unique_tag function try access null pointer.
>> It is differnt and cause misunderstanding.
>>
>> The null pinter blk_mq_unique_tag try access is:
>> rq->mq_hctx(NULL)->queue_num.
>>
>> The racing flow is:
>>
>> Thread A
>> ufshcd_err_handler                    step 1
>>     ufshcd_cmd_inflight(true)            step 3
>>     ufshcd_mcq_req_to_hwq
>>         blk_mq_unique_tag
>>             rq->mq_hctx->queue_num        step 5
>>
>> Thread B               
>> ufs_mtk_mcq_intr(cq complete ISR)            step 2
>>     scsi_done                       
>>         ...
>>         __blk_mq_free_request
>>             rq->mq_hctx = NULL;        step 4
> 
> How about surrounding the blk_mq_unique_tag() call with
> atomic_inc_not_zero(&req->ref) / atomic_dec(&req->ref)?
> 

Hi Bart,

A small wonder, then should we append __blk_mq_free_request() if
req->ref decreased to 0 like following?

        if (req_ref_put_and_test(rq))
                __blk_mq_free_request(rq);
 

> Thanks,
> 
> Bart.
> 

