Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8391625D903;
	Mon,  7 Apr 2025 18:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744050515; cv=none; b=XyuFP3cvfosS+YVsmG9KCxyksTmEP/AMEy9WDisG9g6N/zFi9zuYOWy+I2ryCQyyVMm+wr5RB8KkJ/1Zh9vAykspj987sjHhFQQSnH/LcsQ6PAVMKRetBj+3QraqC92hdBQxlpCdOprwlPhB0MifrTacDNZnm9MYcE9Ja2OTg10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744050515; c=relaxed/simple;
	bh=t9TUQsEt5Q9gIOtHF38LsFjD/8E4Sfx5Y8wLVTNcThA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dYHH3m0LzDkh8oR2Q2uF1EptJmFRijT9zh/2tWOHQw87+26eT7tzHXGtCIPoSIJOtBem6NzxGmQMUgLxUbeAyvvIIT3u6oIdRpTg/t/3/q6khQKtES+RsLaKt69mVVLsj15/vnA8iifHLuZ+4Dj8hpsXZJH7hGd4aGZ8+hrJ57U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V9OFDeBF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V9OFDeBF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F100CC4CEDD;
	Mon,  7 Apr 2025 18:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744050515;
	bh=t9TUQsEt5Q9gIOtHF38LsFjD/8E4Sfx5Y8wLVTNcThA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V9OFDeBFLFfhzZFtHLwRrBF+XIHuHUCJNloCXOSafflkYLjxTNErR3QE7PpyAY8G0
	 oM2oUFEtOllLn1NmB94n+hwstzCt2bOjDdX4VoiNKrddcnGmpdic4Cz/yRHmZz7QFc
	 nCV3LLR4sNHud4N5meQyEh4q/sqCRWb0MfYBfQJfGpCIUWfMxn5bwk4SXtJd6J3JUw
	 aR/ehGVeCa9HHrNClCq/RiWWv0uF8aWPxcQHFcevsDGPoj6uDyrPXI6snymjBf6Iqy
	 gZQbkx+HkYWYDZVHi4aCERl+bUd3HyzdPdHZGznnlN+O7pikgis3pUDMtrdLddifCU
	 mObCa+3aPlJLQ==
Date: Mon, 7 Apr 2025 11:28:32 -0700
From: Kees Cook <kees@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: James Smart <james.smart@broadcom.com>,
	Ram Vegesna <ram.vegesna@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-hardening@vger.kernel.org, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: elx: sli4: Replace deprecated strncpy() with
 strscpy()
Message-ID: <202504071126.37117C5D@keescook>
References: <20250226185531.1092-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250226185531.1092-2-thorsten.blum@linux.dev>

On Wed, Feb 26, 2025 at 07:55:26PM +0100, Thorsten Blum wrote:
> strncpy() is deprecated for NUL-terminated destination buffers; use
> strscpy() instead.
> 
> Compile-tested only.
> 
> Link: https://github.com/KSPP/linux/issues/90
> Cc: linux-hardening@vger.kernel.org
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/scsi/elx/libefc_sli/sli4.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/elx/libefc_sli/sli4.c b/drivers/scsi/elx/libefc_sli/sli4.c
> index 5e7fb110bc3f..d9a231fc0e0d 100644
> --- a/drivers/scsi/elx/libefc_sli/sli4.c
> +++ b/drivers/scsi/elx/libefc_sli/sli4.c
> @@ -3804,7 +3804,7 @@ sli_cmd_common_write_object(struct sli4 *sli4, void *buf, u16 noc,
>  	wr_obj->desired_write_len_dword = cpu_to_le32(dwflags);
>  
>  	wr_obj->write_offset = cpu_to_le32(offset);
> -	strncpy(wr_obj->object_name, obj_name, sizeof(wr_obj->object_name) - 1);
> +	strscpy(wr_obj->object_name, obj_name);

Standard question for these kinds of conversions: Why is it safe that
this is not NUL padded? I haven't found where this buffer is being
zeroed out, but it probably is (given the "- 1" on the length), but
without run-time testing, this needs much more careful analysis.

-Kees

>  	wr_obj->host_buffer_descriptor_count = cpu_to_le32(1);
>  
>  	bde = (struct sli4_bde *)wr_obj->host_buffer_descriptor;
> @@ -3833,7 +3833,7 @@ sli_cmd_common_delete_object(struct sli4 *sli4, void *buf, char *obj_name)
>  			 SLI4_SUBSYSTEM_COMMON, CMD_V0,
>  			 SLI4_RQST_PYLD_LEN(cmn_delete_object));
>  
> -	strncpy(req->object_name, obj_name, sizeof(req->object_name) - 1);
> +	strscpy(req->object_name, obj_name);
>  	return 0;
>  }
>  
> @@ -3856,7 +3856,7 @@ sli_cmd_common_read_object(struct sli4 *sli4, void *buf, u32 desired_read_len,
>  		cpu_to_le32(desired_read_len & SLI4_REQ_DESIRE_READLEN);
>  
>  	rd_obj->read_offset = cpu_to_le32(offset);
> -	strncpy(rd_obj->object_name, obj_name, sizeof(rd_obj->object_name) - 1);
> +	strscpy(rd_obj->object_name, obj_name);
>  	rd_obj->host_buffer_descriptor_count = cpu_to_le32(1);
>  
>  	bde = (struct sli4_bde *)rd_obj->host_buffer_descriptor;
> -- 
> 2.48.1
> 

-- 
Kees Cook
