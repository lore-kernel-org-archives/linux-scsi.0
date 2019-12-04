Return-Path: <SRS0=+pba=Z2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 949F2C43603
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Dec 2019 23:02:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64D2B206DB
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Dec 2019 23:02:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XJy/60+9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbfLDXCq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Dec 2019 18:02:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32714 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728011AbfLDXCq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Dec 2019 18:02:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575500565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XZ22V+LeKTL9G9FnuhA8dKqo40g1wb7UNh59Umr7gyQ=;
        b=XJy/60+9q7ElTCPCs1hT9jrK8Y5S5mHTF3L3Ddi2lSSGd3MRRQNwAqlMVaqVJbgKV+j+9y
        bPovq5zvsj8tHmPdlHE6Xq2Dvr3LxiXZEPJW2xb7hzJDxeWpyWSjdw46YUBRhu1u2TN6KX
        wIoe3ycdpDijJktVvAwXcxghBs4Qu8A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-Q7h8s4WqOmWuL4vDXNMIeA-1; Wed, 04 Dec 2019 18:02:42 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7BEB3107ACC4;
        Wed,  4 Dec 2019 23:02:40 +0000 (UTC)
Received: from ming.t460p (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 96ABE19C6A;
        Wed,  4 Dec 2019 23:02:30 +0000 (UTC)
Date:   Thu, 5 Dec 2019 07:02:25 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Stephen Rust <srust@blockbridge.com>
Cc:     Rob Townley <rob.townley@gmail.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        target-devel@vger.kernel.org, Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Sagi Grimberg <sagi@grimberg.me>,
        Max Gurtovoy <maxg@mellanox.com>
Subject: Re: Data corruption in kernel 5.1+ with iSER attached ramdisk
Message-ID: <20191204230225.GA26189@ming.t460p>
References: <CAAFE1beMkvyRctGqpffd3o_QtDH0CrmQSb=fV4GzqMUXWzPyOw@mail.gmail.com>
 <20191203005849.GB25002@ming.t460p>
 <CAAFE1bcG8c1Q3iwh-LUjruBMAuFTJ4qWxNGsnhfKvGWHNLAeEQ@mail.gmail.com>
 <20191203031444.GB6245@ming.t460p>
 <CAAFE1besnb=HV4C_buORYpWbkXecmtybwX8d_Ka2NsKmiym53w@mail.gmail.com>
 <CAAFE1bfpUWCZrtR8v3S++0-+gi8DJ79X3e0XqDe93i8nuGTnNg@mail.gmail.com>
 <20191203124558.GA22805@ming.t460p>
 <CAAFE1bfB2Km+e=T0ahwq0r9BQrBMnSguQQ+y=yzYi3tursS+TQ@mail.gmail.com>
 <20191204010529.GA3910@ming.t460p>
 <CAAFE1bcJmRP5OSu=5asNTpvkF=kjEZu=GafaS9h52776tVgpPA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAAFE1bcJmRP5OSu=5asNTpvkF=kjEZu=GafaS9h52776tVgpPA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: Q7h8s4WqOmWuL4vDXNMIeA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 04, 2019 at 12:23:39PM -0500, Stephen Rust wrote:
> Hi Ming,
>=20
> I have tried your latest "workaround" patch in brd including the fix
> for large offsets, and it does appear to work. I tried the same tests
> and the data was written correctly for all offsets I tried. Thanks!
>=20
> I include the updated additional bpftrace below.
>=20
> > So firstly, I'd suggest to investigate from RDMA driver side to see why
> > un-aligned buffer is passed to block layer.
> >
> > According to previous discussion, 512 aligned buffer should be provided
> > to block layer.
> >
> > So looks the driver needs to be fixed.
>=20
> If it does appear to be an RDMA driver issue, do you know who we
> should follow up with directly from the RDMA driver side of the world?
>=20
> Presumably non-brd devices, ie: real scsi devices work for these test
> cases because they accept un-aligned buffers?

Right, not every driver supports such un-aligned buffer.

I am not familiar with RDMA, but from the trace we have done so far,
it is highly related with iser driver.=20


Thanks,
Ming

