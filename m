Return-Path: <SRS0=+pcl=63=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5806C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 13 May 2020 21:38:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFF142054F
	for <linux-scsi@archiver.kernel.org>; Wed, 13 May 2020 21:38:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Xee2M7/Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729220AbgEMVi2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 May 2020 17:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729098AbgEMVi2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 May 2020 17:38:28 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A41EC061A0C
        for <linux-scsi@vger.kernel.org>; Wed, 13 May 2020 14:38:27 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id g9so608948edw.10
        for <linux-scsi@vger.kernel.org>; Wed, 13 May 2020 14:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=YPbX1ZNJRcylqfx7sAoZDvfRra3igVWq/9EE6LO6mqw=;
        b=Xee2M7/ZLNd30rkkzUryraJ5US3ZRBC0ylfRA8sTT68UQDkQiHRjcBKKHLCWdipUZB
         Gp0WrBLBHkHIqMaTvVKgqhR985ca4TTJNm59r+3U4w8cRe4MQSewFmYzrdw+Mlz8K4qK
         n8JdloJY9TTBqYFfa5Ud716vy8IqSqvNBoL8M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=YPbX1ZNJRcylqfx7sAoZDvfRra3igVWq/9EE6LO6mqw=;
        b=HQ5bL4Jm2tntXA0GoKiAxi1ANDLJwB3iRZhSk4JkW4iahOCK9zFHgWYTyEcGMvqYes
         A1ZCow91I8c2jMpOKXVp0fY5cG0X+j0pz6xwKXROMWPBMGFWAwbMdiTW9tPKJNpngqf+
         OPGpBiq8H8ZWeTF84/qCElZHQT+82giKU2g+R1FT7qj+yWJs4p7DGpDxHa+y5vWklz2F
         szHG+YGqKYuxAPc+kF+//u4asITmy1wnAyZuxYmGGOT+pxqBGZpW3zfdyttD9GdAZf6G
         dgbpxb2DFgXhE2Lri9QtACRmHhKTVNsFluzNizlE6bvM+83NainiJNrm1kZ6bO3+RIWo
         fnbg==
X-Gm-Message-State: AOAM5322tPjfatJE5YIdvjVtFcOK8DkRc6D2dslYMYe4c4VrRuQYazZy
        S7+aqh8dhC3ZPgIuo6MeXryOmv5sZ46dMG3XEPF/pA==
X-Google-Smtp-Source: ABdhPJwLLBe9dc+fDdzy8iZvrAHzbPEe8CxES2L2++XrKkN8gm5N6gqZsjYdtwKoc2V9f72cuoc0tYBrlZnaxT00mnI=
X-Received: by 2002:a05:6402:2293:: with SMTP id cw19mr1426496edb.351.1589405906197;
 Wed, 13 May 2020 14:38:26 -0700 (PDT)
From:   Chandrakanth Patil <chandrakanth.patil@broadcom.com>
References: <20200508083838.22778-1-chandrakanth.patil@broadcom.com> <yq1lflx3ja5.fsf@oracle.com>
In-Reply-To: <yq1lflx3ja5.fsf@oracle.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQH3mVWICmFH6tkzZj2zVdzLuN4duwG5mIEpqFXXZlA=
Date:   Thu, 14 May 2020 03:08:22 +0530
Message-ID: <6c1141d113401b444bd099df7846e521@mail.gmail.com>
Subject: RE: [PATCH 0/5] megaraid_sas: driver updates for 07.714.04.00-rc1
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Kiran Kumar Kasturi <kiran-kumar.kasturi@broadcom.com>,
        Sankar Patra <sankar.patra@broadcom.com>,
        Sasikumar PC <sasikumar.pc@broadcom.com>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        Anand Lodnoor <anand.lodnoor@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Sorry for the inconvenience. I will make sure this doesn't happen again.

-Chandrakanth Patil

-----Original Message-----
From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
Sent: Tuesday, May 12, 2020 9:19 AM
To: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org; kashyap.desai@broadcom.com;
sumit.saxena@broadcom.com; kiran-kumar.kasturi@broadcom.com;
sankar.patra@broadcom.com; sasikumar.pc@broadcom.com;
shivasharan.srikanteshwara@broadcom.com; anand.lodnoor@broadcom.com
Subject: Re: [PATCH 0/5] megaraid_sas: driver updates for 07.714.04.00-rc1


Hi Chandrakanth!

> This patchset contains few critical driver fixes.
>
> Chandrakanth Patil (5):
>   megaraid_sas: Limit device qd to controller qd when device qd is
>     greater than controller qd
>   megaraid_sas: Remove IO buffer hole detection logic
>   megaraid_sas: Replace undefined MFI_BIG_ENDIAN macro with
>     __BIG_ENDIAN_BITFIELD macro
>   megaraid_sas: TM command refire leads to controller firmware crash
>   megaraid_sas: Update driver version to 07.714.04.00-rc1

The threading was messed up in this series and both patchwork and b4
failed to grok it as a single patch set. It looks like your mail system
somehow broke it up into multiple submissions, each with their own
threading and cover letter.

Also, several patches had incorrect attribution. If a patch was not
authored by you it needs to have a From: identifying the original author
(Sumit, Kashyap, etc.) as identified in the first Signed-off-by: tag.

I fixed things up and applied to 5.8/scsi-queue. But please look into what
went wrong when mailing this series. While I can edit my way out of
incorrectly threaded submissions, the build robots and code checkers can
get stumped when something is broken up. And therefore there is a chance
that the patches didn't get full build and code analysis coverage.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
