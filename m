Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 370E2C41513
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Oct 2023 07:40:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377957AbjJLHkO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Oct 2023 03:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235322AbjJLHkM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Oct 2023 03:40:12 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E13C6
        for <linux-scsi@vger.kernel.org>; Thu, 12 Oct 2023 00:40:10 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-690f7bf73ddso530277b3a.2
        for <linux-scsi@vger.kernel.org>; Thu, 12 Oct 2023 00:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1697096409; x=1697701209; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=t0g3CHLupMrDhHkMlK6gfozlJQHBhX7jZYJ+e0keXWk=;
        b=HDtVHuCftKxdgE/BPt0LBE9bFa1rKgr8eVqNClDcuKPHzaslCm+Yt5KQSaicOIhuCx
         eq38bVojnj8VO69LgmZHEtJOY1djbZjOc/q7bRtS+xfb/ZOTtplBA2EQFp6iaULa/vqJ
         SFnEOajDtrMUMld4MOjWyDtnKwwK+NkOzxi5tpSzueiHA9/D17qJ6POm/bYbavYodpRt
         ypx5ns3frbzKMY6F3SDi/mh25/xZdmKtUW12WdpzT93T+wLYNdVSJvP0RsndMnJmzbLi
         mR5eJvSJ8CfCNZsHqZdNwZ9CRnv7PD8znJlUvBhOnPHvpqkvCvfDLJQB/X+mE6XvqqnI
         EfVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697096409; x=1697701209;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t0g3CHLupMrDhHkMlK6gfozlJQHBhX7jZYJ+e0keXWk=;
        b=CBURkhsNsr9BjLaLNGGQZ9jP+OefZJKtFIxfLqyp0LD1JIduOPR7MFDD961JxOEkhP
         T36pU1oZKlrRHTlm/A8CyKKMoJBGFjqJ3AlhPLEllyb6CdySOu4eYq0pmy1IxqZQbfv3
         0q0hzRZDrykWQSm050cJKt6g9CbN27F8t3s7aOMVixdHBYxN1Bs6Opjm8Sba5P+2j7/2
         TMqnvhnvhUtCIwMgHbU3vHt81jn5wuOe1wrC1b8uvgE5iMGH+SpZHCEe1op+BjkSwJ6K
         NVDmmUOq2mSQjtRh6LffNv0hwD4tfMr+8Q6Wet7UE2BL+QfL4h07h3WtfcDoqETCC+bk
         a31g==
X-Gm-Message-State: AOJu0YzeOhTaN8QG4F6N+jIfz1UGc2GCOmF9FXrUWq6W43OJruujdWC4
        qj+/kOFtskMe7YmfVYAZvTfF6TuBDtfKrgPjYg==
X-Google-Smtp-Source: AGHT+IH0EXGX3kM6pYUNayPRavDSGKGosRNmNjQtofu1wwryxdfzHLf8UxV8MNlsKoohZ4oxr897Hg==
X-Received: by 2002:aa7:88ca:0:b0:68e:2af1:b193 with SMTP id k10-20020aa788ca000000b0068e2af1b193mr24429012pff.28.1697096409579;
        Thu, 12 Oct 2023 00:40:09 -0700 (PDT)
Received: from thinkpad ([120.138.12.180])
        by smtp.gmail.com with ESMTPSA id y12-20020a056a001c8c00b006a77343b0ccsm4896434pfw.89.2023.10.12.00.39.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Oct 2023 00:40:08 -0700 (PDT)
Date:   Thu, 12 Oct 2023 13:09:55 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     "Alessandro Carminati (Red Hat)" <alessandro.carminati@gmail.com>
Cc:     alim.akhtar@samsung.com, andersson@kernel.org, avri.altman@wdc.com,
        bmasney@redhat.com, bvanassche@acm.org, conor+dt@kernel.org,
        cw00.choi@samsung.com, devicetree@vger.kernel.org,
        jejb@linux.ibm.com, konrad.dybcio@linaro.org,
        krzysztof.kozlowski+dt@linaro.org, krzysztof.kozlowski@linaro.org,
        kyungmin.park@samsung.com, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        myungjoo.ham@samsung.com, nm@ti.com, quic_asutoshd@quicinc.com,
        quic_bhaskarv@quicinc.com, quic_cang@quicinc.com,
        quic_narepall@quicinc.com, quic_nguyenb@quicinc.com,
        quic_nitirawa@quicinc.com, quic_richardp@quicinc.com,
        quic_ziqichen@quicinc.com, robh+dt@kernel.org, sboyd@kernel.org,
        vireshk@kernel.org
Subject: Re: [PATCH] scsi: ufs: core: Fix build error: ufshcd_opp_config_clks
Message-ID: <20231012073955.GA14957@thinkpad>
References: <20231011122543.11922-4-manivannan.sadhasivam@linaro.org>
 <20231012072051.1517826-1-alessandro.carminati@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231012072051.1517826-1-alessandro.carminati@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 12, 2023 at 07:20:51AM +0000, Alessandro Carminati (Red Hat) wrote:
> Building linux-6.6-rc3 with this patchset applied and the following
> configuration:
> 
> CONFIG_SCSI_UFSHCD=m
> CONFIG_SCSI_UFS_BSG=y
> 
> I got:
> 
>    scripts/mod/modpost -M -m -a      -o Module.symvers -T modules.order vmlinux.o
> ERROR: modpost: "ufshcd_opp_config_clks" [drivers/ufs/host/ufshcd-pltfrm.ko] undefined!
> make[2]: *** [scripts/Makefile.modpost:145: Module.symvers] Error 1
> make[1]: *** [/home/alessandro/src/linux-6.6-rc3/Makefile:1865: modpost] Error 2
> make: *** [Makefile:234: __sub-make] Error 2
> 
> I needed to add an export symbol to have the build complete
> 
> Signed-off-by: Alessandro Carminati (Red Hat) <alessandro.carminati@gmail.com>

Thanks for the diff. I will squash it with the offending patch.

- Mani

> ---
>  drivers/ufs/core/ufshcd.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index ccd7fcd18355..c0631c37c3d1 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -1098,6 +1098,7 @@ int ufshcd_opp_config_clks(struct device *dev, struct opp_table *opp_table,
>  
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(ufshcd_opp_config_clks);
>  
>  static int ufshcd_opp_set_rate(struct ufs_hba *hba, unsigned long freq)
>  {
> -- 
> 2.34.1
> 

-- 
மணிவண்ணன் சதாசிவம்
