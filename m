Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="knpXpq6E"
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4869E12E
	for <linux-scsi@vger.kernel.org>; Sat,  9 Dec 2023 12:21:56 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id 5614622812f47-3b9db318839so2230819b6e.3
        for <linux-scsi@vger.kernel.org>; Sat, 09 Dec 2023 12:21:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702153315; x=1702758115; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UHPmeQTbBNZP/ufnzye5MJ3nRcYaaEfZJEmdIoOqsQI=;
        b=knpXpq6EKjMiiIaasRONxNwBRnXltcF1UsPo66xoCbl5bYziyScuQDw8izsa3lEJA7
         z5GoJwhWRIt9zBE7aNJDOS+sBkfSoA1rN2bzjgqCXzJSjAK0kWrhzh7XbioeUkNfNP9j
         MugvP2usf1v1HF7tBUoObNHkdgq9+Dffyfdv7lu2jb8pSPiolHUjy1uhxN+XhytqUnOV
         pnxF/yA2MNbn2ZLLa+8tMWpcLy7HXnTUpw2N8GkSjYcuDmKoOFzvLWSQmaBQOEDOXGl8
         t1ZPqpc2hBkueX2qbyEirsYkPK4RSvXeWn3SOIRYIWQdNfPWO6dpa1jaLZCW3/4LA+TH
         olww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702153315; x=1702758115;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UHPmeQTbBNZP/ufnzye5MJ3nRcYaaEfZJEmdIoOqsQI=;
        b=gz2db9EKx65I5fTjgscDeFZvAxMEHZ2/DkB3rPlT1MzeoTj+rNWp8gNQTwLma/Q9lO
         lmGKdsMDBppwaQHgsqj+HSijf2AIjP6KK5ycuFiiSlUOmap15mMagZ1ZaiT+BSEexPVk
         VoKP9d/xkqbjt2DiVuEGVtbUV5cvMMzcb3NnLeqiH1zOzXnZpjgoI3gWqcYb8UX+DDC5
         CVSOjGkgq6jt+B/8wKpR3Veyz1VBZpVBsFZSdd9kSusrQFxrKIhBzCLUiiDTFfUAq62C
         nkYC/SmhM+jVWmUJNJqwPL4qG6chnBbaJxpJwgfisIxn9VWQbj+TUO9NEcKQ+ImRh4Gu
         G7Qg==
X-Gm-Message-State: AOJu0YxFfe3XDG/cZma0FScRBG+7WTvLIdRR0lsB3GFV3wKlhtuX4fBR
	OVRFi70XG9RFHkbPG+evE14=
X-Google-Smtp-Source: AGHT+IHrT9wGS1CQUgD7W84Mm4NLxB8hlbyCMZOssksYs2Vo1j9WqzfFGY+zNDkxxDK1exiqghM8aA==
X-Received: by 2002:a05:6808:1924:b0:3b9:f104:14b0 with SMTP id bf36-20020a056808192400b003b9f10414b0mr2280403oib.33.1702153315406;
        Sat, 09 Dec 2023 12:21:55 -0800 (PST)
Received: from [10.77.50.11] (d67-193-45-165.home3.cgocable.net. [67.193.45.165])
        by smtp.gmail.com with ESMTPSA id h5-20020ac85145000000b00423d75e0444sm1843986qtn.73.2023.12.09.12.21.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Dec 2023 12:21:53 -0800 (PST)
Message-ID: <1cdff053-c2ca-442e-b0b3-92d3bd0f8eeb@gmail.com>
Date: Sat, 9 Dec 2023 12:21:51 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/2] mpt3sas: Additional retries when reading specific
 registers
Content-Language: en-US
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com,
 sreekanth.reddy@broadcom.com, sumit.saxena@broadcom.com
References: <20230829090020.5417-1-ranjan.kumar@broadcom.com>
 <yq1o7iot2gv.fsf@ca-mkp.ca.oracle.com>
From: patrick.strateman@gmail.com
In-Reply-To: <yq1o7iot2gv.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

The loop in _base_readl_ext_retry is wrong, it runs 30 times regardless 
of the result from readl.

This results in the value being incorrect and the device being reset 
nearly continuously.

if (ret_val == 0) continue;

should be

if (ret_val != 0) break;

On 8/30/23 18:39, Martin K. Petersen wrote:
> Ranjan,
>
>> Doorbell and Host diagnostic registers could return 0 even
>> after 3 retries and that leads to occasional resets of the
>> controllers, hence increased the retry count to thirty.
> Applied to 6.6/scsi-staging, thanks!
>
