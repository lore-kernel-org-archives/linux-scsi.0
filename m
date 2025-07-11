Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F63D2192EC;
	Fri, 11 Jul 2025 09:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752224839; cv=none; b=tMT+m8XOoBowNopEGdOxujOni7NpkpNM4vyugNdJvz5OzzwPu3cpoCARsjDxLclY4PC1QLlK6cDFn8smKlX/raCozf4ocUb22bW8ATMQ9ne+GowwbxiAODmXCmXlHNCV42x7v8nT/rlbpz1W7koO2OJianL8l+gatYemAQEubSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752224839; c=relaxed/simple;
	bh=UYG+bqqWwQdOHcMas30kN4TJScHl7PkoLEuA5A1Z27Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j8vIqLbph48YecIlx/ie1Yac9S2J1tgtgE71W2T39814rLNa2EXlQEtk/SmEoZ4IVf9H0MeMTvqKVW9pUFYagR2za/wrGBRU8bJr2OGhFhbqd53IhkN+b9ENr6v3w2QGqgdqcpddJ4Pdy+fsal6sHq3khs4Z47+sluI/4cmbcbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mhFTxXDe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mhFTxXDe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D619C4CEED;
	Fri, 11 Jul 2025 09:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752224838;
	bh=UYG+bqqWwQdOHcMas30kN4TJScHl7PkoLEuA5A1Z27Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mhFTxXDesMziPZvJfppaScCtLUEtw19z51WJ8M4+qKJHeK3b4vRbBcmUdmFN3Cg4r
	 fPkSufE2CmOu4U17Q00df0HjmUo3f8PCRBFLRFUkkatLJ2N493TDP1lMfUFeyMlAkV
	 N7qIeF30CLMgI+rWOx8u7vdqhQdloDa3LsdKbJggXAwKlYBGzEVnTShfiv0HSGFY8m
	 HXtjckXFInPVdI4myCXCG0DqVzh32+x0klpUdWWILI6rX7AKCtYHKCn7NSCax+iQ6S
	 IqCcrKIy0py+IaQC1wJA6Hg4JdnxCzorUkpyFdMM5NNPdkDB2NBiVotf4dCru9ktA7
	 N7+Kk4/BY/xWw==
Date: Fri, 11 Jul 2025 11:07:15 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH v3 3/3] Documentation: driver-api: Update libata error
 handler information
Message-ID: <aHDUQ9FOu0J_SWfh@ryzen>
References: <20250711083544.231706-1-dlemoal@kernel.org>
 <20250711083544.231706-4-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250711083544.231706-4-dlemoal@kernel.org>

On Fri, Jul 11, 2025 at 05:35:44PM +0900, Damien Le Moal wrote:
> Update ``->error_handler()`` section of the libata documentation file
> Documentation/driver-api/libata.rst to remove the reference to the
> function ata_do_eh() as that function was removed. The reference to the
> function ata_bmdma_drive_eh() is also removed as that function does not
> exist at all. And while at it, cleanup the description of the various
> reset operations using a bullet list.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  Documentation/driver-api/libata.rst | 25 ++++++++++++++++---------
>  1 file changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/driver-api/libata.rst b/Documentation/driver-api/libata.rst
> index 5da27a749246..93d97fe78e3f 100644
> --- a/Documentation/driver-api/libata.rst
> +++ b/Documentation/driver-api/libata.rst
> @@ -283,18 +283,25 @@ interrupts, start DMA engine, etc.
>  
>  ``->error_handler()`` is a driver's hook into probe, hotplug, and recovery
>  and other exceptional conditions. The primary responsibility of an
> -implementation is to call :c:func:`ata_do_eh` or :c:func:`ata_bmdma_drive_eh`
> -with a set of EH hooks as arguments:
> +implementation is to call :c:func:`ata_std_error_handler`.
>  
> -'prereset' hook (may be NULL) is called during an EH reset, before any
> -other actions are taken.
> +:c:func:`ata_std_error_handler` will perform a standard error handling sequence
> +to resurect failed devices, detach lost devices and add new devices (if any).
> +This function will call the various reset operations for a port, as needed.
> +These operations are as follows.
>  
> -'postreset' hook (may be NULL) is called after the EH reset is
> -performed. Based on existing conditions, severity of the problem, and
> -hardware capabilities,
> +* The 'prereset' operation (which may be NULL) is called during an EH reset,
> +  before any other action is taken.
>  
> -Either 'softreset' (may be NULL) or 'hardreset' (may be NULL) will be
> -called to perform the low-level EH reset.
> +* The 'postreset' hook (which may be NULL) is called after the EH reset is
> +  performed. Based on existing conditions, severity of the problem, and hardware
> +  capabilities,
> +
> +* Either the 'softreset' operation or the 'hardreset' operation will be called
> +  to perform the low-level EH reset. If both operations are defined,
> +  'hardreset' is preferred and used. If both are not defined, no low-level reset
> +  is performed and EH assumes that an ATA class device is connected through the
> +  link.
>  
>  ::
>  
> -- 
> 2.50.1
> 

Reviewed-by: Niklas Cassel <cassel@kernel.org>
