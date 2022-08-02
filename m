Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D6B4C00144
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Aug 2022 03:20:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233836AbiHBDUW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Aug 2022 23:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232090AbiHBDUT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2022 23:20:19 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0B82662
        for <linux-scsi@vger.kernel.org>; Mon,  1 Aug 2022 20:20:16 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id i62so20063732yba.5
        for <linux-scsi@vger.kernel.org>; Mon, 01 Aug 2022 20:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E0RRsjoUyem/Uu6X8omWbmsj/Rtm7+eGWCw7Bg5wOuk=;
        b=fJfp67jot0JG7C9ufb0tEJZH2wfzDUaQhd+8KHwzRqYFr3b+slwkXVhS7A5677iBte
         yoyvZ7FNGiJJS1hHre8mX7otvQ8fhp7BOv7LoBNMve+fbsDvPeTPtJnCJc+rSF3kQnyV
         94Gmr5ANWthxdPgsvStd5CIg0UZegP8tQqfIg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E0RRsjoUyem/Uu6X8omWbmsj/Rtm7+eGWCw7Bg5wOuk=;
        b=Nub0ABmQ0YGm1H55wlMGLJlr6FUGUruXS6MBvJZO6wnuR9l0TFJc33bQyjcdWJ6Uad
         ll8RV5N2EebFNjjx7F7oflcvuxZl+79vMm0hbsLyYLbzP2uXBwuvRmPIe7mI0FANwD9/
         LdedWPIIqdXGZZJOHthjDZqiErN9OK0C77cUBdrxbLOpY/gBE8DWQgPYHd4QnXe/qJo+
         ITk76KHYd9dwMf/GuIQDxbTbikd98pHpr6jgUE/x+/cMuZbky50ked6P+bipjVCWdS7F
         DPd9dU2i+5pZ2yab40Lun1WHrI/qzEU1VoNhhEQRJ3EIPQkPRtB4DKbxPxe4X86MOla9
         Gxow==
X-Gm-Message-State: ACgBeo1sNGlUPmppbwufmlrAr7h6iOIm6JMIo17BBp2TJzE43/8fnOFA
        PlTGtEy0nTFeQRytcn6qIz3QNMuhUQ/1kpm9gm1Mcw==
X-Google-Smtp-Source: AA6agR45GVkAIWzB395IwGRNxzpFkXaVilMwK8OytxnFjfxML6ca852d/ZTtoG6iW2/mTgBoX1AwOX+HoHm4VVBsVuM=
X-Received: by 2002:a25:7cc2:0:b0:677:5a84:9f79 with SMTP id
 x185-20020a257cc2000000b006775a849f79mr4142817ybc.518.1659410415884; Mon, 01
 Aug 2022 20:20:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220802103643.v5.1.Ibf9efc9be50783eeee55befa2270b7d38552354c@changeid>
 <c4acb34f-7bba-336f-ddfc-a9c098f2c95f@acm.org>
In-Reply-To: <c4acb34f-7bba-336f-ddfc-a9c098f2c95f@acm.org>
From:   Daniil Lunev <dlunev@chromium.org>
Date:   Tue, 2 Aug 2022 13:20:04 +1000
Message-ID: <CAONX=-cAW5UX__xu5y7NdtHkZq-YWmh_k=iFa5witdxw3xXkYA@mail.gmail.com>
Subject: Re: [PATCH v5] ufs: core: print UFSHCD capabilities in controller's
 sysfs node
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Keoseong Park <keosung.park@samsung.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sohaib Mohamed <sohaib.amhmd@gmail.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Is the "capabilities" directory a directory with capabilities of the
> host, with capabilities of the UFS device or perhaps with capabilities
> of both?
I would say effective capabilities of the controller-device pair, from the
semantic that hba->caps field presents. Do you want me to mention it
anywhere?
Thanks,
Daniil
