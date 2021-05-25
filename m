Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5B93C2B9F8
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 19:28:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7AD76141B
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 19:28:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbhEYTaK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 15:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbhEYTaJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 15:30:09 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6998BC061574;
        Tue, 25 May 2021 12:28:39 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id w12so29825212edx.1;
        Tue, 25 May 2021 12:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=75Ks06KfSSPpj59wqT5+AJhX+CfpPc9kzdj5LvsQWiw=;
        b=svvJ8KLxm7v7XhkPXDu/85D+q9srvsXD0Nk4QdWz6di44zcR+CGg/SWo+Vku0xABPc
         kY+YdfpEEZvg8LYfQBvYHufE1xabHJZy1ssdSlqpBxB9LSJVn83UomkRgVwV+pNVuAh/
         aMqcLO5FUr1V+UzqiekdsjvUzKvqe+jU64Ys0VG4KhA/wN5UdcI1dUXR5Wyhw7V2ObY+
         4Nokaju+rctQYQ/XcEvIXKybnXcyaxDN7K5ta9TnKkQhKbC3jC5y2vRfBkkRSgGdoT26
         XB4WNFeqt2YTplmrk2C6kePyODG9g/rpM/CaapJ+hhJ0kHQ5hjGu7pIpqrGPfdecRzbk
         hxxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=75Ks06KfSSPpj59wqT5+AJhX+CfpPc9kzdj5LvsQWiw=;
        b=RHIMUf6NKoxeD49emq1dOeLC361LCwOj0SwSPvc3pzwPpyp8Q2/cHsZPx+TPVsw0Fr
         4tUokpAE0uaeSUqclEf1SJf8M4Q3wS2qTE4/mthaq2egQ/Pn4soGndzz2jMAjiHB/wyd
         PsujKeoKLahOgHfky/KuMPVYpGAgnxl/vK90GTe7jgFUzNf/ofLpD3Hla7OSxyimFZCw
         Rn2D/1EjSR/Oprt7sytVwkKZOSQH/cSXfXfnwkTO0FN8Y/TXPctkPZq//TULAMyALczk
         hVMI3Vq8mI7808cl2NJT3rVfIBunaslN+WWk6CElMAslF0N8iXT0N7uTRBTuy55nBjCt
         kvIg==
X-Gm-Message-State: AOAM533ULWO/trJ3Mk0C78G40j3dDJICP8vKqP58Tw1KplC/9VbGDq4f
        Mv5nS7eqVKQ4aXSj2oApjRs=
X-Google-Smtp-Source: ABdhPJxSYHD+fbJHJRqiTr2DOaX4XZdyd8dfJiksgDH0FbB8/hifaTzAku+sEK5rhVwGQ0f1F4LDig==
X-Received: by 2002:a50:fd13:: with SMTP id i19mr33694293eds.386.1621970917954;
        Tue, 25 May 2021 12:28:37 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.googlemail.com with ESMTPSA id dh21sm11292027edb.28.2021.05.25.12.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 12:28:37 -0700 (PDT)
Message-ID: <f285211d2b8ef2c9c3c01974c91b7b7439b0fd0b.camel@gmail.com>
Subject: Re: [PATCH v1 1/3] scsi: ufs: Let UPIU completion trace print RSP
 UPIU
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 25 May 2021 21:28:36 +0200
In-Reply-To: <628c0050-e3e2-033c-8a25-6fc04d4d5657@acm.org>
References: <20210523211409.210304-1-huobean@gmail.com>
         <20210523211409.210304-2-huobean@gmail.com>
         <628c0050-e3e2-033c-8a25-6fc04d4d5657@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 2021-05-23 at 18:24 -0700, Bart Van Assche wrote:
> On 5/23/21 2:14 PM, Bean Huo wrote:
> 
> > +             rq_rsp = (struct utp_upiu_req *)hba-
> > >lrb[tag].ucd_rsp_ptr;
> 
> 
> So a pointer to a response (hba->lrb[tag].ucd_rsp_ptr) is cast to a
> 
> pointer to a request (struct utp_upiu_req *)? That seems really odd
> to
> 
> me. Please explain.

Bart,

these two structures have the same size, and inside the structures,
the both unions have the same members(not exactly 100% identical). 

struct utp_upiu_rsp {
        struct utp_upiu_header header;
        union {
                struct utp_cmd_rsp sr;
                struct utp_upiu_query qr;
        };
};


struct utp_upiu_req {
        struct utp_upiu_header header;
        union {
                struct utp_upiu_cmd             sc;
                struct utp_upiu_query           qr;
                struct utp_upiu_query           uc;
        };
};

Use one point for response and request both, no problem here. It is
true that looks very ood, and very difficult to read them.

If this is problem, I can change the code, let them more readable.

how do you think?

Bean



