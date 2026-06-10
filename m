Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956CD3921E9
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2026 20:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781124205; cv=none; b=s2aJE+Ma2Tt9xbs+uTl2jgeRMga6fpj+3PRkTyInuWnQS8UMAX7JcYaJNHdgadsIYUnBMjtesDT6VBTKmV/964PTh59lepHGFBQG/9QGU1kK/36Nu32/7XACW7iP4WR1RewE9k4wrLUUVPOM1+nj7BIvcBDzq+ztRYSDcm/1/EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781124205; c=relaxed/simple;
	bh=eECEFWKviFGovSY8dv4YhSbKFI3KHDczqXjfIHtU4KI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KHTeqgjhvSiHYJ0JIaUXcyPDQORI+NQbmw564s9RtSU/hWctYia4weeeLiZz4FR6CqWNoYX/tMneV+/xxuEgrswpyKN0r9n92VScl6YIQmyXbnA1ufZup6NG5Tj2rskmDIpyyaFojLj+B74RCbXKcWA4dXXN2UgFEv7XoAp0ltU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a7zQhnTV; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a7zQhnTV"
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-4863cd41330so206617b6e.1
        for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2026 13:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781124201; x=1781729001; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NpiWNaJanDKRHuWCGrhJcww0s9XnS0dPsuz5e44KkOA=;
        b=a7zQhnTVZxa2jAorHiG22FymWcK3Y5ROW1m5Nc97nczB7ZIFkjCfTWC5bKXr7C93Z2
         MGyVh2XFNrgrOqbUQpwG1Ht6urbckcDtudfvA4IY55weSDuAVy7T8Est1qZ9QWfQEoBj
         TIsvxmxCTQA8KfNXAuukxUZ9Mtmt78g1rTXoIhT6iEfJIZoTxzGahjNo8nlvolOSd4uN
         6zonM7NI9vsSw8XB3/f4m6OKdsFwDj6n33gJEvDevtUnFXLwu4a8uN1d90CV6MEWXejz
         KxG2f5fghg2+p50+uxyB0TXjtiBPc9529VfbA7QQTcHZXdmkDNNPYr9/pmUjY1u7fdJb
         +TLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781124201; x=1781729001;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NpiWNaJanDKRHuWCGrhJcww0s9XnS0dPsuz5e44KkOA=;
        b=iee2Z1ip1buthuOwTekFUM4cM0tiyq1XUpjyjrrMO3AJ6TovPxxhJdiWRJ6TbhyliC
         EfeKncFqTjB3MeV4jtAbLCgbLihLdUPD4prgsk0rMUBB6o+QXCrdBwxFys0yZDYX+vkU
         h/w48MZ9dFKeVc/RdA8T0jJ7taMTXV5DpCnHClKXlTf3NzD/K9tucCjLMgtPctZUT03A
         Kgg+GMUWqugYSfNCyqmiWfvmcAXePjzRGs2d3wKWbaSaek54E2E6W+hR3gEuO2nV2lio
         yGrPVvQBJWGJ1tl1lW4/h6tDB9M630c8HWH8q1oDJ5cCqn9CVaueVuMSARU4XSEdOMns
         LFJg==
X-Gm-Message-State: AOJu0YzrLQY1gUR0rzmXbSkIIetVeUpJKJj3HS0Gol/l7+Z/gTakTNC9
	gdpx23thGalKXIXjLGB6RXwPowYl2U2vwnDtELNyu55uXnk0ceYybmaYAjiPFg==
X-Gm-Gg: Acq92OFhfVIb8QgsnHC45UlGxydBHbYMtujGUQtf/U8tP7O5u/2kJ/tMYDNfYSUohFL
	aN89Ya3knB3X091vErzVXIPg2Zan3LFZqhzBSN35mLiALIu8b03icGecaS4fHFRxh901qlE0i5l
	kgYr/i4rL8mozPmwL0pGnwGt/a+LDnstZWLUZgnPmSy3lgkf6G46kK42Fx5s65uCpzyUr3epGEd
	DrcY0FY/pyhVMLS5Tb+DuYvAbQ4rMAmmmyffScd6RaFoBqYm8N+mHg2NyznwVsYiZf9Ll/K+pOr
	HjjjiqloY4sEwd2AwxuUUh3YGHsTPMPbA70vwYfb9xVNTWDi+ZuBrE0wDjzzSs7DDwpdiasT17c
	5IYLySbsInatfWQ2vR5u1vwMG8Ax2tn/1lYp0XSb1E04OzzhAyrgNHcgso5ViyYPOb78mRwC6+D
	4qT5FJBjUW5i6GOu5+/ml6rXWd5ZEX/UXiLqfzt2/oA+9UkOVt4UIisOhQFzIHg6HgLv0UNAwR3
	wdlcFV7aFWB4mThTjp93AM=
X-Received: by 2002:a05:6808:2f08:b0:479:eead:df9 with SMTP id 5614622812f47-48717b1f6a9mr224413b6e.4.1781124201362;
        Wed, 10 Jun 2026 13:43:21 -0700 (PDT)
Received: from ?IPV6:2605:a601:aab9:5000:dc49:41fd:5d54:871a? ([2605:a601:aab9:5000:dc49:41fd:5d54:871a])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4865b5a53bcsm19419533b6e.3.2026.06.10.13.43.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2026 13:43:20 -0700 (PDT)
Message-ID: <ca27f17a-d95e-471b-ad4f-ecbf6be1104d@gmail.com>
Date: Wed, 10 Jun 2026 15:43:19 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: target: Allow FUA if no write cache enabled
To: sashiko-reviews@lists.linux.dev,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20260609202156.90700-1-stuart.w.hayes@gmail.com>
 <20260609203953.154771F00898@smtp.kernel.org>
Content-Language: en-US
From: stuart hayes <stuart.w.hayes@gmail.com>
In-Reply-To: <20260609203953.154771F00898@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/9/2026 3:39 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Critical] Silently dropping the FUA bit when WCE=0 prevents the backend from honoring the FUA request, causing silent data loss in the fileio AIO backend.
> --
> 
> commit 5cb17faff566c1313276f5a67af675e43649d8d6
> Author: Stuart Hayes <stuart.w.hayes@gmail.com>
> 
> scsi: target: Allow FUA if no write cache enabled
> 
> This commit modifies the target core code to ignore the FUA bit in SCSI
> commands for targets without an enabled write cache. This allows systems
> with firmware that aggressively sets the FUA bit to successfully boot
> without failing due to unsupported FUA write errors.
> 
>> diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
>> index 21f5cb86d70c0..ffd2b6c9bd231 100644
>> --- a/drivers/target/target_core_sbc.c
>> +++ b/drivers/target/target_core_sbc.c
>> @@ -754,6 +754,12 @@ sbc_check_dpofua(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb)
>>   	}
>>   	if (cdb[1] & 0x8) {
>>   		if (!target_check_fua(dev)) {
>> +			/*
>> +			 * Silently ignore FUA if there's no write cache.
>> +			 */
>> +			if (!target_check_wce(dev))
>> +				return 0;
>> +
> 
> [Severity: Critical]
> Does returning early here prevent the command from receiving the SCF_FUA flag?
> 
> By returning 0, this bypasses the cmd->se_cmd_flags |= SCF_FUA; assignment
> that happens further down in sbc_check_dpofua().
> 
> While WCE=0 implies no write cache, the fileio AIO backend relies entirely
> on the SCF_FUA flag to ensure synchronous writes:
> 
> drivers/target/target_core_file.c:fd_execute_rw_aio() {
> ...
> 	aio_cmd->iocb.ki_flags = IOCB_DIRECT;
> 
> 	if (is_write && (cmd->se_cmd_flags & SCF_FUA))
> 		aio_cmd->iocb.ki_flags |= IOCB_DSYNC;
> ...
> }
> 
> Without the SCF_FUA flag, fd_execute_rw_aio() will issue asynchronous
> writes without flushing the cache, as it ignores the O_DSYNC flag set on
> the underlying file descriptor.
> 
> Could this regression lead to silent data loss on power failure, since
> what used to be rejected as an unsupported FUA write will now complete
> asynchronously without a disk cache flush?
> 

Valid point, yes. I will fix.

Also, I accidentally submitted this as V2 when it should have been V3, 
sorry.

>>   			pr_err("Got CDB: 0x%02x with FUA bit set, but device"
>>   			       " does not advertise support for FUA write\n",
>>   			       cdb[0]);
> 

