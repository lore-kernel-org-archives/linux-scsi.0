Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E371DE4E1
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jul 2025 21:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752787260; cv=none; b=B29Ao7gJoPEwQmtwWB8THGENUOpmRuiw5HR/zbAL9fWuPoiiAGQ9SJlSqhk2gZg0E58yD1gqaLQahD/rA7YXpZSUndgIFpFd+mWtPZ70x33y+YzSdqpRCVqh7s+4uY6WTj7t7eXJp2+aY1YPAnGVSl942RVWYdErKe/opFrKn6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752787260; c=relaxed/simple;
	bh=HxRVKnitatRg6kY1yNh/+gBFqyw9hDEXlQ3zTvnKH7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TdNxVhRbPWag7tHtLBejjtncbPquzNQGE+QOQTS1oQYb7XUtXbePVNH613a/pvd1xJgcNdClY0pxGhu8x4vee0oScJ9oX5BPs8Gnio9VMUYUs9QxVuV5g7CxWJFxBIH4IwRAVKXVnr9NdLcsuGLQbrx0JsZxtbTFj+OSI/aSgqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HEw4Kn7d; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HEw4Kn7d"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-237f18108d2so66515ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 17 Jul 2025 14:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752787258; x=1753392058; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LF8Zzpj6KYH7xf5BL6A0j7kHYUrScRFun1TpiQCzfHs=;
        b=HEw4Kn7dhLJwcvrS9p0HJtxMVrjj9oi9ODwZ9hIMfeW8WqPTtyTPEgDAhp/ZPzeoNN
         AUWJeJEf7my0bpD9dqG98HO38IK4erhGUwW+zBa9j4cODlizsQ8JNcWavMTltvhDwXOu
         Kk8lCW7o9H7RW+OgrkwOENAYlE8s023uIwS0rgdGA2g/VkxFsNCFuePbWgFdfSBWJsUV
         e35KT1u+43hskv9OL5DkiI1q5XoyfdKTfD4bIoQZmoXtUJUP+ZTkAMpkqd1b9GGeJyA9
         CdNNEK9EZePsPxvrFvWXJ995Zx4gqZumi4hcHYKkMLf9P5udTBsl8/VPuBX+f/5aDoO3
         o7Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752787258; x=1753392058;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LF8Zzpj6KYH7xf5BL6A0j7kHYUrScRFun1TpiQCzfHs=;
        b=EjVOhG2wByv5NHhZeN+JGG10VQ3HFt+qaxmzboNaNEwnekKM+YE925hMGpIIjXqQPP
         dxpHpLrKHhoMQz9BM0FpVrK4puahYbntL12lPwOdBwR7mOnEBbTLfS9vp2xFYxEiqVXk
         rmgbJog1AzndQpkzTOOfZlv0WZiZmcZQc+Oj8xZvzZtFWs7OWB8hEGl+fpDIC+q0r4zr
         LVPBzSNESKg17qv7v8XLn8ULFoIrKzifdd/9GrFn5tVDH3efBKnV814AxvibZpYJ+Yks
         O6ROv6XEnkZU/C8hbzZMbDMy3bCZxRsDIB89v2sZxPb1wFea5t6ERzcGiBQNmvpcmGD/
         GbPg==
X-Forwarded-Encrypted: i=1; AJvYcCWjIrHvOjcZcdkTtXF0XNQS5I9pTwvqHfjy9+pKKmGsVeQ4UUZloHojwmmjo1i+lqjWCSExQV6lcsiH@vger.kernel.org
X-Gm-Message-State: AOJu0YxBsYOiQ5AguYWMRStK8KFBGRZw44mvMw6uOtuxnC7h/YEyDt9B
	6k8grR4txozWMzwWowN6yfYIGv2vY418POS9Jr8e+qYACZSsGo10djdjFjJY2lfDqA==
X-Gm-Gg: ASbGnctWJYqSjiqq2FzYcqkGXTmmagGv7rWhLS0YFsrL6nikn5Ceg0s3QZE9MKdFyrH
	1pCp4MW9xyTyhCjYrKxIL3GNpc9n4kP7bcVP7tSTN9JNL5vxzY9YIojxcPnzuF43kfLSa1M+HmB
	rmvVexYGixTjBrsfxuH9ynttDwLqIVMl6O699pWffwAam18Vky54QmrxZIRnlrBZiZCIu3yOeZq
	deNzHm5fL0Rnj8mZBatGj8aK03R468KhTkgt3++yCGeU4w61qxr0Wx7P+0QXOiLB1Irx49MFve2
	NjYlfMWD703I0tgUXOJW/y47o33bdSDd5WDulng/q51Tiq+I8dRQA2mHyihcbdG+w766QPHc1H5
	TLfYIEwNj/X+A26EhDP7s5QLdRXvev5ylynvZ/Cm11L4nySd/N10sgT68sw==
X-Google-Smtp-Source: AGHT+IF9JQfmADzl+Yq5vOlNEmJRowbAGu9G80Xz/lb3PmvRmlfsC2hTGqxbszpg2qyxtRnG1JUYnA==
X-Received: by 2002:a17:903:2388:b0:234:b441:4d4c with SMTP id d9443c01a7336-23e39227e02mr1184965ad.5.1752787258108;
        Thu, 17 Jul 2025 14:20:58 -0700 (PDT)
Received: from google.com (166.68.83.34.bc.googleusercontent.com. [34.83.68.166])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23e3b6ef9aesm1037625ad.211.2025.07.17.14.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jul 2025 14:20:57 -0700 (PDT)
Date: Thu, 17 Jul 2025 14:20:53 -0700
From: Igor Pylypiv <ipylypiv@google.com>
To: Niklas Cassel <cassel@kernel.org>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Terrence Adams <tadamsjr@google.com>,
	Damien Le Moal <dlemoal@kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] Revert "scsi: pm80xx: Do not use libsas port ID"
Message-ID: <aHlpNRsPbmrTgv0O@google.com>
References: <20250717165606.3099208-2-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250717165606.3099208-2-cassel@kernel.org>

On Thu, Jul 17, 2025 at 06:56:07PM +0200, Niklas Cassel wrote:
> This reverts commit 0f630c58e31afb3dc2373bc1126b555f4b480bb2.
> 
> Commit 0f630c58e31a ("scsi: pm80xx: Do not use libsas port ID") causes
> drives behind a SAS enclosure (which is connected to one of the ports
> on the HBA) to no longer be detected.
> 
> Connecting the drives directly to the HBA still works. Thus, the commit
> only broke the detection of drives behind a SAS enclosure.
> 
> Reverting the commit makes the drives behind the SAS enclosure to be
> detected once again.
> 
> The commit log of the offending commit is quite vague, but mentions that:
> "Remove sas_find_local_port_id(). We can use pm8001_ha->phy[phy_id].port
> to get the port ID."
> 
> This assumption appears false, thus revert the offending commit.

Thanks for bisecting and reverting the commit, Niklas!

Let me review the changes and send a proper fix that takes into account
drives behind a SAS enclosure. I would appretiate if you could test that
new fix since I don't have a setup with a SAS enclosure.

Thank you,
Igor

> 
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Reviewed-by: Igor Pylypiv <ipylypiv@google.com>

> ---
> dmesg after the offending commit, in case anyone is interested:
> pm80xx0:: pm80xx_chip_phy_start_req 4641: PHY START REQ for phy_id 2
> pm80xx0:: mpi_phy_start_resp 3340: phy start resp status:0x0, phyid:0x2
> pm80xx0:: pm80xx_chip_phy_start_req 4641: PHY START REQ for phy_id 3
> pm80xx0:: mpi_phy_start_resp 3340: phy start resp status:0x0, phyid:0x3
> pm80xx0:: pm80xx_chip_phy_start_req 4641: PHY START REQ for phy_id 4
> pm80xx0:: mpi_phy_start_resp 3340: phy start resp status:0x0, phyid:0x4
> pm80xx0:: mpi_hw_event 3417: HW_EVENT_SAS_PHY_UP phyid:0x4 port_id:0x0
> sas: phy-11:4 added to port-11:0, phy_mask:0x10 (50015b21409aefbf)
> sas: DOING DISCOVERY on port 0, pid:215
> pm80xx0:: pm80xx_chip_reg_dev_req 4742: register device req phy_id 0x0 port_id 0x0
> pm80xx0:: pm8001_mpi_reg_resp 3309: register device status 0 phy_id 0x0 device_id 16385
> sas: executing SMP task failed:-19
> sas: RG to ex 50015b21409aefbf failed:0xffffffed
> pm80xx0:: pm8001_chip_dereg_dev_req 4226: unregister device device_id 16385
> sas: DONE DISCOVERY on port 0, pid:215, result:-19
> pm80xx0:: pm80xx_chip_phy_start_req 4641: PHY START REQ for phy_id 5
> pm80xx0:: mpi_phy_start_resp 3340: phy start resp status:0x0, phyid:0x5
> pm80xx0:: mpi_hw_event 3417: HW_EVENT_SAS_PHY_UP phyid:0x5 port_id:0x0
> sas: phy5 matched wide port0
> sas: phy-11:5 added to port-11:0, phy_mask:0x30 (50015b21409aefbf)
> sas: DOING DISCOVERY on port 0, pid:277
> pm80xx0:: pm80xx_chip_reg_dev_req 4742: register device req phy_id 0x0 port_id 0x0
> pm80xx0:: pm8001_mpi_reg_resp 3309: register device status 0 phy_id 0x0 device_id 16386
> sas: executing SMP task failed:-19
> sas: RG to ex 50015b21409aefbf failed:0xffffffed
> pm80xx0:: pm8001_chip_dereg_dev_req 4226: unregister device device_id 16386
> sas: DONE DISCOVERY on port 0, pid:277, result:-19
> pm80xx0:: pm80xx_chip_phy_start_req 4641: PHY START REQ for phy_id 6
> pm80xx0:: mpi_phy_start_resp 3340: phy start resp status:0x0, phyid:0x6
> pm80xx0:: mpi_hw_event 3417: HW_EVENT_SAS_PHY_UP phyid:0x6 port_id:0x0
> sas: phy6 matched wide port0
> sas: phy-11:6 added to port-11:0, phy_mask:0x70 (50015b21409aefbf)
> sas: DOING DISCOVERY on port 0, pid:277
> pm80xx0:: pm80xx_chip_reg_dev_req 4742: register device req phy_id 0x0 port_id 0x0
> pm80xx0:: pm8001_mpi_reg_resp 3309: register device status 0 phy_id 0x0 device_id 16387
> sas: executing SMP task failed:-19
> sas: RG to ex 50015b21409aefbf failed:0xffffffed
> pm80xx0:: pm8001_chip_dereg_dev_req 4226: unregister device device_id 16387
> sas: DONE DISCOVERY on port 0, pid:277, result:-19
> pm80xx0:: pm80xx_chip_phy_start_req 4641: PHY START REQ for phy_id 7
> pm80xx0:: mpi_phy_start_resp 3340: phy start resp status:0x0, phyid:0x7
> pm80xx0:: mpi_hw_event 3417: HW_EVENT_SAS_PHY_UP phyid:0x7 port_id:0x0
> sas: phy7 matched wide port0
> sas: phy-11:7 added to port-11:0, phy_mask:0xf0 (50015b21409aefbf)
> sas: DOING DISCOVERY on port 0, pid:215
> pm80xx0:: pm80xx_chip_reg_dev_req 4742: register device req phy_id 0x0 port_id 0x0
> pm80xx0:: pm8001_mpi_reg_resp 3309: register device status 0 phy_id 0x0 device_id 16388
> sas: executing SMP task failed:-19
> sas: RG to ex 50015b21409aefbf failed:0xffffffed
> pm80xx0:: pm8001_chip_dereg_dev_req 4226: unregister device device_id 16388
> sas: DONE DISCOVERY on port 0, pid:215, result:-19
> 
>  drivers/scsi/pm8001/pm8001_sas.c | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index f7067878b34f..8cfdfb77d9b0 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -431,6 +431,23 @@ static int pm8001_task_prep_ssp(struct pm8001_hba_info *pm8001_ha,
>  	return PM8001_CHIP_DISP->ssp_io_req(pm8001_ha, ccb);
>  }
>  
> + /* Find the local port id that's attached to this device */
> +static int sas_find_local_port_id(struct domain_device *dev)
> +{
> +	struct domain_device *pdev = dev->parent;
> +
> +	/* Directly attached device */
> +	if (!pdev)
> +		return dev->port->id;
> +	while (pdev) {
> +		struct domain_device *pdev_p = pdev->parent;
> +		if (!pdev_p)
> +			return pdev->port->id;
> +		pdev = pdev->parent;
> +	}
> +	return 0;
> +}
> +
>  #define DEV_IS_GONE(pm8001_dev)	\
>  	((!pm8001_dev || (pm8001_dev->dev_type == SAS_PHY_UNUSED)))
>  
> @@ -503,10 +520,10 @@ int pm8001_queue_command(struct sas_task *task, gfp_t gfp_flags)
>  	spin_lock_irqsave(&pm8001_ha->lock, flags);
>  
>  	pm8001_dev = dev->lldd_dev;
> -	port = pm8001_ha->phy[pm8001_dev->attached_phy].port;
> +	port = &pm8001_ha->port[sas_find_local_port_id(dev)];
>  
>  	if (!internal_abort &&
> -	    (DEV_IS_GONE(pm8001_dev) || !port || !port->port_attached)) {
> +	    (DEV_IS_GONE(pm8001_dev) || !port->port_attached)) {
>  		ts->resp = SAS_TASK_UNDELIVERED;
>  		ts->stat = SAS_PHY_DOWN;
>  		if (sas_protocol_ata(task_proto)) {
> -- 
> 2.50.1
> 
