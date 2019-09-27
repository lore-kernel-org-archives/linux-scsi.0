Return-Path: <SRS0=gVs6=XW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB92C4360C
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Sep 2019 15:26:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A08EC217D7
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Sep 2019 15:26:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbfI0P0o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Sep 2019 11:26:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:38580 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727319AbfI0P0o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Sep 2019 11:26:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3D241AB7D;
        Fri, 27 Sep 2019 15:26:42 +0000 (UTC)
Message-ID: <471732f03049a1528df1d144013d723041f0a419.camel@suse.de>
Subject: Re: [PATCH] scsi: core: Log SCSI command age with errors
From:   Martin Wilck <mwilck@suse.de>
To:     "Milan P. Gandhi" <mgandhi@redhat.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com
Date:   Fri, 27 Sep 2019 17:26:46 +0200
In-Reply-To: <20190923060122.GA9603@machine1>
References: <20190923060122.GA9603@machine1>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2019-09-23 at 11:31 +0530,  Milan P. Gandhi wrote:
> Couple of users had requested to print the SCSI command age along 
> with command failure errors. This is a small change, but allows 
> users to get more important information about the command that was 
> failed, it would help the users in debugging the command failures:
> 
> Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
> ---
> diff --git a/drivers/scsi/scsi_logging.c
> b/drivers/scsi/scsi_logging.c
> index ecc5918e372a..ca2182bc53c6 100644
> --- a/drivers/scsi/scsi_logging.c
> +++ b/drivers/scsi/scsi_logging.c
> @@ -437,6 +437,7 @@ void scsi_print_result(const struct scsi_cmnd
> *cmd, const char *msg,
>  	const char *mlret_string = scsi_mlreturn_string(disposition);
>  	const char *hb_string = scsi_hostbyte_string(cmd->result);
>  	const char *db_string = scsi_driverbyte_string(cmd->result);
> +	unsigned long cmd_age = (jiffies - cmd->jiffies_at_alloc) / HZ;

This comes down to pretty coarse time resolution, does it not? More
often than not, the time difference shown will be 0. I'd recommend at
least millisecond resolution.

>  
>  	logbuf = scsi_log_reserve_buffer(&logbuf_len);
>  	if (!logbuf)
> @@ -478,10 +479,15 @@ void scsi_print_result(const struct scsi_cmnd
> *cmd, const char *msg,
>  
>  	if (db_string)
>  		off += scnprintf(logbuf + off, logbuf_len - off,
> -				 "driverbyte=%s", db_string);
> +				 "driverbyte=%s ", db_string);
>  	else
>  		off += scnprintf(logbuf + off, logbuf_len - off,
> -				 "driverbyte=0x%02x", driver_byte(cmd-
> >result));
> +				 "driverbyte=0x%02x ",
> +				 driver_byte(cmd->result));
> +
> +	off += scnprintf(logbuf + off, logbuf_len - off,
> +			 "cmd-age=%lus", cmd_age);

This is certainly helpful in some situations. Yet I am unsure if it
should *always* be printed. I wouldn't say it's as important as the 
other stuff scsi_print_result() provides. After all, by activating
MLQUEUE+MLCOMPLETE, the time on-wire can be extracted with better
accuracy from currently available logs. 

So perhaps make this depend on a module parameter?

Also, we should carefully ponder if we want to put this on the same
line as the driver byte, as users may have created scripts for parsing
this output.

Regards,
Martin


