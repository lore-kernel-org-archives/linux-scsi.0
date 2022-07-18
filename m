Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5ED7C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jul 2022 08:45:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234025AbiGRIpq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jul 2022 04:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233911AbiGRIpm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2022 04:45:42 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9E055A5;
        Mon, 18 Jul 2022 01:45:40 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 131C04126D;
        Mon, 18 Jul 2022 08:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received:received; s=mta-01; t=
        1658133936; x=1659948337; bh=BIq+hEEh8RMOoO4jTsB6tGOwoYt0aWSQe3S
        gw6BDfiQ=; b=VWSjka2yI1SOxsg5QABddIdA7x0mNVOMOg0A/PZozvUJqS0S06j
        Eo+5k0Rwoy0HjVjGOU8oJET/TgpNaf9E99yV2fD35RXq0aaUFYS8m3p4VqDKfspA
        At98+9AyeOwYOcj169c6QwdFuLKTgSrv9HZYGQCxJRQAv829pm/Vhv+g=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Ox1RSROYcUWG; Mon, 18 Jul 2022 11:45:36 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id D081041253;
        Mon, 18 Jul 2022 11:45:32 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Mon, 18 Jul 2022 11:45:32 +0300
Received: from yadro.com (10.199.18.20) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Mon, 18 Jul
 2022 11:45:31 +0300
Date:   Mon, 18 Jul 2022 11:45:34 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>,
        Nick Couchman <nick.e.couchman@gmail.com>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>
Subject: Re: [PATCH] target: iscsi: handle abort for WRITE_PENDING cmds
Message-ID: <20220718084534.GA12544@yadro.com>
References: <20220713204212.7850-1-d.bogdanov@yadro.com>
 <0fc89e77-197b-47e6-f661-5f7f18f6634f@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0fc89e77-197b-47e6-f661-5f7f18f6634f@oracle.com>
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Mike,

On Thu, Jul 14, 2022 at 11:44:25AM -0500, Mike Christie wrote:
> 
> On 7/13/22 3:42 PM, Dmitry Bogdanov wrote:
> > Sometimes an initiator does not send data for WRITE commands and tries
> > to abort it. The abort hangs waiting for frontend driver completion.
> > iSCSI driver waits for for data and that timeout eventually initiates
> > connection reinstatment. The connection closing releases the commands in
> > the connection, but those aborted commands still did not handle the
> > abort and did not decrease a command ref counter. Because of that the
> > connection reinstatement hangs indefinitely and prevents re-login for
> > that initiator.
> >
> > This patch adds a handling in TCM of the abort for the WRITE_PENDING
> > commands at connection closing moment to make it possible to release
> > them.
> >
> > Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> > ---
> >  drivers/target/iscsi/iscsi_target.c | 13 ++++++++++---
> >  1 file changed, 10 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> > index e368f038ff5c..27eca5e72f52 100644
> > --- a/drivers/target/iscsi/iscsi_target.c
> > +++ b/drivers/target/iscsi/iscsi_target.c
> > @@ -26,6 +26,7 @@
> >  #include <target/target_core_base.h>
> >  #include <target/target_core_fabric.h>
> >
> > +#include <target/target_core_backend.h>
> >  #include <target/iscsi/iscsi_target_core.h>
> >  #include "iscsi_target_parameters.h"
> >  #include "iscsi_target_seq_pdu_list.h"
> > @@ -4171,7 +4172,8 @@ static void iscsit_release_commands_from_conn(struct iscsit_conn *conn)
> >
> >               if (se_cmd->se_tfo != NULL) {
> >                       spin_lock_irq(&se_cmd->t_state_lock);
> > -                     if (se_cmd->transport_state & CMD_T_ABORTED) {
> > +                     if (se_cmd->t_state != TRANSPORT_WRITE_PENDING &&
> > +                         se_cmd->transport_state & CMD_T_ABORTED) {
> >                               /*
> >                                * LIO's abort path owns the cleanup for this,
> >                                * so put it back on the list and let
> > @@ -4191,8 +4193,13 @@ static void iscsit_release_commands_from_conn(struct iscsit_conn *conn)
> >               list_del_init(&cmd->i_conn_node);
> >
> >               iscsit_increment_maxcmdsn(cmd, sess);
> > -             iscsit_free_cmd(cmd, true);
> > -
> > +             if (cmd->se_cmd.t_state == TRANSPORT_WRITE_PENDING &&
> > +                 cmd->se_cmd.transport_state & CMD_T_ABORTED) {
> > +                     /* handle an abort in TCM */
> > +                     target_complete_cmd(&cmd->se_cmd, SAM_STAT_TASK_ABORTED);
> >
> 
> Will we have an extra ref left on the se_cmd if TAS is used so the se_cmd
> does not get freed?
> 
> For TAS, it looks like we would do:
> 
> - target_handle_abort -> queue_status. This would not do anything because
> before calling iscsit_release_commands_from_conn we have killed the iscsi tx
> thread.
> 
> - target_handle_abort -> transport_cmd_check_stop_to_fabric -> check_stop_free ->
> target_put_sess_cmd.
> 
> iscsi creates the se_cmd with TARGET_SCF_ACK_KREF set so do we have one ref
> left?
Yes, you are right. TAS case is not covered by my patch. But that is
actually another bug (that iSCSI does not complete responses in case of
connection closed).
My patch does not do worse for the that case.
IMHO, TAS + connection closed case has to be addressed in a separate patch.
> 
> For the non TAS case we do two puts:
> 
> target_handle_abort -> SCF_ACK_KREF is set so we do a target_put_sess_cmd here.
> 
> target_handle_abort -> transport_cmd_check_stop_to_fabric -> check_stop_free ->
> target_put_sess_cmd which does a second put.

