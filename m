Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11117BB00
	for <linux-scsi@vger.kernel.org>; Wed, 21 Feb 2024 18:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708538479; cv=none; b=c6Dbm/WNxnjwUWjPZFlr+qsOHmNmHygVyshJPZ2vdmEl6f7+avtvVmmzEDAhNNmohOAGOlSAPm6+qwiWbg7Lv1kVBkqeyFtC7Q6wGEfFPT6aNOZp08AhSBP2CZxl48jdgAsbBJUc+3fGfCnUkPVuOKpzXqm0yNDQbXRzzYJyi4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708538479; c=relaxed/simple;
	bh=t/XUwk5TS9Ky2HqKC3MvObSVQS4x92SJn+KRK0ItMuw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YVSSO0ygXgs7XtcPK2zKkkTYuy2/JnISgWDkIqvBJugVCGzwPhWNA26pR8OF0QnS7Yv9NL8+szv6Zxk6ofuJBkqpeKXp/Rz7tBDbJ0w/ceVyc9sxUDppvh47Bk8LwVgiLtmQww04UhY01ewVcV2JJ0dRcjBcMWv2vhk/LvJkl54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-595aa5b1fe0so4526570eaf.2
        for <linux-scsi@vger.kernel.org>; Wed, 21 Feb 2024 10:01:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708538477; x=1709143277;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t/XUwk5TS9Ky2HqKC3MvObSVQS4x92SJn+KRK0ItMuw=;
        b=mQ3Ujyu3Mk/IXvxT/g29UN37J6Mfzip4Go51er1ongdH53Y4ugSkC5UZeAiPwj+i9i
         CIsI6YiHJ8zZU1b3wAU0NYyOIWzkK2T3MZ02usE7RRLP7zC7Hg0DQpeKQSvKisP5ukZe
         H14zoh0A6PQIo5I7Smrb9z11L9NfaVTrVWSVrMiWqN1rOtmtxJyc3DPfZ1U7l3LGmJMd
         I+GKG0KNge7YlnqfEL0pd/7sbJR3GXphj6FOdVsXGWrypGcEUXRYmtEG5MESLCGOlK45
         xGcdYuRvHLg14jJKjcvonhYNr/apQsQ3t21AEROj+DPh9IXfTFgPj3O23TNUL2mmtg8F
         My2g==
X-Forwarded-Encrypted: i=1; AJvYcCXbomvyD9Gx1GfnFgAasw4t+FKEEth6rX8B9v4u67WPNCa2+yPufUqeU2xI0lNlBqKJk1e6pP3I+1AnTufH7F3nE+VWZjoBW3ZQgA==
X-Gm-Message-State: AOJu0YzECEvp/NzGYO9UuUdl/QDZiIZEQ4/LZbs2jcCQfnXfkzGa8g7w
	yu+c383r8w8qpbHrJZO91vUYgszuF9u5yWkEr8DywNi1fz+gsmFW
X-Google-Smtp-Source: AGHT+IEh/kOMQRAU+4zZdRPprsjAmt/ymq/739JlgxltzcC9dG6jrCZCKTzw88pz8itZR4vjQoIR4g==
X-Received: by 2002:a05:6359:4125:b0:17b:759:65c2 with SMTP id kh37-20020a056359412500b0017b075965c2mr21933881rwc.10.1708538476753;
        Wed, 21 Feb 2024 10:01:16 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:d74f:a168:a26a:d7fe? ([2620:0:1000:8411:d74f:a168:a26a:d7fe])
        by smtp.gmail.com with ESMTPSA id ka36-20020a056a0093a400b006e48e0499dfsm1815313pfb.39.2024.02.21.10.01.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Feb 2024 10:01:15 -0800 (PST)
Message-ID: <923e2241-ab08-4cf6-a614-91da4b3575b8@acm.org>
Date: Wed, 21 Feb 2024 10:01:13 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ufs: core: adjust config_scsi_dev usage
Content-Language: en-US
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-mediatek@lists.infradead.org"
 <linux-mediatek@lists.infradead.org>,
 =?UTF-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
 =?UTF-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
 =?UTF-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
 =?UTF-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
 wsd_upstream <wsd_upstream@mediatek.com>, =?UTF-8?B?TGluIEd1aSAo5qGC5p6X?=
 =?UTF-8?Q?=29?= <Lin.Gui@mediatek.com>,
 =?UTF-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>,
 =?UTF-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
 "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
 =?UTF-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
 <Chaotian.Jing@mediatek.com>, =?UTF-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
 <Powen.Kao@mediatek.com>, =?UTF-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
 <Naomi.Chu@mediatek.com>, =?UTF-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
 <Qilin.Tan@mediatek.com>
References: <20240220094211.20678-1-peter.wang@mediatek.com>
 <46d0c5b7-7158-405d-ba38-cece4030e2bd@acm.org>
 <0874377d564ceb63efd62df3757c6e5f3a0dd03c.camel@mediatek.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <0874377d564ceb63efd62df3757c6e5f3a0dd03c.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/20/24 18:44, Peter Wang (王信友) wrote:
> This help function is designed to assist users eliminating the check.
> Formalize the usage can make the code more concise and easier to read.
> Such as ufshcd_vops_init/ufshcd_vops_exit is also only one caller.
> Besides, it also need a comment of config_scsi_dev in ufshcd.h

My personal opinion is that the helper function makes code harder to
read because the definition of a helper function needs to be looked up
to understand the code. There are many examples in the changelog of the
kernel tree that show that there is a preference in the Linux kernel
code base to inline short functions rather than keeping or introducing
short helper functions.

Regarding the config_scsi_dev comment, shouldn't that be a separate
patch since that change is unrelated to the introduction of a helper
function?

Thanks,

Bart.
