Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gEeD8FPs"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF9B171F
	for <linux-scsi@vger.kernel.org>; Fri,  8 Dec 2023 12:39:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702067995;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BZ2jOncrEKw232jrvqkJsjD/GwaaXlY1Y1umyeZKqBI=;
	b=gEeD8FPsNnrR0QG/hwuQWxfEOa2yn5XOcuihrT4Wqh5461mqNbhBw7MsSAK/Di7O3di1I8
	/hIDIOaMzzem/pbEWm9A7mIKGh5YsEsB4SyFvhCfI3W4513i+YofKtDlnzHvRs4yvcC7rN
	To9m5FUc1K+Y5L359C9qkDteXaCJ5Bg=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-141-AVkcJ4hCMee6qLbT1TOzvQ-1; Fri, 08 Dec 2023 15:39:54 -0500
X-MC-Unique: AVkcJ4hCMee6qLbT1TOzvQ-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-77f2d95dedaso232808185a.0
        for <linux-scsi@vger.kernel.org>; Fri, 08 Dec 2023 12:39:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702067993; x=1702672793;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BZ2jOncrEKw232jrvqkJsjD/GwaaXlY1Y1umyeZKqBI=;
        b=vWAMoFNQg1zZyZTHJigtIehQ5fvjqpkAvwc950xjJk4qFuBzrwnJcJQSkkQNv6n9Vr
         ey0kvOt6KEHr0xPrJbXOg/e92N6aOI3d3ZgIDzi7aI/x8kvn4A30F0nuOoX9fdRHO33Y
         JUZ9+VES2DujPPF6cB0XQ+NTmZmuCtbbwYCAQ9ylpyf1wwbmnXr7SjALc/EnakEZbMel
         afjf3YBQyr8Fekb5bg8JY20lII1oV8QFmLJhhWaqDvHDBZZgQws0z0YUIjNAiitR+Cka
         KpZL8vkf3sneIH+NEHy8/hyOXG0P0RpOd7CFmSC6a9bcJG8TzWO8pinBsgC8bxPSBqUT
         97WA==
X-Gm-Message-State: AOJu0YwnNeGbHybc7JGZF6Qhxyv6Lt6a6sMp7ElK1Q6vyQpSe5lDTE8X
	Huis6SzvJmoACUmacCb6eo+2WbTvB6B7HuG8gTMF4ZN7m5BlBNOK1sZP6mAl6hW3CjLr58RnNbD
	1DuU6ltd1vFJC8mvAuPitXw==
X-Received: by 2002:a05:620a:4628:b0:77f:3b42:d9ce with SMTP id br40-20020a05620a462800b0077f3b42d9cemr760944qkb.85.1702067993657;
        Fri, 08 Dec 2023 12:39:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHKxCtQsMQxp/KSOFjCeDbaxYduu4LWKBh1Y0Dagd3wlsrQ4MNeu6AtBDd9TCnEjArfrpOATw==
X-Received: by 2002:a05:620a:4628:b0:77f:3b42:d9ce with SMTP id br40-20020a05620a462800b0077f3b42d9cemr760936qkb.85.1702067993423;
        Fri, 08 Dec 2023 12:39:53 -0800 (PST)
Received: from fedora ([2600:1700:1ff0:d0e0::47])
        by smtp.gmail.com with ESMTPSA id o1-20020a05620a228100b00775bb02893esm941499qkh.96.2023.12.08.12.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Dec 2023 12:39:52 -0800 (PST)
Date: Fri, 8 Dec 2023 14:39:50 -0600
From: Andrew Halaney <ahalaney@redhat.com>
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: martin.petersen@oracle.com, jejb@linux.ibm.com, andersson@kernel.org, 
	konrad.dybcio@linaro.org, linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, quic_cang@quicinc.com, quic_nitirawa@quicinc.com
Subject: Re: [PATCH v2 00/17] scsi: ufs: qcom: Code cleanups
Message-ID: <wimggq4gabqgjinxffx5dmaf6y34kf3q2r4wbcytd7s2pjabfu@hwlni6z7kpam>
References: <20231208065902.11006-1-manivannan.sadhasivam@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231208065902.11006-1-manivannan.sadhasivam@linaro.org>

On Fri, Dec 08, 2023 at 12:28:45PM +0530, Manivannan Sadhasivam wrote:
> Hello,
> 
> This series has code some cleanups to the Qcom UFS driver. No functional
> change. In this version, I've removed code supporting legacy controllers
> ver < 2.0, as the respective platforms were never supported in upstream.
> 
> Tested on: RB5 development board based on Qcom SM8250 SoC.
> 
> - Mani
> 
> Changes in v2:
> 
> * Collected review tags
> * Fixed the comments from Andrew
> * Added a few more patches, most notably one removing the code for old
>   controllers (ver < v2.0)
> 

I took this for a spin on sa8775p-ride when developing another patch
today with no issues. Certainly doesn't hit all the cases here, but:

Tested-by: Andrew Halaney <ahalaney@redhat.com> # sa8775p-ride

> Manivannan Sadhasivam (17):
>   scsi: ufs: qcom: Use clk_bulk APIs for managing lane clocks
>   scsi: ufs: qcom: Fix the return value of ufs_qcom_ice_program_key()
>   scsi: ufs: qcom: Fix the return value when
>     platform_get_resource_byname() fails
>   scsi: ufs: qcom: Remove superfluous variable assignments
>   scsi: ufs: qcom: Remove the warning message when core_reset is not
>     available
>   scsi: ufs: qcom: Export ufshcd_{enable/disable}_irq helpers and make
>     use of them
>   scsi: ufs: qcom: Fail ufs_qcom_power_up_sequence() when core_reset
>     fails
>   scsi: ufs: qcom: Check the return value of
>     ufs_qcom_power_up_sequence()
>   scsi: ufs: qcom: Remove redundant error print for devm_kzalloc()
>     failure
>   scsi: ufs: qcom: Use dev_err_probe() to simplify error handling of
>     devm_gpiod_get_optional()
>   scsi: ufs: qcom: Remove unused ufs_qcom_hosts struct array
>   scsi: ufs: qcom: Sort includes alphabetically
>   scsi: ufs: qcom: Initialize cycles_in_1us variable in
>     ufs_qcom_set_core_clk_ctrl()
>   scsi: ufs: qcom: Simplify ufs_qcom_{assert/deassert}_reset
>   scsi: ufs: qcom: Remove support for host controllers older than v2.0
>   scsi: ufs: qcom: Use ufshcd_rmwl() where applicable
>   scsi: ufs: qcom: Remove unused definitions
> 
>  drivers/ufs/core/ufshcd.c   |   6 +-
>  drivers/ufs/host/ufs-qcom.c | 377 +++++-------------------------------
>  drivers/ufs/host/ufs-qcom.h |  52 +----
>  include/ufs/ufshcd.h        |   2 +
>  4 files changed, 66 insertions(+), 371 deletions(-)
> 
> -- 
> 2.25.1
> 

