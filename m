Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75A85C2BA1A
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 05:25:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46A4A20767
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 05:25:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance-com.20150623.gappssmtp.com header.i=@bytedance-com.20150623.gappssmtp.com header.b="Bz8AYVwW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbgDXFZU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 01:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725769AbgDXFZT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Apr 2020 01:25:19 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5817CC09B045
        for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2020 22:25:19 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id s10so9233800wrr.0
        for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2020 22:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s3xlhYgS/zLqigYSC49t4/AriSS2ZjycNOlqxwfYVsk=;
        b=Bz8AYVwWyABZPDn+Tvm7H7x613yeA324uXHkMcDaqBqprAuMlh+t9Ouz934pUlerqe
         n1E2a9ulEdqITvo6HwecBknJ9BX9V/73WrKYCSd0ZlalXJq4XkgBUEK2Ub4xKbNGLM9P
         1/D/TQA5FlmUWvua0j6YXVeLRzPENcgLkde2O43FW4lYhanDXDxR5EL3+CDxDPBza+d+
         RtmYeDgmmogFgEWmnvqfT23Ot4g2o8+zn7u7ZJmcX8mS8NTqLDK6LG7LcISU0OrC5J0P
         0ny125Bc/2gInL7Lr+7RTW8ypQC19DlTAfGGbTcWT5PIe7QYhBEgOnrv+B3e80AphlKs
         Ht9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s3xlhYgS/zLqigYSC49t4/AriSS2ZjycNOlqxwfYVsk=;
        b=FXAddOMffxFKq7bM5jMXqIXV+Vz7yhYGfvDjHnsv04pmmwd5BHPucKc2v9JQHRFrEZ
         I+gOZ+IzTv499hE0RF9upN79N3H4+znJDZrMJ54vlTt9ReSINQKyXaIoqyTFH8huNjQE
         U+o3P2YuMNC35uTnBnPn/4Zn9jZMS2UlFsTRKSXbRJ11kij/6Of0TI9YV5I/WrWkcW7Q
         W8SU/8S+uOpm2PC+EH6MmFJgkhemcmER/VLOqH0xKto9GwCBt5KbHwmffwxaAp6dwtIX
         LFsKd5eKrgEy0yCHf7yIEX/4wMxv0dffyUNiYWX7cQdKhJrxN3qW7TaH3UaGgUkPvWni
         vv7Q==
X-Gm-Message-State: AGi0PubTXIDnbvqHvhxMVMbntTZaLe2a1kOfH4lXbebNbR/ZP0JeQQGy
        GCkNDqQSarS2vJYQZjPeWdD74BuceqsOs3LXgx0ZtZIKYY0=
X-Google-Smtp-Source: APiQypJkodcSlQExGqyQ0SRDtm4MoJrCEMgXxWF7r2P5IyrMTrnqwzbRvItPW5KmrilVbf+Rs1aU81saFKgpjh5PDcc=
X-Received: by 2002:adf:aa8e:: with SMTP id h14mr9598857wrc.371.1587705918162;
 Thu, 23 Apr 2020 22:25:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200424035843.5914-1-houpu@bytedance.com> <20200424035843.5914-3-houpu@bytedance.com>
 <DM6PR04MB4972B3BE33D83FE7BA78570986D00@DM6PR04MB4972.namprd04.prod.outlook.com>
In-Reply-To: <DM6PR04MB4972B3BE33D83FE7BA78570986D00@DM6PR04MB4972.namprd04.prod.outlook.com>
From:   Hou Pu <houpu@bytedance.com>
Date:   Fri, 24 Apr 2020 13:25:07 +0800
Message-ID: <CAO9YExvkEAYstXxmE=MR5aXGYZSO6pmZHC+zwfiURi1yH3-JMQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] iscsi-target: Fix inconsistent debug message in __iscsi_target_sk_check_close
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Cc:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "mchristi@redhat.com" <mchristi@redhat.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Apr 24, 2020 at 12:16 PM Chaitanya Kulkarni
<Chaitanya.Kulkarni@wdc.com> wrote:
>
> Ho
>
> On 04/23/2020 08:59 PM, Hou Pu wrote:
> > commit 25cdda95fda78d22d44157da15aa7ea34be3c804
> > Author: Nicholas Bellinger<nab@linux-iscsi.org>
> > Date:   Wed May 24 21:47:09 2017 -0700
> >
> >      iscsi-target: Fix initial login PDU asynchronous socket close OOPs
>
> Thanks for the patch.
>
> Did you get a chance to run checkpatch.pl on this patch ?

Will fix it. Sorry for the stupid format error.

Thanks,
Hou
