Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A5D2C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 05:10:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236868AbiCHFLU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 00:11:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiCHFLT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 00:11:19 -0500
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2BF034652
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 21:10:23 -0800 (PST)
Received: by mail-pj1-f43.google.com with SMTP id b8so16096552pjb.4
        for <linux-scsi@vger.kernel.org>; Mon, 07 Mar 2022 21:10:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aw09gyG1Jd4melzKUTHGv80UY/rNHmqRo8tlasfn1k8=;
        b=wPyrXlRvx6Z9madSBmTLoEqonQQvgWz+YWb6Ukh8ic/NdCxqUAmlmoHvsr82z8La1U
         aWYqxzqiVWwtiDHFCgzsXLIQMd0JUB1VKI1on9ekNGfMZVGgWukiyFTrssbRGmD1qdY+
         Kg9QMNGB9Mx+eMm3vhBhjWs6NUqsCbz2ch+9SSQpYR1owxLroqufzER8+Stb8fjzVTnh
         8RblwKIOrRHfqThfU6Bsc49rirq5IRzlV0qq3pLaA8GQReC8mpPTfwuOnzQMBF6FiXkm
         CaXiS3XBCGXDZAZPi38yqN90XUxsmLO8z2p5fL7N/aBQIzAPUiUTa9nh8O1LuIIcNqOJ
         L9WA==
X-Gm-Message-State: AOAM5318VmQhWBauOpvQLSvzTNVGwnF9ur/4CFOyer4qERSyxhfKzqj5
        BnbQ+UazA/2k4fnvg9S/vkY=
X-Google-Smtp-Source: ABdhPJyxjxAcZeXmFLtvPgbQPXl+Yn44rqisdO+ZovDlR5++QefRRcBVqfTS9s8JIsowmQSPV7GZiA==
X-Received: by 2002:a17:902:7089:b0:14f:c32d:f0c4 with SMTP id z9-20020a170902708900b0014fc32df0c4mr15882279plk.97.1646716223152;
        Mon, 07 Mar 2022 21:10:23 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id g20-20020a056a000b9400b004f705514955sm5918063pfj.107.2022.03.07.21.10.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Mar 2022 21:10:22 -0800 (PST)
Message-ID: <56f5c05f-561e-0079-6996-866a047d7535@acm.org>
Date:   Mon, 7 Mar 2022 21:10:21 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [RFC PATCH 4/4] scsi: iscsi_tcp: Allow user to control if
 transmit from queuecommand
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, lduncan@suse.com,
        cleech@redhat.com, ming.lei@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20220308003957.123312-1-michael.christie@oracle.com>
 <20220308003957.123312-5-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220308003957.123312-5-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/7/22 16:39, Mike Christie wrote:
> +static bool iscsi_xmit_from_qc;
> +module_param_named(xmit_from_queuecommand, iscsi_xmit_from_qc, bool, 0644);
> +MODULE_PARM_DESC(xmit_from_queuecommand, "Set to true to try to xmit the task from the queuecommand callout. The default is false wihch will xmit the task from the iscsi_q workqueue.");

s/wihch/which/ ?

It may be hard for users to get the value of this parameter right. Has 
it been considered to make the iSCSI initiator select the proper mode 
depending on the load? I think the DPDK and SPDK software supports this. 
This is supported via user-level multithreading and by scaling to more 
CPU cores if required to achieve full performance.

Thanks,

Bart.
