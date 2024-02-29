Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FA113441D
	for <linux-scsi@vger.kernel.org>; Thu, 29 Feb 2024 18:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709232869; cv=none; b=bHtTG2zFngZJUob0pl/3Ou/PHW20ZuB23CC6BxTLHSd7qSGa4fhtKVGs4F2auQDXdW4sSZRisxjcrv3ngRsPGdRm4fqA+coG0NYQ7LDdweN2kZpFpgIu6ca1wR4vQqMlRTRLkY53UmWxty6O0W8RgZk76F+LlZnMu3W+PSLAVsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709232869; c=relaxed/simple;
	bh=HgK4m1QK4eFk0RW4b2JzhmUEUYQRV9ggAr7bEXDz8Zg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NPnHFXFtWhQP45w3LbvBQMZlE/gtcKgFsiIjvuxlZPTY4LKsLDBKpAYevIICl4LDnnJ9KNwEF6tJjXHaJ3F5njh2r9izf9+63YjukD5HiGxhhP6y9jezuxXxrQn3jB+38V0BLNphmDC2lV+4Q03IbAK/Z4sQ7nJx6LlCXM7dfwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1dcce5e84bcso11737105ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 29 Feb 2024 10:54:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709232867; x=1709837667;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=We7P69cUdLx8yXWBeOCQIW10yxgDaH5RsX8Ds10JxCM=;
        b=lESVhdcRt4lJ17219x/m18zsO8XZLX+3AfOezLxQn61iBBedJgXNlYprWvV3NAGqnL
         +bGnW9c9b1q5bkZTMKHwjWZXdboLoM+YaPofYkuzmAMqrKia5T2wFgS5+rBUpNbNMIxR
         fcbH56DXqmVlMt80P5/eVWc+8dI+zWxIoI4NOF4/2BsAYnyiA5Gv8UwMLwwg2adwyU/R
         RrO3CYinGOLxMOBKxqxkuKgcjJFJReXFdlQ44wej2TTdrzsk8HUKKsKsG/IGjQAoRPz9
         07g98CaophIxNKUWhxkOOx0YUMdJv9dWdreahouPbFgnn+UmU5CYbXOFiMRif7JUCpNq
         JQIA==
X-Gm-Message-State: AOJu0YzVQ8KerJKJDvfZkGZP6QO4fh9bBkYczAbwenwB+l+REFBbzmHi
	tHF1Ynzk+s6zmgIGksW8EaCXEDvBcyfpNpOaRkOJejQ2OtMr1jG+
X-Google-Smtp-Source: AGHT+IFVJlUlyZk6JVUijxLvdEXWF3Ks1dPetpwD2I2tUIcziAZ6VULm097Zyj2kslT2N+hcUJNU1w==
X-Received: by 2002:a17:902:ec8f:b0:1dc:696d:ec64 with SMTP id x15-20020a170902ec8f00b001dc696dec64mr4041072plg.22.1709232866865;
        Thu, 29 Feb 2024 10:54:26 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:2491:7db1:8e45:9513? ([2620:0:1000:8411:2491:7db1:8e45:9513])
        by smtp.gmail.com with ESMTPSA id t18-20020a170902d21200b001dca6d1d574sm1826662ply.302.2024.02.29.10.54.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Feb 2024 10:54:26 -0800 (PST)
Message-ID: <527dfffe-5ea5-4a0c-9be4-d336e202b34b@acm.org>
Date: Thu, 29 Feb 2024 10:54:25 -0800
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
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ecbc260c-1202-4b0f-bcc9-4886c85bf43c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/29/24 10:31, Damien Le Moal wrote:
> Yes, but I find that a little fragile and given that rw-10 causes problems with
> ZBC, I prefer to make it very explicit that the 10B command variants should not
> be used.

Hi Damien,

 From commit c6463c651d7a ("sd_zbc: Force use of READ16/WRITE16"; v4.10):

-------------------------------------------------------------------------
sd_zbc: Force use of READ16/WRITE16

Normally, sd_read_capacity sets sdp->use_16_for_rw to 1 based on the
disk capacity so that READ16/WRITE16 are used for large drives. However,
for a zoned disk with RC_BASIS set to 0, the capacity reported through
READ_CAPACITY may be very small, leading to use_16_for_rw not being
set and READ10/WRITE10 commands being used, even after the actual zoned
disk capacity is corrected in sd_zbc_read_zones. This causes LBA offset
overflow for accesses beyond 2TB.

As the ZBC standard makes it mandatory for ZBC drives to support
the READ16/WRITE16 commands anyway, make sure that use_16_for_rw is set.
-------------------------------------------------------------------------

Would this change be sufficient to fix the problems mentioned above?

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 997de4daa8c4..71f477e502e9 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1279,7 +1279,7 @@ static blk_status_t 
sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
  	if (protect && sdkp->protection_type == T10_PI_TYPE2_PROTECTION) {
  		ret = sd_setup_rw32_cmnd(cmd, write, lba, nr_blocks,
  					 protect | fua, dld);
-	} else if (sdp->use_16_for_rw || (nr_blocks > 0xffff)) {
+	} else if (sdp->use_16_for_rw || (nr_blocks > 0xffff) || (lba >> 32)) {
  		ret = sd_setup_rw16_cmnd(cmd, write, lba, nr_blocks,
  					 protect | fua, dld);
  	} else if ((nr_blocks > 0xff) || (lba > 0x1fffff) ||

Thanks,

Bart.
