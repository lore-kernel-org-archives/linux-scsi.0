Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 387C0C00140
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Aug 2022 10:46:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbiHJKqX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Aug 2022 06:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiHJKqW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Aug 2022 06:46:22 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F16085FB1
        for <linux-scsi@vger.kernel.org>; Wed, 10 Aug 2022 03:46:20 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id EE73638172;
        Wed, 10 Aug 2022 10:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1660128378; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M7MHVNOuKAQx2t6zWfROC3WzGRhBwMLxOL3BtcVT6fA=;
        b=ncurZDn3GJPvhTMhAgRs7mTwagbeRT7rN+UywilDorsNKaAX5w9lYZvD0INS7UuClUXFiF
        4A4FlliaZm8KywCXmKzPppZMkJP3qk/n3OQm5uEPxLXUhRlFEzDEzN8qwHYz6YndKErSTx
        d4ojBnZZMS2oAnV3wkcMy8toGaI4mUQ=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7DA9B13A7E;
        Wed, 10 Aug 2022 10:46:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id BRIrHHqM82ImRAAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 10 Aug 2022 10:46:18 +0000
Message-ID: <6149f7bdfa013e0352e59dee2669298b2c080a03.camel@suse.com>
Subject: Re: [PATCH 3/4] scsi: Internally retry scsi_execute commands
From:   Martin Wilck <mwilck@suse.com>
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Hannes Reinecke <Hannes.Reinecke@suse.com>
Date:   Wed, 10 Aug 2022 12:46:17 +0200
In-Reply-To: <20220810034155.20744-4-michael.christie@oracle.com>
References: <20220810034155.20744-1-michael.christie@oracle.com>
         <20220810034155.20744-4-michael.christie@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Mike,

On Tue, 2022-08-09 at 22:41 -0500, Mike Christie wrote:
> In several places like LU setup and pr_ops we will hit the noretry
> code
> path because we do not retry any passthrough commands that hit device
> errors even though scsi-ml thinks the command is retryable.
>=20
> This has us only fast fail commands that hit device errors that have
> been
> submitted through the block layer directly and not via scsi_execute.
> This
> allows SG IO and other users to continue to get fast failures and all
> device errors returned to them, and scsi_execute users will get their
> retries they had requested.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>

Thanks a lot. I like the general approach, but I am concerned that by
treating every command sent by scsi_execute() or scsi_execute_req() as
a retryable command, we may break some callers, or at least modify
their semantics in unexpected ways. For example, spi_execute(),
scsi_probe_lun(), scsi_report_lun_scan() currently retry only on UA.
With this change, these commands will be retried in additional cases,
without the caller noticing (see 949bf797595fc ("[SCSI] fix command
retries in spi_transport class"). It isn't obvious to me that this is
correct in all affected cases.=A0

Note that the retry logic of the mid level may change depending on the
installed device handler. For example, ALUA devices will endlessly
retry UA with ASC=3D29, which some callers explicitly look for.

I believe we need to review all callers that have their own retry loop
and /or error handling logic. This includes sd_spinup_disk(),
sd_sync_cache(), scsi_test_unit_ready(). SCSI device handlers treat
some sense keys in special ways, or may retry commands on another
member of a port group (see alua_rtpg()).

DID_TIME_OUT is a general concern - no current caller of scsi_execute()
expects timed-out commands to be retried, and doing so has the
potential of slowing down operations a lot. I am aware that my recent
patch changed exactly this for scsi_probe_lun(), but doing the same
thing for every scsi_execute() invocation sounds at least somewhat
dangerous.

Bottom line: I wonder if SUBMITTED_BY_SCSI_EXEC is suffient to
determine that a command should be retried like an ordinary block level
command.

Regards,
Martin


> ---
> =A0drivers/scsi/scsi_error.c | 3 ++-
> =A01 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index ac4471e33a9c..573d926220c4 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1806,7 +1806,8 @@ bool scsi_noretry_cmd(struct scsi_cmnd *scmd)
> =A0=A0=A0=A0=A0=A0=A0=A0 * assume caller has checked sense and determined
> =A0=A0=A0=A0=A0=A0=A0=A0 * the check condition was retryable.
> =A0=A0=A0=A0=A0=A0=A0=A0 */
> -=A0=A0=A0=A0=A0=A0=A0if (req->cmd_flags & REQ_FAILFAST_DEV ||
> blk_rq_is_passthrough(req))
> +=A0=A0=A0=A0=A0=A0=A0if (req->cmd_flags & REQ_FAILFAST_DEV ||
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 scmd->submitter =3D=3D SUBMITTED_BY_BLOCK=
_PT)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return true;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0return false;

