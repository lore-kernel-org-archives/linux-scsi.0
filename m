Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93B45E82CAE
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Sep 2023 16:29:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbjI0Q3c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 12:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjI0Q3a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 12:29:30 -0400
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA81291;
        Wed, 27 Sep 2023 09:29:29 -0700 (PDT)
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1c44c0f9138so85542405ad.2;
        Wed, 27 Sep 2023 09:29:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695832169; x=1696436969;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=duvjCo0JuxZMgwCrfLCTY+iDLqat7LNdQ7M8fdOT0po=;
        b=iXqa4P9X2fGBddzi7de9SnVPnyVi33WihaL0/OrK33EYJu0qxeZDlptVTdqlA6xcPL
         y1cjbtbiWM9cEMgf1sZlpumXHBqK6QDO9Nbd4jDJ8QJkbka9IiTnt8deGS+9+Fn7CoJ5
         1uKXAmyAJia670DpxiXuC0Y3LwIX0E3e71DcyH9mKww5UFrbhZW/IPsCgphfJtyBXn6m
         AWZdH0Ru4j8P4ynaUIWcBYX5FJAkO2k8eNoAupygB2Vc2R8BJgGwnjckCFCy2YT1mDMB
         7e6iUgJTapPVV6zoGW9LIQP9L1WK+pR4ruLrraZ9h7L6h4ra63pZdt2rYEIUZXuVzMVl
         KWLw==
X-Gm-Message-State: AOJu0YwGGCXQG34B/Aqxjzb3Og8KoteIrHTpv/SyM/Q3FGfK6yurbvyO
        b2PbFT8nJFUrFBSf4opuczc=
X-Google-Smtp-Source: AGHT+IHg7FxsvwgANgoqbtLbTNE3UuFHvB0DuslkKsiuySFg+EFbm13utdrF7qIUr4pWxRK5/diH8g==
X-Received: by 2002:a17:902:d3cd:b0:1bd:d141:f02d with SMTP id w13-20020a170902d3cd00b001bdd141f02dmr2072088plb.68.1695832168888;
        Wed, 27 Sep 2023 09:29:28 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:8f39:a76e:2f15:c958? ([2620:15c:211:201:8f39:a76e:2f15:c958])
        by smtp.gmail.com with ESMTPSA id jw16-20020a170903279000b001b89b7e208fsm13434819plb.88.2023.09.27.09.29.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Sep 2023 09:29:28 -0700 (PDT)
Message-ID: <05e7792e-bae6-4501-b14c-773bd4a3fe98@acm.org>
Date:   Wed, 27 Sep 2023 09:29:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 09/23] scsi: sd: Do not issue commands to suspended
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
References: <20230926081507.69346-1-dlemoal@kernel.org>
 <20230926081507.69346-10-dlemoal@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230926081507.69346-10-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/26/23 01:14, Damien Le Moal wrote:
> If an error occurs when resuming a host adapter before the devices
> attached to the adapter are resumed, the adapter low level driver may
> remove the scsi host, resulting in a call to sd_remove() for the
> disks of the host. This in turn results in a call to sd_shutdown() which
> will issue a synchronize cache command and a start stop unit command to
> spindown the disk. sd_shutdown() issues the commands only if the device
> is not already runtime suspended but does not check the power state for
> system-wide suspend/resume. That is, the commands may be issued with the
> device in a suspended state, which causes PM resume to hang, forcing a
> reset of the machine to recover.
> 
> Fix this by tracking the suspended state of a disk by introducing the
> suspended boolean field in the scsi_disk structure. This flag is set to
> true when the disk is suspended is sd_suspend_common() and resumed with
> sd_resume(). When suspended is true, sd_shutdown() is not executed from
> sd_remove().


Reviewed-by: Bart Van Assche <bvanassche@acm.org>
