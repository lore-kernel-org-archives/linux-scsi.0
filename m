From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC 04/11] iscsi-target: Add per transport iscsi_cmd
 alloc/free
Date: Fri, 22 Mar 2013 15:59:21 -0700
Message-ID: <1363993161.30339.39.camel@haakon2.linux-iscsi.org>
References: <1362707116-31406-1-git-send-email-nab@linux-iscsi.org>
	 <1362707116-31406-5-git-send-email-nab@linux-iscsi.org>
	 <514C9394.7000501@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:45471 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423536Ab3CVW7Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Mar 2013 18:59:24 -0400
In-Reply-To: <514C9394.7000501@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Alexander Nezhinsky <alexandern@mellanox.com>

On Fri, 2013-03-22 at 10:23 -0700, Andy Grover wrote:
> On 03/07/2013 05:45 PM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> >
> > This patch converts struct iscsi_cmd memory allocation + free to use
> > ->iscsit_alloc_cmd() + ->iscsit_free_cmd() iscsit_transport API caller,
> > and export iscsit_allocate_cmd() + iscsit_free_cmd() symbols
> >
> > Also update iscsit_free_cmd() to include a final ->iscsit_unmap_cmd()
> > API call.
> >
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > ---
> >   drivers/target/iscsi/iscsi_target.c      |    2 +
> >   drivers/target/iscsi/iscsi_target_util.c |   34 ++++++++++++++++++++++++++---
> >   drivers/target/iscsi/iscsi_target_util.h |    2 +
> >   3 files changed, 34 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> > index 4dc1c9b..9cd7b7b 100644
> > --- a/drivers/target/iscsi/iscsi_target.c
> > +++ b/drivers/target/iscsi/iscsi_target.c

<SNIP>

> > @@ -176,6 +186,7 @@ struct iscsi_cmd *iscsit_allocate_cmd(struct iscsi_conn *conn, gfp_t gfp_mask)
> >
> >   	return cmd;
> >   }
> > +EXPORT_SYMBOL(iscsit_allocate_cmd);
> >
> >   struct iscsi_seq *iscsit_get_seq_holder_for_datain(
> >   	struct iscsi_cmd *cmd,
> > @@ -661,6 +672,11 @@ void iscsit_free_queue_reqs_for_conn(struct iscsi_conn *conn)
> >   	spin_unlock_bh(&conn->response_queue_lock);
> >   }
> >
> > +void iscsit_cache_free_cmd(struct iscsi_cmd *cmd)
> 
> Caching is an implementation detail, rename to iscsit_free_cmd()?
> 

Already removed for forth-coming RFC-v2 code.

> > +{
> > +	kmem_cache_free(lio_cmd_cache, cmd);
> > +}
> > +
> >   void iscsit_release_cmd(struct iscsi_cmd *cmd)
> >   {
> >   	struct iscsi_conn *conn = cmd->conn;
> > @@ -679,17 +695,26 @@ void iscsit_release_cmd(struct iscsi_cmd *cmd)
> >   		iscsit_remove_cmd_from_response_queue(cmd, conn);
> >   	}
> >
> > -	kmem_cache_free(lio_cmd_cache, cmd);
> > +	conn->conn_transport->iscsit_free_cmd(cmd);
> >   }
> >
> >   void iscsit_free_cmd(struct iscsi_cmd *cmd)
> >   {
> > +	struct iscsi_conn *conn = cmd->conn;
> >   	/*
> >   	 * Determine if a struct se_cmd is associated with
> >   	 * this struct iscsi_cmd.
> >   	 */
> >   	switch (cmd->iscsi_opcode) {
> >   	case ISCSI_OP_SCSI_CMD:
> > +		if (cmd->data_direction == DMA_TO_DEVICE)
> > +			iscsit_stop_dataout_timer(cmd);
> > +
> > +		if (conn->conn_transport->iscsit_unmap_cmd)
> > +			conn->conn_transport->iscsit_unmap_cmd(cmd, conn);
> 
> Don't check, just call it?
> 

->iscsit_unmap_cmd() has been dropped entirety for RFC-v2 code.

--nab

