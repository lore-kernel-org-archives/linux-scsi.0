Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E1F134CD5
	for <linux-scsi@vger.kernel.org>; Tue, 27 Feb 2024 09:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709024711; cv=none; b=E8k1lpvg0MIStVE3se4G68Ejo9GF4MEIzJgefxD2UFyYez4RBEHJWL5NUmPqOss5t9/+sYaUIHfCXH10PF1LkllxWd4vapEpBovbcqSwK0uxudZ3aAeX93HNDLTE6FxKWuuIiGgt6NL2rYNiGjdICcRqJ7yMGfoAgQzcuL44Cbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709024711; c=relaxed/simple;
	bh=WBe6ga2pwLP2qHgi217Nz+cjjBzoXfuuCdkvtlbLF4o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CT1oB4bjs0TKJhEHpMYz9VkNWqsEPsO7ZThiSNl+JubTXoKqa02NB24NeQJop64z9mTmnYAniPznEHa1igolRtfRaprW1t5gcl5eTPOQiHTtT0TmWqS1WZ23DGVssnZIac3BBu4f8/c9TZLIrq4tMeZMWBIP1sSo4Y4c4vxMngE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=F14Kc37D; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="F14Kc37D"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5640fef9fa6so5228329a12.0
        for <linux-scsi@vger.kernel.org>; Tue, 27 Feb 2024 01:05:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1709024707; x=1709629507; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rCD6F3e3P3I+Zgk/2guSviAQKEfOfySNcNBt5UHEyXo=;
        b=F14Kc37D4Num9JJ7X0m0kszo6RDhV8CtzHX4Rj3+1qHBOrIAXjE4MN3+cnUdGFyaPk
         nTRzOX1QtDxWi+PDZgbqjMQnZFFF0JcCEq3mrUmUbNJ7c43dijsvAtZciq94eP/h8gaV
         EqtPAaNnrNWoUTTrz7YDTP4JAnXMxHFwtQTGtdV82u/82iS95dI6Qzv13v8IWRLcEzZg
         aCPN/gaG7CJMODQvIidIMKKFfoBID6rb4nvVPSMZpC5cgDEFJnn6h4yq+0MjkHBubwGn
         cSL7vetUlu4kRhHgRofrNBSdKFfkjd5CH4H4swtfmUqZn42R/+xuD9CxTL2mpWilYmst
         uhcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709024707; x=1709629507;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rCD6F3e3P3I+Zgk/2guSviAQKEfOfySNcNBt5UHEyXo=;
        b=bfrRt2t+KDZ94GCPQlK2RvZwkTevG9+NsrLDu+7kMqwRswS3E9pH8flzpt1ytn34Xq
         SPbLmrFOfwPYKT0WAGldd+pFiHwFmhVyCgCZm/oF92ftpClQn+tMhFukeZKrOm2B6J+V
         9f8wwEuH1I2jdogyG1Ow93CO3WX2JzOEIIswcKg/ZcNq4jKnIiKljJieYRJKq1KJf+7K
         R9FSW8IoDr50u1r3wNP/1mYfX1wQJWMIOH1hw1WkKUSVSg7PgmYMT+myAquBR2PcSRrJ
         wMR7aer41/HkdwOEVON0bH05Ki+LDO2f90p3nO4RYV91L+qZR5UatEDWPsOKzab5DAK7
         SESA==
X-Forwarded-Encrypted: i=1; AJvYcCWVlw1o+2aAl9+kJguZj5j6yb4EU5w2o4oDDe275xZHB7a3X4A/7VZ2XPZystwZlHTHOb744Yca3GlpYqMX7KjvfmAzsxe20bpmKw==
X-Gm-Message-State: AOJu0Yw387AXU/tSI93/pQ39mm+pl2zf+UF+s2tRwwivibLpfn+AqetS
	Bs2DmGmbYuz6d+Uzq52TgDHwhailXUgJJn05jUHAQx3em57Xri2+KMef1a/oCXOnroTwehXP5Hz
	m
X-Google-Smtp-Source: AGHT+IGmE8MK4gkN9ZDkWYcSJldVKxnmTp00nCPleWmQ8of4pKV4ikWCBrLzgOeJlaMUry+8f5Wkfg==
X-Received: by 2002:a17:907:9950:b0:a3e:bd4e:c87e with SMTP id kl16-20020a170907995000b00a3ebd4ec87emr6151888ejc.36.1709024707227;
        Tue, 27 Feb 2024 01:05:07 -0800 (PST)
Received: from ?IPV6:2001:a61:1366:6801:d8:8490:cf1a:3274? ([2001:a61:1366:6801:d8:8490:cf1a:3274])
        by smtp.gmail.com with ESMTPSA id c12-20020a17090603cc00b00a433f470cf1sm552971eja.138.2024.02.27.01.05.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Feb 2024 01:05:07 -0800 (PST)
Message-ID: <8f4fe820-2385-40e7-a3c6-51102e57acad@suse.com>
Date: Tue, 27 Feb 2024 10:05:05 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] USB:UAS:return ENODEV when submit urbs fail with device
 not attached.
To: "WeitaoWang-oc@zhaoxin.com" <WeitaoWang-oc@zhaoxin.com>,
 Oliver Neukum <oneukum@suse.com>, stern@rowland.harvard.edu,
 gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
 usb-storage@lists.one-eyed-alien.net
Cc: WeitaoWang@zhaoxin.com
References: <20240222165441.6148-1-WeitaoWang-oc@zhaoxin.com>
 <3ff16f34-07a9-4b7e-b51d-b7220f08d88d@suse.com>
 <41daf1a9-590a-e220-84a3-648eb895272b@zhaoxin.com>
Content-Language: en-US
From: Oliver Neukum <oneukum@suse.com>
In-Reply-To: <41daf1a9-590a-e220-84a3-648eb895272b@zhaoxin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 22.02.24 21:06, WeitaoWang-oc@zhaoxin.com wrote:

> Maybe, my description was not accurate enough, here not add new return
> value to scsi layer,it just add a case to tell device is gone in the uas
> driver internal and the ENODEV error code not return to scsi layer.
> Here just notify SCSI layer of device loss through flag DID_NO_CONNECT.
> This is also hope to fix this issue in the uas driver internal.

Hi,

sorry for the delay. OK, I see what you are aiming at. Could you redo
the patch with a better description, like:

We need to translate -ENODEV to DID_NOT_CONNECT for the SCSI layer.

	Regards
		Oliver

