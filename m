Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECFE2C43334
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jul 2022 00:10:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241092AbiGOAKE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jul 2022 20:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232915AbiGOAKD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jul 2022 20:10:03 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8393D68725
        for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2022 17:10:02 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id e16so3250769pfm.11
        for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2022 17:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2cE8jLkic9As9sQ30K6zAJeKdXbt9DAEUpU770ZaRnI=;
        b=nploK16b+dMmMzLx/+iaWxPdIcmOaIWvxrB5Gn3lJzHVEN2rXU2KW9jWPW52oVV9RN
         NwsFGbQ/9mzJJfNLVFh0Iw28KfHiOQm3oHwBrFhupvatO8J77Izg+QYCQDrMFQSWbE+R
         Ur22AnDqXN24R0drvqp5BbWHALVKByPueP3qxoc76RcUuSmuqAagjzxA2xqKBdSirHn7
         crRVR1pmbKhQAn7Mu5NNyi3QXFHDQZCWJjCKFPoanBrRtSp3SlNF6mGy+RNJewRFf99j
         GC53e2R08dUIe4A26mANsn4d3LQoAHcJZcXLNscRntr7frYhD+qcAX1N2e4396ccB+Q4
         aJXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=2cE8jLkic9As9sQ30K6zAJeKdXbt9DAEUpU770ZaRnI=;
        b=sPJyHZoRdubgOyRdxLgz35cLjswW3AmEVZEASOTKq8PF9f+Qbow4cG/Mdxqb3B8+Rk
         Dd+lh5N9ahvm0bwmKF0QpDhUzrjxbiqv+7VOD+WLZdsuXW66IQMvKUg7k67QHAeXcCk6
         Q1ZT/QifUu1q8/9n0axd0pJOWE+f8nnis1feDpZhT8lHA8+K/Iy9SXMHr7es5hg8vWTk
         jTymhsThVXbIm1VMrxGWoZvpoX9vas4QvIyuNW3zZFe2vAiMbDMDkDLN0TBqhTUydXTR
         o3IDQI1Fj0i1IBY0nnS6zvBT5/zQz5OvIlAKKnti7pe2vpWeHkR7XwhMgCbF/0FM4Pff
         375Q==
X-Gm-Message-State: AJIora9PAinzIgyRcBnA7voVSdxEeuk7DGUPqwoTPeLkKynPZmEPGcW/
        nU3YQdLbiM8Wyww8fQ86HtZUZYNVDzamqA==
X-Google-Smtp-Source: AGRyM1tTUgGK7vO9wBiBCGWRZ+zIWte9GXKdJ4XxVHDwpvNlvhzUW04NE7mO7SXnJupUJbeurACOZA==
X-Received: by 2002:a05:6a00:1345:b0:52a:d5b4:1984 with SMTP id k5-20020a056a00134500b0052ad5b41984mr10817315pfu.6.1657843801968;
        Thu, 14 Jul 2022 17:10:01 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id mt20-20020a17090b231400b001ef899eb51fsm4195817pjb.29.2022.07.14.17.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 17:10:01 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 14 Jul 2022 17:10:00 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH 2/2] mpi3mr: Reduce VD queue depth on detecting the
 throttling
Message-ID: <20220715001000.GA565294@roeck-us.net>
References: <20220708195020.8323-1-sreekanth.reddy@broadcom.com>
 <20220708195020.8323-3-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708195020.8323-3-sreekanth.reddy@broadcom.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Jul 09, 2022 at 01:20:20AM +0530, Sreekanth Reddy wrote:
> Reduce the VD queue depth on detecting the throttling condition.
> 
> Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

Building i386:allyesconfig ... failed
--------------
drivers/scsi/mpi3mr/mpi3mr_os.c: In function 'mpi3mr_queue_qd_reduction_event':
drivers/scsi/mpi3mr/mpi3mr_os.c:389:40: error: cast from pointer to integer of different size [-Werror=pointer-to-int-cast]
  389 |         *(__le64 *)fwevt->event_data = (__le64)tg;
      |                                        ^
drivers/scsi/mpi3mr/mpi3mr_os.c: In function 'mpi3mr_fwevt_bh':
drivers/scsi/mpi3mr/mpi3mr_os.c:1655:22: error: cast to pointer from integer of different size
 1655 |                 tg = (struct mpi3mr_throttle_group_info *)
      |                      ^

bisect log attached.

Guenter

---
# bad: [37b355fdaf31ee18bda9a93c2a438dc1cbf57ec9] Add linux-next specific files for 20220714
# good: [32346491ddf24599decca06190ebca03ff9de7f8] Linux 5.19-rc6
git bisect start 'HEAD' 'v5.19-rc6'
# good: [6d30dd0872599b7004e26330fc2e476ad900e7f6] Merge branch 'drm-next' of git://git.freedesktop.org/git/drm/drm.git
git bisect good 6d30dd0872599b7004e26330fc2e476ad900e7f6
# good: [64b90d49f82dcc78b4ecf98bf8cb306713f80c36] Merge branch 'next' of git://git.kernel.org/pub/scm/virt/kvm/kvm.git
git bisect good 64b90d49f82dcc78b4ecf98bf8cb306713f80c36
# good: [9cb02c37af5c63f4e609b370b2b17a9e7f98300d] Merge branch 'staging-next' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
git bisect good 9cb02c37af5c63f4e609b370b2b17a9e7f98300d
# bad: [c9020490ef7b885984e6cf1d39687794538a4605] Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git
git bisect bad c9020490ef7b885984e6cf1d39687794538a4605
# bad: [75c791957c6e636b5c42f63ead2101271cc1bd13] Merge branch 'gpio/for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/brgl/linux.git
git bisect bad 75c791957c6e636b5c42f63ead2101271cc1bd13
# good: [297bdc540f0e391568788f8ece3020653748a26f] scsi: smartpqi: Close write read holes
git bisect good 297bdc540f0e391568788f8ece3020653748a26f
# bad: [4dbe57617d045d9579390c160998d2bd6e76a82d] Merge branch 'for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
git bisect bad 4dbe57617d045d9579390c160998d2bd6e76a82d
# good: [85ebec464953ed20bf43f60b529fa4b568ade219] Merge branch 'for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
git bisect good 85ebec464953ed20bf43f60b529fa4b568ade219
# bad: [039e231c6573c2384b4cfed16b62f39ccd6be51b] scsi: sd: Support multiple LBA ranges in an UNMAP command
git bisect bad 039e231c6573c2384b4cfed16b62f39ccd6be51b
# good: [6d567dfee0b7b4c66fb1f62d59a2e62e2709b453] scsi: smartpqi: Add ctrl ready timeout module parameter
git bisect good 6d567dfee0b7b4c66fb1f62d59a2e62e2709b453
# bad: [3101bcf7eea56fd76c7cb11b518d6acc9a15a08a] scsi: sg: Allow waiting for commands to complete on removed device
git bisect bad 3101bcf7eea56fd76c7cb11b518d6acc9a15a08a
# good: [f54f85dfd757301791be8ce6fccc6f6604d82b40] scsi: smartpqi: Update version to 2.1.18-045
git bisect good f54f85dfd757301791be8ce6fccc6f6604d82b40
# bad: [c196bc4dce42bdcc2c69ec106d176f427c56003a] scsi: mpi3mr: Reduce VD queue depth on detecting throttling
git bisect bad c196bc4dce42bdcc2c69ec106d176f427c56003a
# good: [fded192f13033676a5ed202cae187d2832fa0093] scsi: mpi3mr: Resource Based Metering
git bisect good fded192f13033676a5ed202cae187d2832fa0093
# first bad commit: [c196bc4dce42bdcc2c69ec106d176f427c56003a] scsi: mpi3mr: Reduce VD queue depth on detecting throttling
