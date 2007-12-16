From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 20/24] iscsi_tcp: enable sg chaining
Date: Sun, 16 Dec 2007 12:09:04 +0200
Message-ID: <4764F940.8080401@panasas.com>
References: <11975714233983-git-send-email-michaelc@cs.wisc.edu> <11975714323427-git-send-email-michaelc@cs.wisc.edu> <11975714333916-git-send-email-michaelc@cs.wisc.edu> <11975714342353-git-send-email-michaelc@cs.wisc.edu> <1197571435692-git-send-email-michaelc@cs.wisc.edu> <119757143673-git-send-email-michaelc@cs.wisc.edu> <11975714363904-git-send-email-michaelc@cs.wisc.edu> <11975714372848-git-send-email-michaelc@cs.wisc.edu> <11975714382641-git-send-email-michaelc@cs.wisc.edu> <11975714404116-git-send-email-michaelc@cs.wisc.edu> <11975714413336-git-send-email-michaelc@cs.wisc.edu> <1197571442630-git-send-email-michaelc@cs.wisc.edu> <11975714441250-git-send-email-michaelc@cs.wisc.edu> <1197571445685-git-send-email-michaelc@cs.wisc.edu> <1197571447387-git-send-email-michaelc@cs.wisc.edu>
  <1197571448857-git-send-email-michaelc@cs.wisc.edu> <11975714503562-git-send-email-michaelc@cs.wisc.edu> <1197571451503-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:38196 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760639AbXLPKJ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Dec 2007 05:09:58 -0500
In-Reply-To: <1197571451503-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org

On Thu, Dec 13 2007 at 20:43 +0200, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> The previous patches converted iscsi_tcp to support sg chaining.
> This patch sets the proper flags and sets sg_table size to
> 4096. This allows fs io to be capped at max_sectors, but passthrough
> IO to be limited by some other part of the kernel.
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  drivers/scsi/iscsi_tcp.c |    5 +++--
>  drivers/scsi/iscsi_tcp.h |    3 ---
>  2 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index 65df908..84c4a50 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -1928,13 +1928,14 @@ static struct scsi_host_template iscsi_sht = {
>  	.queuecommand           = iscsi_queuecommand,
>  	.change_queue_depth	= iscsi_change_queue_depth,
>  	.can_queue		= ISCSI_DEF_XMIT_CMDS_MAX - 1,
> -	.sg_tablesize		= ISCSI_SG_TABLESIZE,
> +	.sg_tablesize		= 4096,
+	.sg_tablesize		= ~0,
I use ~0 in my tree. The 4096 is a mechanical limitation here without
any real reasons. ~0 means that the driver does not have any limitations
and the minimum will be at some higher level.

>  	.max_sectors		= 0xFFFF,
>  	.cmd_per_lun		= ISCSI_DEF_CMD_PER_LUN,
>  	.eh_abort_handler       = iscsi_eh_abort,
>  	.eh_device_reset_handler= iscsi_eh_device_reset,
>  	.eh_host_reset_handler	= iscsi_eh_host_reset,
>  	.use_clustering         = DISABLE_CLUSTERING,
> +	.use_sg_chaining	= ENABLE_SG_CHAINING,
>  	.slave_configure        = iscsi_tcp_slave_configure,
>  	.proc_name		= "iscsi_tcp",
>  	.this_id		= -1,
> @@ -1974,7 +1975,7 @@ static struct iscsi_transport iscsi_tcp_transport = {
>  	.host_template		= &iscsi_sht,
>  	.conndata_size		= sizeof(struct iscsi_conn),
>  	.max_conn		= 1,
> -	.max_cmd_len		= ISCSI_TCP_MAX_CMD_LEN,
> +	.max_cmd_len		= 16,
>  	/* session management */
>  	.create_session		= iscsi_tcp_session_create,
>  	.destroy_session	= iscsi_tcp_session_destroy,
> diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
> index 893cd2e..ed0b991 100644
> --- a/drivers/scsi/iscsi_tcp.h
> +++ b/drivers/scsi/iscsi_tcp.h
> @@ -24,9 +24,6 @@
>  
>  #include <scsi/libiscsi.h>
>  
> -#define ISCSI_SG_TABLESIZE		SG_ALL
> -#define ISCSI_TCP_MAX_CMD_LEN		16
> -
>  struct crypto_hash;
>  struct socket;
>  struct iscsi_tcp_conn;

Don't fix it just yet. I will send a patch much later,
when I will actually need it. I just wanted to make a note
of it.

Boaz
