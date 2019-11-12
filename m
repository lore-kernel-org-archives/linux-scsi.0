Return-Path: <SRS0=nPvI=ZE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DD01C43331
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 01:08:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 383C5206C3
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 01:08:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rroV+ecl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfKLBIE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Nov 2019 20:08:04 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:33223 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbfKLBIE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Nov 2019 20:08:04 -0500
Received: by mail-il1-f194.google.com with SMTP id m5so13988142ilq.0;
        Mon, 11 Nov 2019 17:08:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IC9ayxLDS2fylW4K+8GP3+8qi+D0oVuUCRrXm2+nZNY=;
        b=rroV+ecl5sM+RCaQSfhRMmte4ZG8Ug6KGF3hOvd7b6j6UpOXPJptOjGciTX1ymruQk
         lAaxBgjRa9yyqw87XYELKn9m1tj84GAURzbX1vGvti0uQrwPZCq48/zmXUyD+BxDP97l
         vGVMpU3ITB/S4yS7Z9m4xwwiWltruasGawP4YW3W8bwt80o2DeB9SakEbXGLRFsGiZlA
         pD+1UvKWN3mD/rGDhCew5u6K8Upd9sGREpxkUwfgWB3UdPV+o8pMVTQizGZuqHE6O3cQ
         pe2/OeGZ64GdmTq+XFL5ftDGm7OrK28H3D/VlwjxTdboDsif/fUxZhurNPQbM+a2Nd6l
         EQSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IC9ayxLDS2fylW4K+8GP3+8qi+D0oVuUCRrXm2+nZNY=;
        b=bPy7QN7/WZPY+ofxrJ9y3Wt6JiB6AViSG+Ahd3iewxXY/zV199FdZY8YAL/BGOxybO
         ELGsv0uNpCav1DTHJkjH4Bk5kYGcjrrY8YYxTvH8GXkcKWkOakjTLBqtCglWJjXpW6Vl
         y5Nns6qbkAJpb6oYf52aTIzH5nwI99ShRhe7/wM/5l319e55y5DqABDlkeOeVXPIM9Ks
         q55Pm21df1kAGdorpaWtUsSxyzrL+4yotZn5JBDmS55hxoDoBluAHumROmY6/rg2OT+F
         CTO4JoM4sW1ApKcUMUEs6skP3hpJPzWJYoDzqXKBDY5vZFM1FVndXRIL0nPG8rfp4TMT
         LtRA==
X-Gm-Message-State: APjAAAUiEFqVCvF4RGEhdvwkrAfC+PkkoZaJgO15GenN3k8nMXC1/BBD
        /gUGz3fx6g7pWcaxik5ZLzRGGkWqNtEi59sLL77uUg==
X-Google-Smtp-Source: APXvYqzl5hT3aUqRJCJnIVXehX99G3T3Akb+SYNDVYFOFytvELLAVB9ThBhwrsy6L9WTc09HtYxYCvgciO/j/N0WVCw=
X-Received: by 2002:a92:16d4:: with SMTP id 81mr34044620ilw.198.1573520883421;
 Mon, 11 Nov 2019 17:08:03 -0800 (PST)
MIME-Version: 1.0
References: <BN7PR08MB56840512CEBCDD2A1194F7F5DB770@BN7PR08MB5684.namprd08.prod.outlook.com>
In-Reply-To: <BN7PR08MB56840512CEBCDD2A1194F7F5DB770@BN7PR08MB5684.namprd08.prod.outlook.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Tue, 12 Nov 2019 06:37:27 +0530
Message-ID: <CAGOxZ53VowHTr4vubs4_GQE0drCTkf2iht=xt7dbeSKYGwdtHg@mail.gmail.com>
Subject: Re: [RESEND PATCH v1 0/2] Two small patches for UFS
To:     "Bean Huo (beanhuo)" <beanhuo@micron.com>
Cc:     "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bean

On Tue, Nov 12, 2019 at 5:53 AM Bean Huo (beanhuo) <beanhuo@micron.com> wrote:
>
> Bean Huo <beanhuo@micron.com>
>
> Resend since ver.kernel.org rejected @outlook.com.
> Hi,
> Here are two small patches, one is to fix a potential bug which could
> chase system hang-up, second one is to add more helpful debug hint.
>
> Bean Huo (2):
>   scsi: ufs: print helpful hint when response size exceed buffer size
>   scsi: ufs: fix potential bug which ends in system hang-up
>
This series looks good to me, feel free to add
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

Thanks,

>  drivers/scsi/ufs/ufshcd.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> --
> 2.17.1



-- 
Regards,
Alim
