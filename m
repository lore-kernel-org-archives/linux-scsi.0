Return-Path: <SRS0=xqUt=CC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA398C433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 08:42:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98AEA2075B
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 08:42:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ermSDjEO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728907AbgHXImD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Aug 2020 04:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728902AbgHXImA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Aug 2020 04:42:00 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F35FC061573;
        Mon, 24 Aug 2020 01:42:00 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id b2so7308333edw.5;
        Mon, 24 Aug 2020 01:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=voyHwITvq0wBrEVy8zw4YRZx8e/OMXcyqakQHvKeh/0=;
        b=ermSDjEORxns3jhdPPECRpUY4VjiYyjh8zO6N8AMfuuBeGJg3j99euRppSQLVxs/dw
         8kgXi0mzu/qkUDmYgW9YF5E/I5si611wq/vMMv7MDUhaNGtZCqxPrnHYoQsE5dbFSGO3
         tBMakxKoQtoqEswQq7IHzRHirRI8Vsux04uu7dUYVh8i+tGRgYsx1Kz7wuDg5r/jrjWz
         PPLYoRErbe+xmTj0TEcA/sKd3gnX1IE93yzDFDU9qcMfKSdWK0lJulc0wBot6oHiI9P+
         7EJdHiGbxauhLFUqUhyk5uA40IWnpWS8EW7NpnDBiIkudWCG6aslw1I2wHtw5sbo1wPR
         e7iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=voyHwITvq0wBrEVy8zw4YRZx8e/OMXcyqakQHvKeh/0=;
        b=qM82Q+ZAZNuKStmEkeAaRoh8OpyYh0oq+52MvlXjvb9qAVkW8fpiYOOs7TNc6zrVmj
         YvnM7U5ek1T9G4drLeM9F2cWg2ziMTCrja9K7gFflTV3Qc+77SCyBNfUhCFitXnJo6tw
         gpQeFGP+vWChwU/AcKJpbuYhwoIT4sA69HeQEkCk8GrK18sJHaXhJB5eGTLyeg/k/2Cw
         5T05prt4Rft9czrSKqc03iV2aYebNd6s1HfXoirzYeudG0P+qD2SOz7nB3tW7Y9r4YB5
         IWbAEeMQWCPdOuMgA77sMqpLvAGu3TtsaaMGYqF08MfrGSsqr+h+nCxIlWNEyy7PDgd9
         gnww==
X-Gm-Message-State: AOAM532e1O3ahti0e2w2Lz7ueMmFsSHPJj1xIU0mZ1upzC5e/i99keOc
        N7ouKYYUuNbLjBfEZK4tQpwUvHwkwPk=
X-Google-Smtp-Source: ABdhPJw6lViolyBYiuU6fE0J2sX1K/TXzR7Bu+m8X17rLlN7OTdukidPQF+5yeKTubWw25iOt0FfJw==
X-Received: by 2002:a05:6402:6da:: with SMTP id n26mr4452755edy.262.1598258519203;
        Mon, 24 Aug 2020 01:41:59 -0700 (PDT)
Received: from ubuntu-laptop ([2a01:598:898a:234e:1d41:83f0:a723:a7e3])
        by smtp.googlemail.com with ESMTPSA id f10sm6987edr.18.2020.08.24.01.41.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 24 Aug 2020 01:41:58 -0700 (PDT)
Message-ID: <6a4c297fba9a393c3f472ab443f8cb59b800e2b0.camel@gmail.com>
Subject: Re: [PATCH v2] scsi: ufs: Remove an unpaired
 ufshcd_scsi_unblock_requests() in err_handler()
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Mon, 24 Aug 2020 10:41:50 +0200
In-Reply-To: <1597798958-24322-1-git-send-email-cang@codeaurora.org>
References: <1597798958-24322-1-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-08-18 at 18:02 -0700, Can Guo wrote:
> Commit 5586dd8ea250 ("scsi: ufs: Fix a race condition between error
> handler
> and runtime PM ops") moves the ufshcd_scsi_block_requests() inside
> err_handler(), but forgets to remove the
> ufshcd_scsi_unblock_requests() in
> the early return path. Correct the coding mistake.
> 
> Fixes: 5586dd8ea250 ("scsi: ufs: Fix a race condition between error
> handler and runtime PM ops")
> Signed-off-by: Can Guo <cang@codeaurora.org>
> Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
> Reviewed-by: Hongwu Su<hongwus@codeaurora.org>

Reviewed-by: Bean Huo <beanhuo@micron.com>



