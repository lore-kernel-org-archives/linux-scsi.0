Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA86DC0015E
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jul 2023 10:42:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbjGZKmO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jul 2023 06:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233981AbjGZKmN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jul 2023 06:42:13 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15FE12129
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jul 2023 03:42:11 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-1bb73eb80e4so2028233fac.3
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jul 2023 03:42:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690368130; x=1690972930;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0TsJ83inhfD0tGVI2m5IEe3UXUGH/+4TQQBfORE3pLk=;
        b=aPgKD/ICUvl+hiZvYl0HHOUi4tKdj5lXWVTfImCJ1vYPHnvMLKeNTCSnNbAUD5lKHz
         GS8CVbDaZEFuw52jyRAlcinGT5j1ZMSA0MUsFIIRQn5w/L+8oEO4paSy3VDe5RypWkck
         /Pv1uQHCxuSxZRuz2jLndr76TB23Xzb+zIxmu30D1DYYhBr7SRs2XfCZgAwnmgM2wYTQ
         RugIgFmlUvYLlmzpQiQNB3MA9D26ViL2KUI9TTRAmYAmLLRbK2MO33k6QflptP70gu4x
         c/jo5K0pwbFLlIZjL+zzSwSfAm8RicUN8AEU2zSFGE1b+ZUQuTk7D+G5IvzIhlKDyXBe
         o+vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690368130; x=1690972930;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0TsJ83inhfD0tGVI2m5IEe3UXUGH/+4TQQBfORE3pLk=;
        b=IoCvZEWeGt2HAs3T1yt7bkV63hA+V76mUs3Ue3Aj340fqyr2t340nxkj+LNXk/rERe
         SxiFS615M3jozOkDo54lGV9ug7f/FXRA3liPjjxNhwCjeAAS5BvacUEPDi0JyYHG2JOO
         7HDNC02NnAbo88lS/tdZNZijPMrx8aDgM221XYyO8hjmVEEs3dfOTRNmT5riY9ZgvRqK
         QaNOJbMEMzYdbVgFg7TnVi+z9khFQdYqboAEzwiJlU+SF0D7+uOrr9FXe6gpW1iRQeSU
         UoqtZmI9TOcCK3K7IqGwc5qBMP5cWZUtmBHFUtY+XYuW3UcdzcwBVnzQUgc4rfH3xLrR
         4wCQ==
X-Gm-Message-State: ABy/qLZMqkK3H5kx8U5iYmizosuO6OfXq8xI3zz9SooY/n3Uv05iIhNR
        qt1/vugyw4q1cgoeDOETRZiP8w4pBa73r2T67ishok3IUGc=
X-Google-Smtp-Source: APBJJlFS7OU+eOw5TMiO97SVv44H8gNLcxVPXlo3f62k9kmZWwPj5qWGuceo9DuSMRhUTLuURmqYOms6G9Ipu4a3Q0g=
X-Received: by 2002:a05:6870:b295:b0:1bb:8867:f7ef with SMTP id
 c21-20020a056870b29500b001bb8867f7efmr2187411oao.25.1690368130295; Wed, 26
 Jul 2023 03:42:10 -0700 (PDT)
MIME-Version: 1.0
References: <20230724132303.19470-1-ranjan.kumar@broadcom.com> <yq1v8e7zds0.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1v8e7zds0.fsf@ca-mkp.ca.oracle.com>
From:   Ranjan kumar <kranjan.kernelbugtrack@gmail.com>
Date:   Wed, 26 Jul 2023 16:11:59 +0530
Message-ID: <CA+Uq_0xh5DSKEKgvY4prqHa+Cc97o-FLWVjw_UePPC7tJ-ddSQ@mail.gmail.com>
Subject: Re: [PATCH v1 0/6] mpi3mr: Few Enhancements and minor fixes
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Ranjan Kumar <ranjan.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org, rajsekhar.chundru@broadcom.com,
        sathya.prakash@broadcom.com, sumit.saxena@broadcom.com,
        chandrakanth.patil@broadcom.com, sreekanth.reddy@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

On Wed, 26 Jul 2023 at 06:53, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Ranjan,
>
> > Few Enhancements and minor fixes of mpi3mr driver.
> >
> > Ranjan Kumar (6):
> >   mpi3mr: Invokes soft reset upon TSU or event ack time out
> >   mpi3mr: Update MPI Headers to version 3.00.28
> >   mpi3mr: Add support for more than 1MB I/O
> >   mpi3mr: WriteSame implementation
> >   mpi3mr: Enhance handling of devices removed after controller reset
> >   mpi3mr: Update driver version to 8.5.0.0.0
>
> When you repost a series it needs to have a new version number. So v2 in
> this case. And you need to include a log of the modifications made since
> v1 so we don't have to re-review things that haven't changed.
Thanks for the feedback . I will take care of it in future submission.
Thanks & Regards,
Ranjan
>
> Thanks!
>
> --
> Martin K. Petersen      Oracle Linux Engineering
