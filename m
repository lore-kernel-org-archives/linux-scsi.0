Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBB06C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 14:12:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235587AbiI2OMh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 10:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235596AbiI2OMf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 10:12:35 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BF0174229
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 07:12:33 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B075F2189C;
        Thu, 29 Sep 2022 14:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1664460752; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=38NkiCZvPjyc2iaaG1aQ+Yu8AyhWxTwJrrSvggDETlw=;
        b=VWBvIl6x72OAzWoFlku0gbIR5rGmmNEDnd5fFztVUyB2qOzWWC6otyJiVIs6GFG5FNUIwX
        fXlMcGRIbqQNqUi4Dbu6by9Mlew1lkbDrHW8fWIzEOKY4VN0nPfcAgDNk+nhdzQC/Shw7J
        d9NBJ/o+dfDRHFYzmS/3LpWgbh6Y2RY=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 706AB13A71;
        Thu, 29 Sep 2022 14:12:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id +jeaGdCnNWPBOgAAMHmgww
        (envelope-from <mwilck@suse.com>); Thu, 29 Sep 2022 14:12:32 +0000
Message-ID: <f8fbff5c280b7cb6fdd31979a50608561b38c626.camel@suse.com>
Subject: Re: [PATCH v2 22/35] scsi: Have scsi-ml retry read_capacity_16
 errors
From:   Martin Wilck <mwilck@suse.com>
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Date:   Thu, 29 Sep 2022 16:12:31 +0200
In-Reply-To: <20220929025407.119804-23-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
         <20220929025407.119804-23-michael.christie@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2022-09-28 at 21:53 -0500, Mike Christie wrote:
> This has read_capacity_16 have scsi-ml retry errors instead of
> driving
> them itself.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
> =A0drivers/scsi/sd.c | 82 +++++++++++++++++++++++++--------------------
> --
> =A01 file changed, 43 insertions(+), 39 deletions(-)
>=20
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 37eafa968116..a35c089c3097 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2283,55 +2283,59 @@ static int read_capacity_16(struct scsi_disk
> *sdkp, struct scsi_device *sdp,
> =A0=A0=A0=A0=A0=A0=A0=A0struct scsi_sense_hdr sshdr;
> =A0=A0=A0=A0=A0=A0=A0=A0int sense_valid =3D 0;
> =A0=A0=A0=A0=A0=A0=A0=A0int the_result;
> -=A0=A0=A0=A0=A0=A0=A0int retries =3D 3, reset_retries =3D
> READ_CAPACITY_RETRIES_ON_RESET;
> =A0=A0=A0=A0=A0=A0=A0=A0unsigned int alignment;
> =A0=A0=A0=A0=A0=A0=A0=A0unsigned long long lba;
> =A0=A0=A0=A0=A0=A0=A0=A0unsigned sector_size;
> +=A0=A0=A0=A0=A0=A0=A0struct scsi_failure failures[] =3D {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0{
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.se=
nse =3D UNIT_ATTENTION,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.as=
c =3D 0x29,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.as=
cq =3D 0,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* =
Device reset might occur several times */
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.al=
lowed =3D READ_CAPACITY_RETRIES_ON_RESET,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.re=
sult =3D SAM_STAT_CHECK_CONDITION,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0},
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0{
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.re=
sult =3D SCMD_FAILURE_ANY,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.al=
lowed =3D 3,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0},
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0{},
> +=A0=A0=A0=A0=A0=A0=A0};

I first wondered whether this was correct, until I realized that
the logic in patch 02/35 actually treats the counts for different
failures independently, so that the maximum overall retry count is
the sum of the individual retry counts.

I wonder if we should give callers the chance to set a limit for the
overall retry count in addition to the retry counts for individual=20
failures.

Martin

