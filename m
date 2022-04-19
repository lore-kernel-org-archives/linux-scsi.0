Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69140C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 21:48:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344874AbiDSVuu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 17:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343747AbiDSVut (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 17:50:49 -0400
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A793FD8F
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 14:48:06 -0700 (PDT)
Received: by mail-pl1-f174.google.com with SMTP id c12so17060313plr.6
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 14:48:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xRik7W8n6zGWRqXlmJcnNxQ7rY4wFTu72Ih4D/jEb/Q=;
        b=3bKbCyLWbDeZvcQmoFBYj/UNef84VAgDBtFngzRdjVoz0e247F9Id4s0ECj8fuCSzo
         XljqQ382z39wuHs2m5vD+fMZkOIdfsMScVh1WGSx6ny4TEROx0TuIbWU3Zu/9Ru5cBy9
         j8mRdE1gXoGNw5ai9TBPMZE7NKhCAY7UHLyTLGyhutFSdWSgyh+xaj8s7EdvNhvKO/AX
         pf4/AvndWfiG3Ym57l9LKvg2E50lIOi0jVUlbFb8SWrWSZ3vUo4kfzIbIo4Vm8+WQvCj
         Jojs6Z6d5I3dLefIzLJ+kXj7etojp2rqohrRklQMSzfxs9r+YPn/jW633B6bS3mleZJ7
         N0Eg==
X-Gm-Message-State: AOAM530o5huZ2cmQZs76bx/plLQHev0SvY0Wk25xu/pKAkftV0zQr+2+
        bA+80+ck7gvehPV0XH/ONPk=
X-Google-Smtp-Source: ABdhPJzXqL1CIRO+6cQpIJTbfDnvRvh2wjttQza4j1WABuNPki3NXGKG+O2NVij/pyB6oaTrYPZq6w==
X-Received: by 2002:a17:90b:48c1:b0:1d2:7859:dfce with SMTP id li1-20020a17090b48c100b001d27859dfcemr739143pjb.14.1650404885706;
        Tue, 19 Apr 2022 14:48:05 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:59ec:2e90:f751:1806? ([2620:15c:211:201:59ec:2e90:f751:1806])
        by smtp.gmail.com with ESMTPSA id z11-20020aa7990b000000b005061fcc75b6sm17458083pff.125.2022.04.19.14.48.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Apr 2022 14:48:04 -0700 (PDT)
Message-ID: <5eb9e3b1-e4af-e1e6-2545-d6ba8ed52d7b@acm.org>
Date:   Tue, 19 Apr 2022 14:48:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 28/29] scsi: ufs: Move the ufs_is_valid_unit_desc_lun()
 definition
Content-Language: en-US
To:     Bean Huo <huobean@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Bean Huo <beanhuo@micron.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
References: <20220412181853.3715080-1-bvanassche@acm.org>
 <20220412181853.3715080-29-bvanassche@acm.org>
 <332ee72936e1353439d0daaa55a70e218da913b3.camel@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <332ee72936e1353439d0daaa55a70e218da913b3.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/19/22 14:00, Bean Huo wrote:
> You didn't move this function to drivers/ufs/core/ufshcd-priv.h,

Hmm ... it is not clear why you wrote the above? I think that the diff 
clearly shows that ufs_is_valid_unit_desc_lun() is moved into 
drivers/scsi/ufs/ufshcd-priv.h.

Thanks,

Bart.
