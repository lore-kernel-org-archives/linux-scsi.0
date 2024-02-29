Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E199B16FF51
	for <linux-scsi@vger.kernel.org>; Thu, 29 Feb 2024 22:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709246359; cv=none; b=d83/VFCuSRYkhssCBsRxEzolbuTQ8VvpQ+do32lJtHGY79pToHJYG/8yZdl+8UVojUKnnVvFzZqmDNShDumLDyIU5th6Rqh7F6sz+B8QsbIMRM8TU0LKMSRAPHwqjfV2rf/TrVb+cyW/NEMXBrb6KV7qa4A5V0j+s2tWCUdW+qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709246359; c=relaxed/simple;
	bh=loPrJ9LHdl6IXgK/3yfaL9UsQeHhbYE1HxhncopJlvw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pNyxn67EgdzpQfGY/sbIGtxb8zPiOupjehFM2epacCERXVlLAwvFxnm/+cuAOGQgct+bzUQjgnbIB5PHRnuVjXXX7U1H6k2yTjLKPzUW/1aji51ZdXVhN5lqw1GPCJsAAmJHPyOLDThmjr0jkdDiZQ/nWP2DklwveWykTbBQEJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-3bb9b28acb4so1069414b6e.2
        for <linux-scsi@vger.kernel.org>; Thu, 29 Feb 2024 14:39:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709246357; x=1709851157;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ax7k91vCBienqZQRLqygpxJL++FYc63iev+tcYtFv58=;
        b=d/v3IM+wVLweUm9CpLRmNpmByPPMju8KCwXU5yiQWRgzZeo3h5ucKBSFvcScscgF26
         1p2wXHPvecg4Kc5WJQeI2jlwz2HH65C7gouEVxSIfCQXi3/g6+h3CUC/842J5trFNfR7
         AqVcOgMwezBs2vlMiKcFyqbVEAYnMSRq1gA8dWgHluUBhPG46E25tAN9Xl4t4Rs+FwJn
         9Cg7MTqiVlLHkTz/jZDxP7hlYmZ+xy02m3qEOgmM44Ki7Nv7AimxRdmBHAjZTn0n5Pw9
         qiZ+Kv2D6frRWz7w4/AefI4wmpq9V9ckTfrYCqbk0j20G/Wi6MOTxbNcwjt+QKAcL1O8
         ayMw==
X-Gm-Message-State: AOJu0Yz7qTTmSnjh6BCzhjNkijsXi/ZJVvrxCzEBUKKSHQXj34sKNW7X
	PczBmyQ1YpAW9Q+3/mVf+972XgGLGwiZczENqYoH30uDk1LMbcKRkOwgIl4t
X-Google-Smtp-Source: AGHT+IFQRuyQHn/NxhRpsxZGfewRqDiM/MR0zYESpRY/cXdhbzomRWYFJ7lDDL192G4paOAgX2XqEQ==
X-Received: by 2002:a05:6808:ab8:b0:3c0:443c:84bb with SMTP id r24-20020a0568080ab800b003c0443c84bbmr3106935oij.59.1709246356835;
        Thu, 29 Feb 2024 14:39:16 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:2491:7db1:8e45:9513? ([2620:0:1000:8411:2491:7db1:8e45:9513])
        by smtp.gmail.com with ESMTPSA id j36-20020a63fc24000000b0059b2316be86sm1792662pgi.46.2024.02.29.14.39.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Feb 2024 14:39:16 -0800 (PST)
Message-ID: <fbe8bf39-4222-4b5a-8c7f-d284bc9f29fe@acm.org>
Date: Thu, 29 Feb 2024 14:39:15 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi/sd_zbc: Use READ(10)/WRITE(10) for zoned UFS devices
Content-Language: en-US
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
 <cd13bc17-f930-471d-9b69-81831205db64@acm.org>
 <57fc23ee-d450-40b1-89f5-c7a85b6b158a@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <57fc23ee-d450-40b1-89f5-c7a85b6b158a@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/29/24 14:16, Damien Le Moal wrote:
> On 2024/02/29 14:07, Bart Van Assche wrote:
>> --- a/drivers/scsi/sd_zbc.c
>> +++ b/drivers/scsi/sd_zbc.c
>> @@ -734,6 +734,8 @@ static int sd_zbc_check_capacity(struct scsi_disk
>> *sdkp, unsigned char *buf,
>>    					(unsigned long long)sdkp->capacity,
>>    					(unsigned long long)max_lba + 1);
>>    			sdkp->capacity = max_lba + 1;
>> +			if (sdkp->capacity > 0xffffffff)
>> +				sdkp->device->use_16_for_rw = 1;
> 
> ZBC makes 16B RW mandatory, regardless of the device capacity. So I am not very
> keen on playing games like this and think that it is safer to always use RW-16,
> regardless of the device capacity. I prefer your first patch, with the added
> "use_10_for_rw = 0;" added.

Hi Damien,

I think that we need to combine the two patches otherwise we risk
breaking support for zoned devices that are neither ATA devices nor
UFS devices. How about the patch below?

Thanks,

Bart.


diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 0a0f483124c3..6d55a01f0263 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -986,8 +986,15 @@ static void ata_gen_ata_sense(struct ata_queued_cmd 
*qc)

  void ata_scsi_sdev_config(struct scsi_device *sdev)
  {
-	sdev->use_10_for_rw = 1;
-	sdev->use_10_for_ms = 1;
+	if (sdev->type == TYPE_ZBC) {
+		/* READ16/WRITE16/SYNC16 is mandatory for ZBC devices */
+		sdev->use_16_for_rw = 1;
+		sdev->use_10_for_rw = 0;
+		sdev->use_16_for_sync = 1;
+	} else {
+		sdev->use_10_for_rw = 1;
+		sdev->use_10_for_ms = 1;
+	}
  	sdev->no_write_same = 1;

  	/* Schedule policy is determined by ->qc_defer() callback and
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

