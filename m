Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cnz5WcC/"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C971193
	for <linux-scsi@vger.kernel.org>; Wed,  6 Dec 2023 11:12:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701889922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rdbwGcL3xfTd0SQ2ofmFtSrkLP5S7WJXgHm5WJg2yPQ=;
	b=cnz5WcC/E+Kms3dMzdbj2lWe9MpSkHPS41jRlOwlo8OurAzn8CX+4iVQZtEtcZjcwD+L+T
	Jj417DA2x3CjDvOh8BuI76EhNySxJczV6998pGs5NsJRAktftaxHNqSF33+niPEXB8aho/
	joR5WixXrR6+h1XqZzjpdXEaSd1uGCM=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-19-P17tBH94O1qjhetxSS91yA-1; Wed, 06 Dec 2023 13:43:43 -0500
X-MC-Unique: P17tBH94O1qjhetxSS91yA-1
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-58d95645871so80808eaf.1
        for <linux-scsi@vger.kernel.org>; Wed, 06 Dec 2023 10:43:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701888214; x=1702493014;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rdbwGcL3xfTd0SQ2ofmFtSrkLP5S7WJXgHm5WJg2yPQ=;
        b=Swv+uLJMMoSSmVIf4rYTQDfgRT8ul6N3ZQv+AaBTLte9tKkW3gl98M3QhrqC3ba3KP
         FzU7Qjo3NffwM3OfRUBpa9pHpGVaQicgioTdqL9awgOOwcdtvNFo69MEvdMcn8VyAqZh
         Gk9C+k7HTKqcBeqRjEHwzHipCl6CwEnctpBjk+MNx6GHo9dM6Ye9gUExU7+JIbOk1P/p
         0echIKmTLgPrLRyO4XTY2/Lmghz712fZd/u4QCoLINQslJ4bd1I2FDIFBNsgVd0K5U/w
         mAKZK1m3OasOR3ZmAut4BrSVagevzherswNY6fCUmqTBLPQ4Mz5CqfHIwn2MVszVjvxz
         pzMg==
X-Gm-Message-State: AOJu0Yyrv5i2stbRAS3W7zNDWRSMQ4m7hOvgHd2D7TXP0UecKU6KTThL
	vapcfO6jD3C7W5qy8eJfrndFq/1tUeoamHJbjABR1km4Hnd4AZoJk/opGG3Qvmmnu2lCNF4KE+t
	MjAxyBm8RWpLPNyZByVqw1A==
X-Received: by 2002:a05:6358:91a6:b0:16d:aead:f74f with SMTP id j38-20020a05635891a600b0016daeadf74fmr894779rwa.13.1701888214070;
        Wed, 06 Dec 2023 10:43:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFZve0jDN+whXG9Fyrygjtk5nDhHS4D1oiR1nOY5YrJFkYaAmPCNcVIlXYPMaf+xGLMIHTxNQ==
X-Received: by 2002:a05:6358:91a6:b0:16d:aead:f74f with SMTP id j38-20020a05635891a600b0016daeadf74fmr894768rwa.13.1701888213764;
        Wed, 06 Dec 2023 10:43:33 -0800 (PST)
Received: from fedora ([2600:1700:1ff0:d0e0::47])
        by smtp.gmail.com with ESMTPSA id bz6-20020ad44c06000000b0067a2a621fadsm183188qvb.53.2023.12.06.10.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 10:43:33 -0800 (PST)
Date: Wed, 6 Dec 2023 12:43:31 -0600
From: Andrew Halaney <ahalaney@redhat.com>
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: martin.petersen@oracle.com, jejb@linux.ibm.com, andersson@kernel.org, 
	konrad.dybcio@linaro.org, linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, quic_cang@quicinc.com
Subject: Re: [PATCH 08/13] scsi: ufs: qcom: Check the return value of
 ufs_qcom_power_up_sequence()
Message-ID: <7ch3mroun3pnaxpej4orlukotdrrnzdkuts6rzjruk4hghtira@x7txcjve56wb>
References: <20231201151417.65500-1-manivannan.sadhasivam@linaro.org>
 <20231201151417.65500-9-manivannan.sadhasivam@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231201151417.65500-9-manivannan.sadhasivam@linaro.org>

On Fri, Dec 01, 2023 at 08:44:12PM +0530, Manivannan Sadhasivam wrote:
> If ufs_qcom_power_up_sequence() fails, then it makes no sense to enable
> the lane clocks and continue ufshcd_hba_enable(). So let's check the return
> value of ufs_qcom_power_up_sequence().
> 
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Reviewed-by: Andrew Halaney <ahalaney@redhat.com>

> ---
>  drivers/ufs/host/ufs-qcom.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 4948dd732aae..e4dd3777a4d4 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -415,7 +415,10 @@ static int ufs_qcom_hce_enable_notify(struct ufs_hba *hba,
>  
>  	switch (status) {
>  	case PRE_CHANGE:
> -		ufs_qcom_power_up_sequence(hba);
> +		err = ufs_qcom_power_up_sequence(hba);
> +		if (err)
> +			return err;
> +
>  		/*
>  		 * The PHY PLL output is the source of tx/rx lane symbol
>  		 * clocks, hence, enable the lane clocks only after PHY
> -- 
> 2.25.1
> 
> 

