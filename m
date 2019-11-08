Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B0B7FA372C
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 16:34:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E81A21882
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 16:34:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FVSRnp/r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbfKHQe3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 11:34:29 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21752 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726039AbfKHQe2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2019 11:34:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573230867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MswkzqSTgztzY8rIctB3nvZ7tTFuK81EkDbQodyjE2k=;
        b=FVSRnp/rq5HswGy0zsc2HoPGQIexpYvfIjMnc0sczZPnrPEslioaHn9DgGM5Ebzpd6mN8V
        mJLbOzKhkVJpIyo+5RytCpGHjtK+9qqCf3WQGuRLyDGvia/8Qob1LfxHsbDSYbnTUU6Sxo
        Oinj2Bi5oFWMqL8jeKwVmolqocWh0CE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-hWr799ELOo2eZxLUvrdC3g-1; Fri, 08 Nov 2019 11:34:24 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 28D6B107ACC4;
        Fri,  8 Nov 2019 16:34:23 +0000 (UTC)
Received: from [10.10.125.42] (ovpn-125-42.rdu2.redhat.com [10.10.125.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F18260BE1;
        Fri,  8 Nov 2019 16:34:22 +0000 (UTC)
Subject: Re: [PATCH v2] target: core: Prevent memory reclaim recursion
To:     Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
References: <20191108082901.417950-1-damien.lemoal@wdc.com>
 <cefdcca4-e839-829e-54aa-b95e77825d1d@acm.org>
From:   Mike Christie <mchristi@redhat.com>
Message-ID: <5DC59908.5010600@redhat.com>
Date:   Fri, 8 Nov 2019 10:34:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.6.0
MIME-Version: 1.0
In-Reply-To: <cefdcca4-e839-829e-54aa-b95e77825d1d@acm.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: hWr799ELOo2eZxLUvrdC3g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/08/2019 10:22 AM, Bart Van Assche wrote:
> On 11/8/19 12:29 AM, Damien Le Moal wrote:
>> Prevent recursion into the IO path under low memory conditions by using
>> GFP_NOIO in place of GFP_KERNEL when allocating a new command with
>> tcmu_alloc_cmd() and user ring space with tcmu_get_empty_block().
>>
>> Reported-by: Masato Suzuki <masato.suzuki@wdc.com>
>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
>> ---
>>
>> Changes from v1:
>> * Added reported-by tag
>>
>>   drivers/target/target_core_user.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> The patch subject is weird. Shouldn't the patch subject start with
> "tcmu" instead of "target: core"?
>=20
> Has the recursion mentioned in the patch description been observed or is
> this a theoretical issue? I'm asking this because GFP_NOIO only prevents

Observed.

> recursion if it is used inside a block driver or filesystem. The tcmu
> driver is neither - it submits block I/O or filesystem I/O instead of
> implementing a block driver or filesystem. Should we really disallow
> tcmu to use the swap subsystem?

A common use is tcm loop on the frontend and tcmu on the backend. You
see this with virt and containers, where some app is used to interacting
SCSI devices, but then the storage is backed by something that people
didn't want to put in the kernel. It's similar to nbd when you use
AF_UNIX sockets with a local running daemon.

