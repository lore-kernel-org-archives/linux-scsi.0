Return-Path: <SRS0=9eMh=27=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C76CC33CA2
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 01:28:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7266A2072E
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 01:28:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L/UoUV4U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730624AbgAJB2z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jan 2020 20:28:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50951 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730609AbgAJB2y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jan 2020 20:28:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578619733;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oQXk4NikYqJ8ojs8oxiLGwzKHjP5osvxSkqPpWYYobo=;
        b=L/UoUV4Ul2Y4bwIfz4IFF4Y6W+Oi/8N+r7Bw7WeGg1iujYNkwnmOSvT+35By8n0QVL3u1j
        wCP1vx5GB9EUx60T/xYN9jmKYu5Oh74CuhaWrbFb7l+Mb9lnte7sY2zMDR6+CAe9RfdlIg
        QjQTvCcwIj5oMLV+mGWYr73Q773Jz84=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-totL9jj0PJW14MGQKoTLig-1; Thu, 09 Jan 2020 20:28:52 -0500
X-MC-Unique: totL9jj0PJW14MGQKoTLig-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 33A081005502;
        Fri, 10 Jan 2020 01:28:51 +0000 (UTC)
Received: from agk-dp.fab.redhat.com (agk-dp.fab.redhat.com [10.33.15.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ED64660E3E;
        Fri, 10 Jan 2020 01:28:50 +0000 (UTC)
Received: from agk by agk-dp.fab.redhat.com with local (Exim 4.69)
        (envelope-from <agk@redhat.com>)
        id 1ipj6X-0001wF-2m; Fri, 10 Jan 2020 01:28:49 +0000
Date:   Fri, 10 Jan 2020 01:28:48 +0000
From:   Alasdair G Kergon <agk@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Tony Asleson <tasleson@redhat.com>,
        Sweet Tea Dorminy <sweettea@redhat.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC 9/9] __xfs_printk: Add durable name to output
Message-ID: <20200110012848.GB7297@agk-dp.fab.redhat.com>
Mail-Followup-To: Dave Chinner <david@fromorbit.com>,
        Tony Asleson <tasleson@redhat.com>,
        Sweet Tea Dorminy <sweettea@redhat.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20200104025620.GC23195@dread.disaster.area> <5ad7cf7b-e261-102c-afdc-fa34bed98921@redhat.com> <20200106220233.GK23195@dread.disaster.area> <CAMeeMh-zr309TzbC3ayKUKRniat+rzurgzmeM5LJYMFVDj7bLA@mail.gmail.com> <20200107012353.GO23195@dread.disaster.area> <4ce83a0e-13e1-6245-33a3-5c109aec4bf1@redhat.com> <20200108021002.GR23195@dread.disaster.area> <9e449c65-193c-d69c-1454-b1059221e5dc@redhat.com> <20200109014117.GB3809@agk-dp.fab.redhat.com> <20200109232244.GT23195@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200109232244.GT23195@dread.disaster.area>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
        03798903. Registered Office: Peninsular House, 30-36 Monument
        Street, 4th Floor, London, England, EC3R 8NB.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jan 10, 2020 at 10:22:44AM +1100, Dave Chinner wrote:
> Yeah, and if you add the equivalent of 'lsblk -f' then you also get
> the fs UUID to identify the filesystem on the block device at a
> given time....

The UUID usually already gets recorded and displayed:

# lsblkj -f --until "2020-01-09 22:00:00"
NAME                             FSTYPE      FSVER LABEL UUID            =
                       FSAVAIL FSUSE% MOUNTPOINT
sda                                                                      =
                                     =20
=E2=94=9C=E2=94=80sda1                           xfs                     =
78524ad6-6445-4bb6-840b-194871231274  =20
...

(It's also capturing something simple for mountpoint when it can, but so =
far that's
only visible with journalctl.)
=20
Alasdair

