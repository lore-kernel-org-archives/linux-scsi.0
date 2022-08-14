Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12FD7C25B06
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Aug 2022 14:27:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239346AbiHNO16 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 14 Aug 2022 10:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239844AbiHNO15 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Aug 2022 10:27:57 -0400
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA44E12092
        for <linux-scsi@vger.kernel.org>; Sun, 14 Aug 2022 07:27:53 -0700 (PDT)
Received: by mail-pl1-f181.google.com with SMTP id x10so4477583plb.3
        for <linux-scsi@vger.kernel.org>; Sun, 14 Aug 2022 07:27:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=nAODcxIXpeXjIJkhr1mxDERh/4uWm6kyOn+7P9g8doY=;
        b=I28O3TJP45+tPCO5Sf9gt8HY858TjRhZKzDBz8fxBzywzZgzt+2jlvIotNAKAr+z7n
         bn2cvMolatnMfTOwB+w6ZhR2eZGCH6aeell7Lv4SosIlhOMfGJqz+JQ4Z9tgqRFVjHXA
         H0byX1qcsN4SYBXQ43fnNvO4deHPvpby6IrOGCML3fujTgMkCQlVQ4lZ0LYMnaPOiAJh
         WJZV7lNKTFekOeWhT9uGvPg88JPAP1ID/LcJ7gvv0gcVFgoYOAL+MdcMt8auvXa9Qc+I
         NuUt7Lo07blUa/MnuD8zCuxT9PbFccZYQ90e/3rfhKKWZ3MnWp/bM8t1Uli6OBmw93ge
         nReg==
X-Gm-Message-State: ACgBeo0hTTQAIhj8IPrVLmmmCQwuFcXPScz6/YFYYAR+H5TW+fVBDcmQ
        NdtqgiaYuA6Z935vvLx8aVY=
X-Google-Smtp-Source: AA6agR7XlPCU7pDiRdg3VksxxJaIDNCBKzqs/SFrbzfDOh3nYkdhajXTQgY1mbr2hx7gAld0JFkTrA==
X-Received: by 2002:a17:90b:4a84:b0:1f7:2ee5:a30b with SMTP id lp4-20020a17090b4a8400b001f72ee5a30bmr13960911pjb.1.1660487273344;
        Sun, 14 Aug 2022 07:27:53 -0700 (PDT)
Received: from [192.168.3.217] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id t7-20020a1709027fc700b0016d737bff00sm5432128plb.220.2022.08.14.07.27.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Aug 2022 07:27:52 -0700 (PDT)
Message-ID: <e71a33f6-0a65-561b-33b9-6772239c21df@acm.org>
Date:   Sun, 14 Aug 2022 07:27:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 0/4] Remove procfs support
Content-Language: en-US
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20220812204553.2202539-1-bvanassche@acm.org>
 <DM6PR04MB6575F397E1B519922D3C2C5AFC699@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB6575F397E1B519922D3C2C5AFC699@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/14/22 05:54, Avri Altman wrote:
>> The SCSI sysfs interface made the procfs interface superfluous. sysfs support
 >
> Field application engineers are using #cat /proc/scsi/scsi to get the devices's fw version - Rev: xxx
> Where should they look for that now?

Hi Avri,

Please take a look at the output of the following command:

find /sys -name inquiry | xargs grep -aH .

Thanks,

Bart.
