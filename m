Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2603EFA372C
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 15:16:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC3EE206C3
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 15:16:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i8KTcFR1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbfKHPQ1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 10:16:27 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59329 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727233AbfKHPQ0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2019 10:16:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573226186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sdJq9GCWEigvvKAEhdiMe0zWBDjEkdIA0zDjk+u6lhw=;
        b=i8KTcFR1U6B7JhBLjIYtnJvTPNYq0v/0xfnE60lRkorIsC37YD0yjhIso43iWLV32ypJ4p
        pHKL7YyF0fir7kIr8hIx/uR2xO0s+9DjIHDJCGH9DBQGyOVcEm7cD/vQi9fBzwmr9T07UD
        miyPvrjMbPeMJvWD6vTlcSHjRnthzCY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-fhtsWwYyNlO4PtBrYovQIw-1; Fri, 08 Nov 2019 10:16:22 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC70B180496F;
        Fri,  8 Nov 2019 15:16:20 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B27485DA7F;
        Fri,  8 Nov 2019 15:16:17 +0000 (UTC)
Date:   Fri, 8 Nov 2019 10:16:16 -0500
From:   Mike Snitzer <snitzer@redhat.com>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>
Subject: Re: [PATCH 9/9] block: rework zone reporting
Message-ID: <20191108151616.GA8047@redhat.com>
References: <20191108015702.233102-1-damien.lemoal@wdc.com>
 <20191108015702.233102-10-damien.lemoal@wdc.com>
MIME-Version: 1.0
In-Reply-To: <20191108015702.233102-10-damien.lemoal@wdc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: fhtsWwYyNlO4PtBrYovQIw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Nov 07 2019 at  8:57pm -0500,
Damien Le Moal <damien.lemoal@wdc.com> wrote:

> From: Christoph Hellwig <hch@lst.de>
>=20
> Avoid the need to allocate a potentially large array of struct blk_zone
> in the block layer by switching the ->report_zones method interface to
> a callback model. Now the caller simply supplies a callback that is
> executed on each reported zone, and private data for it.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>

Reviewed-by: Mike Snitzer <snitzer@redhat.com>

