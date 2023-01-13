Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 264B7C54EBE
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Jan 2023 14:12:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234059AbjAMOMh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Jan 2023 09:12:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241320AbjAMOMO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jan 2023 09:12:14 -0500
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9773E8D5E5;
        Fri, 13 Jan 2023 06:08:19 -0800 (PST)
Received: from mta-01.yadro.com (localhost.localdomain [127.0.0.1])
        by mta-01.yadro.com (Proxmox) with ESMTP id 7155E341746;
        Fri, 13 Jan 2023 17:08:17 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; h=cc
        :cc:content-type:content-type:date:from:from:in-reply-to
        :message-id:mime-version:references:reply-to:subject:subject:to
        :to; s=mta-01; bh=wUB2XrlKQCI2b2IvULO1TtTfCjn0ogMQX5Y6hiYqPIA=; b=
        nOX/3M2oODZ98+LgHCPnhqmeLdTWiN0be2b6yIQ11mLyWhvGQ+GQAb5Uk2WLERao
        MyqRH6Lm+HNk9MKTnOHAa5cSBRGIs7jEMtZrkVvN0glsLvn+bLVVORidO+m2VVjK
        zQOS3jwoaBX0mAimMhd+I6eUroq/2O+gI1DMqI0LQio=
Received: from T-EXCH-08.corp.yadro.com (unknown [172.17.10.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Proxmox) with ESMTPS id 65A0E34173F;
        Fri, 13 Jan 2023 17:08:17 +0300 (MSK)
Received: from yadro.com (10.178.114.42) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Fri, 13 Jan
 2023 17:08:16 +0300
Date:   Fri, 13 Jan 2023 17:08:16 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     <mlombard@redhat.com>, <martin.petersen@oracle.com>,
        <mgurtovoy@nvidia.com>, <sagi@grimberg.me>,
        <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
Subject: Re: [PATCH v2 09/13] scsi: target: iscsit: Fix isert disconnect
 handling during login
Message-ID: <20230113140816.GA31614@yadro.com>
References: <20230112030832.110143-1-michael.christie@oracle.com>
 <20230112030832.110143-10-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230112030832.110143-10-michael.christie@oracle.com>
X-Originating-IP: [10.178.114.42]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jan 11, 2023 at 09:08:28PM -0600, Mike Christie wrote:
> 
> If we get a disconnect event while logging in we can end up in a state
> where will never be able to relogin. This happens when:
> 
> 1. login thread has put us into TARG_CONN_STATE_IN_LOGIN
> 2. isert then does
> 
> isert_disconnected_handler -> iscsit_cause_connection_reinstatement
> 
> which sets the conn connection_reinstatement flag. Nothing else happens
> because we are only in IN_LOGIN. The tx/rx threads are not running yet
> so we can't start recovery from those contexts at this time.
> 
> 3. The login thread finishes processing the login pdu and thinks login is
> done. It sets us into TARG_CONN_STATE_LOGGED_IN/TARG_SESS_STATE_LOGGED_IN.
> This starts the rx/tx threads.
> 
> 4. The initiator thought it disconnected the connection at 2, and has
> since sent a new connect which is now handled. This leads us to eventually
> run:
> 
> iscsi_check_for_session_reinstatement-> iscsit_stop_session ->
> iscsit_cause_connection_reinstatement
> 
> iscsit_stop_session sees the old conn and does
> iscsit_cause_connection_reinstatement which sees connection_reinstatement
> is set so it just returns instead of trying to kill the tx/rx threads
> which would have caused recovery to start.
> 
> 5. iscsit_stop_session then waits on session_wait_comp which will never
> happen since we didn't kill the tx/rx threads.
> 
> This has the iscsit login code check if a fabric driver ran
> iscsit_cause_connection_reinstatement during the login process similar
> to how we check for the sk state for tcp based iscsit. This will prevent
> us from getting into 3 and creating a ghost session.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/target/iscsi/iscsi_target_nego.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
> index ff49c8f3fe24..2dd81752d4c9 100644
> --- a/drivers/target/iscsi/iscsi_target_nego.c
> +++ b/drivers/target/iscsi/iscsi_target_nego.c
> @@ -350,6 +350,16 @@ static int iscsi_target_do_tx_login_io(struct iscsit_conn *conn, struct iscsi_lo
>                                             ISCSI_LOGIN_STATUS_NO_RESOURCES);
>                         return -1;
>                 }
> +
> +               /*
> +                * isert doesn't know the iscsit state and uses
> +                * iscsit_cause_connection_reinstatement as a generic error
> +                * notification system. It may call it before we are in FFP.
> +                * Handle this now in case it signaled a failure before the
> +                * rx/tx threads were up and could start recovery.
> +                */
> +               if (atomic_read(&conn->connection_reinstatement))
> +                       goto err;

Why only for login->login_complete case? In other case the session will
not hang? Will it be droppped on login timeout or something else?

May be the root cause is point 2 itself - calling iscsit_cause_connection_reinstatement
in not ISER_CONN_FULL_FEATURE state where there are no TX_RX threads?
I mean that was a misuse of iscsit_cause_connection_reinstatement?

>         }
> 
>         if (conn->conn_transport->iscsit_put_login_tx(conn, login,
> --
> 2.31.1
> 
> 

