Return-Path: <SRS0=dbdl=37=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C144C3F68F
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Feb 2020 12:28:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16CA92086A
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Feb 2020 12:28:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jj+QRujA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728800AbgBKM2y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Feb 2020 07:28:54 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:60276 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728467AbgBKM2y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Feb 2020 07:28:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581424133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uHEOjUhMWrW6Y0OTSi8s083JPpT8Ksjs/CTyJdEAW5w=;
        b=Jj+QRujAGUd0JbYvMneQn2NyGzoSTXitnUk1JHIi/OIRNkOx3SRiiKp7mCkG+n3nSHvZ48
        AoW8hJRLGz734/20KTPmdG31TIzquJy/W18TIl8lihQfo0KiH9n4tHVWzU5r1UOd6cYa98
        DzGEbK76XHt4otHHQkFl8LVywwoLAuk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-tbZMTi2APfmrcMiAbIN50A-1; Tue, 11 Feb 2020 07:28:48 -0500
X-MC-Unique: tbZMTi2APfmrcMiAbIN50A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F1557800D5E;
        Tue, 11 Feb 2020 12:28:46 +0000 (UTC)
Received: from ming.t460p (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 10B0B5C120;
        Tue, 11 Feb 2020 12:28:32 +0000 (UTC)
Date:   Tue, 11 Feb 2020 20:28:21 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Tim Walker <tim.t.walker@seagate.com>
Cc:     linux-block@vger.kernel.org,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-nvme@lists.infradead.org
Subject: Re: [LSF/MM/BPF TOPIC] NVMe HDD
Message-ID: <20200211122821.GA29811@ming.t460p>
References: <CANo=J14resJ4U1nufoiDq+ULd0k-orRCsYah8Dve-y8uCjA62Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANo=J14resJ4U1nufoiDq+ULd0k-orRCsYah8Dve-y8uCjA62Q@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Feb 10, 2020 at 02:20:10PM -0500, Tim Walker wrote:
> Background:
>=20
> NVMe specification has hardened over the decade and now NVMe devices
> are well integrated into our customers=E2=80=99 systems. As we look for=
ward,
> moving HDDs to the NVMe command set eliminates the SAS IOC and driver
> stack, consolidating on a single access method for rotational and
> static storage technologies. PCIe-NVMe offers near-SATA interface
> costs, features and performance suitable for high-cap HDDs, and
> optimal interoperability for storage automation, tiering, and
> management. We will share some early conceptual results and proposed
> salient design goals and challenges surrounding an NVMe HDD.

HDD. performance is very sensitive to IO order. Could you provide some
background info about NVMe HDD? Such as:

- number of hw queues
- hw queue depth
- will NVMe sort/merge IO among all SQs or not?

>=20
>=20
> Discussion Proposal:
>=20
> We=E2=80=99d like to share our views and solicit input on:
>=20
> -What Linux storage stack assumptions do we need to be aware of as we
> develop these devices with drastically different performance
> characteristics than traditional NAND? For example, what schedular or
> device driver level changes will be needed to integrate NVMe HDDs?

IO merge is often important for HDD. IO merge is usually triggered when
.queue_rq() returns STS_RESOURCE, so far this condition won't be
triggered for NVMe SSD.

Also blk-mq kills BDI queue congestion and ioc batching, and causes
writeback performance regression[1][2].

What I am thinking is that if we need to switch to use independent IO
path for handling SSD and HDD. IO, given the two mediums are so
different from performance viewpoint.

[1] https://lore.kernel.org/linux-scsi/Pine.LNX.4.44L0.1909181213141.1507=
-100000@iolanthe.rowland.org/
[2] https://lore.kernel.org/linux-scsi/20191226083706.GA17974@ming.t460p/


Thanks,=20
Ming

