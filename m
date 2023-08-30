Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14137C83F1E
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Aug 2023 18:38:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238027AbjH3SiO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Aug 2023 14:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245603AbjH3PkM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2023 11:40:12 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78CA122
        for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2023 08:40:08 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 8A4632184D;
        Wed, 30 Aug 2023 15:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1693410007; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+EZtLZVfROJEjOqLL0PBCzbAq8vbRSHlU8SCbSJGe/A=;
        b=EHIAHbK5ZH/WtbztoUhEL5ZUq9iq1Cz+xMmE7vELe6A7c6WlBC8T/1tAAXJErPq6QjCNsi
        r+DKWm/wFJ7Nv5boHRlBBcI0oR9wJ4r0TwxVfOw0Cy9Ho1AMNWEoDKYHptZLdaEQZ+DWWI
        FzF7zSkVT8qXRsHGOsC94uflcgTfrqI=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 19DC613441;
        Wed, 30 Aug 2023 15:40:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Eg3HBNdi72TvNAAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 30 Aug 2023 15:40:07 +0000
Message-ID: <c5716074eb67693570b7eadac47561f6c601aa7b.camel@suse.com>
Subject: Re: [PATCH] scsi: core: Remove ACTION_RETRY since it is redundant
From:   Martin Wilck <mwilck@suse.com>
To:     Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org
Cc:     Krishna Kant <krishna.kant@purestorage.com>,
        Seamus Connor <sconnor@purestorage.com>
Date:   Wed, 30 Aug 2023 17:40:06 +0200
In-Reply-To: <20220901214749.18875-1-brian@purestorage.com>
References: <20220901214749.18875-1-brian@purestorage.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2022-09-01 at 14:47 -0700, Brian Bunker wrote:
> The case of ACTION_RETRY in scsi_io_completion_action does nothing
> different than ACTION_DELAYED_RETRY, and by name gives the idea
> that it does.
>=20
> Following ACTION_RETRY:
> __scsi_queue_insert(cmd, SCSI_MLQUEUE_EH_RETRY, false);
>=20
> Following ACTION_DELAYED_RETRY:
> __scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY, false);
>=20
> Then __scsi_queue_insert calls scsi_set_blocked(cmd, reason) where
> both of the reasons set by ACTION_RETRY and ACTION_DELAYED_RETRY
> fall into the same case.
>=20
> =A0=A0=A0 case SCSI_MLQUEUE_DEVICE_BUSY:
> =A0=A0=A0 case SCSI_MLQUEUE_EH_RETRY:
> =A0=A0=A0=A0=A0=A0=A0 atomic_set(&device->device_blocked,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 device->max_device_blocked);
> =A0=A0=A0=A0=A0=A0=A0 break;
>=20
> Acked-by: Krishna Kant <krishna.kant@purestorage.com>
> Acked-by: Seamus Connor <sconnor@purestorage.com>
> Signed-off-by: Brian Bunker <brian@purestorage.com>

I like this, but I would suggest to keep ACTION_RETRY and ditch
ACTION_DELAYED_RETRY instead. The retry isn't delayed in the usual
sense of the word (which would imply some sort of time interval). We
just wait for the device_blocked counter to go to zero.

Thanks,
Martin

> ---
> =A0drivers/scsi/scsi_lib.c | 10 +++-------
> =A01 file changed, 3 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index ef08029a0079..d85d72bc01f2 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -687,7 +687,7 @@ static void scsi_io_completion_action(struct
> scsi_cmnd *cmd, int result)
> =A0=A0=A0=A0=A0=A0=A0=A0struct request *req =3D scsi_cmd_to_rq(cmd);
> =A0=A0=A0=A0=A0=A0=A0=A0int level =3D 0;
> =A0=A0=A0=A0=A0=A0=A0=A0enum {ACTION_FAIL, ACTION_REPREP, ACTION_DELAYED_=
REPREP,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ACTION_RETRY, ACTION_DELAYED_RETRY}=
 action;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ACTION_DELAYED_RETRY} action;
> =A0=A0=A0=A0=A0=A0=A0=A0struct scsi_sense_hdr sshdr;
> =A0=A0=A0=A0=A0=A0=A0=A0bool sense_valid;
> =A0=A0=A0=A0=A0=A0=A0=A0bool sense_current =3D true;=A0=A0=A0=A0=A0 /* fa=
lse implies "deferred
> sense" */
> @@ -704,7 +704,7 @@ static void scsi_io_completion_action(struct
> scsi_cmnd *cmd, int result)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * reasons.=A0 Just retry=
 the command and see what
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * happens.
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0action =3D ACTION_RETRY;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0action =3D ACTION_DELAYED_R=
ETRY;
> =A0=A0=A0=A0=A0=A0=A0=A0} else if (sense_valid && sense_current) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0switch (sshdr.sense_key) =
{
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0case UNIT_ATTENTION:
> @@ -720,7 +720,7 @@ static void scsi_io_completion_action(struct
> scsi_cmnd *cmd, int result)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 * media change, so we just retry the
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 * command and see what happens.
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 */
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0action =3D ACTION_RETRY;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0action =3D ACTION_DELAYED_RETRY;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0b=
reak;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0case ILLEGAL_REQUEST:
> @@ -841,10 +841,6 @@ static void scsi_io_completion_action(struct
> scsi_cmnd *cmd, int result)
> =A0=A0=A0=A0=A0=A0=A0=A0case ACTION_DELAYED_REPREP:
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0scsi_mq_requeue_cmd(cmd,
> ALUA_TRANSITION_REPREP_DELAY);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> -=A0=A0=A0=A0=A0=A0=A0case ACTION_RETRY:
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Retry the same command i=
mmediately */
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0__scsi_queue_insert(cmd, SC=
SI_MLQUEUE_EH_RETRY,
> false);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> =A0=A0=A0=A0=A0=A0=A0=A0case ACTION_DELAYED_RETRY:
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Retry the same command=
 after a delay */
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0__scsi_queue_insert(cmd, =
SCSI_MLQUEUE_DEVICE_BUSY,
> false);

