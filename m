Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BED38394;
	Mon, 19 Aug 2024 04:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724041071; cv=none; b=YZ4zRiUC2Kku0Se9M8yq5qsVRrWPnM55ApvFmGkUP2u9Lz+cefkqXCtKxb2C99hMqSOqB8wNKGB+AP+iZnRxUSOCAoY8+BtmBoukaoU010mhPaiPeMp93jtEaR+bwOKetfwYgUe8cv8P6tFU0yzyPNPTjezfxtOZL+XT2hlczYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724041071; c=relaxed/simple;
	bh=M3sfCsQ738NNzKcRDJ3YsMDynsmCYn+/KmSEAlKKgKU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WY831PpgYNxFAlWdPvirtDbRDClP2W8Ze5prbQ9aCjpjq0OAL9nXcrB2rjatdN/WSx3iqUl3Y0TGg845OhW1gPwSSgcAa/Ha/kuT2R0bzL78NH4koJhz2SiTX1AIDYf9CRUtN2Luhj0cwh2Fd9KbHxvvWqueXZKy9yLlhl4oZtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pqT9a7ah; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pqT9a7ah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E180FC32782;
	Mon, 19 Aug 2024 04:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724041071;
	bh=M3sfCsQ738NNzKcRDJ3YsMDynsmCYn+/KmSEAlKKgKU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pqT9a7ahbnjD9bJ7twx7zQZuTV1sg/2lUe+AbP+1wAHxwOBybH/0yMaNuSQZwoWcO
	 7FvBeqMm9H8BDCXOPH4Bz4uUGzKTyR/vOBzhQ9GznCNF87NDpGVijlZmr6MGye02YE
	 /6w4mfamIxDrUIIvQgv7oyxqdTAcydeINy0SeLcnLF93YtKkhALRWuGnK9PYKm6+CM
	 fnNDyQcoPRWt/AudpT8iriWqSdznEADkam/eg7fUD/GtkqNwffF+WVmEuhuA9NAIkf
	 ilGulrp1yuG3YIb1il/N392xPOvCghT3Dgy4AjCK0XpNzpRZeJEiGac/l//3EthyTR
	 lc8XxnFUR6iyg==
Message-ID: <a3fc662c-fa98-4a6e-807b-babb9a344904@kernel.org>
Date: Mon, 19 Aug 2024 13:17:48 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] scsi: sd: retry command SYNC CACHE if format in
 progress
To: Yihang Li <liyihang9@huawei.com>, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 bvanassche@acm.org, linuxarm@huawei.com, prime.zeng@huawei.com,
 stable@vger.kernel.org
References: <20240817015019.3467765-1-liyihang9@huawei.com>
 <10c56cbc-a367-44c3-8b14-b846a3c4e4a0@kernel.org>
 <4618fc13-4499-53f1-efea-0487f436b353@huawei.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <4618fc13-4499-53f1-efea-0487f436b353@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/19/24 13:07, Yihang Li wrote:
> 
> 
> On 2024/8/19 7:55, Damien Le Moal wrote:
>> On 8/17/24 10:50, Yihang Li wrote:
>>> If formatting a suspended disk (such as formatting with different DIF
>>> type), the disk will be resuming first, and then the format command will
>>> submit to the disk through SG_IO ioctl.
>>>
>>> When the disk is processing the format command, the system does not submit
>>> other commands to the disk. Therefore, the system attempts to suspend the
>>> disk again and sends the SYNC CACHE command. However, the SYNC CACHE
>>
>> Why would the system try to suspend the disk with a request in flight ? Sounds
>> like there is a bug with PM reference counting, no ?
> 
> According to my understand and test, the format command request is finished,
> so it is not in flight for the kernel. And the command need a few time to processing
> in the disk while no other commands are being sent.

OK, fine. But I think that retrying SYNC CACHE if the drive is formatting makes
absolutely no sense at all because there is nothing to flush in that case.
So what about simply ignoring the error ? I.e. something like this:

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 699f4f9674d9..1da267b8cd8a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1824,12 +1824,14 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
                                /* this is no error here */
                                return 0;
                        /*
-                        * This drive doesn't support sync and there's not much
-                        * we can do because this is called during shutdown
-                        * or suspend so just return success so those operations
-                        * can proceed.
+                        * If a format is in progress (asc = LOGICAL UNIT NOT
+                        * READY, ascq = FORMAT IN PROGRESS) or if the drive
+                        * does not support sync, there is not much we can do
+                        * because this is called during shutdown or suspend. So
+                        * just return success so those operations can proceed.
                         */
-                       if (sshdr.sense_key == ILLEGAL_REQUEST)
+                       if ((sshdr.asc == 0x04 && sshdr.ascq == 0x04) ||
+                           sshdr.sense_key == ILLEGAL_REQUEST)
                                return 0;
                }

> 
>>
>>> command will fail because the disk is in the formatting process, which
>>> will cause the runtime_status of the disk to error and it is difficult
>>> for user to recover it. Error info like:
>>>
>>> [  669.925325] sd 6:0:6:0: [sdg] Synchronizing SCSI cache
>>> [  670.202371] sd 6:0:6:0: [sdg] Synchronize Cache(10) failed: Result: hostbyte=0x00 driverbyte=DRIVER_OK
>>> [  670.216300] sd 6:0:6:0: [sdg] Sense Key : 0x2 [current]
>>> [  670.221860] sd 6:0:6:0: [sdg] ASC=0x4 ASCQ=0x4
>>>
>>> To solve the issue, retry the command until format command is finished.
>>>
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Yihang Li <liyihang9@huawei.com>
>>> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
>>> ---
>>> Changes since v3:
>>> - Add Cc tag for kernel stable.
>>>
>>> Changes since v2:
>>> - Add Reviewed-by for Bart.
>>>
>>> Changes since v1:
>>> - Updated and added error information to the patch description.
>>>
>>> ---
>>>  drivers/scsi/sd.c | 5 +++++
>>>  1 file changed, 5 insertions(+)
>>>
>>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>>> index adeaa8ab9951..5cd88a8eea73 100644
>>> --- a/drivers/scsi/sd.c
>>> +++ b/drivers/scsi/sd.c
>>> @@ -1823,6 +1823,11 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
>>>  			    (sshdr.asc == 0x74 && sshdr.ascq == 0x71))	/* drive is password locked */
>>>  				/* this is no error here */
>>>  				return 0;
>>> +
>>> +			/* retry if format in progress */
>>> +			if (sshdr.asc == 0x4 && sshdr.ascq == 0x4)
>>> +				return -EBUSY;
>>> +
>>>  			/*
>>>  			 * This drive doesn't support sync and there's not much
>>>  			 * we can do because this is called during shutdown
>>

-- 
Damien Le Moal
Western Digital Research

