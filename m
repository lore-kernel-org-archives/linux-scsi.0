Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E6D5C4361B
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 22:18:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00FFA23D1F
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 22:18:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388372AbgLIWSm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 17:18:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731549AbgLIWSg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 17:18:36 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA7FC0613CF;
        Wed,  9 Dec 2020 14:17:55 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id b73so3315250edf.13;
        Wed, 09 Dec 2020 14:17:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UPUaOFp5NODFudWRtOd5GpcAPuCqh+JN0Y1v/v4qA4o=;
        b=ECg2MAuSAWKsmySaYm1/kgnyl5Bh8k6U1cZQOdfj43Hvsi97DKxGoewmv7Y54uKbd7
         N8L52HmOKay4OelU/0pYYnibquT/nCC3uQStwd8RyRDagqJdntnaJrA3/P2zXSOqu8Hl
         V6zfA88AqrigQx834MxVf94E6rDiTj3kLF/OCV0AQ1kOnToKr8ahA+rZRG3dbhp/kx1a
         IM+SWBkR8QDRyewxB+FcRKbJYYQGe6wmFeblz2JqGafA3fWPE4DudFCk6iP6BaKfBaCG
         xP21voQ/zdIi6H5Y04e8ROmm8FTo00uyZz109Hp0idqisajozDIGJ8w2MaQ8zB59EYmb
         eiwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UPUaOFp5NODFudWRtOd5GpcAPuCqh+JN0Y1v/v4qA4o=;
        b=S7jtayTyf+PY9lrRM/DEQ4Hsk0n1m9nAAV5Usb0u+zpojuSUC14FTjgwitbphauAWs
         ibfskexYMXeiux5Pb/VLxj1C36lqHwVo7NjviqOJFAwJJh1RaDyQGS45RwXj6RP1UGeF
         MNKmdtBAldnDaSVU58rHF1vFb0TzbBIJNtbpzXwlY2/cqQv0/mQCVq3R7tzASFF4D6WN
         xSvLLtEIVi2gvTFk+DiAVxKTEBxmxxfMARIciq5+63LFvGH5GOFzLktnBnuxvn0RREdV
         z52+cKIfTZlBbqtcRTxbzCF+jP2U7MmNm7HK3VMaLQfDGKe0Ksf5i4AI9T6hm2ygjgWm
         ORIg==
X-Gm-Message-State: AOAM532btNpmPrCtJliXS1Zr7EED1PrrnFNr86+pz0f1vBQsicbxZZsk
        8Qel+dTwGVlN804aUI90hPk=
X-Google-Smtp-Source: ABdhPJxPvkLtkpoJVjnKH+SulVeiCmEf7/igCoYl95Jz/H7ngG81JOJilo/oDvIU8kYnSJpUD95+TA==
X-Received: by 2002:aa7:c749:: with SMTP id c9mr4096239eds.3.1607552274324;
        Wed, 09 Dec 2020 14:17:54 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id u3sm2611973eje.33.2020.12.09.14.17.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 09 Dec 2020 14:17:53 -0800 (PST)
Message-ID: <48c1f368d7ce23abee32dce052d8e2a724a94d01.camel@gmail.com>
Subject: Re: [PATCH v1 2/2] scsi: ufs: Clean up some lines from
 ufshcd_hba_exit()
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
Date:   Wed, 09 Dec 2020 23:17:52 +0100
In-Reply-To: <1607497100-27570-3-git-send-email-cang@codeaurora.org>
References: <1607497100-27570-1-git-send-email-cang@codeaurora.org>
         <1607497100-27570-3-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-12-08 at 22:58 -0800, Can Guo wrote:
> ufshcd_hba_exit() is always called after ufshcd_exit_clk_scaling()
> and
> ufshcd_exit_clk_gating(), so no need to suspend clock scaling again
> in
> ufshcd_hba_exit().
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>

