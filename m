Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECAA219EB;
	Tue, 13 Aug 2024 05:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723526088; cv=none; b=mC8y26akcJFwrvOGsjUUd1FAl/MPEqdFZc/vEu89tEDFIq8/swFGiG9tzP3g2QjT/xom4MFhPJCKJCGkacP1D8+J05p/2iRmTO1IRokVlLTmxokZUTcCy+iaLZLNIAk0U1pPiB4TqEZVD5zvfZeSNxmPd7aKPw6Cwk5a5850Qdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723526088; c=relaxed/simple;
	bh=Zy3d+CQ+9kwcPHjJ2TpBkbN91nBgsNVclVWu2IJOqrA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PgnBpxQc2nOPIzRueyYBgRp+xrWL1C25eNV0FKpL6Jo4t4od4nPna5v8Z9IWT3EqETcU071asPQkdKBXb2R0pSXIDtNukR/zmjV+RKkuYD8y6wI7/AbEv4KCqug2VsYH7sleFkNMPHSoPIvW26A/mZ3xexu0SAm1pQ8va+A0u1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qHos+eJh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qHos+eJh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5A76C4AF09;
	Tue, 13 Aug 2024 05:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723526088;
	bh=Zy3d+CQ+9kwcPHjJ2TpBkbN91nBgsNVclVWu2IJOqrA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qHos+eJhM/ztgA3THGVPR4X6ogA5gmE+adasiNA1C+Zy3uZDJ7yitXObzc3bDICw8
	 43nvJiqh4ZajCO5RoSzjbN8t7m111DwEavd2iqgHrjQ4b8Dq5QoaZEudWrwSCpM/gy
	 DR7RuhoyzacBNYUK7IS+S1o8wLMwlO9BOTkQEpCk=
Date: Tue, 13 Aug 2024 07:14:45 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Yihang Li <liyihang9@huawei.com>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	bvanassche@acm.org, linuxarm@huawei.com, prime.zeng@huawei.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v3] scsi: sd: retry command SYNC CACHE if format in
 progress
Message-ID: <2024081338-trance-precinct-bfa6@gregkh>
References: <20240813011747.3643577-1-liyihang9@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240813011747.3643577-1-liyihang9@huawei.com>

On Tue, Aug 13, 2024 at 09:17:47AM +0800, Yihang Li wrote:
> If formatting a suspended disk (such as formatting with different DIF
> type), the disk will be resuming first, and then the format command will
> submit to the disk through SG_IO ioctl.
> 
> When the disk is processing the format command, the system does not submit
> other commands to the disk. Therefore, the system attempts to suspend the
> disk again and sends the SYNC CACHE command. However, the SYNC CACHE
> command will fail because the disk is in the formatting process, which
> will cause the runtime_status of the disk to error and it is difficult
> for user to recover it. Error info like:
> 
> [  669.925325] sd 6:0:6:0: [sdg] Synchronizing SCSI cache
> [  670.202371] sd 6:0:6:0: [sdg] Synchronize Cache(10) failed: Result: hostbyte=0x00 driverbyte=DRIVER_OK
> [  670.216300] sd 6:0:6:0: [sdg] Sense Key : 0x2 [current]
> [  670.221860] sd 6:0:6:0: [sdg] ASC=0x4 ASCQ=0x4
> 
> To solve the issue, retry the command until format command is finished.
> 
> Signed-off-by: Yihang Li <liyihang9@huawei.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/sd.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index adeaa8ab9951..5cd88a8eea73 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1823,6 +1823,11 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
>  			    (sshdr.asc == 0x74 && sshdr.ascq == 0x71))	/* drive is password locked */
>  				/* this is no error here */
>  				return 0;
> +
> +			/* retry if format in progress */
> +			if (sshdr.asc == 0x4 && sshdr.ascq == 0x4)
> +				return -EBUSY;
> +
>  			/*
>  			 * This drive doesn't support sync and there's not much
>  			 * we can do because this is called during shutdown
> -- 
> 2.33.0
> 
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
