Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F7A1E86E
	for <linux-scsi@vger.kernel.org>; Mon,  6 Oct 2025 02:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759716047; cv=none; b=GLtrKdmpekCEbyyfLGatjgIFZXaSO6RPBZ4YT4oq40yjYZTBqgszUNQeJkXawxz834k6OYwPyVtMOV7Hkl5Jnwz7wpE/JLETTeTKQhKKwuHLUCmRaKUMDnfB46cRmdvkOHneZ7mI3pGFIUCcJVGuEZg6iO0jeMr1iB6nDoHpI6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759716047; c=relaxed/simple;
	bh=0872Dk6DZCM9MFVXp/4j/Ncsq03/r24AIypW/77zCeE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EvdmiFeXc5KuoTdsY/pAcyZuMC2l3Uf/+w9L7fiKlEog8PyV/+PzZehgYgWwVamNCtW83386Ts1whZFX/VdbTv1DqMANaOzqKyqc8O5Bg2uzj6/UVFey78+KYOuoXbHIagQF+99gnFKytO0JYvxe9nb1LBNcfAZdw3qVui5RFaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O+n+fnur; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O+n+fnur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E699C4CEF4;
	Mon,  6 Oct 2025 02:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759716047;
	bh=0872Dk6DZCM9MFVXp/4j/Ncsq03/r24AIypW/77zCeE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=O+n+fnurHwt5UaiB8HzMdVNkyB5AiGbET0zT/aerr2dF7RDJRBycYh8lNoa1VxvNH
	 AGP575DXmeRhxrndiygm/wlBO0cGw0QoGpuGUDE/0RY8LW41aom+nppB2PlHAVHWlu
	 Sz74YjzhDgM2daAK8oSHwwRdQzbela/dVb5RFA88ZZA0VwmZBvPDDSNmI2RZ8Y9Ern
	 etXNoVCcOsMnljhC58v138DX4Fa6Aeq5CBEr3qWZGooXtK+lOqRJCb0S3Nch+BiyyN
	 376Rr8HK5Z2l5pwVMrV2F/EsyguVH9wwuRajpEIf9Aw1QGwNl7rfZPLkb1tuUc1NC2
	 NBTWRrHBedXdQ==
Message-ID: <1066f2aa-2024-475c-b9f6-e4c24476f061@kernel.org>
Date: Mon, 6 Oct 2025 11:00:44 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/9] scsi: sd: Have scsi-ml retry read_capacity_16
 errors
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org,
 hare@suse.de
References: <20251002192510.1922731-1-emilne@redhat.com>
 <20251002192510.1922731-4-emilne@redhat.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251002192510.1922731-4-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/3/25 04:25, Ewan D. Milne wrote:
> This has read_capacity_16 have scsi-ml retry errors instead of driving
> them itself.
> 
> There are 2 behavior changes with this patch:
> 1. There is one behavior change where we no longer retry when
> scsi_execute_cmd returns < 0, but we should be ok. We don't need to retry
> for failures like the queue being removed, and for the case where there
> are no tags/reqs since the block layer waits/retries for us. For possible
> memory allocation failures from blk_rq_map_kern we use GFP_NOIO, so
> retrying will probably not help.
> 2. For the specific UAs we checked for and retried, we would get
> READ_CAPACITY_RETRIES_ON_RESET retries plus whatever retries were left
> from the main loop's retries. Each UA now gets
> READ_CAPACITY_RETRIES_ON_RESET reties, and the other errors get up to 3
> retries. This is most likely ok, because READ_CAPACITY_RETRIES_ON_RESET
> is already 10 and is not based on anything specific like a spec or
> device, so the extra 3 we got from the main loop was probably just an
> accident and is not going to help.
> 
> Original patch by Mike Christie <michael.christie@oracle.com> modified
> based upon review comments for an earlier version of this patch.
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>  drivers/scsi/sd.c | 107 +++++++++++++++++++++++++++++++---------------
>  1 file changed, 73 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index e3b802b26f0e..25561d01f972 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2631,14 +2631,66 @@ static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
>  static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
>  		struct queue_limits *lim, unsigned char *buffer)
>  {
> -	unsigned char cmd[16];
> +	static const u8 cmd[16] = {
> +		[0] = SERVICE_ACTION_IN_16,
> +		[1] = SAI_READ_CAPACITY_16,
> +		[13] = RC16_LEN,
> +	};
>  	struct scsi_sense_hdr sshdr;
> +	struct scsi_failure failure_defs[] = {
> +		/*
> +		 * Do not retry Invalid Command Operation Code or Invalid
> +		 * Field in CDB.
> +		 */
> +		{
> +			.sense = ILLEGAL_REQUEST,
> +			.asc = 0x20,
> +			.ascq = 0x00,

There are many possible ascq values for asc 0x20, so may be use
SCMD_FAILURE_ASCQ_ANY here ?

> +			.result = SAM_STAT_CHECK_CONDITION,
> +		},
> +		{
> +			.sense = ILLEGAL_REQUEST,
> +			.asc = 0x24,
> +			.ascq = 0x00,

Same here.

> +			.result = SAM_STAT_CHECK_CONDITION,
> +		},
> +		/* Do not retry Medium Not Present */
> +		{
> +			.sense = UNIT_ATTENTION,
> +			.asc = 0x3A,
> +			.ascq = SCMD_FAILURE_ASCQ_ANY,
> +			.result = SAM_STAT_CHECK_CONDITION,
> +		},
> +		{
> +			.sense = NOT_READY,
> +			.asc = 0x3A,
> +			.ascq = SCMD_FAILURE_ASCQ_ANY,
> +			.result = SAM_STAT_CHECK_CONDITION,
> +		},
> +		/* Device reset might occur several times so retry a lot */
> +		{
> +			.sense = UNIT_ATTENTION,
> +			.asc = 0x29,
> +			.ascq = 0x00,

Same here too.

> +			.allowed = READ_CAPACITY_RETRIES_ON_RESET,
> +			.result = SAM_STAT_CHECK_CONDITION,
> +		},
> +		/* Any other error not listed above retry 3 times */
> +		{
> +			.result = SCMD_FAILURE_RESULT_ANY,
> +			.allowed = 3,
> +		},
> +		{}
> +	};

[...]

> -	} while (the_result && retries);
> +	if (the_result > 0) {
> +		if (media_not_present(sdkp, &sshdr))
> +			return -ENODEV;
> +
> +		sense_valid = scsi_sense_valid(&sshdr);
> +		if (sense_valid && sshdr.sense_key == ILLEGAL_REQUEST &&
> +		    (sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
> +		     sshdr.ascq == 0x00) {
> +			/*
> +			 * Invalid Command Operation Code or Invalid Field in
> +			 * CDB, just retry silently with RC10

Please spell out "READ CAPACITY (10)", or "...retry silently with the 10B READ
CAPACITY command".

> +			 */
> +			return -EINVAL;
> +		}
> +	}
>  
>  	if (the_result) {
>  		sd_print_result(sdkp, "Read Capacity(16) failed", the_result);


-- 
Damien Le Moal
Western Digital Research
