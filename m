From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 3/8] scsi: clean up S/G table freeing
Date: Wed, 01 Oct 2014 14:22:18 +0200
Message-ID: <542BF1FA.5050908@acm.org>
References: <1410107469-896-1-git-send-email-hch@lst.de> <1410107469-896-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baptiste.telenet-ops.be ([195.130.132.51]:51604 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaJAMWV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2014 08:22:21 -0400
In-Reply-To: <1410107469-896-4-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 09/07/14 18:31, Christoph Hellwig wrote:
> -static void scsi_release_buffers(struct scsi_cmnd *cmd)
> -{
> -	if (cmd->sdb.table.nents)
> -		scsi_free_sgtable(&cmd->sdb, false);
> -
> -	memset(&cmd->sdb, 0, sizeof(cmd->sdb));
> -
> -	if (scsi_prot_sg_count(cmd))
> -		scsi_free_sgtable(cmd->prot_sdb, false);
> -}
> -
> -static void scsi_release_bidi_buffers(struct scsi_cmnd *cmd)
> -{
> -	struct scsi_data_buffer *bidi_sdb = cmd->request->next_rq->special;
> -
> -	scsi_free_sgtable(bidi_sdb, false);
> -	kmem_cache_free(scsi_sdb_cache, bidi_sdb);
> -	cmd->request->next_rq->special = NULL;
> -}

I can see that the scsi_free_sgtable(&cmd->sdb, false) call, the 
scsi_free_sgtable(cmd->prot_sdb, false) call and the 
scsi_free_sgtable(bidi_sdb, false) call are now performed by the new 
function scsi_free_sgtables(). But what's not clear to me is to which 
function the kmem_cache_free(scsi_sdb_cache, bidi_sdb) call has been moved ?

> +		scsi_free_sgtables(cmd);
>   		if (q->mq_ops) {
>   			cmd->request->cmd_flags &= ~REQ_DONTPREP;
>   			scsi_mq_uninit_cmd(cmd);
>   			scsi_mq_requeue_cmd(cmd);
> -		} else {
> -			scsi_release_buffers(cmd);
> +		} else
>   			scsi_requeue_command(q, cmd);
> -		}

Apparently braces have been removed from around the else-part. Isn't the 
preferred style to use braces around single-line else-clauses if the 
if-clause consists of multiple statements ?

Bart.

