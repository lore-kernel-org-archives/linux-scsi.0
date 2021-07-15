Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46E43C07E96
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Jul 2021 10:38:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23C09613C0
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Jul 2021 10:38:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240493AbhGOKkx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Jul 2021 06:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239274AbhGOKkx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jul 2021 06:40:53 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375D3C06175F;
        Thu, 15 Jul 2021 03:37:59 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id y4so5699232pgl.10;
        Thu, 15 Jul 2021 03:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=ntQ1APPK8FylP7HkBMgBjaeIri+5h5z88dbUY111u7w=;
        b=uPdvDNnvsGmOyRZ0zjAGTdsRDuLGGqDIuDnbC6y/8wYxadMbj5Dww+UOJeJdpIZftn
         8PjNFRYtwdrgm7SLnvqDsZrfT4PkWn5EXBoDfTeBkLHiks62g6XKjeJ6nL+p1CxXX0ha
         K7Rp9XOCsKDFuZwN0HnxRIZyS+oCHNkSnLM4t8b8WabDnxmiC+LyomL1XkomOVvRRb/5
         M+xkUYj/KQop5yRg4mwSw7HEJd3A7nBvILaRzL2+sBokRwqMfZIlB/urM+chDM5vOJAY
         fTAZhhhwYxIp8CAr9+qMaDjX/kudoOMlLZaKZewLT1UyC9JtDXQZeHJoVGvCqISQQ+i3
         BWKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=ntQ1APPK8FylP7HkBMgBjaeIri+5h5z88dbUY111u7w=;
        b=FRN8/iMbceKhuUCgeFFn3wr4I0ID8/SqJ7Z+8+HnjEm1OwSseVouTSf7AK/zb7OAGt
         o9D75K/TVeQjgff9iDzxJ1ZF6nuC+xpfwNCM9dslHxBQeFdox2olmnhtRhIPxrpfP3TX
         QUeEEt1oCcsRTrIZ4hArdDvDsnV05ptc07ka+LbOSwq9kuFmwlwyOR6fSgrd7OX24ji3
         8J5XOELhZByzpV1D+aYrts8W1a24CzmYP3QMDutNKoaB+ZsUA0YNMyUgwS73Lp18Lxoa
         4nrmBU7WgQOEV1GGMiAqoCGCrnfYCUDM75poADeEeXGEJicNCHWkwLaH/sOg8w7wOYQw
         rlgg==
X-Gm-Message-State: AOAM531l5I05mF6m13+1vwq6vXxqpIbSHqi3YsbqwkS/0mKs9FcCwVwj
        lY/K7vojqPKjhLv21e2cTcxLSgR42jo=
X-Google-Smtp-Source: ABdhPJzFuC2zr0nJxXz8s4fLNjSe1chatHzhno70VIcf4npN+7SdiSbekePhgTDM232EYGd0izrY/g==
X-Received: by 2002:a62:ea1a:0:b029:329:a95a:fab with SMTP id t26-20020a62ea1a0000b0290329a95a0fabmr3948860pfh.31.1626345478421;
        Thu, 15 Jul 2021 03:37:58 -0700 (PDT)
Received: from [10.162.0.26] ([45.135.186.83])
        by smtp.gmail.com with ESMTPSA id l188sm1011131pgl.93.2021.07.15.03.37.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jul 2021 03:37:57 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [BUG] scsi: lpfc: possible ABBA deadlock
To:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <652256c8-6fce-a506-76a9-e1502a5ff82e@gmail.com>
Date:   Thu, 15 Jul 2021 18:37:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

I find there is a possible ABBA deadlock in the lpfc driver in Linux 5.10:

In lpfc_nvmet_unsol_fcp_issue_abort():
3502:     spin_lock_irqsave(&ctxp->ctxlock, flags);
3504: spin_lock(&phba->sli4_hba.abts_nvmet_buf_list_lock);

In lpfc_sli4_nvmet_xri_aborted():
1787: spin_lock(&phba->sli4_hba.abts_nvmet_buf_list_lock);
1794:     spin_lock(&ctxp->ctxlock);

When lpfc_nvmet_unsol_fcp_issue_abort() and 
lpfc_sli4_nvmet_xri_aborted() are concurrently executed, the deadlock 
can occur.

I am not quite sure whether this possible deadlock is real and how to 
fix it if it is real.
Any feedback would be appreciated, thanks :)


Best wishes,
Jia-Ju Bai
