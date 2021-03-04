Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7328C433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 08:14:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8562964F09
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 08:14:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236340AbhCDINt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Mar 2021 03:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236328AbhCDINe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Mar 2021 03:13:34 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6170FC061574
        for <linux-scsi@vger.kernel.org>; Thu,  4 Mar 2021 00:12:53 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id dm26so10003183edb.12
        for <linux-scsi@vger.kernel.org>; Thu, 04 Mar 2021 00:12:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bvuWuQfLZ/V1PP4bIjmySBmnABuubpHMXG4v7FSa2ec=;
        b=XVWZd1a7SKhWyStuj/Q6X1UzDHOTU3EmzOLTF+zmWQgB4bjv9CEvkRL72SwzGbutvJ
         eAwFsA590lKEe3RMyd7oVOK3vrJF81bAMg7txOBpLuSaCkF03M4/TwdUX9BVhc+SBNp5
         NGddRSM62I1uI/oEGuXoJv7yRwnMoonO/QJA+r+aSn+CvuBJfMSdm73HHaQB4NXpQ2YR
         W36wuu/wJUuV/KNsOKo6OLso9J1k+apknxAaEKGndtLxLDBPtcGQFdLGjCU+ZaGxr3yO
         WikeyDsjXpQFSIIL+FG2zy0Rkb2uRkA+HQmY9sfGSjwPdZACcZToHfCprHpLtCWYBkBC
         QeGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bvuWuQfLZ/V1PP4bIjmySBmnABuubpHMXG4v7FSa2ec=;
        b=XJ5Z675m332AXfc1HleJwW2QqXz0Mgar8o0ypKMPmOZ/ZRx+8t3J4R18Imh6ksIScB
         kT6Keb2Lo5INAgOXAq9GW/LKtQ4YauGWjH1ALsl3kZxKHlFEfq02UVTVfIUCBeCcxvHy
         p3QLdPSgLva4n9Q92Uz4peDmg1U3rHiRtEml98U+T+ZJAmnhu01wb1Z7/rYCdyUfbXXx
         tMhzbJakdNBNcSWsHJLgASz5Ef7+trcfAPbiYhlZxCeE8bfUIk28tAY0PxvVKN+YFz2W
         5LLAkN44G8gjbVU4+giVw27ogu5nZPtLc0OcOo24g/HdD5IIfuKvFxq6FZa0lnsLU2Tr
         VvCQ==
X-Gm-Message-State: AOAM533tvDtIHNSYkmeb0sJ18WEAoBKd7Z40SwBge5Ly5b+3xpXEQIby
        9sJueS1PfUFatwcNiTtQ9EESNM6Y8J6wRkp0A0cQHA==
X-Google-Smtp-Source: ABdhPJwn6kXQqyrX50ZR1mVJfAfueaOrvVykUzclvyeJiOYmZthjEC95emS8qzYoXt4NecAQpEfXIVtNmR8eVEIjci4=
X-Received: by 2002:a05:6402:c:: with SMTP id d12mr2992014edu.100.1614845572093;
 Thu, 04 Mar 2021 00:12:52 -0800 (PST)
MIME-Version: 1.0
References: <20210301181847.2893199-1-ipylypiv@google.com>
In-Reply-To: <20210301181847.2893199-1-ipylypiv@google.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Thu, 4 Mar 2021 09:12:41 +0100
Message-ID: <CAMGffEmr7Q8_xvZRgJOyBBWF8g+hdLFWhLWTqn_BgOgGM6hq0Q@mail.gmail.com>
Subject: Re: [PATCH] scsi: pm80xx: Remove list entry from pm8001_ccb_info
To:     Igor Pylypiv <ipylypiv@google.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Vishakha Channapattan <vishakhavc@google.com>,
        Akshat Jain <akshatzen@google.com>,
        Jolly Shah <jollys@google.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Mar 1, 2021 at 7:19 PM Igor Pylypiv <ipylypiv@google.com> wrote:
>
> List entry is not used.
>
> Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_sas.h | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
> index 039ed91e9841..9ae9f1e61b54 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -281,7 +281,6 @@ struct pm8001_prd {
>   * CCB(Command Control Block)
>   */
>  struct pm8001_ccb_info {
> -       struct list_head        entry;
>         struct sas_task         *task;
>         u32                     n_elem;
>         u32                     ccb_tag;
> --
> 2.30.1.766.gb4fecdf3b7-goog
>
