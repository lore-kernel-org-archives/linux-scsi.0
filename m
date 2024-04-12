Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D991052F9B;
	Fri, 12 Apr 2024 12:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712923692; cv=none; b=AHJIQRwIS1RcA0dGuKXku35xsEuviXtHMZXiWL4qaQKGrUYep8gPF1MuJ6xfiNLzkkL2SEDN1JmK3ilfKrQ4E4/jO2fLqj/D3aLXZolb9NwztA67JyFrHV0QuUJexiu53UPSoOrXQpTUQ8WJ3uyRvpxNjjZBfNApQ2oAo7mhkPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712923692; c=relaxed/simple;
	bh=imRHGZh1StRgTH0gY3//iwdwORWKCOc1mgfKSbv/wf8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r42teHR6eSGJIvSrur9VYY8UOGVCbhk2QnvYCSAg1rFRauW8xkpPFpm0h7WP4tkLuSoVBlQ44BNae5er+MsCd3qF7iMyMJ3p4wqsocnQnFhRJy/SjThTSIeO2Jv4YELOmn3OsU846ZMUH0kf/MomLgVqm9AvEXd0ofzP6dSiV4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UmvitSYE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UmvitSYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25788C113CC;
	Fri, 12 Apr 2024 12:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712923692;
	bh=imRHGZh1StRgTH0gY3//iwdwORWKCOc1mgfKSbv/wf8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UmvitSYEUH8yveRywsVGXdtHCVoC+UzFjO+ZFhyVrM0naByxuYNR/XJYswI27Vmie
	 Y411xAqbgxWkY9WzcUYezh0HC5rxXN3H7gszg/TfrEZQumIoWBU5GS3FT1l/hJoYL4
	 5gY5QHorHMsaQxViQW+ozJJ/JwPzav+gvJ0wWSJ+SU3axGplHE7iSUdvIybgwiDeyi
	 3rVmRg1dgvb68SWKv+MKHtTZrKXIM54Vfg+HJulghbO7cA6DTAAjInp5aE6qDBWhqr
	 /9BN5mcRjrDknCG6M1K8Ssq5m7OEURv+xEEIdLOjUqRi6XLco3b98t0YJucjCnHujj
	 oK5jRicgoQ3mw==
Date: Fri, 12 Apr 2024 14:08:08 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [PATCH] ata: libata-scsi: Fix ata_scsi_port_error_handler()
 error path
Message-ID: <ZhkkKPpuscTx4ZT0@ryzen>
References: <20240411234731.810968-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240411234731.810968-1-dlemoal@kernel.org>

On Fri, Apr 12, 2024 at 08:47:31AM +0900, Damien Le Moal wrote:
> Commit 0c76106cb975 ("scsi: sd: Fix TCG OPAL unlock on system resume")
> incorrectly handles scsi_resume_device() errors, leading to a double
> call to spin_unlock_irqrestore() to unlock a device port. Fix this by
> redefining the goto labels used in case of error and only unlock the
> port scsi_scan_mutex when scsi_resume_device() fails.
> 
> Bug found with the Smatch static checker warning:
> 
> 	drivers/ata/libata-scsi.c:4774 ata_scsi_dev_rescan()
> 	error: double unlocked 'ap->lock' (orig line 4757)
> 
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Fixes: 0c76106cb975 ("scsi: sd: Fix TCG OPAL unlock on system resume")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  drivers/ata/libata-scsi.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 2f4c58837641..e954976891a9 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -4745,7 +4745,7 @@ void ata_scsi_dev_rescan(struct work_struct *work)
>  			 * bail out.
>  			 */
>  			if (ap->pflags & ATA_PFLAG_SUSPENDED)
> -				goto unlock;
> +				goto unlock_ap;
>  
>  			if (!sdev)
>  				continue;
> @@ -4758,7 +4758,7 @@ void ata_scsi_dev_rescan(struct work_struct *work)
>  			if (do_resume) {
>  				ret = scsi_resume_device(sdev);
>  				if (ret == -EWOULDBLOCK)
> -					goto unlock;
> +					goto unlock_scan;
>  				dev->flags &= ~ATA_DFLAG_RESUMING;
>  			}
>  			ret = scsi_rescan_device(sdev);
> @@ -4766,12 +4766,13 @@ void ata_scsi_dev_rescan(struct work_struct *work)
>  			spin_lock_irqsave(ap->lock, flags);
>  
>  			if (ret)
> -				goto unlock;
> +				goto unlock_ap;
>  		}
>  	}
>  
> -unlock:
> +unlock_ap:
>  	spin_unlock_irqrestore(ap->lock, flags);
> +unlock_scan:
>  	mutex_unlock(&ap->scsi_scan_mutex);
>  
>  	/* Reschedule with a delay if scsi_rescan_device() returned an error */
> -- 
> 2.44.0
> 

Subject: [PATCH] ata: libata-scsi: Fix ata_scsi_port_error_handler() error path
ata_scsi_port_error_handler() ? How did you come up with that? :)
Wrong copy paste?

s/ata_scsi_port_error_handler()/ata_scsi_dev_rescan()/

With that:
Reviewed-by: Niklas Cassel <cassel@kernel.org>
