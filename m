Return-Path: <SRS0=Y1L5=XE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8AA1C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Sep 2019 11:52:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AD7121920
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Sep 2019 11:52:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404309AbfIILwu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Sep 2019 07:52:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50546 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404215AbfIILwt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 9 Sep 2019 07:52:49 -0400
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1B8FA5AFE9
        for <linux-scsi@vger.kernel.org>; Mon,  9 Sep 2019 11:52:49 +0000 (UTC)
Received: by mail-qk1-f198.google.com with SMTP id w20so14993782qka.18
        for <linux-scsi@vger.kernel.org>; Mon, 09 Sep 2019 04:52:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CkP1XKb4Ipu83efc9YeevsDGcjt9KZv3bT0PM57OVrg=;
        b=FMt7VLUTZouqrhmGC/MvA/aS428pj91gZyTFAIk46lGbINTexsw7vnu2mB/bk+XfCu
         7Rp0VLbK2joRLdUMwjvUzXluy4MQUEQGD0dWQZV6WiRoupXF1JoLAdF2RV7ggsR0538z
         DleCo0rw8tIoHwunOTUO1jin7BjbA/yi0KmyJ2L/66nBeyn+hJCMiFv1JTfH7u3Npd1J
         IwzgG0+AeD5WQdjSj9hbygYYoNl1jYXHEM1EJeTWzakVp1mQj5z3xW4xcO1tylvV41js
         /x3KkGIHAOuJcvm+uhvxbcEL5xhAU+mY6P4RyG6DngbstJb7szJejexKbfj9kYK7BlzC
         QGYA==
X-Gm-Message-State: APjAAAWIjkVdDgY3MI7dyp8XSFFHudZuooOBVeLsuYFUpeNaCuiNMy6x
        fwc8Oc1l8kN+HORiUojvK8uqS9ORTrAvS89/cb6m5g6ZkFItdxP8Kos8jHUl35hSV3dWq5Xx2Qi
        1jOCYLXCmtkfhKAne1UFJ+w==
X-Received: by 2002:a37:883:: with SMTP id 125mr22000412qki.478.1568029968167;
        Mon, 09 Sep 2019 04:52:48 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy7UXwA+iMKaHbLkSdYaAE6FdxQnvEHOHNtcbzM4Ddrsbtji5KdKvkwyIDdJQc90sZZ8ST6Hg==
X-Received: by 2002:a37:883:: with SMTP id 125mr22000394qki.478.1568029967791;
        Mon, 09 Sep 2019 04:52:47 -0700 (PDT)
Received: from rhel7lobe ([2600:6c64:4e80:f1:aa45:cafe:5682:368f])
        by smtp.gmail.com with ESMTPSA id c26sm8175867qtk.93.2019.09.09.04.52.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Sep 2019 04:52:43 -0700 (PDT)
Message-ID: <10d6ef9022a8eb892b3837739276f15dd9c87d47.camel@redhat.com>
Subject: Re: [PATCH] V2.  bnx2fc: Handle scope bits when array returns BUSY
 or TASK_SET_FULL
From:   Laurence Oberman <loberman@redhat.com>
To:     cdupuis1@gmail.com, QLogic-Storage-Upstream@qlogic.com,
        linux-scsi@vger.kernel.org
Date:   Mon, 09 Sep 2019 07:52:39 -0400
In-Reply-To: <99d3265e65c6ca84e06a631caa276710ae9d27e2.camel@gmail.com>
References: <1567801579-18674-1-git-send-email-loberman@redhat.com>
         <99d3265e65c6ca84e06a631caa276710ae9d27e2.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 2019-09-07 at 21:34 -0400, cdupuis1@gmail.com wrote:
> On Fri, 2019-09-06 at 16:26 -0400, Laurence Oberman wrote:
> > The qla2xxx driver had this issue as well when the newer array
> > firmware returned the retry_delay_timer in the fcp_rsp.
> > The bnx2fc is not handling the masking of the scope bits either
> > so the retry_delay_timestamp value lands up being a large value
> > added to the timer timestamp delaying I/O for up to 27 Minutes.
> > This patch adds similar code to handle this to the
> > bnx2fc driver to avoid the huge delay.
> > 
> > Signed-off-by: Laurence Oberman <loberman@redhat.com>
> > ---
> >  drivers/scsi/bnx2fc/bnx2fc_io.c | 23 ++++++++++++++++++++---
> >  1 file changed, 20 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c
> > b/drivers/scsi/bnx2fc/bnx2fc_io.c
> > index 9e50e5b..39f4aeb 100644
> > --- a/drivers/scsi/bnx2fc/bnx2fc_io.c
> > +++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
> > @@ -1928,6 +1928,7 @@ void bnx2fc_process_scsi_cmd_compl(struct
> > bnx2fc_cmd *io_req,
> >  	struct bnx2fc_rport *tgt = io_req->tgt;
> >  	struct scsi_cmnd *sc_cmd;
> >  	struct Scsi_Host *host;
> > +	u16 scope, qualifier = 0;
> >  
> >  
> >  	/* scsi_cmd_cmpl is called with tgt lock held */
> > @@ -1997,12 +1998,28 @@ void bnx2fc_process_scsi_cmd_compl(struct
> > bnx2fc_cmd *io_req,
> >  
> >  			if (io_req->cdb_status ==
> > SAM_STAT_TASK_SET_FULL ||
> >  			    io_req->cdb_status == SAM_STAT_BUSY) {
> > +				/* Newer array firmware with BUSY or
> > +				 * TASK_SET_FULL may return a status
> > that needs
> > +				 * the scope bits masked.
> > +				 * Or a huge delay timestamp up to 27
> > minutes
> > +				 * can result.
> > +				*/
> > +				if (fcp_rsp->retry_delay_timer) {
> > +					/* Upper 2 bits */
> > +					scope = fcp_rsp-
> > > retry_delay_timer
> > 
> > +						& 0xC000;
> > +					/* Lower 14 bits */
> > +					qualifier = fcp_rsp-
> > > retry_delay_timer
> > 
> > +						& 0x3FFF;
> > +				}
> > +				if (scope > 0 && qualifier > 0 &&
> > +					qualifier <= 0x3FEF) {
> >  				/* Set the jiffies + retry_delay_timer
> > * 100ms
> >  				   for the rport/tgt */
> > -				tgt->retry_delay_timestamp = jiffies +
> > -					fcp_rsp->retry_delay_timer * HZ
> > / 10;
> > +					tgt->retry_delay_timestamp =
> > jiffies +
> > +						(qualifier * HZ / 10);
> > +				}
> >  			}
> > -
> >  		}
> >  		if (io_req->fcp_resid)
> >  			scsi_set_resid(sc_cmd, io_req->fcp_resid);
> 
> What better thing to be doing than reviewing patches on a Saturday
> evening.  Looks good though I might suggest moving the indent of the
> comment in the new if statement.
> 
> Reviewed-by: Chad Dupuis <cdupuis1@gmail.com>
> 

The qla2xxx driver had this issue as well when the newer array
firmware returned the retry_delay_timer in the fcp_rsp.
The bnx2fc is not handling the masking of the scope bits either
so the retry_delay_timestamp value lands up being a large value
added to the timer timestamp delaying I/O for up to 27 Minutes.
This patch adds similar code to handle this to the
bnx2fc driver to avoid the huge delay.

V2. Indent comments as suggested

Signed-off-by: Laurence Oberman <loberman@redhat.com>
Reported-by: David Jeffery <djeffery@redhat.com>

---
 drivers/scsi/bnx2fc/bnx2fc_io.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c
b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 9e50e5b..39f4aeb 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1928,6 +1928,7 @@ void bnx2fc_process_scsi_cmd_compl(struct
bnx2fc_cmd *io_req,
 	struct bnx2fc_rport *tgt = io_req->tgt;
 	struct scsi_cmnd *sc_cmd;
 	struct Scsi_Host *host;
+	u16 scope, qualifier = 0;
 
 
 	/* scsi_cmd_cmpl is called with tgt lock held */
@@ -1997,12 +1998,28 @@ void bnx2fc_process_scsi_cmd_compl(struct
bnx2fc_cmd *io_req,
 
 			if (io_req->cdb_status ==
SAM_STAT_TASK_SET_FULL ||
 			    io_req->cdb_status == SAM_STAT_BUSY) {
+				/* Newer array firmware with BUSY or
+				 * TASK_SET_FULL may return a status
that needs
+				 * the scope bits masked.
+				 * Or a huge delay timestamp up to 27
minutes
+				 * can result.
+				*/
+				if (fcp_rsp->retry_delay_timer) {
+					/* Upper 2 bits */
+					scope = fcp_rsp-
>retry_delay_timer
+						& 0xC000;
+					/* Lower 14 bits */
+					qualifier = fcp_rsp-
>retry_delay_timer
+						& 0x3FFF;
+				}
+				if (scope > 0 && qualifier > 0 &&
+					qualifier <= 0x3FEF) {
 					/* Set the jiffies +
retry_delay_timer * 100ms
 				   	for the rport/tgt */
-				tgt->retry_delay_timestamp = jiffies +
-					fcp_rsp->retry_delay_timer * HZ
/ 10;
+					tgt->retry_delay_timestamp =
jiffies +
+						(qualifier * HZ / 10);
+				}
 			}
-
 		}
 		if (io_req->fcp_resid)
 			scsi_set_resid(sc_cmd, io_req->fcp_resid);
-- 
1.8.3.1


