Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 212C0C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 13:50:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235276AbiI2NuI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 09:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235310AbiI2NuE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 09:50:04 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE1965679
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 06:49:56 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1A58D1F8C3;
        Thu, 29 Sep 2022 13:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1664459395; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oSZeIOd9Wqx1iHAQgtBSXrzCww9YSDqyGIuIMgj6Fas=;
        b=JT26UX5kTyQW+l+pENqTVhO7NayVUOsMcQG53BKETdpYGn0ubOCFaELFGKYxg+49I8ptb/
        MCmajDEyL0tsiF6jREf6rSPPs3L5xkHe7KkaDaK9xCXC2xWOjaNmt4YtgsfzeeDQTL5dOq
        ZPGaAsXj+fVoxf+uHXlY2UWRKCPIRwE=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D40871348E;
        Thu, 29 Sep 2022 13:49:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id D/8xMoKiNWOYMAAAMHmgww
        (envelope-from <mwilck@suse.com>); Thu, 29 Sep 2022 13:49:54 +0000
Message-ID: <532a7a0898744c6199c87db273e04d5f51d10134.camel@suse.com>
Subject: Re: [PATCH v2 21/35] scsi: retry INQUIRY after timeout
From:   Martin Wilck <mwilck@suse.com>
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Date:   Thu, 29 Sep 2022 15:49:54 +0200
In-Reply-To: <20220929025407.119804-22-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
         <20220929025407.119804-22-michael.christie@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2022-09-28 at 21:53 -0500, Mike Christie wrote:
> Description from: Martin Wilck <mwilck@suse.com>:
>=20
> The SCSI mid layer doesn't retry commands after DID_TIME_OUT (see
> scsi_noretry_cmd()). Packet loss in the fabric can cause spurious
> timeouts
> during SCSI device probing, causing device probing to fail. This has
> been
> observed in FCoE uplink failover tests, for example.
>=20
> This patch fixes the issue by retrying the INQUIRY up to 3 times (in
> practice, we never observed more than a single retry),
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
> =A0drivers/scsi/scsi_scan.c | 4 ++++
> =A01 file changed, 4 insertions(+)
>=20
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 83f33b215e4c..4c2e8d1baf43 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -674,6 +674,10 @@ static int scsi_probe_lun(struct scsi_device
> *sdev, unsigned char *inq_result,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.=
allowed =3D 3,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.=
result =3D SAM_STAT_CHECK_CONDITION,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0},
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0{
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.al=
lowed =3D 3,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.re=
sult =3D DID_TIME_OUT << 16,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0},
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0{},
> =A0=A0=A0=A0=A0=A0=A0=A0};
> =A0

Thinking about it (and re-reading my own commit message), it might be
better to just use .allowed =3D 1 here.

Thanks,
Martin

