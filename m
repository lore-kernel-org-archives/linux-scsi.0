Return-Path: <SRS0=sMUn=3N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98499C2D0DB
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 15:23:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5994A2077C
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 15:23:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="Gg8fu1up";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="Gg8fu1up"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387434AbgAXPXF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jan 2020 10:23:05 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37944 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387401AbgAXPXE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Jan 2020 10:23:04 -0500
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 700F48EE149;
        Fri, 24 Jan 2020 07:23:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1579879384;
        bh=YVK7H9Hic96f/7ALOkD1wK2EKPxt6ObGLhYigvGCFmg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Gg8fu1upP6C8Kj17tKvKhUHb5uuKDNpr67jVQ2zwO5xhpn1F2Zenu3V2cb3VgnaGL
         nxbtdFrxNXr+kFN3zbOgIG6EuhTKKPu64y6NiOlFeLBPLwLsl87RSupOgiqLLdy4Uw
         +bXpk0YA8a80A9Azh/3JMj+umm93lWJEqsyeTi68=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ugPiJ80SGGg3; Fri, 24 Jan 2020 07:23:04 -0800 (PST)
Received: from jarvis.lan (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id D17B88EE0D4;
        Fri, 24 Jan 2020 07:23:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1579879384;
        bh=YVK7H9Hic96f/7ALOkD1wK2EKPxt6ObGLhYigvGCFmg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Gg8fu1upP6C8Kj17tKvKhUHb5uuKDNpr67jVQ2zwO5xhpn1F2Zenu3V2cb3VgnaGL
         nxbtdFrxNXr+kFN3zbOgIG6EuhTKKPu64y6NiOlFeLBPLwLsl87RSupOgiqLLdy4Uw
         +bXpk0YA8a80A9Azh/3JMj+umm93lWJEqsyeTi68=
Message-ID: <1579879382.3001.4.camel@HansenPartnership.com>
Subject: Re: [PATCH] scsi: don't panic host on invalid sgtable count
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
Date:   Fri, 24 Jan 2020 07:23:02 -0800
In-Reply-To: <20200124151607.31375-1-johannes.thumshirn@wdc.com>
References: <20200124151607.31375-1-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 2020-01-25 at 00:16 +0900, Johannes Thumshirn wrote:
> If we have an invalid number of entries mapped an sg table, there's
> no need to panic the host, instead we can spit out a warning in dmesg
> and gracefully return an I/O error.

Can we?  This is an assertion failure which should never happen.  If it
does, it's likely an indicator that a system has gone seriously out of
spec for some reason, like internal compromise, CPU/Memory failure or
something else.

The HA view is that panic is appropriate for conditions that should
never happen because it helps the machine fail fast.

James

> While we're at it fix a trailing whitespace in the comment above.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  drivers/scsi/scsi_lib.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 3e7a45d0daca..9bddf54e3def 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -992,12 +992,15 @@ static blk_status_t scsi_init_sgtable(struct
> request *req,
>  			SCSI_INLINE_SG_CNT)))
>  		return BLK_STS_RESOURCE;
>  
> -	/* 
> +	/*
>  	 * Next, walk the list, and fill in the addresses and sizes
> of
>  	 * each segment.
>  	 */
>  	count = blk_rq_map_sg(req->q, req, sdb->table.sgl);
> -	BUG_ON(count > sdb->table.nents);
> +	if (WARN_ON_ONCE(count > sdb->table.nents)) {
> +		sg_free_table_chained(&sdb->table,
> SCSI_INLINE_SG_CNT);
> +		return BLK_STS_IOERR;
> +	}
>  	sdb->table.nents = count;
>  	sdb->length = blk_rq_payload_bytes(req);
>  	return BLK_STS_OK;

