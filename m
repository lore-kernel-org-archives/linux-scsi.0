Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0651C04A6A
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Aug 2023 18:36:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjHASgY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Aug 2023 14:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbjHASgX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2023 14:36:23 -0400
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E154B1FC6;
        Tue,  1 Aug 2023 11:36:22 -0700 (PDT)
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1bbc64f9a91so50562415ad.0;
        Tue, 01 Aug 2023 11:36:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690914982; x=1691519782;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fcfz0R863zI3puuV2hq31o7wiMDL/GrNDWB4uRz0UMA=;
        b=CtNuTotdx1+JSm3a0FyrdbPSCfx/gadOgo18i9XZUaSc2kQxc8500Np1EmyyLcoKbO
         7RLx/7yp6/yDVsbUq7y7DS9TTGwy+ZJvjJ5Zb3MhvjKdpJo7twsk/MgK1n3N8mTj+1WY
         CbYljhyLLFjGIxfQTj4bwvayyqUPJmyKGCspW8v89WJQnHcG8MAPRelEXSgFOfyBPnKf
         rx9kODyD7khFb2nIGGH0puUkQKesPIh0Txw2HwlFYsFkXRv7XK+jtyGw5q0GIyppc4aw
         WG3hKHNgVcIeZlKtcKxxFWjD9fGuR0K9SPKI1Jr5bDfE6j3A81iGHIMifAo31RZIAyml
         Uawg==
X-Gm-Message-State: ABy/qLa6SENrvDgMZZxQEzVauxogOXRgfoJQJwNahKkyR9QE9EBZg4WS
        ws2mcoxGVTqHCZjc5uPikY9+S9aRGlg=
X-Google-Smtp-Source: APBJJlFEZHbhrk80IMySZCiA2wwL94qZptM+hPS4ANLpvhWT/1MzxDDnzuzluExdej7RBTRIydy0fA==
X-Received: by 2002:a17:902:d4c3:b0:1b7:e355:d1ea with SMTP id o3-20020a170902d4c300b001b7e355d1eamr15212995plg.24.1690914982313;
        Tue, 01 Aug 2023 11:36:22 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id a2-20020a170902ee8200b001b04c2023e3sm10785049pld.218.2023.08.01.11.36.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Aug 2023 11:36:21 -0700 (PDT)
Message-ID: <8c8f38de-f418-6ffb-8949-f6eb85602d98@acm.org>
Date:   Tue, 1 Aug 2023 11:36:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] ata,scsi: do not issue START STOP UNIT on resume
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Paul Ausbeck <paula@soe.ucsc.edu>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        TW <dalzot@gmail.com>, regressions@lists.linux.dev
References: <20230731003956.572414-1-dlemoal@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230731003956.572414-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/30/23 17:39, Damien Le Moal wrote:
> Given that ATA devices will be woken up by libata activity on resume,
> sd_resume() has no need to issue a START STOP UNIT command, which solves
> the above mentioned problems. Do not issue this command by introducing
> the new scsi_device flag no_start_on_resume and setting this flag to 1
> in ata_scsi_dev_config(). sd_resume() is modified to issue a START STOP
> UNIT command only if this flag is not set.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
