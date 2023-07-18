Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E495FEB64DC
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Jul 2023 17:41:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbjGRRlx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Jul 2023 13:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjGRRlw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Jul 2023 13:41:52 -0400
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB4CD3
        for <linux-scsi@vger.kernel.org>; Tue, 18 Jul 2023 10:41:48 -0700 (PDT)
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-666e916b880so3946436b3a.2
        for <linux-scsi@vger.kernel.org>; Tue, 18 Jul 2023 10:41:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689702107; x=1692294107;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fnL+4eKchlLBqgnSWUCxwrOR90ZM8MoCkVgnRaAJ/yw=;
        b=Wv3QinKpDso9ODx3WwqO3YrZpm9HkH4DOubMpnAwaPuvNTi/mjZ3m2oMsqaUdEDP5+
         y4xF1lkhvC60qcyg2iJIDdEsv4se8s5/mKT69GXfQmCfBA1YJmskYH1i8/Yq57hvUD0Y
         DLSaRJ6NYc+CmXyU1KZgJaT3rWWo8Y8lKyYVbU0XHiBK3Wja0kvKRy6cZSyMcwxEgJ55
         /5shqeDPKaxZjumVGE4ISHCOEUiOuz60WOikK4TA2wNnoKF9+Mmah8RYbUMCJC0TmMOE
         R1M0r6PIrxku/Y/irUfd/ms7X1iQBT1IWAAssrygZDTXvqa35fijdTaX6F5SKot+01zs
         OOsw==
X-Gm-Message-State: ABy/qLYUIoUdkygdtXYF0Ou7rkh7m/af5aNGK+nY7xh7903xBWjEwsku
        lZ0UN9Rh2OMpWKoeBKOaT9JLF2LFGRk=
X-Google-Smtp-Source: APBJJlFMjxAGNSqk7Xskn10VK+CT7TqmjQOsoxG7nsj5kaMYy38+GJxJUY/shnn+C4xqlIUbvgDeEg==
X-Received: by 2002:a05:6a20:a10c:b0:134:589a:cdcb with SMTP id q12-20020a056a20a10c00b00134589acdcbmr8313536pzk.12.1689702107424;
        Tue, 18 Jul 2023 10:41:47 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:3cb6:9d30:79d0:90cc? ([2620:15c:211:201:3cb6:9d30:79d0:90cc])
        by smtp.gmail.com with ESMTPSA id c9-20020aa78c09000000b00682a61fa525sm1864201pfd.91.2023.07.18.10.41.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jul 2023 10:41:47 -0700 (PDT)
Message-ID: <d50271d5-c3b4-44b1-769b-be200c4577df@acm.org>
Date:   Tue, 18 Jul 2023 10:41:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
From:   Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi: ufs: Remove HPB support
To:     kernel test robot <lkp@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     oe-kbuild-all@lists.linux.dev, Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        ChanWoo Lee <cw9316.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Lu Hongfei <luhongfei@vivo.com>,
        Daniil Lunev <dlunev@chromium.org>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Can Guo <quic_cang@quicinc.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <arthur.simchaev@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Markus Fuchs <mklntf@gmail.com>,
        Po-Wen Kao <powen.kao@mediatek.com>,
        Eric Biggers <ebiggers@google.com>
References: <20230717193827.2001174-1-bvanassche@acm.org>
 <202307190020.oxUXDCH1-lkp@intel.com>
Content-Language: en-US
In-Reply-To: <202307190020.oxUXDCH1-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/18/23 10:02, kernel test robot wrote:
> All warnings (new ones prefixed by >>):
> 
>     drivers/ufs/core/ufshcd.c: In function 'ufs_get_device_desc':
>>> drivers/ufs/core/ufshcd.c:8092:12: warning: variable 'b_ufs_feature_sup' set but not used [-Wunused-but-set-variable]
>      8092 |         u8 b_ufs_feature_sup;
>           |            ^~~~~~~~~~~~~~~~~

I think the above warning can be fixed as follows (will fold this in
when reposting this patch):

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index e40b71c8dbc0..c394dc50504a 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8089,7 +8089,6 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
  {
  	int err;
  	u8 model_index;
-	u8 b_ufs_feature_sup;
  	u8 *desc_buf;
  	struct ufs_dev_info *dev_info = &hba->dev_info;

@@ -8118,7 +8117,6 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
  	dev_info->wspecversion = desc_buf[DEVICE_DESC_PARAM_SPEC_VER] << 8 |
  				      desc_buf[DEVICE_DESC_PARAM_SPEC_VER + 1];
  	dev_info->bqueuedepth = desc_buf[DEVICE_DESC_PARAM_Q_DPTH];
-	b_ufs_feature_sup = desc_buf[DEVICE_DESC_PARAM_UFS_FEAT];

  	model_index = desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];


