Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0171C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 19:05:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABBF264FE0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 19:05:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbhCKTEq convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 14:04:46 -0500
Received: from fgw20-4.mail.saunalahti.fi ([62.142.5.107]:49113 "EHLO
        fgw20-4.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229938AbhCKTEb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Mar 2021 14:04:31 -0500
Received: from imac.makisara.private (87-92-207-71.rev.dnainternet.fi [87.92.207.71])
        by fgw20.mail.saunalahti.fi (Halon) with ESMTPSA
        id 9b8aa21e-829c-11eb-ba24-005056bd6ce9;
        Thu, 11 Mar 2021 21:04:30 +0200 (EET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH] st: reject MTIOCTOP mt_count values out of range for the
 SPACE(6) scsi command
From:   =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= 
        <kai.makisara@kolumbus.fi>
In-Reply-To: <CA+-=Uwah2MS_aD+PeSBkQa_=1wCD+3=g6W4PvLnbJ_-px8G97g@mail.gmail.com>
Date:   Thu, 11 Mar 2021 21:04:27 +0200
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <ECFDF4C4-C716-4174-8493-B325851CC28B@kolumbus.fi>
References: <CA+-=Uwah2MS_aD+PeSBkQa_=1wCD+3=g6W4PvLnbJ_-px8G97g@mail.gmail.com>
To:     Patrick Strateman <patrick.strateman@gmail.com>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I am sorry that this is response has taken too long…

Martin suggested adding support for SPACE(16) and you said that you are willing to implement
that. I think this is the correct direction. I think that there are still in use old drives that don’t
support SPACE(16) and it is good if these are not forgotten.

In case you want the interim patch applied to prevent incorrect results with SPACE(6), I support that.

Thanks,
Kai


> On 13. Jan 2021, at 4.24, Patrick Strateman <patrick.strateman@gmail.com> wrote:
> 
> Values greater than 0x7FFFFF do not fit in the 24 bit big endian two's
> complement integer for the underlying scsi SPACE(6) command.
> 
> Signed-off-by: Patrick Strateman <patrick.strateman@gmail.com>

Acked-by: Kai Mäkisara <kai.makisara@kolumbus.fi>

> ---
> drivers/scsi/st.c | 16 ++++++++++++++++
> 1 file changed, 16 insertions(+)
> 
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index 43f7624508a9..190fa678d149 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -2719,6 +2719,22 @@ static int st_int_ioctl(struct scsi_tape *STp,
> unsigned int cmd_in, unsigned lon
>     blkno = STps->drv_block;
>     at_sm = STps->at_sm;
> 
> +    switch (cmd_in) {
> +    case MTFSFM:
> +    case MTFSF:
> +    case MTBSFM:
> +    case MTBSF:
> +    case MTFSR:
> +    case MTBSR:
> +    case MTFSS:
> +    case MTBSS:
> +        // count field for SPACE(6) is a 24 bit big endian two's
> complement integer
> +        if (arg > 0x7FFFFF) {
> +            st_printk(ST_DEB_MSG, STp, "Cannot space more than
> 0x7FFFFF units.\n");
> +            return (-EINVAL);
> +        }
> +    }
> +
>     memset(cmd, 0, MAX_COMMAND_SIZE);
>     switch (cmd_in) {
>     case MTFSFM:

