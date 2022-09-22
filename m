Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE8E8C54EE9
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 18:31:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbiIVSbW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 14:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232700AbiIVSax (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 14:30:53 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A66810B23D
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 11:28:08 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id c4so8468818iof.3
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 11:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=ZXkuoJN7DK7qQfm5r7ECOHzIgNY6d3HZTieo4WxgmDg=;
        b=TC+pJhfEN/PyAXFz9y6nGede4tCH/WFNjMjWPIjHTuEQpw8cxk7XrbKNF2DJmY48jP
         OMXtozYtcQaXjwXQIh5dyupZ3vsYSgI3pgg54c3aV1P0/lVY5wsRWyr3OjpKpoupjlif
         xHeHXkQHHz9zloxEyG/49pm8yN6eRu4Z+6bll/V6pIjIYBC8iar5KFGGbanhuD827JQJ
         zLfsxwUt2iPe7PTqqrqNLFDdgeavsSr69K+zKE1VqxLJwY8YLHH6EfGDkXi7mK6UVC8H
         GX0VrV6IEWs24StfNrAtfWZrKGeTBhtsmuxiH/X7MuV+/Mw0FvM1uleEODvJNUFG722z
         1LEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=ZXkuoJN7DK7qQfm5r7ECOHzIgNY6d3HZTieo4WxgmDg=;
        b=r+3O5TZyPi2KMP6LEd0I7E4Te16tlJAh+h7DFW2CDjnp7XrTSD1EIZLsXDmX2Upwr7
         +/4tptHVT9yfZdfLNmZukUYVqT87bljRN/ftlzz+yeHLMyy36jWypVFMyum/rJHUmtCa
         brovkvjZquIfhrn07PoJbfAA7nNKfNiiNeuaeByYqVS0w8nJjcq2A2djMobF0B6fjPCy
         LlOHT5yzHVDsjrZwcVnrotF8WuDMVvqotOQe/Jl69poWTpJBniLxw+PSqYBtnIDqDl0x
         XB8vlEp7X5lBXBW0rmelmf1JsI5WjzckK3gBvqbU186hiZiqVp5FYTU24YuxU277N9Sp
         CuWQ==
X-Gm-Message-State: ACrzQf0KjPF6+yBZQd374Owa7AeHv64oRVoGHCT31PcARWL3gcP2jwIg
        k+8ikUPoutEiyZooFZB/RgRMEp4LB3XJbA==
X-Google-Smtp-Source: AMsMyM5/mw+f8DSISvPa79cGNBFPKxngRjSrKI07M17BHrjwAKNBmZT/eBpWILXqY0PAsnK6yyWCzQ==
X-Received: by 2002:a05:6638:300e:b0:35a:ab7a:4509 with SMTP id r14-20020a056638300e00b0035aab7a4509mr2787464jak.82.1663871287586;
        Thu, 22 Sep 2022 11:28:07 -0700 (PDT)
Received: from m1max.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id q20-20020a05663810d400b0035a468b7fbesm2440646jad.71.2022.09.22.11.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 11:28:07 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-block@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: [PATCHSET 0/5] Enable alloc caching and batched freeing for passthrough
Date:   Thu, 22 Sep 2022 12:28:00 -0600
Message-Id: <20220922182805.96173-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

The passthrough IO path currently doesn't do any request allocation
batching like we do for normal IO. Wire this up through the usual
blk_mq_alloc_request() allocation helper.

Similarly, we don't currently supported batched completions for
passthrough IO. Allow the request->end_io() handler to return back
whether or not it retains ownership of the request. By default all
handlers are converted to returning RQ_END_IO_NONE, which retains
the existing behavior. But with that in place, we can tweak the
nvme uring_cmd end_io handler to pass back ownership, and hence enable
completion batching for passthrough requests as well.

This is good for a 10% improvement for passthrough performance. For
a non-drive limited test case, passthrough IO is now more efficient
than the regular bdev O_DIRECT path.

-- 
Jens Axboe


