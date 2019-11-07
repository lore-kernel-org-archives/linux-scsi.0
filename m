Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C4C7C43331
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 18:59:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 066B62085B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 18:59:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=unipv-it.20150623.gappssmtp.com header.i=@unipv-it.20150623.gappssmtp.com header.b="iPZ79ADk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfKGS76 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:59:58 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:37753 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbfKGS75 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 13:59:57 -0500
Received: by mail-ot1-f66.google.com with SMTP id d5so2970052otp.4
        for <linux-scsi@vger.kernel.org>; Thu, 07 Nov 2019 10:59:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unipv-it.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rgwxQZHa6ldii1pWiRxVyykr5nSYdGqgGsnTVFnT84Y=;
        b=iPZ79ADka3j4nmgFew4aV8GDcZgyEwjLMdxp0Mh5gVImbZONvzSBW9L1sDFI8fDn3H
         tnob8FIWxwGjDxp9eXuUAyD7X+O9J00fk8t56cyUl1HBcq0UNvZEFDD7/H+/lhhzvKYj
         SgIFewwBSBs+CRZJu4aSqVjtbsfPz4Ia4NSA5kd8fqnHx+ad24lm/tMPtATyuujAgPXh
         1XKicq1x1Q5xCLuAe65ljYXBxTPoh9Q9cqz2zM2+OCgrTkmSh/OTID/oUW0ztm5864wN
         wN4GNgZiZRtRUKL6RJ6zJRdQh59WYXHqXthL1ObImv7honOLN59FTmXsawrwD0Dyt9e/
         vpFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rgwxQZHa6ldii1pWiRxVyykr5nSYdGqgGsnTVFnT84Y=;
        b=TXsJX5Mx15Tgwh+qhT90SiqDgUAU/TL8veTy/sV36sM1c52map5SMzef8qWr46EW1N
         +kzhoa9YSmoT6NqqdshSpNgBRos4cWs5Jq9vIpf5Qn0JdJxY0NmZomnxaqRk2RWfyopY
         dEzIkBooBn2iBzCt5TrMliTK6z2qvyNq6bpTlo7TkBkv/7X2y83bzBz8/xS7f0JmKAGE
         3mPd7sEj0OXP+UcSCSLS5KXyMIf1SfXofACdoJSh6G8DmHfEObrt9kxbbPrfGo9EdrQT
         jxEOmyyVjVQs4R4L9gTKznrHABAHWO3acZaDIydTnlwd7KThvtnqdtPDoNkfHPMa+PR5
         Ch2A==
X-Gm-Message-State: APjAAAWtQQ43U+GKKa+SVYF849HqGCzUISEonvvMqzq+gzBlJ9dgtYgL
        rqjj/qQCLzNU8ZFTVImhY3suqVekKvKBKdHq5/KyjA==
X-Google-Smtp-Source: APXvYqzZ2xDwFA4+o+16DbpXyR0jc2MOPlP3+u/QTC5jyvI5FJY3d9mHmZ9im0K4MWchyT/eP41C3qrbM2OhGj3lIpU=
X-Received: by 2002:a9d:5a0f:: with SMTP id v15mr4513902oth.266.1573153195073;
 Thu, 07 Nov 2019 10:59:55 -0800 (PST)
MIME-Version: 1.0
References: <Pine.LNX.4.44L0.1911061044070.1694-100000@iolanthe.rowland.org>
 <BYAPR04MB5816640CEF40CB52430BBD3AE7790@BYAPR04MB5816.namprd04.prod.outlook.com>
 <b22c1dd95e6a262cf2667bee3913b412c1436746.camel@unipv.it> <BYAPR04MB58167B95AF6B7CDB39D24C52E7780@BYAPR04MB5816.namprd04.prod.outlook.com>
In-Reply-To: <BYAPR04MB58167B95AF6B7CDB39D24C52E7780@BYAPR04MB5816.namprd04.prod.outlook.com>
From:   Andrea Vai <andrea.vai@unipv.it>
Date:   Thu, 7 Nov 2019 19:59:44 +0100
Message-ID: <CAOsYWL3NkDw6iK3q81=5L-02w=VgPF_+tYvfgnTihgCcwKgA+g@mail.gmail.com>
Subject: Re: Slow I/O on USB media after commit f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

[Sorry for the duplicate message, it didn't reach the lists due to
html formatting]
Il giorno gio 7 nov 2019 alle ore 08:54 Damien Le Moal
<Damien.LeMoal@wdc.com> ha scritto:
>
> On 2019/11/07 16:04, Andrea Vai wrote:
> > Il giorno mer, 06/11/2019 alle 22.13 +0000, Damien Le Moal ha scritto:
> >>
> >>
> >> Please simply try your write tests after doing this:
> >>
> >> echo mq-deadline > /sys/block/<name of your USB
> >> disk>/queue/scheduler
> >>
> >> And confirm that mq-deadline is selected with:
> >>
> >> cat /sys/block/<name of your USB disk>/queue/scheduler
> >> [mq-deadline] kyber bfq none
> >
> > ok, which kernel should I test with this: the fresh git cloned, or the
> > one just patched with Alan's patch, or doesn't matter which one?
>
> Probably all of them to see if there are any differences.

with both kernels, the output of
cat /sys/block/sdh/queue/schedule

already contains [mq-deadline]: is it correct to assume that the echo
command and the subsequent testing is useless? What to do now?

Thanks, and bye
Andrea
