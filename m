Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2C3AC433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 11:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235079AbiI2LAK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 07:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235103AbiI2LAI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 07:00:08 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00242A722
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 04:00:03 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E0AC621BCF;
        Thu, 29 Sep 2022 11:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1664449201; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eFDi1nJpNf6W0t+WPeLzqV3iR6Tj5we2HvOzOcCzZLc=;
        b=DyuEQDf/sEkE31NBv6gnu74LnCFqlOJLFA9mr4fpoAVsTNPptdrY2ntArUjS64D4t2iLUQ
        d1SVvtrXw650eCzS4NCIlOheVu/20byudCymGy7/vRdGd1dG+u0MU5U/K+SOgiTLg+p8MU
        4ffbiMYmmp+hicHLYe+Ib6Q8L7oMgTE=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 99D381348E;
        Thu, 29 Sep 2022 11:00:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id q4T9IrF6NWOUYQAAMHmgww
        (envelope-from <mwilck@suse.com>); Thu, 29 Sep 2022 11:00:01 +0000
Message-ID: <8ea448f35480725ce982ba63b8ecb9baafa1edba.camel@suse.com>
Subject: Re: [PATCH v2 02/35] scsi: Allow passthrough to override what
 errors to retry
From:   Martin Wilck <mwilck@suse.com>
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Date:   Thu, 29 Sep 2022 13:00:00 +0200
In-Reply-To: <20220929025407.119804-3-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
         <20220929025407.119804-3-michael.christie@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2022-09-28 at 21:53 -0500, Mike Christie wrote:
> For passthrough, we don't retry any error we get a check condition
> for.
> This results in a lot of callers driving their own retries for those
> types
> of errors and retrying all errors, and there has been a request to
> retry
> specific host byte errors.
>=20
> This adds the core code to allow passthrough users to specify what
> errors
> they want scsi-ml to retry for them. We can then convert users to
> drop
> their sense parsing and retry handling.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>

I like the general approach. A few remarks below.

> ---
> =A0drivers/scsi/scsi_error.c | 63
> +++++++++++++++++++++++++++++++++++++++
> =A0drivers/scsi/scsi_lib.c=A0=A0 |=A0 1 +
> =A0include/scsi/scsi_cmnd.h=A0 | 26 +++++++++++++++-
> =A03 files changed, 89 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 3f630798d1eb..4bf7b65bc63d 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1831,6 +1831,63 @@ bool scsi_noretry_cmd(struct scsi_cmnd *scmd)
> =A0=A0=A0=A0=A0=A0=A0=A0return false;
> =A0}
> =A0
> +static enum scsi_disposition scsi_check_passthrough(struct scsi_cmnd
> *scmd)
> +{
> +=A0=A0=A0=A0=A0=A0=A0struct scsi_failure *failure;
> +=A0=A0=A0=A0=A0=A0=A0struct scsi_sense_hdr sshdr;
> +=A0=A0=A0=A0=A0=A0=A0enum scsi_disposition ret;
> +=A0=A0=A0=A0=A0=A0=A0int i =3D 0;
> +
> +=A0=A0=A0=A0=A0=A0=A0if (!scmd->result || !scmd->failures)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return SCSI_RETURN_NOT_HAND=
LED;
> +
> +=A0=A0=A0=A0=A0=A0=A0while (1) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0failure =3D &scmd->failures=
[i++];

Style nit: a for loop would express the logic better, IMO.

> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!failure->result)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0bre=
ak;
> +
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (failure->result =3D=3D =
SCMD_FAILURE_ANY)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0got=
o maybe_retry;
> +
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (host_byte(scmd->result)=
 & host_byte(failure-
> >result)) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0got=
o maybe_retry;

Using "&" here needs explanation. The host byte is not a bit mask.

> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else if (get_status_byte(=
scmd) &
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 __get_status_byte(failure->result)) {

See above.

> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(get_status_byte(scmd) !=3D
> SAM_STAT_CHECK_CONDITION ||
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 failure->sense =3D=3D SCMD_FAILURE_SENSE_ANY)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0goto maybe_retry;
> +
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret=
 =3D scsi_start_sense_processing(scmd,
> &sshdr);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(ret =3D=3D NEEDS_RETRY)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0goto maybe_retry;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0els=
e if (ret !=3D SUCCESS)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0return ret;
> +
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(failure->sense !=3D sshdr.sense_key)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0continue;
> +
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(failure->asc =3D=3D SCMD_FAILURE_ASC_ANY)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0goto maybe_retry;
> +
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(failure->asc !=3D sshdr.asc)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0continue;
> +
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(failure->ascq =3D=3D SCMD_FAILURE_ASCQ_ANY ||
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 failure->ascq =3D=3D sshdr.ascq)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0goto maybe_retry;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0}
> +
> +=A0=A0=A0=A0=A0=A0=A0return SCSI_RETURN_NOT_HANDLED;
> +
> +maybe_retry:
> +=A0=A0=A0=A0=A0=A0=A0if (failure->allowed =3D=3D SCMD_FAILURE_NO_LIMIT |=
|
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ++failure->retries <=3D failure->allowed)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return NEEDS_RETRY;
> +
> +=A0=A0=A0=A0=A0=A0=A0return SUCCESS;
> +}
> +
> =A0/**
> =A0 * scsi_decide_disposition - Disposition a cmd on return from LLD.
> =A0 * @scmd:=A0=A0=A0=A0=A0=A0SCSI cmd to examine.
> @@ -1859,6 +1916,12 @@ enum scsi_disposition
> scsi_decide_disposition(struct scsi_cmnd *scmd)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return SUCCESS;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0
> +=A0=A0=A0=A0=A0=A0=A0if (blk_rq_is_passthrough(scsi_cmd_to_rq(scmd))) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rtn =3D scsi_check_passthro=
ugh(scmd);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (rtn !=3D SCSI_RETURN_NO=
T_HANDLED)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret=
urn rtn;
> +=A0=A0=A0=A0=A0=A0=A0}
> +
> =A0=A0=A0=A0=A0=A0=A0=A0/*
> =A0=A0=A0=A0=A0=A0=A0=A0 * first check the host byte, to see if there is =
anything in
> there
> =A0=A0=A0=A0=A0=A0=A0=A0 * that would indicate what we need to do.
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 497efc0da259..56aefe38d69b 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1608,6 +1608,7 @@ static blk_status_t scsi_prepare_cmd(struct
> request *req)
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0/* Usually overridden by the ULP */
> =A0=A0=A0=A0=A0=A0=A0=A0cmd->allowed =3D 0;
> +=A0=A0=A0=A0=A0=A0=A0cmd->failures =3D NULL;
> =A0=A0=A0=A0=A0=A0=A0=A0memset(cmd->cmnd, 0, sizeof(cmd->cmnd));
> =A0=A0=A0=A0=A0=A0=A0=A0return scsi_cmd_to_driver(cmd)->init_command(cmd)=
;
> =A0}
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index bac55decf900..9fb85932d5b9 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -65,6 +65,23 @@ enum scsi_cmnd_submitter {
> =A0=A0=A0=A0=A0=A0=A0=A0SUBMITTED_BY_SCSI_RESET_IOCTL =3D 2,
> =A0} __packed;
> =A0
> +#define SCMD_FAILURE_NONE=A0=A0=A0=A0=A0=A00
> +#define SCMD_FAILURE_ANY=A0=A0=A0=A0=A0=A0=A0-1
> +#define SCMD_FAILURE_SENSE_ANY=A00xff
> +#define SCMD_FAILURE_ASC_ANY=A0=A0=A00xff
> +#define SCMD_FAILURE_ASCQ_ANY=A0=A00xff
> +#define SCMD_FAILURE_NO_LIMIT=A0=A0-1
> +
> +struct scsi_failure {
> +=A0=A0=A0=A0=A0=A0=A0int result;
> +=A0=A0=A0=A0=A0=A0=A0u8 sense;
> +=A0=A0=A0=A0=A0=A0=A0u8 asc;
> +=A0=A0=A0=A0=A0=A0=A0u8 ascq;
> +
> +=A0=A0=A0=A0=A0=A0=A0s8 allowed;
> +=A0=A0=A0=A0=A0=A0=A0s8 retries;
> +};
> +
> =A0struct scsi_cmnd {
> =A0=A0=A0=A0=A0=A0=A0=A0struct scsi_device *device;
> =A0=A0=A0=A0=A0=A0=A0=A0struct list_head eh_entry; /* entry for the host
> eh_abort_list/eh_cmd_q */
> @@ -85,6 +102,8 @@ struct scsi_cmnd {
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0int retries;
> =A0=A0=A0=A0=A0=A0=A0=A0int allowed;
> +=A0=A0=A0=A0=A0=A0=A0/* optional array of failures that passthrough user=
s want
> retried */
> +=A0=A0=A0=A0=A0=A0=A0struct scsi_failure *failures;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0unsigned char prot_op;
> =A0=A0=A0=A0=A0=A0=A0=A0unsigned char prot_type;
> @@ -330,9 +349,14 @@ static inline void set_status_byte(struct
> scsi_cmnd *cmd, char status)
> =A0=A0=A0=A0=A0=A0=A0=A0cmd->result =3D (cmd->result & 0xffffff00) | stat=
us;
> =A0}
> =A0
> +static inline u8 __get_status_byte(int result)
> +{
> +=A0=A0=A0=A0=A0=A0=A0return result & 0xff;
> +}
> +
> =A0static inline u8 get_status_byte(struct scsi_cmnd *cmd)
> =A0{
> -=A0=A0=A0=A0=A0=A0=A0return cmd->result & 0xff;
> +=A0=A0=A0=A0=A0=A0=A0return __get_status_byte(cmd->result);
> =A0}
> =A0
> =A0static inline void set_host_byte(struct scsi_cmnd *cmd, char status)

