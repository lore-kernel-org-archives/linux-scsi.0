Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C40CDC00140
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Aug 2022 13:38:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbiHONio (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Aug 2022 09:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbiHONim (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Aug 2022 09:38:42 -0400
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C812520F73
        for <linux-scsi@vger.kernel.org>; Mon, 15 Aug 2022 06:38:40 -0700 (PDT)
Received: by mail-pl1-f175.google.com with SMTP id x23so6349905pll.7
        for <linux-scsi@vger.kernel.org>; Mon, 15 Aug 2022 06:38:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=p5rACQnpiaK58eTgmPmupdM7kXWlHgfyFcJuxsiqheA=;
        b=LjBNbKNzUy1Ccyu+EW+WXShQDEvgP7Y932aN8wHXTngcmm0ujZnOF7P/RMTcd0yEOQ
         2POUPPffJzWavSa6BWsg6jUNiCf8przQSX1dcAwB5QK25FbsHSi67XFyFidN4G0ML48k
         +esFAI7po6OejBWMFxvt0PHiVt4Mp927n6a7et+K/T0VaKpVnl9sian/5C49qmE60O2f
         //9bU3TL5T+TKo81/0ug8+x+WUJlwOgMdlSfh6UtUONmiWYyiBdnhfT0v2DsuaLxHTO8
         NQpTUJgC83JmdLnbkWNDwHkZ0JLHVs1sPJ/rjB75+0M0ngmTCG99H1ftld2xbDFZf9zQ
         YlmA==
X-Gm-Message-State: ACgBeo3dm+YZW7VJouH+j+2J0UH1mG+rriROcRfk8EMFoF02uJgzPlnP
        pYD3V7sMSEDB5b2T2TXkqp8=
X-Google-Smtp-Source: AA6agR4D9BiW3fEq+ocEEa+K1xAc2C46dIgFzevZebm3FD3+WHVZDPNtsBg13c7REJg5JLzVSPfHMg==
X-Received: by 2002:a17:902:f787:b0:16a:1e2b:e97 with SMTP id q7-20020a170902f78700b0016a1e2b0e97mr16505114pln.27.1660570720264;
        Mon, 15 Aug 2022 06:38:40 -0700 (PDT)
Received: from [192.168.3.217] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id z5-20020a1709027e8500b0016b865ea2ddsm6975063pla.85.2022.08.15.06.38.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Aug 2022 06:38:39 -0700 (PDT)
Message-ID: <5b83ac46-9c69-6eba-c19d-5124a022e86a@acm.org>
Date:   Mon, 15 Aug 2022 06:38:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH 0/4] Remove procfs support
Content-Language: en-US
To:     dgilbert@interlog.com, Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20220812204553.2202539-1-bvanassche@acm.org>
 <DM6PR04MB6575F397E1B519922D3C2C5AFC699@DM6PR04MB6575.namprd04.prod.outlook.com>
 <e71a33f6-0a65-561b-33b9-6772239c21df@acm.org>
 <ce3ae6cc-bd66-6139-f503-adeee3884313@interlog.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ce3ae6cc-bd66-6139-f503-adeee3884313@interlog.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/14/22 14:07, Douglas Gilbert wrote:
> How about lsscsi ?
> # lsscsi
> [0:0:0:0]    disk    Linux    scsi_debug       0191  /dev/sda
> [1:0:0:0]    disk    Linux    scsi_debug       0191  /dev/sdb
> [2:0:0:0]    disk    Linux    scsi_debug       0191  /dev/sdc
> [N:0:1:1]    disk    SKHynix_HFS512GDE9X081N__1                 
> /dev/nvme0n1
> 
> I plan to add JSON output to lsscsi in the near future.

Hi Doug,

It was not clear to me whether or not Avri needs to retrieve the version 
information on an Android system. Neither /proc/scsi nor lsscsi are 
available on recent Android systems. I will see whether I can include 
the sg3_utils package in Android.

Thanks,

Bart.

