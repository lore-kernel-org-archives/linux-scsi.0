Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55748C352A1
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Dec 2022 03:33:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbiLFDdu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Dec 2022 22:33:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbiLFDdt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2022 22:33:49 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E1017AA5
        for <linux-scsi@vger.kernel.org>; Mon,  5 Dec 2022 19:33:48 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id x28so4345414lfn.6
        for <linux-scsi@vger.kernel.org>; Mon, 05 Dec 2022 19:33:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MpTOCNPoOGHImcyJ2epk+VnyvAQlwpT32RE+xjqo+ew=;
        b=iGbJ+Vkx4UC1HXpXrfqx1bnICBm9nHpXOT02dS8SU+BhM7NfrjsO5nGsFvhOhelmVO
         tEiqJrga0l7cTv3wIyqgEhjS6C9PYsHdr+V3rqqshutZNCYl3kgFvfBJKXwAeD/rwgQ3
         UQVsPCqdsUYvSqAs13E6fxqhplyTphB4hBcQ/pFmocZ8+6XveOQ2Q3bAcrDswWNVowGg
         yqHcaR1XCps4yPG/J9BtJKyE+5bG4VaRxvAl2hNV1UeCXvHCxtjVC+k1h4rDxuTn74sh
         OMhMpgUgTmE5cKgaNGelTdWf54yjsDIa2TKMNKhdTqbelnpKpudk9+1cSNe8I0gyRh1F
         lsHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MpTOCNPoOGHImcyJ2epk+VnyvAQlwpT32RE+xjqo+ew=;
        b=F0Gp62n/Q4PJZjq000Dw1YaXnEY9aI8u/mgLcp/tBh0cmQgL+8BbOMCv7MM+3JwmwQ
         st6EgRYVhoUd0DpRUIyGna7Wwnw0l2JUjTlkqlfDcgM+qQPeTssYjR/Eqo1+0BbadxFN
         muSX4o/cPar7p6An7UKWLYX4x5sSAs1phsE2T9YYgf/YdoRxrX0xNvMAFv7p9nJT5U8P
         G+Ydta5u41WbWw3QEGa8fYUbQ6AJ0CWCDpsP+PiXvhI7i7xZFZ0zXuM9DDsendaVONdw
         Ekij5w5Vq9euBcHbPvckyf+bwMLygEACLeh7e7LOH+jRUH/HRNWH8uZT9MhGC3cY8lSC
         DsOw==
X-Gm-Message-State: ANoB5pn57pxqij9KYeSRuKkjCcQ2+GoCykRO4jSnkz2x27CudZ+mGb8K
        TA/KJpKUV8V577nyR+dReqqj76cty8bqzXOK4Q==
X-Google-Smtp-Source: AA0mqf7BGVlmehyMTfuDhKwJMJE/OMgw+2TKeJBCjok2UWENOn/HbvnRAnoEddur3sdaSStyS3TDSLInFdY24rz3x8M=
X-Received: by 2002:a05:6512:104a:b0:4b5:6683:795c with SMTP id
 c10-20020a056512104a00b004b56683795cmr3309502lfb.101.1670297626335; Mon, 05
 Dec 2022 19:33:46 -0800 (PST)
MIME-Version: 1.0
References: <20221206031109.10609-1-peter.wang@mediatek.com>
In-Reply-To: <20221206031109.10609-1-peter.wang@mediatek.com>
From:   Stanley Chu <chu.stanley@gmail.com>
Date:   Tue, 6 Dec 2022 11:33:34 +0800
Message-ID: <CAGaU9a-e7CkOvQaSHJKR+zYx3YyTnKubS7o_O5SHj-tSqFKyCA@mail.gmail.com>
Subject: Re: [PATCH v4] ufs: core: wlun suspend SSU/enter hibern8 fail recovery
To:     peter.wang@mediatek.com
Cc:     stanley.chu@mediatek.com, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com,
        wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com,
        tun-yu.yu@mediatek.com, eddie.huang@mediatek.com,
        naomi.chu@mediatek.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Dec 6, 2022 at 11:18 AM <peter.wang@mediatek.com> wrote:
>
> From: Peter Wang <peter.wang@mediatek.com>
>
> When SSU/enter hibern8 fail in wlun suspend flow, trigger error
> handler and return busy to break the suspend.
> If not, wlun runtime pm status become error and the consumer will
> stuck in runtime suspend status.
>
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>

Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
