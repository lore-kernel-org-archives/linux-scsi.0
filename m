Return-Path: <SRS0=gVs6=XW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99536C4360C
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Sep 2019 17:45:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7560821655
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Sep 2019 17:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfI0Rp0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Sep 2019 13:45:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32850 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726321AbfI0RpZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Sep 2019 13:45:25 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8B24F81F0D
        for <linux-scsi@vger.kernel.org>; Fri, 27 Sep 2019 17:45:25 +0000 (UTC)
Received: by mail-io1-f70.google.com with SMTP id r13so13803841ioj.22
        for <linux-scsi@vger.kernel.org>; Fri, 27 Sep 2019 10:45:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V7uKVOUP48sjqm3uZXCLKF4/Ns/Wlt7x8/p5qhE25yM=;
        b=ANRyyUshEJmGZW5RzF4w6oAcQ9xMZsmqtiwDRQe2dgxg48Y3uv9QQ8xTLyw6Gh/rui
         IGjX1kPjLW5H8iNIyLYjBzW2hA2UGI30nGMK3TT2T/Y3YDklic/2p34Am+i0L3ER3NkJ
         woWsZdui3oD4AqIz35BfBEDV/CTjPERSMxuG6ND/cZciY8BWF1Q0QTwMzB7VdVbqvm9h
         aAFxsYs4/mi8T1rDBoEYnfKwPvm8H9njwYQjZn4ksW/pQvXE71Dl/3mwXJaePm3siE0C
         AvCxZzLheF3p33OttJn2XflUf+vm0Qsw+oI5E19ysCVTeBukDdbxA1Ohu2JD/86wRyjk
         m51A==
X-Gm-Message-State: APjAAAVqhWOA5Me8gVOBqTHcI0fORL5DCQohVbigKWMLBdtlzunLpmtT
        wafKanjaW5Rkh/paQ5z/N/fdOF5dUSKs0FHYuAIlxeXpzDqSQnouAGJDUSInaxWkzLsKh2l5e5Z
        OXFnuMcGmEivQgf0ylyzV8g==
X-Received: by 2002:a6b:7b01:: with SMTP id l1mr9667885iop.292.1569606324581;
        Fri, 27 Sep 2019 10:45:24 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxn9P3vvJuZThbXqohEVpw39+J3Lm89eYktjf2LzDdXdg38hErbsCdidVqxqFGbfNDqBwekMw==
X-Received: by 2002:a6b:7b01:: with SMTP id l1mr9667854iop.292.1569606324228;
        Fri, 27 Sep 2019 10:45:24 -0700 (PDT)
Received: from rhel7lobe ([2600:6c64:4e80:f1:aa45:cafe:5682:368f])
        by smtp.gmail.com with ESMTPSA id b7sm2529587iod.42.2019.09.27.10.45.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Sep 2019 10:45:23 -0700 (PDT)
Message-ID: <3a8ee584f9846fba94d98d0e6941fefdcbed5d71.camel@redhat.com>
Subject: Re: [PATCH] scsi: core: Log SCSI command age with errors
From:   Laurence Oberman <loberman@redhat.com>
To:     Martin Wilck <mwilck@suse.de>,
        "Milan P. Gandhi" <mgandhi@redhat.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com
Date:   Fri, 27 Sep 2019 13:45:21 -0400
In-Reply-To: <471732f03049a1528df1d144013d723041f0a419.camel@suse.de>
References: <20190923060122.GA9603@machine1>
         <471732f03049a1528df1d144013d723041f0a419.camel@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2019-09-27 at 17:26 +0200, Martin Wilck wrote:
> On Mon, 2019-09-23 at 11:31 +0530,  Milan P. Gandhi wrote:
> > Couple of users had requested to print the SCSI command age along 
> > with command failure errors. This is a small change, but allows 
> > users to get more important information about the command that was 
> > failed, it would help the users in debugging the command failures:
> > 
> > Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
> > ---
> > diff --git a/drivers/scsi/scsi_logging.c
> > b/drivers/scsi/scsi_logging.c
> > index ecc5918e372a..ca2182bc53c6 100644
> > --- a/drivers/scsi/scsi_logging.c
> > +++ b/drivers/scsi/scsi_logging.c
> > @@ -437,6 +437,7 @@ void scsi_print_result(const struct scsi_cmnd
> > *cmd, const char *msg,
> >  	const char *mlret_string = scsi_mlreturn_string(disposition);
> >  	const char *hb_string = scsi_hostbyte_string(cmd->result);
> >  	const char *db_string = scsi_driverbyte_string(cmd->result);
> > +	unsigned long cmd_age = (jiffies - cmd->jiffies_at_alloc) / HZ;
> 
> This comes down to pretty coarse time resolution, does it not? More
> often than not, the time difference shown will be 0. I'd recommend at
> least millisecond resolution.
> 
> >  
> >  	logbuf = scsi_log_reserve_buffer(&logbuf_len);
> >  	if (!logbuf)
> > @@ -478,10 +479,15 @@ void scsi_print_result(const struct scsi_cmnd
> > *cmd, const char *msg,
> >  
> >  	if (db_string)
> >  		off += scnprintf(logbuf + off, logbuf_len - off,
> > -				 "driverbyte=%s", db_string);
> > +				 "driverbyte=%s ", db_string);
> >  	else
> >  		off += scnprintf(logbuf + off, logbuf_len - off,
> > -				 "driverbyte=0x%02x", driver_byte(cmd-
> > > result));
> > 
> > +				 "driverbyte=0x%02x ",
> > +				 driver_byte(cmd->result));
> > +
> > +	off += scnprintf(logbuf + off, logbuf_len - off,
> > +			 "cmd-age=%lus", cmd_age);
> 
> This is certainly helpful in some situations. Yet I am unsure if it
> should *always* be printed. I wouldn't say it's as important as the 
> other stuff scsi_print_result() provides. After all, by activating
> MLQUEUE+MLCOMPLETE, the time on-wire can be extracted with better
> accuracy from currently available logs. 
> 
> So perhaps make this depend on a module parameter?
> 
> Also, we should carefully ponder if we want to put this on the same
> line as the driver byte, as users may have created scripts for
> parsing
> this output.
> 
> Regards,
> Martin
> 
> 
Hi Martin

Agreed about log extraction, but turning that on with a busy workload
in a production environment is not practical. We cant do it with
systems with 1000's of luns and 1000's of IOPS/sec.
Also second resolution is good enough for the debug we want to see.

Regards
Laurence

