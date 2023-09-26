Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07045E7E656
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Sep 2023 17:18:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbjIZRSv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Sep 2023 13:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232539AbjIZRSt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Sep 2023 13:18:49 -0400
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06779FB;
        Tue, 26 Sep 2023 10:18:42 -0700 (PDT)
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-6c4e7951dc1so2583834a34.3;
        Tue, 26 Sep 2023 10:18:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695748721; x=1696353521;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3cupA8S56N17JveXUIHbyJJHTDB/W+L12sXAOzHaZfE=;
        b=xH3eLErSO6NGta0nyuKPZhkD9OGTvgmSw+gW8rT94XPfHDus9Y7fDU5btbemeF+LJF
         7kr4t9IhGX6gmlakT0NIeXTaVCcWet6rHb/DhrNIZqgOA78iQURk1fr85EKJDOxt5MoZ
         I8t0StwipcwmF7Q6/ycW2s884x4+D268KWT8Os00yxLcKw0Y9l0nChb3DZQ5WPwRtViS
         jCrtpdnoGaClfmKwrAsVcz7yDVwUtzjnLk7oMOpFvv6pX8uwgheUj6+J6vE1Ru7fzVWo
         GZDj1BX8IqFdBCSx+9TRN2ua70ns1AqmBzrj535tTC1VBW5q8K+l1npC/b2bqrqk8jti
         O+3g==
X-Gm-Message-State: AOJu0Yx4FgL335ToLZ+IbwPUm6Zox2ULNtHQa5dZdZ06qgcFv3DxgxNM
        JaZNYfcyhHfak61S0D6T+M0Prxl8jfY=
X-Google-Smtp-Source: AGHT+IFnaXHb/UlFJ+W8r+1Afs5RouiauFFSqheJ2axgcwtx8GE8cVhTsBlwYuC3xjRex4bTB0V40w==
X-Received: by 2002:a05:6358:33a2:b0:142:d1cb:48ab with SMTP id i34-20020a05635833a200b00142d1cb48abmr13981124rwd.15.1695748721084;
        Tue, 26 Sep 2023 10:18:41 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:a80d:6f65:53d4:d1bf? ([2620:15c:211:201:a80d:6f65:53d4:d1bf])
        by smtp.gmail.com with ESMTPSA id z3-20020a63ac43000000b005803b6060a0sm5953093pgn.23.2023.09.26.10.18.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Sep 2023 10:18:40 -0700 (PDT)
Message-ID: <c94b6ac7-a938-42f4-9125-c638a0bb02de@acm.org>
Date:   Tue, 26 Sep 2023 10:18:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 01/23] ata: libata-core: Fix ata_port_request_pm()
 locking
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
References: <20230923002932.1082348-1-dlemoal@kernel.org>
 <20230923002932.1082348-2-dlemoal@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230923002932.1082348-2-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/22/23 17:29, Damien Le Moal wrote:
> The function ata_port_request_pm() checks the port flag
> ATA_PFLAG_PM_PENDING and calls ata_port_wait_eh() if this flag is set to
> ensure that power management operations for a port are not scheduled
> simultaneously. However, this flag check is done without holding the
> port lock.
> 
> Fix this by taking the port lock on entry to the function and checking
> the flag under this lock. The lock is released and re-taken if
> ata_port_wait_eh() needs to be called. The two WARN_ON() macros checking
> that the ATA_PFLAG_PM_PENDING flag was cleared are removed as the first
> call is racy and the second one done without holding the port lock.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>

