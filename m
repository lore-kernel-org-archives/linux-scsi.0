Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A7A5C5DF60
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 16:34:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05B6D217F5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 16:34:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D+VxWYoK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390165AbfKEQe3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 11:34:29 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26748 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390153AbfKEQe2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 11:34:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572971667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jGQmqLeCoIMOYixwDK5EhAaP0PYA9BAL3PEV/L6zzKs=;
        b=D+VxWYoKyIv1NzgDFk1SgCxn3529AscrGtrg/hIKE0afZTzR4danuL9iuBF5W3TGwj6oXE
        bVoxkZ3JOBPwgAhorcZblp8bcw3OvFb2vY3hORwpIWkrZhZfJlvxiBeVYpKyyxuNRGrVPp
        ZpRnYM3RfwzVMsPZpinPTnmJ0uioNWE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-SmT2toR1OVufYcXOGEJNbw-1; Tue, 05 Nov 2019 11:34:24 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE1901005500;
        Tue,  5 Nov 2019 16:34:22 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E37460CC0;
        Tue,  5 Nov 2019 16:34:22 +0000 (UTC)
Date:   Tue, 5 Nov 2019 11:34:21 -0500
From:   Mike Snitzer <snitzer@redhat.com>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Ajay Joshi <ajay.joshi@wdc.com>,
        Matias Bjorling <matias.bjorling@wdc.com>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 7/8] dm: add zone open, close and finish support
Message-ID: <20191105163421.GA22009@redhat.com>
References: <20191027140549.26272-1-damien.lemoal@wdc.com>
 <20191027140549.26272-8-damien.lemoal@wdc.com>
MIME-Version: 1.0
In-Reply-To: <20191027140549.26272-8-damien.lemoal@wdc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: SmT2toR1OVufYcXOGEJNbw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Oct 27 2019 at 10:05am -0400,
Damien Le Moal <damien.lemoal@wdc.com> wrote:

> From: Ajay Joshi <ajay.joshi@wdc.com>
>=20
> Implement REQ_OP_ZONE_OPEN, REQ_OP_ZONE_CLOSE and REQ_OP_ZONE_FINISH
> support to allow explicit control of zone states.
>=20
> Contains contributions from Matias Bjorling, Hans Holmberg and
> Damien Le Moal.
>=20
> Signed-off-by: Ajay Joshi <ajay.joshi@wdc.com>
> Signed-off-by: Matias Bjorling <matias.bjorling@wdc.com>
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>

Acked-by: Mike Snitzer <snitzer@redhat.com>

