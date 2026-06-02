Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381623911DC
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jun 2026 11:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780398497; cv=none; b=QIDcRQBvTHrGX5OoCi+/uH/TOdUvXcUz8o4AiUqP86IwsWP571ky7MQKeIKm1W7KnB0ZINllwXSATVNm0olxs5i+iPFIDeS57lJorqelIt5+WjH/oz93hl/QX4+gbNFvPa08QiGG7NU6ULrSWiGENQZRDJCjIJyUAeloU5iHyKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780398497; c=relaxed/simple;
	bh=akWMMCc0Bp/DEE0tIX+f8QgX69V/nLO8kX1M/CD+iWU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VQG7sjsUXAXCmDxF0LS+cwhCNERhZmOW9YS+v3DZafNDf+MbdlSnIV8uFoDBkRS0ZzAAD02DI+58L70kdR7+Gud8We4EYRFY7lUxmv+zGfteQOx+Fsw+hOGL+iNgcaXW28+VIqATMu1Yu9Yfr108Vil1cMUSuIWPMApbEFtVtHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eDgd95VS; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eDgd95VS"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-45ef37b56e6so430987f8f.1
        for <linux-scsi@vger.kernel.org>; Tue, 02 Jun 2026 04:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780398495; x=1781003295; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c6awtT/C6UJbxAHF/tpUQAV5v99ihStDcLxWXURVV5Y=;
        b=eDgd95VS+8W7u03JbeEHcnY7J2DUkp9VOFRjge9208GID23Us0FiOXejoPlfCrL1vm
         OmwHVWnhB/tOLyYceeXLEK+NQl8WxsfdjZM3gJASCaRWAYNxg2i0KItN0DfcEIML123x
         ajKoiIasZYYhAnzkT4PK+iljUklq/UpsPKmZI8kXjN5hV6AmWpWeJY2daHKBhvoz/BPx
         0vZ32e8H5FKBYYo2KErFd8vDKqM012fWWVPxlaCpuSrfNZAx4dFD3RnpuJJbhlLLY+P2
         aiwgYPvpo+p05f6wQm2Odah4L17Fv1xxElMGF+bD57SbHrm0iBOKgVFcX+a+9ZeTRg9G
         kgeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780398495; x=1781003295;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c6awtT/C6UJbxAHF/tpUQAV5v99ihStDcLxWXURVV5Y=;
        b=NWJa9p/0jnz3kZy2CXjO62TMkmlgndWvN2ni35RRfksyWCThlnD33fYq0o76nwUhBc
         YTxuSFO5a2YXWLkUkwmM9kalrHYLcYPd1vtez1V1Q1wXD2wQbSBUFLLWM8hCiPJAezCK
         2dp6ojJdnc6CW5cpc6mHr7zZQy/7aa3mrr9LnSKTyLLzV0XbvflaU+71qdrq/L/6H++m
         +fg7wxvUA8ZBw8xMlhnN7QXc1ZAcXqQHj6BRA69XXCQaFGsDd6e9Jb8v48zZZXYMr1OS
         AmbdZQymPCEw/K520KdSjIhyPHDiKZ+hcvE5X3aMhucBICzOpcaF04ZWXTmbxvKw9eXl
         GG6w==
X-Gm-Message-State: AOJu0Yzh4oreJ1AtAGzdji7nX18BIwHr1dypghV5q6nYT3Bc3jAoakuU
	YMT4FLyPxkt+/sX1qDRtnz0V7lb1q5l5e5QvR1r8pbI3dhTwuoCvBZE=
X-Gm-Gg: Acq92OH69JMIK+jmOzZqMItNLGAmhkmRft5oF3YmvAvNKHxohYIq0Au6yqwgVUNHron
	9670kn4m6O4WRoDYogGj/+e8B4rEyXXqwJX7SCeq7Vs6Fy/TXHYfPdDuoVWNEh9zVYUQHSSG9z+
	Q1dwKS+WbZares1SUyyj9k1bqP5qwPywRIAaK97wLp7U7sRknAejRmySvlIkwYhRYjeMicoNUc3
	fGL2s/pHtRqX5foGeFWuKtwAIt3zzTPYTxN1g9iwM402pqcSLmQcW7zhEEkaFFsNSlFlWIJk4+E
	GuX5UeqUzby2ZwO+4icT7Svx0hDVBwYaeAhBzpMwu9q8Scg0R29VEr4Zk2RN1fk8wiFvCyuIbyM
	H9g5Gpt/nxGm5/CZzwcvy43yaDcRAv1Z3i7PYiX21Y0bav2sZTb5aTQ7mGuzwcc/WP1IoaV8T3b
	3WcJxG7S/BZN+0jG1oqPVPzPg17XgrwmjRpOdan7+wnumIWdrmqBCevVtxEpjV64aRwI6HKSg=
X-Received: by 2002:a05:6000:719:b0:45e:ec27:f39c with SMTP id ffacd0b85a97d-4601973a504mr2242440f8f.5.1780398491609;
        Tue, 02 Jun 2026 04:08:11 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef34b47eesm34827163f8f.9.2026.06.02.04.08.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2026 04:08:11 -0700 (PDT)
Message-ID: <5e01d852-b752-4a01-b391-cac8dd9696b3@gmail.com>
Date: Tue, 2 Jun 2026 13:08:10 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [EXTERNAL] Re: [PATCH 06/44] scsi: qla2xxx: Add FC operational
 firmware load for 29xx
To: Nilesh Javali <njavali@marvell.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Christoph Hellwig <hch@lst.de>
Cc: SCSI-ML <linux-scsi@vger.kernel.org>,
 GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
 Anil Gurumurthy <agurumurthy@marvell.com>,
 "emilne@redhat.com" <emilne@redhat.com>,
 "jmeneghi@redhat.com" <jmeneghi@redhat.com>, "hare@suse.com"
 <hare@suse.com>, Sameer Kshatriya <skshatriya@marvell.com>
References: <20260601102853.328426-1-njavali@marvell.com>
 <20260601102853.328426-7-njavali@marvell.com>
 <191cd7dc-f6e7-46c1-8a0c-9e63482f34a0@gmail.com>
 <CO6PR18MB45003BEE884DBDCA16C90D26AF122@CO6PR18MB4500.namprd18.prod.outlook.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <CO6PR18MB45003BEE884DBDCA16C90D26AF122@CO6PR18MB4500.namprd18.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/2/26 12:11 PM, Nilesh Javali wrote:

> On 6/1/26 12:28 PM, Nilesh Javali wrote:
> 
>> From: Manish Rangankar <mailto:mrangankar@marvell.com>
>>
>> Add support to load the 29xx FC operational firmware from the
>> filesystem and to set up the corresponding firmware dump
>> template.  This follows the same request_firmware / segment-load
>> pattern used by earlier adapters.
> 
>> Cc: mailto:stable@vger.kernel.org

>>> New features and hardware support should not be targeted for stable
>>> trees. Only bug fixes or essential regressions belong here.

>>>> [NJ:] Noted.

Thanks. I'm sure the stable branch maintainers are overwhelmed and
appreciate receiving emails that are strictly relevant to their work.

>> @@ -7680,6 +7720,7 @@ qla2x00_timer(struct timer_list *t)
>>    #define FW_FILE_ISP8031	"ql8300_fw.bin"
>>    #define FW_FILE_ISP27XX	"ql2700_fw.bin"
>>    #define FW_FILE_ISP28XX	"ql2800_fw.bin"
>> +#define FW_FILE_ISP29XX	"ql2900_fw.bin"
>>    
>>    
>>    static DEFINE_MUTEX(qla_fw_lock);
>> @@ -7697,6 +7738,7 @@ static struct fw_blob qla_fw_blobs[] = {
>>    	{ .name = FW_FILE_ISP8031, },
>>    	{ .name = FW_FILE_ISP27XX, },
>>    	{ .name = FW_FILE_ISP28XX, },
>> +	{ .name = FW_FILE_ISP29XX, },
>>    	{ .name = NULL, },
>>    };
>>    
>> @@ -7730,6 +7772,8 @@ qla2x00_request_firmware(scsi_qla_host_t *vha)
>>    		blob = &qla_fw_blobs[FW_ISP27XX];
>>    	} else if (IS_QLA28XX(ha)) {
>>    		blob = &qla_fw_blobs[FW_ISP28XX];
>> +	} else if (IS_QLA29XX(ha)) {
>> +		blob = &qla_fw_blobs[FW_ISP29XX];
>>    	} else {
>>    		return NULL;
>>    	}

>>> The last available firmware file intended for user-space updates via
>>> request_firmware() was "ql2500_fw.bin" back in 2019 (for the ISP25xx QLogic
>>> 2500 Series 8Gb FC HBAs). Since then, no official firmware binaries have
>>> been released or published for newer 16Gb or 32Gb HBAs (such as ISP83xx,
>>> ISP27xx, or ISP28xx), let alone being merged into the upstream
>>> linux-firmware.git repository.

>>> While this code might be useful for your internal development and testing
>>> purposes, adding dead code to the upstream kernel for firmware files that
>>> do not publicly exist provides zero value.

>>>> [NJ:] Just in case the firmware from flash cannot be loaded due to some reasons,
>>>> then a recovery mechanism is essential to load firmware from file.
A fallback recovery mechanism is a good design choice, but upstream it
provides zero value to users who don't have access to these firmware files.
If they were to be published in the linux-firmware.git repository,
adding this recovery code would be completely justified.

It has been years since the inclusion of these definitions,
yet the files are still nowhere to be found:

  #define FW_FILE_ISP81XX "ql8100_fw.bin"
  #define FW_FILE_ISP82XX "ql8200_fw.bin"
  #define FW_FILE_ISP2031 "ql2600_fw.bin"
  #define FW_FILE_ISP8031 "ql8300_fw.bin"
  #define FW_FILE_ISP27XX "ql2700_fw.bin"
  #define FW_FILE_ISP28XX "ql2800_fw.bin"
