From: Varun Prakash <varun@chelsio.com>
Subject: Re: [PATCH v2 04/16] iscsi-target: add void (*iscsit_release_cmd)()
Date: Mon, 11 Apr 2016 22:46:41 +0530
Message-ID: <20160411171639.GA1713@chelsio.com>
References: <cover.1460204441.git.varun@chelsio.com>
 <1499510260d6358522b4023822022f0add88b687.1460204441.git.varun@chelsio.com>
 <570A9094.6010502@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:63137 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbcDKRRL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Apr 2016 13:17:11 -0400
Content-Disposition: inline
In-Reply-To: <570A9094.6010502@grimberg.me>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, nab@linux-iscsi.org, swise@opengridcomputing.com, kxie@chelsio.com, indranil@chelsio.com

On Sun, Apr 10, 2016 at 08:42:44PM +0300, Sagi Grimberg wrote:
> 
> >Add void (*iscsit_release_cmd)() to
> >struct iscsit_transport, iscsi-target
> >uses this callback to release transport
> >driver resources associated with an iSCSI cmd.
> 
> I'd really like to see some reasoning on why you add
> abstraction callouts. It may have a valid reason but
> it needs to be documented in the change log...

This is for releasing DDP resource and sg page
in case of PASSTHROUGH_SG_TO_MEM_NOALLOC.
I will update commit log in -v3.

> 
> >diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
> >index 428b0d9..a533017 100644
> >--- a/drivers/target/iscsi/iscsi_target_util.c
> >+++ b/drivers/target/iscsi/iscsi_target_util.c
> >@@ -725,6 +725,9 @@ void __iscsit_free_cmd(struct iscsi_cmd *cmd, bool scsi_cmd,
> >  		iscsit_remove_cmd_from_immediate_queue(cmd, conn);
> >  		iscsit_remove_cmd_from_response_queue(cmd, conn);
> >  	}
> >+
> >+	if (conn && conn->conn_transport->iscsit_release_cmd)
> >+		conn->conn_transport->iscsit_release_cmd(conn, cmd);
> >  }
> 
> Did you verify that you get here with conn = NULL (given that you test
> it)? If so, then can you please document why is it expected for this
> function to be called twice that we need to make it safe?
> 
> If not, then I'd move this check to be a WARN_ON/BUG_ON to hunt
> down when is this happening.

There is already a check for NULL conn in __iscsit_free_cmd()

	if (conn && check_queues) {
  		iscsit_remove_cmd_from_immediate_queue(cmd, conn);
  		iscsit_remove_cmd_from_response_queue(cmd, conn);
	}

cmd->conn can become NULL in ERL2 error recovery.
