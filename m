Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C792FC35
	for <linux-scsi@vger.kernel.org>; Thu, 29 Feb 2024 22:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709244471; cv=none; b=GXtIMKUOipSwb/sbxIXWWt4YKCCe0ozVKVUlsONpHfBVDqXv3+3czM4NXMRPKPNfllFAIEvtnF7KOAbnRJuusjbuyHTsgbNoaEOqwcugaF35fAwr+35wvs4sVv2pKHUW5TzTL08BrpEzAIAv+PUWJW51AmrvOrzCpXlgQcB+gqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709244471; c=relaxed/simple;
	bh=Fqoz9KduHFMD7P8hHJdxwOpn/laN3SlvitE5tm8Tjg4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=gf3+/rWQdK632NMC7X/OEtvWE89OEyYK8E5faQnr0QQVRggKw1Sbn8LbPm4Y5Z/I3SHnXy4pC2UZPEt9ve2CciOxTjBjDEH1iTTuqOK8rz7apAyTV39VEUtNaKXLqnHGe0EscypvVScNccv0TpOQ5UgnFvpwHAGJjxKePnh3TEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6e58a984ea1so1039562b3a.2
        for <linux-scsi@vger.kernel.org>; Thu, 29 Feb 2024 14:07:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709244470; x=1709849270;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o7Mmfys9tyKIaBEklfp9zzJn0WH6uowRH0LpOJf3RDM=;
        b=UD2TCJlY2fb9ALfoUsMpVJebd3V6hg67XKiz7PqxwsbZfO2qczS8ThyLyv+MfEwFou
         JvQXey7cs6Wye/GSKQn1PvEXjQJl9eIR/DwrUzbaL1bMLT1W9PM539Tq5D4jd/aZakY1
         1ZbXMm21VnngDtoXJ4Bb2yXsV6Fl7jR4IXXZl9lyUNVkTJQ+zO4QN+Y3Wwbw2ZcZjCet
         cZz28lAqi5zKTeA0IrnvFYin+L237htu3Q+5xIUVrWKrjLH6BgiKoXgIRdAZh8GMtElT
         6btSjedlaO9fRWmw9kk0fsMwn0epq7s7/NWQomCZOrI0vSL1hlCV08g7+uS3M00mUXej
         h3PA==
X-Gm-Message-State: AOJu0Ywa4TSmWdAduv9Y3Nh3Ha61IZ/iTxLUde9VDj4M+ji3U/7KEKUI
	c/Wt0FoX5fVrofxUoOB7HrnDhdaOOH9HuAIWqBZXRze0dcy8dRxYVApKgV5x
X-Google-Smtp-Source: AGHT+IFipHtpI+jnDNZh0jYmf08LZd7gYcTXHaM4z3VQVTys301E2KVeV+O0ioou+cP0TZL2/W6O1A==
X-Received: by 2002:a05:6a00:2301:b0:6e4:646e:a130 with SMTP id h1-20020a056a00230100b006e4646ea130mr436919pfh.23.1709244469623;
        Thu, 29 Feb 2024 14:07:49 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:2491:7db1:8e45:9513? ([2620:0:1000:8411:2491:7db1:8e45:9513])
        by smtp.gmail.com with ESMTPSA id c6-20020aa78806000000b006e53cc789c3sm1752172pfo.107.2024.02.29.14.07.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Feb 2024 14:07:49 -0800 (PST)
Message-ID: <cd13bc17-f930-471d-9b69-81831205db64@acm.org>
Date: Thu, 29 Feb 2024 14:07:47 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi/sd_zbc: Use READ(10)/WRITE(10) for zoned UFS devices
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20240229172333.2494378-1-bvanassche@acm.org>
 <d28c3a75-0a90-4720-a510-7e6847d76f8b@kernel.org>
 <eec0d0d1-9fe3-457f-8150-e5cbe19a9f23@acm.org>
 <ecbc260c-1202-4b0f-bcc9-4886c85bf43c@kernel.org>
 <527dfffe-5ea5-4a0c-9be4-d336e202b34b@acm.org>
 <0c34b7b3-0e24-4256-b593-98675db8e3a8@kernel.org>
 <0004135e-56e9-4722-bc6a-ddb293274d39@acm.org>
In-Reply-To: <0004135e-56e9-4722-bc6a-ddb293274d39@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/29/24 12:05, Bart Van Assche wrote:
> [ ... ]

Thinking further about this, wouldn't this be a better solution
(untested)?

Thanks,

Bart.


diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 997de4daa8c4..8d3020486095 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2798,6 +2798,13 @@ sd_read_capacity(struct scsi_disk *sdkp, unsigned 
char *buffer)
  				      sdkp->physical_block_size);
  	sdkp->device->sector_size = sector_size;

+	/*
+	 * For zoned block devices, if RC BASIS = 1 in the READ CAPACITY
+	 * response, sdkp->capacity does not represent the device capacity but
+	 * the highest LBA of the conventional zones at the start of the LBA
+	 * space. sd_zbc_check_capacity() sets sdkp->capacity correctly for
+	 * zoned devices.
+	 */
  	if (sdkp->capacity > 0xffffffff)
  		sdp->use_16_for_rw = 1;

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 26af5ab7d7c1..d4d6b3056410 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -734,6 +734,8 @@ static int sd_zbc_check_capacity(struct scsi_disk 
*sdkp, unsigned char *buf,
  					(unsigned long long)sdkp->capacity,
  					(unsigned long long)max_lba + 1);
  			sdkp->capacity = max_lba + 1;
+			if (sdkp->capacity > 0xffffffff)
+				sdkp->device->use_16_for_rw = 1;
  		}
  	}

@@ -924,11 +926,6 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 
buf[SD_BUF_SIZE])
  		return 0;
  	}

-	/* READ16/WRITE16/SYNC16 is mandatory for ZBC devices */
-	sdkp->device->use_16_for_rw = 1;
-	sdkp->device->use_10_for_rw = 0;
-	sdkp->device->use_16_for_sync = 1;
-
  	/* Check zoned block device characteristics (unconstrained reads) */
  	ret = sd_zbc_check_zoned_characteristics(sdkp, buf);
  	if (ret)

