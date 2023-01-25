Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0FABC54EED
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Jan 2023 20:51:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236534AbjAYUvD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Jan 2023 15:51:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235174AbjAYUvC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jan 2023 15:51:02 -0500
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A60E40C1;
        Wed, 25 Jan 2023 12:50:59 -0800 (PST)
Received: from mta-01.yadro.com (localhost.localdomain [127.0.0.1])
        by mta-01.yadro.com (Proxmox) with ESMTP id 93319341CB9;
        Wed, 25 Jan 2023 23:50:57 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; h=cc
        :cc:content-type:content-type:date:from:from:in-reply-to
        :message-id:mime-version:references:reply-to:subject:subject:to
        :to; s=mta-01; bh=GIyOvFMNyA3fCJNpJNPOa+C37WuGFiuD6d3HgX8tf9o=; b=
        gVVtzkbk+7O/fpFWCAHKw8/tdRCHJYmzkLDdKzsQ5YRgE8vCf9xowRPN+R1nyv6X
        XchEEwQnkgC8xZW+95Uo6qZSENsgI2Ynk4yetTAcEHQn99ZoE9dsArBEvNR0LPgm
        WyfBQhvvCDucaOANmBLmipODWDucWQR14k8PYfLMqSE=
Received: from T-EXCH-08.corp.yadro.com (unknown [172.17.10.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Proxmox) with ESMTPS id 89113341C77;
        Wed, 25 Jan 2023 23:50:57 +0300 (MSK)
Received: from yadro.com (10.199.18.20) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Wed, 25 Jan
 2023 23:50:57 +0300
Date:   Wed, 25 Jan 2023 23:50:56 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     <michael.christie@oracle.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>, Forza <forza@tnonline.net>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>
Subject: Re: [PATCH 1/2] target: iscs: reject cmd in closed session
Message-ID: <20230125205056.GI31614@yadro.com>
References: <20230125083309.24678-1-d.bogdanov@yadro.com>
 <20230125083309.24678-2-d.bogdanov@yadro.com>
 <825571ca-4687-4b5c-971f-b9e13efb152d@oracle.com>
 <478beda7-df98-d925-bfac-2856984c12d7@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <478beda7-df98-d925-bfac-2856984c12d7@oracle.com>
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Mike,

On Wed, Jan 25, 2023 at 11:18:32AM -0600, michael.christie@oracle.com wrote:
> On 1/25/23 11:03 AM, Mike Christie wrote:
> > On 1/25/23 02:33, Dmitry Bogdanov wrote:
> >> Do not handle incoming commands if the session is already closed.
> >>
> >> That patch fixes the following stacktrace:
> >>
> >>  Decremented iSCSI connection count to 0 from node: iqn.1996-04.com.local:3
> >>  TARGET_CORE[iSCSI]: Deregistered fabric_sess
> >>  Moving to TARG_SESS_STATE_FREE.
> >>  Released iSCSI session from node: iqn.1996-04.com.local:3
> >>  Decremented number of active iSCSI Sessions on iSCSI TPG: 0 to 1
> >>  rx_loop: 48, total_rx: 48, data: 48
> >>  Got SCSI Command, ITT: 0x2000005d, CmdSN: 0x4a020000, ExpXferLen: 0, Length: 0, CID: 0
> >> BUG: Kernel NULL pointer dereference on read at 0x00000000
> >>   Faulting instruction address: 0xc008000000a9b574
> >>   Oops: Kernel access of bad area, sig: 11 [#1]
> >>   NIP [c008000000a9b574] transport_lookup_cmd_lun+0x37c/0x470 [target_core_mod]
> >>   LR [c008000001017318] iscsit_setup_scsi_cmd+0x520/0x780 [iscsi_target_mod]
> >> Call Trace:
> >>  [c000000059e4fae0] [c000000059e4fb70] 0xc000000059e4fb70 (unreliable)
> >>  [c000000059e4fb70] [c008000001017318] iscsit_setup_scsi_cmd+0x520/0x780 [iscsi_target_mod]
> >>  [c000000059e4fc30] [c00800000101c448] iscsit_get_rx_pdu+0x720/0x11d0 [iscsi_target_mod]
> >>  [c000000059e4fd60] [c00800000101ebc8] iscsi_target_rx_thread+0xb0/0x190 [iscsi_target_mod]
> >>  [c000000059e4fdb0] [c00000000018c50c] kthread+0x19c/0x1b0
> >>
> >> Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> >> ---
> >>  drivers/target/iscsi/iscsi_target.c | 8 ++++++--
> >>  include/scsi/iscsi_proto.h          | 1 +
> >>  2 files changed, 7 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> >> index baf4da7bb3b4..f6008675dd3f 100644
> >> --- a/drivers/target/iscsi/iscsi_target.c
> >> +++ b/drivers/target/iscsi/iscsi_target.c
> >> @@ -1199,7 +1199,9 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
> >>              hdr->cmdsn, be32_to_cpu(hdr->data_length), payload_length,
> >>              conn->cid);
> >>
> >> -    target_get_sess_cmd(&cmd->se_cmd, true);
> >> +    if (target_get_sess_cmd(&cmd->se_cmd, true) < 0)
> >> +            return iscsit_add_reject_cmd(cmd,
> >> +                            ISCSI_REASON_WAITING_FOR_LOGOUT, buf);
> >>
> > Did this require target_stop_session somewhere? I think this is a possible

In my private patchset there the third patch was with
target_stop_session/target_wait_for_sess_cmds right after
scsit_free_connection_recovery_entries(sess) from the second patch.
I did not post it because you are preparing a patchset with
target_wait_for_sess_cmds in iscsi.

Please, take my second patch to your patchset (if Martin will not take
it separately), it is definitely a bugfix.
But, please, take care that after
iscsit_free_connection_recovery_entries iscsi should wait for commands
complete too to fix that use-after-free completely.

> Oh wait, if there is a use after free like below then iscsit_stop_session
> won't help since we are trying to stop incoming commands from referencing
> the se_session/iscsit_session. We would need to check something on the
> iscsit_conn.

Looking at the log snippet now I see that the call trace is not about
new command in the dead session. Because iscsi session is closed only
after both RX and TX threads have been stopped. It was a command in an
alive session.
Most likely, that call trace was due to the problem that I fixed in
dd0a66ada0bd ("scsi: target: core: Fix race during ACL removal") that
was catched on FC. And this one was on iSCSI. They are about the same
age.

I am dropping this (1st) patch as it is for an unreal case and actually does
not solve use-after-free session: iscsit_add_reject_cmd in the end calls
target_put_sess_cmd(se_cmd);
	target_free_tag(sess->se_sess, cmd);
    percpu_ref_put(&se_sess->cmd_count);


> > use after free.
> >
> > It seems like if we have logged the message:
> >
> >>  Moving to TARG_SESS_STATE_FREE.
> >
> > then we called:
> >
> > transport_deregister_session -> transport_free_session
> >
> > and freed the se_session.
> >
> > So above if target_get_sess_cmd returns failure then we have run:
> >
> > transport_free_session ->transport_uninit_session -> percpu_ref_exit
> >
> > and transport_free_session could have done:
> >
> > kmem_cache_free(se_sess_cache, se_sess)
> >
> > by the time we run the code above and we are now accessing a freed
> > se_session and iscsit_session.

 
BR,
 Dmitry

