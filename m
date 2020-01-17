Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BC75C33CB1
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 14:15:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E697B2082F
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 14:15:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="AtjNSOYr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgAQOPY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jan 2020 09:15:24 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:34195 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgAQOPY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2020 09:15:24 -0500
Received: by mail-il1-f196.google.com with SMTP id s15so21425204iln.1
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jan 2020 06:15:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TFdZxAKXWdJqLhVt7jIC0rjkszL1cc8nPIw1ewCe+gM=;
        b=AtjNSOYrC+v7RLTgnLzZKG4rVX2CMLv5CHJqDsc0lgVDNhdPZ2Gqc5ZAFyuQPXvovs
         pC/ZhoJGuBHSr5BW1yhPKXQwQCMzm19cykvHr5Q9QWAjT+in2bEu6tFLwtfZjzNdsTQE
         zSJmR0s++m9V33drFYWnbjfVXkTkhZplVWhZcgci1R4KPLE5hF2PihDw9pz2WWKw2yMb
         frLnlAB/6kU2AvCcUgP0lW88ocAPBQx2ic/fJ8bXe04cEXUJrndUMMbaOr/RLQ8vEF3V
         D5jjBmjyzMmCjrFsqb5D2mtUdUEzRqy945z3ugY8wHkiBP6e3qLJqvATKje2xy/LqP6E
         /8Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TFdZxAKXWdJqLhVt7jIC0rjkszL1cc8nPIw1ewCe+gM=;
        b=QOnjeTKVoUvffHWwGHSmje76MZpsTh7SHf7iWEFo3pKow3uUnHw1EzWGyiZX3s7Fry
         kbGZ+jCKjPFaujH75zLh7TsIZNDYCPCciCAE43gxNe8eU3qo6GGY13yD0PTWgpYE90JG
         yfoPbFFTNWvw8jY4q9tFGnaGCLWZLq8mzCUmg34kV8kEWf9qP2zRlqoYPm0UEOKf+3ja
         rp/2jHtURaE54Sx8naOK8lgD0wbStR6DOKwGQ8iGVK0Cla9xaeanCqkXSq/0+wDsXxNT
         plXEyevmvNug+YCe9Ohdh63VvxZVc2/eiXCtVal/GCL7qAK663DVjSgwL2FR71+8AX/x
         HORg==
X-Gm-Message-State: APjAAAWDbIc3KREC/qgyQ3jCW6N7NkQAxghOOyCtwAfB467ZIaVMMEbZ
        i/sy9ICZKdmJRU9mzp/RORINk+Xz+i6X3EwEieEx8A==
X-Google-Smtp-Source: APXvYqwqmBIQX3U/4jueoFpEsbsb3q8trxxhGFPMr+tERoWnZI71I5HGNSO+uGm46Eq+4xmEFNm/c9mMPOJzrQF204Y=
X-Received: by 2002:a05:6e02:f0f:: with SMTP id x15mr3034086ilj.298.1579270522928;
 Fri, 17 Jan 2020 06:15:22 -0800 (PST)
MIME-Version: 1.0
References: <20200117071923.7445-1-deepak.ukey@microchip.com> <20200117071923.7445-6-deepak.ukey@microchip.com>
In-Reply-To: <20200117071923.7445-6-deepak.ukey@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Fri, 17 Jan 2020 15:15:12 +0100
Message-ID: <CAMGffEnc1sWgOB7PENtbBQUzJ6iRORHrJe4Y5FV1+WkgrhAwOg@mail.gmail.com>
Subject: Re: [PATCH V2 05/13] pm80xx : Support for char device.
To:     Deepak Ukey <deepak.ukey@microchip.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas G <Viswas.G@microchip.com>,
        Jack Wang <jinpu.wang@profitbricks.com>, yuuzheng@google.com,
        Vikram Auradkar <auradkar@google.com>, vishakhavc@google.com,
        bjashnani@google.com, Radha Ramachandran <radha@google.com>,
        akshatzen@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jan 17, 2020 at 8:10 AM Deepak Ukey <deepak.ukey@microchip.com> wrote:
>
> From: Deepak Ukey <Deepak.Ukey@microchip.com>
>
> Added the support to register the char device for pm80xx module so that
> management utility fetch the different information from driver with the
> help of IOCTL. Also added the IOCTL functionality to get driver info so
> that management utility can fetch the information about driver like
> driver name, driver major number, driver minor number and build number.
>
> Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Radha Ramachandran <radha@google.com>

Thanks for the commit message, looks much better. In the past, people
are against IOCTL, suggesting netlink,
have you considered that?

Martin, James, what do you think?

Regards,
Jack
