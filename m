Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 427A2C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Apr 2022 04:14:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236373AbiDAEQZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Apr 2022 00:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233783AbiDAEQY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2022 00:16:24 -0400
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38A3173341
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 21:14:34 -0700 (PDT)
Received: by mail-pg1-f170.google.com with SMTP id t4so1473101pgc.1
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 21:14:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hS0oIZkh+SmiQmMZmnLoPIwIZoxz8fBFCgb/2x3bT6g=;
        b=B/UG9C0zHM/bTjc6yS8rYXoi3RC0SJIg6LhYrrUSOMdx60gRPE7l1dfD4olCKwWot4
         UtyDaNkLuFaXnMO8Y/+mdJl6AnMOUefKN1/cb8FrQzCyQkexJqIc/vLRFRHRcSKCjJHd
         nRsg+oNovWjj29rUK6Oq2TAg863pzo+P95gqeuKL1iKYW9/opv6Q+hKMEs8OlB7GFizk
         G3CrY/T4CSMw6ZJnK3gEFxqztfiwWt1gietCYyFmjiLXdSLNMLOu/6Cmd3ZAkE/09QUn
         3nK8ZyUWdar4PPLUFTcQFUlxUR9wV7S77WjP0lOt7cMc1EfMF1U6Si+IGwPXQ8Q2+8DL
         ULqQ==
X-Gm-Message-State: AOAM5308yVXl8SXxPkEEFDJDOyJeLgo3QsPgYaCedtpHF1uDFnDxpkNT
        8EisVrmWnyuE1kjTLhxof6k=
X-Google-Smtp-Source: ABdhPJxUSL8ljhPOVjAcwVwslFTbfR2EnAUld8YtiKDyxOmTMYkQntNRwxp5q3f08PeyWr+x4y0cwA==
X-Received: by 2002:a05:6a00:1695:b0:4f7:decc:506b with SMTP id k21-20020a056a00169500b004f7decc506bmr8911207pfc.7.1648786474354;
        Thu, 31 Mar 2022 21:14:34 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id kk11-20020a17090b4a0b00b001c73933d803sm12079388pjb.10.2022.03.31.21.14.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Mar 2022 21:14:33 -0700 (PDT)
Message-ID: <91fb8b36-b3dd-c68b-5d08-49928c1e6d27@acm.org>
Date:   Thu, 31 Mar 2022 21:14:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 26/29] scsi: ufs: Split the ufshcd.h header file
Content-Language: en-US
To:     Chanho Park <chanho61.park@samsung.com>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>
Cc:     'Jaegeuk Kim' <jaegeuk@kernel.org>,
        'Adrian Hunter' <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        'Avri Altman' <Avri.Altman@wdc.com>,
        'Can Guo' <cang@codeaurora.org>,
        'Asutosh Das' <asutoshd@codeaurora.org>,
        'Daejun Park' <daejun7.park@samsung.com>,
        'Guenter Roeck' <linux@roeck-us.net>,
        'Bean Huo' <beanhuo@micron.com>,
        'Keoseong Park' <keosung.park@samsung.com>,
        'Mike Snitzer' <snitzer@redhat.com>,
        'Eric Biggers' <ebiggers@google.com>,
        'Jens Axboe' <axboe@kernel.dk>,
        'Ulf Hansson' <ulf.hansson@linaro.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <CGME20220331224010epcas2p33104ab9dbf6df0d885f1cc2b31d07d12@epcas2p3.samsung.com>
 <20220331223424.1054715-27-bvanassche@acm.org>
 <002201d8455e$67b46e70$371d4b50$@samsung.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <002201d8455e$67b46e70$371d4b50$@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/31/22 17:21, Chanho Park wrote:
> I'm seeing below build error when I applied this patch. Any baseline do I
> need?
> 
> In file included from drivers/scsi/ufs/ufs-sysfs.c:9:
> drivers/scsi/ufs/ufshcd-priv.h:32:20: error: redefinition of
> 'ufs_hwmon_probe'
>     32 | static inline void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask) {}
>        |                    ^~~~~~~~~~~~~~~
> In file included from drivers/scsi/ufs/ufshcd-priv.h:5,
>                   from drivers/scsi/ufs/ufs-sysfs.c:9:
> drivers/scsi/ufs/ufshcd.h:1079:20: note: previous definition of
> 'ufs_hwmon_probe' with type 'void(struct ufs_hba *, u8)' {aka 'void(struct
> ufs_hba *, unsigned char)'}
>   1079 | static inline void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask) {}
>        |                    ^~~~~~~~~~~~~~~
> In file included from drivers/scsi/ufs/ufs-sysfs.c:9:
> drivers/scsi/ufs/ufshcd-priv.h:33:20: error: redefinition of
> 'ufs_hwmon_remove'
>     33 | static inline void ufs_hwmon_remove(struct ufs_hba *hba) {}
>        |                    ^~~~~~~~~~~~~~~~
> In file included from drivers/scsi/ufs/ufshcd-priv.h:5,
>                   from drivers/scsi/ufs/ufs-sysfs.c:9:
> drivers/scsi/ufs/ufshcd.h:1080:20: note: previous definition of
> 'ufs_hwmon_remove' with type 'void(struct ufs_hba *)'
>   1080 | static inline void ufs_hwmon_remove(struct ufs_hba *hba) {}
>        |                    ^~~~~~~~~~~~~~~~

Hi Chanho,

Patch 26/29 duplicates the ufs_hwmon_remove() etc. definitions instead 
of moving these. The patch below needs to be applied on top of this 
patch to make it build. I will fix this when I repost this patch series.

Thanks,

Bart.

diff --git a/include/scsi/ufshcd.h b/include/scsi/ufshcd.h
index 946d915f5a42..3caec295d87a 100644
--- a/include/scsi/ufshcd.h
+++ b/include/scsi/ufshcd.h
@@ -1071,16 +1071,6 @@ static inline void *ufshcd_get_variant(struct 
ufs_hba *hba)
  	return hba->priv;
  }

-#ifdef CONFIG_SCSI_UFS_HWMON
-void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask);
-void ufs_hwmon_remove(struct ufs_hba *hba);
-void ufs_hwmon_notify_event(struct ufs_hba *hba, u8 ee_mask);
-#else
-static inline void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask) {}
-static inline void ufs_hwmon_remove(struct ufs_hba *hba) {}
-static inline void ufs_hwmon_notify_event(struct ufs_hba *hba, u8 
ee_mask) {}
-#endif
-
  #ifdef CONFIG_PM
  extern int ufshcd_runtime_suspend(struct device *dev);
  extern int ufshcd_runtime_resume(struct device *dev);
