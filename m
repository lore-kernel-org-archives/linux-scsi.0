Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C189C001B0
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Aug 2023 06:11:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjHIGLb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Aug 2023 02:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbjHIGLa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Aug 2023 02:11:30 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E2E12D
        for <linux-scsi@vger.kernel.org>; Tue,  8 Aug 2023 23:11:29 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id d75a77b69052e-40fd2f6bd7cso46498141cf.1
        for <linux-scsi@vger.kernel.org>; Tue, 08 Aug 2023 23:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1691561488; x=1692166288;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7Ms7iYNp80/BrQPVd1Wu0NtDMidguJs1Vm+Kts8MPK0=;
        b=RN576sBAEe/LovR6mCDVhX2xoekgFTYj/fgTIaDKWa+LJB9YVfaWfR58VPB3BXSfdn
         v/IasQm7bVjAStbpq0fvSbuMSimHH0Sh0+aJRO4WPMG2xbo74qaecU9vEghc1H8e7e/E
         L7+FImW8W+0VI7PK6KDLQAXJFJ1PqBKHm627rByV8J+lXBQBNg3Ug276XTU1mRxv2hE0
         tZzp3a03Nge8nevSnfrH1qIm4I9dT2enkPmsen70nPaZvtrF9Kq+Y5LLA7fPTIzqWzDI
         ghDypxrPkJ6gW4zjyn86bKmWCuFeq6qw31tMwrfonZXKe0dgpPwGqrycTIng8mHtqEPr
         /lfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691561488; x=1692166288;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7Ms7iYNp80/BrQPVd1Wu0NtDMidguJs1Vm+Kts8MPK0=;
        b=kglNyCx0Hhept+R78rzJa8GLQNCZfrAWyzN7jyxuxgNpK+/6wWilnJxGoCqmD/txTS
         6rSXCkKKvTzMCZ18xn0ZlNe/RD6dGHu3kCI83Wwlk4xzZyVPfzmW7hyp0xinj8AxSYdi
         p9Ae6hCPdlOWRZvhhE//QPn5t1DDkScrVvgZPu8JHbh6/1qD4Ts8VI4NA7fc9NT+02Gm
         HlrF912WpsCVTfW51MvJ4P7tsAu4fkY7pfYpeghnYMhLU8rOOwLs4zd88w4OtcfjRfi2
         7K0FASCDWlDEV/LEryKb2hi5QexYkTWH/1cahORO9tEMKWOyNLlRil2NDQJqAhJNncPL
         CAjw==
X-Gm-Message-State: AOJu0YyT6NLGd+/QayO21ZO6rHe+XUwGYqj5nvpU2b/Tnbx9gIpr4hP9
        b8nWwnX6TbrGfMK+StvbU7k55P8PYS+aCI1pIg==
X-Google-Smtp-Source: AGHT+IHf87EZm3LQgNx9Ep7FX3BJm1QmcuWANPNoYzfIPWVmf7wCxsLgxKWucwlxNZlNYTQFLSRGFg==
X-Received: by 2002:a05:622a:170e:b0:403:9e72:5e93 with SMTP id h14-20020a05622a170e00b004039e725e93mr2579278qtk.9.1691561488321;
        Tue, 08 Aug 2023 23:11:28 -0700 (PDT)
Received: from thinkpad ([117.207.25.122])
        by smtp.gmail.com with ESMTPSA id o16-20020a0cf4d0000000b0063d385c28edsm4259014qvm.41.2023.08.08.23.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 23:11:27 -0700 (PDT)
Date:   Wed, 9 Aug 2023 11:41:21 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     kernel test robot <lkp@intel.com>
Cc:     oe-kbuild-all@lists.linux.dev, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [jejb-scsi:misc 36/37] drivers/ufs/host/ufs-qcom.c:64:3: sparse:
 sparse: symbol 'ufs_qcom_bw_table' was not declared. Should it be static?
Message-ID: <20230809061121.GB5348@thinkpad>
References: <202308091030.L5JrOBJB-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <202308091030.L5JrOBJB-lkp@intel.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 09, 2023 at 10:44:28AM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git misc
> head:   6cae9a3910ac1b5daf5ac3db9576b78cc4eff5aa
> commit: 03ce80a1bb869f735de793f04c9c085b61884599 [36/37] scsi: ufs: qcom: Add support for scaling interconnects
> config: arm64-randconfig-r071-20230808 (https://download.01.org/0day-ci/archive/20230809/202308091030.L5JrOBJB-lkp@intel.com/config)
> compiler: aarch64-linux-gcc (GCC) 12.3.0
> reproduce: (https://download.01.org/0day-ci/archive/20230809/202308091030.L5JrOBJB-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202308091030.L5JrOBJB-lkp@intel.com/
> 
> sparse warnings: (new ones prefixed by >>)
> >> drivers/ufs/host/ufs-qcom.c:64:3: sparse: sparse: symbol 'ufs_qcom_bw_table' was not declared. Should it be static?
> 

This is already taken care by https://lore.kernel.org/all/20230802040154.10652-1-manivannan.sadhasivam@linaro.org/

- Mani

> vim +/ufs_qcom_bw_table +64 drivers/ufs/host/ufs-qcom.c
> 
>     60	
>     61	struct __ufs_qcom_bw_table {
>     62		u32 mem_bw;
>     63		u32 cfg_bw;
>   > 64	} ufs_qcom_bw_table[MODE_MAX + 1][QCOM_UFS_MAX_GEAR + 1][QCOM_UFS_MAX_LANE + 1] = {
>     65		[MODE_MIN][0][0]		   = { 0,		0 }, /* Bandwidth values in KB/s */
>     66		[MODE_PWM][UFS_PWM_G1][UFS_LANE_1] = { 922,		1000 },
>     67		[MODE_PWM][UFS_PWM_G2][UFS_LANE_1] = { 1844,		1000 },
>     68		[MODE_PWM][UFS_PWM_G3][UFS_LANE_1] = { 3688,		1000 },
>     69		[MODE_PWM][UFS_PWM_G4][UFS_LANE_1] = { 7376,		1000 },
>     70		[MODE_PWM][UFS_PWM_G1][UFS_LANE_2] = { 1844,		1000 },
>     71		[MODE_PWM][UFS_PWM_G2][UFS_LANE_2] = { 3688,		1000 },
>     72		[MODE_PWM][UFS_PWM_G3][UFS_LANE_2] = { 7376,		1000 },
>     73		[MODE_PWM][UFS_PWM_G4][UFS_LANE_2] = { 14752,		1000 },
>     74		[MODE_HS_RA][UFS_HS_G1][UFS_LANE_1] = { 127796,		1000 },
>     75		[MODE_HS_RA][UFS_HS_G2][UFS_LANE_1] = { 255591,		1000 },
>     76		[MODE_HS_RA][UFS_HS_G3][UFS_LANE_1] = { 1492582,	102400 },
>     77		[MODE_HS_RA][UFS_HS_G4][UFS_LANE_1] = { 2915200,	204800 },
>     78		[MODE_HS_RA][UFS_HS_G1][UFS_LANE_2] = { 255591,		1000 },
>     79		[MODE_HS_RA][UFS_HS_G2][UFS_LANE_2] = { 511181,		1000 },
>     80		[MODE_HS_RA][UFS_HS_G3][UFS_LANE_2] = { 1492582,	204800 },
>     81		[MODE_HS_RA][UFS_HS_G4][UFS_LANE_2] = { 2915200,	409600 },
>     82		[MODE_HS_RB][UFS_HS_G1][UFS_LANE_1] = { 149422,		1000 },
>     83		[MODE_HS_RB][UFS_HS_G2][UFS_LANE_1] = { 298189,		1000 },
>     84		[MODE_HS_RB][UFS_HS_G3][UFS_LANE_1] = { 1492582,	102400 },
>     85		[MODE_HS_RB][UFS_HS_G4][UFS_LANE_1] = { 2915200,	204800 },
>     86		[MODE_HS_RB][UFS_HS_G1][UFS_LANE_2] = { 298189,		1000 },
>     87		[MODE_HS_RB][UFS_HS_G2][UFS_LANE_2] = { 596378,		1000 },
>     88		[MODE_HS_RB][UFS_HS_G3][UFS_LANE_2] = { 1492582,	204800 },
>     89		[MODE_HS_RB][UFS_HS_G4][UFS_LANE_2] = { 2915200,	409600 },
>     90		[MODE_MAX][0][0]		    = { 7643136,	307200 },
>     91	};
>     92	
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

-- 
மணிவண்ணன் சதாசிவம்
