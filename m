Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ABC9C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 09:26:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2751A64E21
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 09:26:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbhBWJ0u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Feb 2021 04:26:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbhBWJ0a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2021 04:26:30 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F749C061574;
        Tue, 23 Feb 2021 01:25:50 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id hs11so33538829ejc.1;
        Tue, 23 Feb 2021 01:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oUeNxPejcwjb4n/U2d5bG02E83g99iYwUvLJIxb+5oc=;
        b=pUKfY99ijdQixF+dp0MdVO1AAJHWKhBI7ar7mBc0Im9Pz20HEUCe1flLy9AW8b6uEM
         h81edap9zaUv2iymLgXLzePqh4woAwuUo23+cRZ6bsfYOtq6wqafgjFvnJU7rbgGXhKz
         3mXqIkIAqFTwNTJXEztAwckCuQgRA1d7u94oFCnT2L0+S5/Ne7frOaJBKaS7HU7EWmeN
         xJF+anuZsRZo71ptAl6E/Icn/a2l4xeI2k2lma2vhbtjFI3Bk7X951TVPqCTmNyLJeJi
         T29LE0Yk19tSyOzy1phtdzm9rwXCu4+2GwDEOaAYQQCuWRMSB4ZTxPtFjex++TeykPy0
         LgXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oUeNxPejcwjb4n/U2d5bG02E83g99iYwUvLJIxb+5oc=;
        b=LKGJNQeMlOcRoIXa5XlM7npGirWt3le+bZCJzpRpratPzRlzQecgoycDoaZUE1adL/
         PvUZjhb7nY2n99FyiiOB9BhAFUbi2Ezey9PuprN4J5Zj3TMj/BHyYqTvWA17GGKYT5dT
         OFPxzZxhwpSXtStQPlNvOunmjHKSmQ8EkQwxrL4ySPS+bGRUbj6HbF9RPvtd2M1CCvAS
         ahMiWtLkpDh+0UIEj9jZLwsaUSPyLKIZdjHBiwul1vKfb18LTEhNkLQlK35C8+o79p5J
         aKCuvrPnBaOd4Oll+mZ+9Pd3cZzR7llxhakh9jQ55AMXcis7nMRNtBS/01aRXM0EV2am
         SeXg==
X-Gm-Message-State: AOAM530ONwwdAQCUcvLeGJlFnGW1hiYwSakUf3jpLnitxqzVz9ouys+1
        bgKg6eeMSAsVXFDYmgqNHYQ=
X-Google-Smtp-Source: ABdhPJzGcoDRhMVMarnqINrUfuxRAwoOJ7PIpNO//v7irRQRBr4qyi4bUF5mvA7Kwcx0gkJ6neKXIg==
X-Received: by 2002:a17:906:c82e:: with SMTP id dd14mr13635439ejb.102.1614072348981;
        Tue, 23 Feb 2021 01:25:48 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bec1d.dynamic.kabel-deutschland.de. [95.91.236.29])
        by smtp.googlemail.com with ESMTPSA id q16sm12085425ejd.39.2021.02.23.01.25.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 23 Feb 2021 01:25:48 -0800 (PST)
Message-ID: <d5393d50a2d7c4752828a5707a6225ff6ca62f68.camel@gmail.com>
Subject: Re: [PATCH v22 4/4] scsi: ufs: Add HPB 2.0 support
From:   Bean Huo <huobean@gmail.com>
To:     daejun7.park@samsung.com, Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Date:   Tue, 23 Feb 2021 10:25:47 +0100
In-Reply-To: <20210222093150epcms2p155352e2255e6bfd8f8d71c737ed05e76@epcms2p1>
References: <20210222092957epcms2p728b0c563f3cfbecbf8692d7e86f9afed@epcms2p7>
         <20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p3>
         <CGME20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p1>
         <20210222093150epcms2p155352e2255e6bfd8f8d71c737ed05e76@epcms2p1>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2021-02-22 at 18:31 +0900, Daejun Park wrote:
>                 }
>         }
> @@ -532,8 +870,8 @@ static int ufshpb_execute_map_req(struct
> ufshpb_lu *hpb,
>         if (unlikely(last))
>                 mem_size = hpb->last_srgn_entries * HPB_ENTRY_SIZE;
>  
> -       ufshpb_set_read_buf_cmd(rq->cmd, map_req->rgn_idx,
> -                               map_req->srgn_idx, mem_size);
> +       ufshpb_set_read_buf_cmd(rq->cmd, map_req->rb.rgn_idx,
> +                               map_req->rb.srgn_idx, hpb-
> >srgn_mem_size);

Are you sure here it is hpb->srgn_mem_size, not mem_size???
if not mem_size, why you kept mem_size??

Bean

