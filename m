Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC71EC00140
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Aug 2022 17:03:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236532AbiHHRDM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Aug 2022 13:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233053AbiHHRDK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2022 13:03:10 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E80140FE
        for <linux-scsi@vger.kernel.org>; Mon,  8 Aug 2022 10:03:09 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id CA7E734E2C;
        Mon,  8 Aug 2022 17:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1659978187; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DYNu2VbrH5irDZS8Z31D8Qdrq9XX2rC2jr2PFNEjMBs=;
        b=vBenYf+4ruj0IKNaAP4Uss5R/PxaL+fzv8/ONEJuzQcgTE7sfqJLUdleQjAbwevxNYBFvG
        f2EMrjIQqWfOjHdJIWyRpSQx+YXFIFz4q4Ut+13dTa1jmwCb51zBd/ZfB7UjkfcfNe/cXm
        T53HYHx5NdGM+sp4ezoivUhFYfkvnFM=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 97C7613A7C;
        Mon,  8 Aug 2022 17:03:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id co5sI8tB8WLFSQAAMHmgww
        (envelope-from <mwilck@suse.com>); Mon, 08 Aug 2022 17:03:07 +0000
Message-ID: <e307dbbefd669e47312d6e2bd9784e88e823f242.camel@suse.com>
Subject: Re: [PATCH] scsi_lib: Allow the ALUA transitioning state enough time
From:   Martin Wilck <mwilck@suse.com>
To:     Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Krishna Kant <krishna.kant@purestorage.com>,
        Seamus Connor <sconnor@purestorage.com>
Date:   Mon, 08 Aug 2022 19:03:07 +0200
In-Reply-To: <20220729214110.58576-1-brian@purestorage.com>
References: <20220729214110.58576-1-brian@purestorage.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2022-07-29 at 14:41 -0700, Brian Bunker wrote:
> The error path for the SCSI check condition of not ready, target in
> ALUA state transition, will result in the failure of that path after
> the retries are exhausted. In most cases that is well ahead of the
> transition timeout established in the SCSI ALUA device handler.
>=20
> Instead, reprep the command and re-add it to the queue after a 1
> second
> delay. This will allow the handler to take care of the timeout and
> only fail the path if the target has exceeded the transition expiry
> timeout (default 60 seconds). If the expiry timeout is exceeded, the
> handler will change the path state from transitioning to standby
> leading to a path failure eliminating the potential of this re-prep
> to continue endlessly. In most cases the target will exit the
> transitioning state well before the expiry timeout but after the
> retries are exhausted as mentioned.
>=20
> Additionally remove the scsi_io_completion_reprep function which
> provides little value.
>=20
> Acked-by: Krishna Kant <krishna.kant@purestorage.com>
> Acked-by: Seamus Connor <sconnor@purestorage.com>
> Signed-off-by: Brian Bunker <brian@purestorage.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
> =A0drivers/scsi/scsi_lib.c | 44 +++++++++++++++++++++++----------------
> --
> =A01 file changed, 25 insertions(+), 19 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 6ffc9e4258a8..1afb267ff9a2 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -118,7 +118,7 @@ scsi_set_blocked(struct scsi_cmnd *cmd, int
> reason)
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0}
> =A0
> -static void scsi_mq_requeue_cmd(struct scsi_cmnd *cmd)
> +static void scsi_mq_requeue_cmd(struct scsi_cmnd *cmd, unsigned long
> msecs)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0struct request *rq =3D scsi_cmd_to_rq(cmd);
> =A0
> @@ -128,7 +128,12 @@ static void scsi_mq_requeue_cmd(struct scsi_cmnd
> *cmd)
> =A0=A0=A0=A0=A0=A0=A0=A0} else {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0WARN_ON_ONCE(true);
> =A0=A0=A0=A0=A0=A0=A0=A0}
> -=A0=A0=A0=A0=A0=A0=A0blk_mq_requeue_request(rq, true);
> +
> +=A0=A0=A0=A0=A0=A0=A0if (msecs) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0blk_mq_requeue_request(rq, =
false);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0blk_mq_delay_kick_requeue_l=
ist(rq->q, msecs);
> +=A0=A0=A0=A0=A0=A0=A0} else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0blk_mq_requeue_request(rq, =
true);
> =A0}
> =A0
> =A0/**
> @@ -658,14 +663,6 @@ static unsigned int scsi_rq_err_bytes(const
> struct request *rq)
> =A0=A0=A0=A0=A0=A0=A0=A0return bytes;
> =A0}
> =A0
> -/* Helper for scsi_io_completion() when "reprep" action required. */
> -static void scsi_io_completion_reprep(struct scsi_cmnd *cmd,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct request_queue *q)
> -{
> -=A0=A0=A0=A0=A0=A0=A0/* A new command will be prepared and issued. */
> -=A0=A0=A0=A0=A0=A0=A0scsi_mq_requeue_cmd(cmd);
> -}
> -
> =A0static bool scsi_cmd_runtime_exceeced(struct scsi_cmnd *cmd)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0struct request *req =3D scsi_cmd_to_rq(cmd);
> @@ -683,14 +680,21 @@ static bool scsi_cmd_runtime_exceeced(struct
> scsi_cmnd *cmd)
> =A0=A0=A0=A0=A0=A0=A0=A0return false;
> =A0}
> =A0
> +/*
> + * When ALUA transition state is returned, reprep the cmd to
> + * use the ALUA handlers transition timeout. Delay the reprep
> + * 1 sec to avoid aggressive retries of the target in that
> + * state.
> + */
> +#define ALUA_TRANSITION_REPREP_DELAY=A0=A0=A01000
> +
> =A0/* Helper for scsi_io_completion() when special action required. */
> =A0static void scsi_io_completion_action(struct scsi_cmnd *cmd, int
> result)
> =A0{
> -=A0=A0=A0=A0=A0=A0=A0struct request_queue *q =3D cmd->device->request_qu=
eue;
> =A0=A0=A0=A0=A0=A0=A0=A0struct request *req =3D scsi_cmd_to_rq(cmd);
> =A0=A0=A0=A0=A0=A0=A0=A0int level =3D 0;
> -=A0=A0=A0=A0=A0=A0=A0enum {ACTION_FAIL, ACTION_REPREP, ACTION_RETRY,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ACTION_DELAYED_RETRY} action;
> +=A0=A0=A0=A0=A0=A0=A0enum {ACTION_FAIL, ACTION_REPREP, ACTION_DELAYED_RE=
PREP,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ACTION_RETRY, ACTION_DELAYED_RETRY}=
 action;
> =A0=A0=A0=A0=A0=A0=A0=A0struct scsi_sense_hdr sshdr;
> =A0=A0=A0=A0=A0=A0=A0=A0bool sense_valid;
> =A0=A0=A0=A0=A0=A0=A0=A0bool sense_current =3D true;=A0=A0=A0=A0=A0 /* fa=
lse implies "deferred
> sense" */
> @@ -779,8 +783,8 @@ static void scsi_io_completion_action(struct
> scsi_cmnd *cmd, int result)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0action =3D
> ACTION_DELAYED_RETRY;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0case 0x0a: /* ALUA state transition
> */
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0blk_stat =3D BLK_STS_TRANSPORT=
;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fallthrough;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0action =3D
> ACTION_DELAYED_REPREP;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0default:
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0action =3D ACTION_FAIL;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> @@ -839,7 +843,10 @@ static void scsi_io_completion_action(struct
> scsi_cmnd *cmd, int result)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fallthrough;
> =A0=A0=A0=A0=A0=A0=A0=A0case ACTION_REPREP:
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0scsi_io_completion_reprep(c=
md, q);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0scsi_mq_requeue_cmd(cmd, 0)=
;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> +=A0=A0=A0=A0=A0=A0=A0case ACTION_DELAYED_REPREP:
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0scsi_mq_requeue_cmd(cmd,
> ALUA_TRANSITION_REPREP_DELAY);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> =A0=A0=A0=A0=A0=A0=A0=A0case ACTION_RETRY:
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Retry the same command=
 immediately */
> @@ -933,7 +940,7 @@ static int scsi_io_completion_nz_result(struct
> scsi_cmnd *cmd, int result,
> =A0 * command block will be released and the queue function will be
> goosed. If we
> =A0 * are not done then we have to figure out what to do next:
> =A0 *
> - *=A0=A0 a) We can call scsi_io_completion_reprep().=A0 The request will
> be
> + *=A0=A0 a) We can call scsi_mq_requeue_cmd().=A0 The request will be
> =A0 *=A0=A0=A0=A0=A0unprepared and put back on the queue.=A0 Then a new c=
ommand
> will
> =A0 *=A0=A0=A0=A0=A0be created for it.=A0 This should be used if we made =
forward
> =A0 *=A0=A0=A0=A0=A0progress, or if we want to switch from READ(10) to RE=
AD(6)
> for
> @@ -949,7 +956,6 @@ static int scsi_io_completion_nz_result(struct
> scsi_cmnd *cmd, int result,
> =A0void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int
> good_bytes)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0int result =3D cmd->result;
> -=A0=A0=A0=A0=A0=A0=A0struct request_queue *q =3D cmd->device->request_qu=
eue;
> =A0=A0=A0=A0=A0=A0=A0=A0struct request *req =3D scsi_cmd_to_rq(cmd);
> =A0=A0=A0=A0=A0=A0=A0=A0blk_status_t blk_stat =3D BLK_STS_OK;
> =A0
> @@ -986,7 +992,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd,
> unsigned int good_bytes)
> =A0=A0=A0=A0=A0=A0=A0=A0 * request just queue the command up again.
> =A0=A0=A0=A0=A0=A0=A0=A0 */
> =A0=A0=A0=A0=A0=A0=A0=A0if (likely(result =3D=3D 0))
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0scsi_io_completion_reprep(c=
md, q);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0scsi_mq_requeue_cmd(cmd, 0)=
;
> =A0=A0=A0=A0=A0=A0=A0=A0else
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0scsi_io_completion_action=
(cmd, result);
> =A0}

