Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3C31E898
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jul 2024 05:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720501383; cv=none; b=DW9Q8H+GKDggMYY6UEct/qGhxJSit4TkjjTNcHBVb9Q//Nd+rvTEjbI2caEKCxhU78xqeJn/OfcZeXF+9TbNNCkJ9HNl3qznJAriTkBL88otW5Q0DmfTJ1LVHI04yk4LrR8OUWjaRhpUJgESBngRo0aOBADyl40lW+njK7g2RsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720501383; c=relaxed/simple;
	bh=bY2MByXGAwE9Wt+hsowhOhkV6iAF1+Y48RwcKCFCmts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WEzTt2jzxeqOyTYByM7VL1uQYbAOkyaHejOOmIBVgt5p9eCcHGLBL/JNik5Xbc+x8+ISSWCFkUOlKYo7LjyhB/oHBDucrbqg9DDEqj250xTvzV+3kHxpXTIzmutYYKF+aVOk6T0aq5CYOTqopelcABAWCvrHQDoTwRRk+XBRLAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DwWh6aQb; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DwWh6aQb"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-70b07bdbfbcso2728591b3a.0
        for <linux-scsi@vger.kernel.org>; Mon, 08 Jul 2024 22:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720501381; x=1721106181; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9IFriyQEONdxZVke0K4jyLQbUlfTpngU6JSaJ4ronAU=;
        b=DwWh6aQbfwfNWxKgqPxaJ6FQ2nunnDGqHIK+wRiSRzzDMJSKs0MfCFS3NyL9G6dPJZ
         NBNcejZXh7lbIMB0ILfhle7atFfrzFLu+ooxCRoGAtIhjeIkL/QAv4HhHoGZr0U7/vRg
         aO1lMsMF4WEGXtjX8bpVJQ2q01MfhVjEQle9nF31J7R62RIJGxdZaonsyaD4gpthjaEv
         PZRlgWDIBKCPmvk/2RoTda9fdXlWG0asP5vpfUl74FUFuwNPmgOFbN2QoOOxNwAJQBuY
         2mklk5LdJ/IteSxDSICnV7pOLXQOgdmEmZdfZqcGsAknVnx0SYaENOjz5i5Myrj+5uFE
         INSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720501381; x=1721106181;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9IFriyQEONdxZVke0K4jyLQbUlfTpngU6JSaJ4ronAU=;
        b=MXPugmUgqEzy1jHKVf2J6myGCmAvjIiLn+I+FByZm4s4HhqaH5xnqDD+/Y3xY4SBPZ
         KA74szivIxx1KO9YFagpJvzIgTFEb0nZvkCI3gfelirsJj3XsnXG2klBD1oBajmtkejh
         0CSzlmOdqLmaK8UZTxNvD2YL/0xmRpbD/yL1Z3bdOvuSRRDG0La+WaU1SySEzutKdJST
         3VHqtn/n6Gizg85BvAlHUsXD/2i/ccjDPGgMsP+Z2i5EAvg6pzdz30Ww5dtHIqhqHjzJ
         XJ3GyInDyTe0fqvQgt+id4PI2l9nePua1QEfzn7n50o2++jJDxJjgxQ0Cd9J2eYUsX4M
         HrtA==
X-Forwarded-Encrypted: i=1; AJvYcCU3Shp/pABuhlBpmhNvG/Ly2H4/+ooN0yAZl9YtQhXvir11NHcWin+Hmw9qbFc3mlQh212Rm2NbRhgEUNjDkTfdIp4tyZa5T8oHxg==
X-Gm-Message-State: AOJu0YzOtq2VqTLoUZEpGAdLuzWhZnCHaEFbQt93EHcfT09tyeePksQT
	aY9BVFGb4Mh48J7HhkTCoTjGkKha5ELZ07ycr5SmoQrbqiKHolxR2OYv/PfvEQ==
X-Google-Smtp-Source: AGHT+IHdsOxPitSwTy17HULGlKHfCFH5GtOmBWcmFcvIjW8ZFj3mBQyxbejeuZYp4KAJIivxxkusYQ==
X-Received: by 2002:a05:6a20:2d06:b0:1c0:f114:100c with SMTP id adf61e73a8af0-1c298c46d2emr1617937637.17.1720501381319;
        Mon, 08 Jul 2024 22:03:01 -0700 (PDT)
Received: from thinkpad ([117.193.209.237])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b439e95afsm788259b3a.210.2024.07.08.22.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jul 2024 22:03:00 -0700 (PDT)
Date: Tue, 9 Jul 2024 10:32:49 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, peter.wang@mediatek.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: Re: [PATCH v5 01/10] scsi: ufs: Declare functions once
Message-ID: <20240709050249.GA3820@thinkpad>
References: <20240708211716.2827751-1-bvanassche@acm.org>
 <20240708211716.2827751-2-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240708211716.2827751-2-bvanassche@acm.org>

On Mon, Jul 08, 2024 at 02:15:56PM -0700, Bart Van Assche wrote:
> Several functions are declared in include/ufs/ufshcd.h and also in
> drivers/ufs/core/ufshcd-priv.h. Remove the duplicate declarations.
> 
> Reviewed-by: Peter Wang <peter.wang@mediatek.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

- Mani

> ---
>  drivers/ufs/core/ufshcd-priv.h | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
> index f42d99ce5bf1..668748477e6e 100644
> --- a/drivers/ufs/core/ufshcd-priv.h
> +++ b/drivers/ufs/core/ufshcd-priv.h
> @@ -66,14 +66,8 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
>  int ufshcd_mcq_init(struct ufs_hba *hba);
>  int ufshcd_mcq_decide_queue_depth(struct ufs_hba *hba);
>  int ufshcd_mcq_memory_alloc(struct ufs_hba *hba);
> -void ufshcd_mcq_make_queues_operational(struct ufs_hba *hba);
> -void ufshcd_mcq_config_mac(struct ufs_hba *hba, u32 max_active_cmds);
> -u32 ufshcd_mcq_read_cqis(struct ufs_hba *hba, int i);
> -void ufshcd_mcq_write_cqis(struct ufs_hba *hba, u32 val, int i);
>  struct ufs_hw_queue *ufshcd_mcq_req_to_hwq(struct ufs_hba *hba,
>  					   struct request *req);
> -unsigned long ufshcd_mcq_poll_cqe_lock(struct ufs_hba *hba,
> -				       struct ufs_hw_queue *hwq);
>  void ufshcd_mcq_compl_all_cqes_lock(struct ufs_hba *hba,
>  				    struct ufs_hw_queue *hwq);
>  bool ufshcd_cmd_inflight(struct scsi_cmnd *cmd);

-- 
மணிவண்ணன் சதாசிவம்
