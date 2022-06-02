Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56096C43334
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jun 2022 19:00:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238312AbiFBTAr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jun 2022 15:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238334AbiFBTAo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jun 2022 15:00:44 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7508218B
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jun 2022 12:00:42 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id h23so9227273lfe.4
        for <linux-scsi@vger.kernel.org>; Thu, 02 Jun 2022 12:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bLXqpZqUpjmLtDJLdYDDgRERBZs8x5eg23gMXRE2O2I=;
        b=dr78rjNQlaLH6J7W/s+cvsrN8F6fedE+eFge26685r0DNnsuE/D41GDCJm4wx64lEo
         C1Xrmmayy9fx0wKO+3A4jecFcZLRAZybR0+HNsyUoqJUphOAmEZToPPkTaojPMHZH4E/
         WyIrDm8IDqEhNL9aqf50DiGSVHXGTXnJ46pZc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bLXqpZqUpjmLtDJLdYDDgRERBZs8x5eg23gMXRE2O2I=;
        b=4cCyylw1vexwDPf7ZEEink0CclCVckl+JPsNf4qC4WUAaGvWQSxEsI5Y0T/unMv4yK
         Ft8mA6aiLD422FsWNWenpGJSNYHHdr0jDHw5e3Pgxidqzq45jhSDEDubrvN+g3qz3aGJ
         hY3wz6Nup7sK6SeUZyzIUtdTkmDqgMKf9AtB0067NuCYF5wa09SYDBjPLRreXGTA3EWd
         M2l3eXXZJFfYA/bblDwQfy7Jk9RQz3sGc1XKafUnpo6WpqSl+dcTyoWBB/gDY+rV+wt+
         yc/jOD9WNdd7f10psi254284t3+nB0t3PzkxkIEDMp2q9yBzaAq7aWPkMK/XI+ZwEC8s
         ARjA==
X-Gm-Message-State: AOAM533HD2ebFFRlDdmcBsrijjdCHPCMn7SVNO8lqGF/F3zmCcWhN67r
        LtuHhZnme0I2cej3OTREeNhAXObc8CyRoGu5zD1fFqFXVb1NTw==
X-Google-Smtp-Source: ABdhPJycdpow/f52aXXEG2UlzWrKJNIDuhpykCxvmNIp0xbY7jcDjB+7pKGmbdJ4E7jAef5zdToIU29goQ8lDxLmDF0=
X-Received: by 2002:a05:6512:687:b0:478:d7ba:6a7c with SMTP id
 t7-20020a056512068700b00478d7ba6a7cmr4410545lfe.556.1654196441050; Thu, 02
 Jun 2022 12:00:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAHZQxyKMcCaquQ9n8pJ9tNb3HRZ2e14iXXojYS3C4=dB6NpUKQ@mail.gmail.com>
 <YpjTek7u+7+zFXzM@infradead.org>
In-Reply-To: <YpjTek7u+7+zFXzM@infradead.org>
From:   Brian Bunker <brian@purestorage.com>
Date:   Thu, 2 Jun 2022 12:00:30 -0700
Message-ID: <CAHZQxyL9km19F+Pyv3DBeP7NHgg-m-zxNcw9gB97DTfeg_F=hA@mail.gmail.com>
Subject: Re: [PATCH] scsi_lib: allow the ALUA transitioning state time to complete
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jun 2, 2022 at 8:12 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Thu, Jun 02, 2022 at 08:10:28AM -0700, Brian Bunker wrote:
> >  static void scsi_io_completion_reprep(struct scsi_cmnd *cmd,
> > -                                     struct request_queue *q)
> > +                                     struct request_queue *q,
> > unsigned long msecs)
> >  {
> >         /* A new command will be prepared and issued. */
> > -       scsi_mq_requeue_cmd(cmd);
> > +       scsi_mq_requeue_cmd(cmd, msecs);
>
> q is unused.  But I think it is better if we just kill this pointless
> wrapper anyway.
>
> > +       case ACTION_DELAYED_REPREP:
> > +               scsi_io_completion_reprep(cmd, q, ALUA_TRANSITION_REPREP_DELAY);
>
> This is using spaces where it should use tabs.
>

Like this then:

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e9db7da0c79c..e16a129fb064 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -118,7 +118,7 @@ scsi_set_blocked(struct scsi_cmnd *cmd, int
reason)
        }
 }

-static void scsi_mq_requeue_cmd(struct scsi_cmnd *cmd)
+static void scsi_mq_requeue_cmd(struct scsi_cmnd *cmd, unsigned long
msecs)
 {
        struct request *rq = scsi_cmd_to_rq(cmd);

@@ -128,7 +128,12 @@ static void scsi_mq_requeue_cmd(struct scsi_cmnd
*cmd)
        } else {
                WARN_ON_ONCE(true);
        }
-       blk_mq_requeue_request(rq, true);
+
+       if (msecs) {
+               blk_mq_requeue_request(rq, false);
+               blk_mq_delay_kick_requeue_list(rq->q, msecs);
+       } else
+               blk_mq_requeue_request(rq, true);
 }

 /**
@@ -658,14 +663,6 @@ static unsigned int scsi_rq_err_bytes(const
struct request                            *rq)
        return bytes;
 }

-/* Helper for scsi_io_completion() when "reprep" action required. */
-static void scsi_io_completion_reprep(struct scsi_cmnd *cmd,
-                                     struct request_queue *q)
-{
-       /* A new command will be prepared and issued. */
-       scsi_mq_requeue_cmd(cmd);
-}
-
 static bool scsi_cmd_runtime_exceeced(struct scsi_cmnd *cmd)
 {
        struct request *req = scsi_cmd_to_rq(cmd);
@@ -683,14 +680,22 @@ static bool scsi_cmd_runtime_exceeced(struct
scsi_cmnd *cm                           d)
        return false;
 }

+/*
+ * When ALUA transition state is returned, reprep the cmd to
+ * use the ALUA handlers transition timeout. Delay the reprep
+ * 1 sec to avoid aggressive retries of the target in that
+ * state.
+ */
+#define ALUA_TRANSITION_REPREP_DELAY   1000
+
 /* Helper for scsi_io_completion() when special action required. */
 static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 {
        struct request_queue *q = cmd->device->request_queue;
        struct request *req = scsi_cmd_to_rq(cmd);
        int level = 0;
-       enum {ACTION_FAIL, ACTION_REPREP, ACTION_RETRY,
-             ACTION_DELAYED_RETRY} action;
+       enum {ACTION_FAIL, ACTION_REPREP, ACTION_DELAYED_REPREP,
+             ACTION_RETRY, ACTION_DELAYED_RETRY} action;
        struct scsi_sense_hdr sshdr;
        bool sense_valid;
        bool sense_current = true;      /* false implies "deferred sense" */
@@ -779,8 +784,8 @@ static void scsi_io_completion_action(struct
scsi_cmnd *cmd, int result)
                                        action = ACTION_DELAYED_RETRY;
                                        break;
                                case 0x0a: /* ALUA state transition */
-                                       blk_stat = BLK_STS_AGAIN;
-                                       fallthrough;
+                                       action = ACTION_DELAYED_REPREP;
+                                       break;
                                default:
                                        action = ACTION_FAIL;
                                        break;
@@ -839,7 +844,10 @@ static void scsi_io_completion_action(struct
scsi_cmnd *cmd, int result)
                        return;
                fallthrough;
        case ACTION_REPREP:
-               scsi_io_completion_reprep(cmd, q);
+               scsi_mq_requeue_cmd(cmd, 0);
+               break;
+       case ACTION_DELAYED_REPREP:
+               scsi_mq_requeue_cmd(cmd, msecs);
                break;
        case ACTION_RETRY:
                /* Retry the same command immediately */
@@ -933,7 +941,7 @@ static int scsi_io_completion_nz_result(struct
scsi_cmnd *cmd, int result,
  * command block will be released and the queue function will be goosed. If we
  * are not done then we have to figure out what to do next:
  *
- *   a) We can call scsi_io_completion_reprep().  The request will be
+ *   a) We can call scsi_mq_requeue_cmd().  The request will be
  *     unprepared and put back on the queue.  Then a new command will
  *     be created for it.  This should be used if we made forward
  *     progress, or if we want to switch from READ(10) to READ(6) for
@@ -986,7 +994,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd,
unsigned int good_bytes)
         * request just queue the command up again.
         */
        if (likely(result == 0))
-               scsi_io_completion_reprep(cmd, q);
+               scsi_mq_requeue_cmd(cmd, 0);
        else
                scsi_io_completion_action(cmd, result);
 }


-- 

Brian Bunker
PURE Storage, Inc.
brian@purestorage.com
