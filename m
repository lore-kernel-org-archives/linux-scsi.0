Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE2D3C4320A
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 09:08:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5B0660F11
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 09:08:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbhGZI1u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jul 2021 04:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231728AbhGZI1t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jul 2021 04:27:49 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C980C061757;
        Mon, 26 Jul 2021 02:08:17 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id p5so5053480wro.7;
        Mon, 26 Jul 2021 02:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=6UidWeNxrSOnDZ0KCptBo1G225rSq/x688dX5SrFaco=;
        b=ONEyqEtSpNYp+pRUEUwgwnhaIXVYLQCZrspZUTHkrcLzJyyZBE3Mbe/lKEb1sR9pyy
         iiqBs1s4TlZW5VIAo1ezCssb1Ar4nPleMlbJLVM3voAIRQ1AaL+ePWqPy7gWa5vL7x2r
         GLMdxFEbZNb43J2xInxIicfgqhNnevOEnRz5bQtEXIbGp88PYjwcYuAQaYGIcpvBJfpx
         eF1A0agd8B1kS2COEoqT7S5G5yX1C89PZA6MTMgpyIIDxCfCcaTrLPm0rxtyM3XEoT3d
         xzDuXoh7NTaP5NzXwD52dTs81Sqj/iaoQo0M2OY1Oo+VGWSTOG+GP7D5xPFbFTK4rUc1
         ydEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=6UidWeNxrSOnDZ0KCptBo1G225rSq/x688dX5SrFaco=;
        b=duj8LxKo3kAImoZTygzVXk97nmV+G7rqxM5eV4qNd+9FXXuMLDUMze78ACf2P5u2IX
         JHCm7l5MJM75EmZMVy++txuAMQGc2xMgKIBQEEJ2p3tWQk+qEaZ+Sb9myhzfWlHg28i2
         c624SzWK6MUS7T5y0kW/inC0uV1kzAFpTLNjIFBT6UMbGLjy+CYnECTXZEcpcBySyAka
         kMBnt0lYUGle/lY8Znt17Uw6VyyqBROP4MGJ0A++UGfuOBJDP8IAveAatBm4NQqrb7CB
         QUspUuzp/nXbuWIuwe6bbZGyo4X5ohKXJhL7WBj7+0dDR60d9khSfJrzv3tbnB16SYaJ
         DFnA==
X-Gm-Message-State: AOAM531Kymeivg7/aF0L7Av2YJjcPzz/VAYVfLyvCHI1kFf5rxr+W+GY
        ZVzEtvYtnirq4ZdinCIBdvIYJyCxzg4=
X-Google-Smtp-Source: ABdhPJwo060IhxjxrnRMeqN5imtTDU0SxGtk/wK5MOX4baA2kNq9DK+uBnJ5vxtAApN+UD+ObVRtCg==
X-Received: by 2002:a5d:4c87:: with SMTP id z7mr18055261wrs.405.1627290496226;
        Mon, 26 Jul 2021 02:08:16 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bec25.dynamic.kabel-deutschland.de. [95.91.236.37])
        by smtp.googlemail.com with ESMTPSA id i5sm5923319wrw.13.2021.07.26.02.08.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 02:08:15 -0700 (PDT)
Message-ID: <2b4f4e6d76cdc517843fe8880312541c754d5352.camel@gmail.com>
Subject: Re: [PATCH v2 14/15] scsi: ufs: ufs-exynos: multi-host
 configuration for exynosauto
From:   Bean Huo <huobean@gmail.com>
To:     Chanho Park <chanho61.park@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Can Guo <cang@codeaurora.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Bart Van Assche <bvanassche@acm.org>,
        jongmin jeong <jjmin.jeong@samsung.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org
Date:   Mon, 26 Jul 2021 11:08:14 +0200
In-Reply-To: <20210714071131.101204-15-chanho61.park@samsung.com>
References: <20210714071131.101204-1-chanho61.park@samsung.com>
         <CGME20210714071200epcas2p3f76e68f6bbb4755574dba2055a8130ab@epcas2p3.samsung.com>
         <20210714071131.101204-15-chanho61.park@samsung.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-07-14 at 16:11 +0900, Chanho Park wrote:
> UFS controller of ExynosAuto v9 SoC supports multi-host interface for
> I/O
> 
> virtualization. In general, we're using para-virtualized driver to
> 
> support a block device by several virtual machines. However, it
> should
> 
> be relayed by backend driver. Multi-host functionality extends the
> host
> 
> controller by providing register interfaces that can be used by each
> 
> VM's ufs drivers respectively. By this, we can provide direct access
> to
> 
> the UFS device for multiple VMs. It's similar with SR-IOV of PCIe.
> 

Hi Chanho Park,
very inteseted in this patch. you mentined SR-IOV. In order to make
your patch work on the UFS, does UFS device side need changes?

or the common current 3.1 UFS can work with this new controller?

 

> 
> 
> We divide this M-HCI as PH(Physical Host) and VHs(Virtual Host). The
> PH
> 
> supports all UFSHCI functions(all SAPs) same as conventional UFSHCI
> but
> 
> the VH only supports data transfer function. Thus, except UTP_CMD_SAP
> and
> 
> UTP_TMPSAP, the PH should handle all the physical features.
> 
> 
> 
> This patch provides an initial implementation of PH part. M-HCI can
> 
> support up to four interfaces but this patch initially supports only
> 1
> 
> PH and 1 VH. For this, we uses TASK_TAG[7:5] field so TASK_TAG[4:0]
> for
> 
> 32 doorbel will be supported. After the PH is initiated, this will
> send


I don't understand here.  how many doorbell registers you have now?
and doesn VHs have a doorbell register also? and each doorbell register
still supprts 32 tags?

Kind regards
Beab



