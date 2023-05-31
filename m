Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A8DBC77B73
	for <linux-scsi@archiver.kernel.org>; Wed, 31 May 2023 16:46:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjEaQqg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 May 2023 12:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbjEaQqb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2023 12:46:31 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2361412F
        for <linux-scsi@vger.kernel.org>; Wed, 31 May 2023 09:46:30 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 92BEE1F385;
        Wed, 31 May 2023 16:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1685551588; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/qLZLFo5s/e1+DwzaDunp2ZKeqsqnnSfVThtIxQK4cg=;
        b=sYm8GciJuK613QQGO6B3rYu1IkbD6dVDNdX/FjSPwPUIa+ZK/rsL76Pgce4aM4W/+OBBib
        w85Y7O41T6nT69dSnt63rr68QesbevshEVBtgSwV4jnbzeMfpc7wapM8N1ea+NW48U989j
        WImZNS5Z/PgW6UMIgPFDn3RrYczKgHU=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 67E89138E8;
        Wed, 31 May 2023 16:46:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 4t/XF+R5d2TLcAAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 31 May 2023 16:46:28 +0000
Message-ID: <0ae2037c89757b4ccfadd6bdc4dc471db92b82f0.camel@suse.com>
Subject: Re: [PATCH 1/9] lpfc: Fix use-after-free rport memory access in
 lpfc_register_remote_port
From:   Martin Wilck <mwilck@suse.com>
To:     Justin Tee <justintee8345@gmail.com>, linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com
Date:   Wed, 31 May 2023 18:46:27 +0200
In-Reply-To: <20230523183206.7728-2-justintee8345@gmail.com>
References: <20230523183206.7728-1-justintee8345@gmail.com>
         <20230523183206.7728-2-justintee8345@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2023-05-23 at 11:31 -0700, Justin Tee wrote:
> Due to a target port D_ID swap, it is possible for the
> lpfc_register_remote_port routine to touch post mortem fc_rport
> memory when
> trying to access fc_rport->dd_data.
>=20
> The D_ID swap causes a simultaneous call to
> lpfc_unregister_remote_port,
> where fc_remote_port_delete reclaims fc_rport memory.
>=20
> Remove the fc_rport->dd_data->pnode NULL assignment because the
> following
> line reassigns ndlp->rport with an fc_rport object from
> fc_remote_port_add
> anyways.=A0 The pnode nullification is superfluous.
>=20
> Signed-off-by: Justin Tee <justin.tee@broadcom.com>

This patch fixed a customer issue for us.

Acked-by: Martin Wilck <mwilck@suse.com>


> ---
> =A0drivers/scsi/lpfc/lpfc_hbadisc.c | 8 --------
> =A01 file changed, 8 deletions(-)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c
> b/drivers/scsi/lpfc/lpfc_hbadisc.c
> index 67bfdddb897c..63e42e3f2165 100644
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
> @@ -4498,14 +4498,6 @@ lpfc_register_remote_port(struct lpfc_vport
> *vport, struct lpfc_nodelist *ndlp)
> =A0=A0=A0=A0=A0=A0=A0=A0if (vport->load_flag & FC_UNLOADING)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> =A0
> -=A0=A0=A0=A0=A0=A0=A0/*
> -=A0=A0=A0=A0=A0=A0=A0 * Disassociate any older association between this =
ndlp and
> rport
> -=A0=A0=A0=A0=A0=A0=A0 */
> -=A0=A0=A0=A0=A0=A0=A0if (ndlp->rport) {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rdata =3D ndlp->rport->dd_d=
ata;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rdata->pnode =3D NULL;
> -=A0=A0=A0=A0=A0=A0=A0}
> -
> =A0=A0=A0=A0=A0=A0=A0=A0ndlp->rport =3D rport =3D fc_remote_port_add(shos=
t, 0,
> &rport_ids);
> =A0=A0=A0=A0=A0=A0=A0=A0if (!rport) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0dev_printk(KERN_WARNING, =
&phba->pcidev->dev,

