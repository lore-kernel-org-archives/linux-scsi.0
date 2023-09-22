Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D15DCE7A81
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Sep 2023 20:08:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbjIVUI2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Sep 2023 16:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbjIVUI1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2023 16:08:27 -0400
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3160E19D;
        Fri, 22 Sep 2023 13:08:19 -0700 (PDT)
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1bdf4752c3cso22571805ad.2;
        Fri, 22 Sep 2023 13:08:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695413298; x=1696018098;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AmmANjjg8qeeqVpRFF8MM0elAglZNyZGpftJFm3I7mE=;
        b=inz56Ubqf9NuUtaTz00EM1SlU/n7nL7dYYAnA8exNaKoSQoPbF1RvOc5QzBfhThhHp
         arBiweDH1W9wwpCsMdlgROoZ8IHYYlBN4oA+DPGUp+i54SDHCpZFJraxaCsmHNjVrUoM
         y1MLRnhMQAT4cSprewNWm63ynKs4OtknQhQmz2zRnbnXwCavxnKfmI5UkPwbU18eKk1F
         g0wyLWU440s78gT/3jiLb1NNFOwpiQ4uOExJjXTSs/ODooKrBTQhRZnKcY4xhz3XYBVm
         PCmoW4Rj0ia6ZyfySTb483NkbbBwG/a5tcC5k/pVElrX5gP720o0GpY9Ghgl/abFs5Cq
         cr0Q==
X-Gm-Message-State: AOJu0YzTq3wrKqDQGdlslZycrvMw1AcHC+p5dm6Rug7nhNZZA/VqsOKI
        SOqvqfEraikPq+wq4zqJZ24=
X-Google-Smtp-Source: AGHT+IFJQE3SZeS0v1IVVuQF+TxARNF1WxmptDbwRQoQhJsfbESy2UW4m0Epik2rpMdQm3aFFs3wiw==
X-Received: by 2002:a17:902:ea0f:b0:1bf:557c:5a2c with SMTP id s15-20020a170902ea0f00b001bf557c5a2cmr573290plg.44.1695413298416;
        Fri, 22 Sep 2023 13:08:18 -0700 (PDT)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net. [73.231.117.72])
        by smtp.gmail.com with ESMTPSA id u2-20020a17090282c200b001bc445e2497sm3888293plz.79.2023.09.22.13.08.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Sep 2023 13:08:17 -0700 (PDT)
Message-ID: <a745a2a7-e740-4bf3-a775-e22bc55dbe58@acm.org>
Date:   Fri, 22 Sep 2023 13:08:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 09/23] scsi: sd: Do not issue commands to suspended
 disks on shutdown
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
References: <20230921180758.955317-1-dlemoal@kernel.org>
 <20230921180758.955317-10-dlemoal@kernel.org>
 <49f609ca-f862-4dce-95d8-616acbbc3e0e@acm.org>
 <1166d617-529f-a85b-eb51-427e8c2e8e45@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1166d617-529f-a85b-eb51-427e8c2e8e45@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/22/23 12:10, Damien Le Moal wrote:
> Looking at the code, scsi_remove_host() calls scsi_forget_host() which calls
> __scsi_remove_device() for any device that is not in the SDEV_DEL state.
> __scsi_remove_device() then sets the state to SDEV_CANCEL. So it appears that
> the state should always be CANCEL and not running. However, my tests showed it
> to be running. I am not fully understanding how sd_remove() end up being called...

I think this is how sd_sync_cache() gets called from inside
scsi_remove_host():

scsi_remove_host()
   -> scsi_forget_host()
     -> __scsi_remove_device()
       -> device_del(&sdev->sdev_gendev)
         -> bus_remove_device()
           -> device_release_driver()
             -> __device_release_driver()
               -> sd_remove()
                 -> sd_shutdown()
                   -> sd_sync_cache()

In other words, it is guaranteed that scsi_device_set_state(sdev, 
SDEV_CANCEL) has been called before sd_remove() if it is called by 
scsi_remove_host().

> I think we should investigate this further though, to make sure that we can
> always safely call sd_shutdown(). __scsi_remove_device() has this comment:
> 
> /*
>   * If blocked, we go straight to DEL and restart the queue so
>   * any commands issued during driver shutdown (like sync
>   * cache) are errored immediately.
>   */
> 
> Which kind of give a hint that we should probably not blindy always try to call
> sd_shutdown().

Does that comment perhaps refer to the SDEV_BLOCK / SDEV_CREATED_BLOCK
states? Anyway, I'm wondering whether there are better ways to prevent
that it is attempted to queue SCSI commands if a SCSI device is
suspended, e.g. by checking the suspended state from inside
scsi_device_state_check() or scsi_dispatch_cmd().

Thanks,

Bart.


