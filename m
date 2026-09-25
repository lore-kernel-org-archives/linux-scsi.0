Received: from mta1.migadu.com (out-106.mta1.migadu.com [95.215.58.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1228477282
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 09:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790327200; cv=none; b=uJ5/SR4GXr9E9kX+w/CC44fa8eP20LU6+HjezY/CuTOPg/svVakUhhmU+1xqaumsQt+LZFXTQuGpcxALL8zvHpNLtbrL2gCjRv8YXTCg7uV48ZWHftmDR8j0SMSFBTXRQlhHXTFBx/1RQU05gmoDIxI/jC1GBSVOZSaeLaaXBic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790327200; c=relaxed/simple;
	bh=77eIgiOaVeUpNkSyBuO5LAV7jHkOebf29UiihaTQwqM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eMbtIsR+9DT1DzR3TM2xAof4lDaI4Qq+WjKVc4d3OCT8pieG+2nUMwApUOiKwWfPm9Rj7hktFCeMOsPeFfBuagvWNe8zfs3OliFD7l3jV0mv6vuJiuzY+fhPMZWrdVmG4ZnHkE7s896jRoAwBN74VEPlgdgRd7OLMm4vhgJJvLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FOJF/x5S; arc=none smtp.client-ip=95.215.58.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FOJF/x5S"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=77eIgiOaVeUpNkSyBuO5LAV7jHkOebf29UiihaTQwqM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790327196; v=1; x=1790931996;
 b=FOJF/x5SKo5Fc0VwIOt5Hb1mRsP6VR9eQAPyKw0zypZs0TEa9Hxehgukhgi03zt+ezFRFuyl
 NyHeFfJk3q31ibr+n7UlSXjncM9kknPwHVzNydoo5XibyzXEozoL+AufZnVkA3hHL5Q32eaTpLL
 6BhhYCF381NygGWNgsILdYl0=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id 49937161d7c7e917;
	Fri, 25 Sep 2026 09:06:36 +0000
X-Mizu-Trace-ID: 49937161d7c7e917
X-Migadu-Flow: FLOW_OUT
Message-ID: <1ffb80b0-c312-4773-8e0e-fd6a59a674f2@linux.dev>
Date: Fri, 25 Sep 2026 10:06:35 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/7] scsi: scsi_debug: Split resp_read_dt0()
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 Christoph Hellwig <hch@lst.de>
References: <cover.1790290089.git.bvanassche@acm.org>
 <4b4b537c1a2c95b81d0c8b8f9c4c31e2b9f47369.1790290090.git.bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <4b4b537c1a2c95b81d0c8b8f9c4c31e2b9f47369.1790290090.git.bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/24/26 23:54, Bart Van Assche wrote:
> +/*
> + * Returns the number of bytes transferred, or -1 with *scsi_status set to a
> + * SCSI status code on failure.
> + */
> +static int __resp_read_dt0(struct scsi_cmnd *scp, struct sdeb_store_info *sip,
> +			   u64 lba, u32 num, u32 ei_lba, int *scsi_status)
> +{
> +	u8 *cmd = scp->cmnd;
> +
> +	/* DIX + T10 DIF */
> +	if (unlikely(sdebug_dix && scsi_prot_sg_count(scp))) {
> +		switch (prot_verify_read(scp, lba, num, ei_lba)) {
> +		case 1: /* Guard tag error */
> +			if (cmd[1] >> 5 != 3) { /* RDPROTECT != 3 */
> +				mk_sense_buffer(scp, ABORTED_COMMAND,
> +					LOGICAL_BLOCK_GUARD_CHECK_FAILED);
> +				*scsi_status = check_condition_result;
> +				return -1;
> +			} else if (scp->prot_flags & SCSI_PROT_GUARD_CHECK) {
> +				mk_sense_buffer(scp, ILLEGAL_REQUEST,
> +					LOGICAL_BLOCK_GUARD_CHECK_FAILED);
> +				*scsi_status = illegal_condition_result;
> +				return -1;
> +			}
> +			break;
> +		case 3: /* Reference tag error */
> +			if (cmd[1] >> 5 != 3) { /* RDPROTECT != 3 */
> +				mk_sense_buffer(scp, ABORTED_COMMAND,
> +					LOGICAL_BLOCK_REFERENCE_TAG_CHECK_FAILED);
> +				*scsi_status = check_condition_result;
> +				return -1;
> +			} else if (scp->prot_flags & SCSI_PROT_REF_CHECK) {
> +				mk_sense_buffer(scp, ILLEGAL_REQUEST,
> +					LOGICAL_BLOCK_REFERENCE_TAG_CHECK_FAILED);
> +				*scsi_status = illegal_condition_result;
> +				return -1;
> +			}
> +			break;
> +		}
> +	}
> +
> +	*scsi_status = DID_ERROR << 16;

This just seems odd. We are still setting scsi_status = DID_ERROR << 16 
even if no error. I know that it is not checked (for no error), but it 
is a good practice to make it hold a proper value.

Similar could be said how it is initialized in resp_read_dt0().
> +	return do_device_access(sip, scp, 0, lba, num, 0, false, false);
> +}

