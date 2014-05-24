From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] qla2xxx: Convert to percpu_ida session tag
 pre-allocation
Date: Fri, 23 May 2014 19:33:22 -0700
Message-ID: <1400898802.6476.25.camel@haakon3.risingtidesystems.com>
References: <1400892216-9784-1-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:47718 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaEXCd3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 May 2014 22:33:29 -0400
In-Reply-To: <1400892216-9784-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, Roland Dreier <roland@kernel.org>, Christoph Hellwig <hch@lst.de>

Hi Qlogic folks,

A question for you below..

On Sat, 2014-05-24 at 00:43 +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch converts qla2xxx target code to use generic percpu_ida
> tag allocation provided by target-core, thus removing the original
> kmem_cache_zalloc() for each struct qla_tgt_cmd descriptor in the
> incoming ATIO packet fast-path.
> 
> This includes the conversion of qlt_handle_cmd_for_atio() to perform
> qla_tgt_sess lookup before dispatching a command descriptor into
> qla_tgt_wq process context, along with handling the case where no
> active session exists, and subsequently kicking off a seperate
> process context for qlt_create_sess_from_atio() to create a new one.
> 
> It also includes moving tag allocation into generic code within
> qlt_get_tag(), so that the same logic can be shared between
> qlt_handle_cmd_for_atio() + qlt_create_sess_from_atio() contexts.
> Also, __qlt_do_work() has been made generic between both normal
> process context in qlt_do_work() + qlt_create_sess_from_atio().
> 
> Next, update qlt_free_cmd() to release the percpu-ida tags, and
> drop the now-unused global qla_tgt_cmd_cachep.
> 
> Finally in tcm_qla2xxx code, tcm_qla2xxx_check_initiator_node_acl()
> has been updated to use transport_init_session_tags() along with a
> hardcoded TCM_QLA2XXX_DEFAULT_TAGS=512 as the number of qla_tgt_cmd
> descriptors to pre-allocate per qla_tgt_sess instance.
> 
> Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
> Cc: Quinn Tran <quinn.tran@qlogic.com>
> Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
> Cc: Chad Dupuis <chad.dupuis@qlogic.com>
> Cc: Roland Dreier <roland@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/scsi/qla2xxx/qla_target.c  |  195 ++++++++++++++++++++++++------------
>  drivers/scsi/qla2xxx/qla_target.h  |    6 ++
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c |    4 +-
>  drivers/scsi/qla2xxx/tcm_qla2xxx.h |    2 +
>  4 files changed, 142 insertions(+), 65 deletions(-)
> 

<SNIP>

> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index 68fb66f..34db344 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -1482,7 +1482,9 @@ static int tcm_qla2xxx_check_initiator_node_acl(
>  	}
>  	se_tpg = &tpg->se_tpg;
>  
> -	se_sess = transport_init_session(TARGET_PROT_NORMAL);
> +	se_sess = transport_init_session_tags(TCM_QLA2XXX_DEFAULT_TAGS,
> +					      sizeof(struct qla_tgt_cmd),
> +					      TARGET_PROT_NORMAL);
>  	if (IS_ERR(se_sess)) {
>  		pr_err("Unable to initialize struct se_session\n");
>  		return PTR_ERR(se_sess);
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.h b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
> index 33aaac8..b0a3ea5 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.h
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
> @@ -4,6 +4,8 @@
>  #define TCM_QLA2XXX_VERSION	"v0.1"
>  /* length of ASCII WWPNs including pad */
>  #define TCM_QLA2XXX_NAMELEN	32
> +/* Number of pre-allocated per-session tags */
> +#define TCM_QLA2XXX_DEFAULT_TAGS 512
>  

So a question wrt to the TCM_QLA2XXX_DEFAULT_TAGS value above used to
determine the number of qla_tgt_cmd descriptors to pre-allocate at
qla_tgt_sess creation time..

This value needs to line up with the total number of possible incoming
ATIO packets, plus the number of qla_tgt_cmd descriptors that have not
been acknowledged with a CTIO packet.  Typically with other fabrics that
have been converted to use percpu_ida, we over-allocate the number of
per-session tags in order to completely avoid the slow-path where
percpu_ida has to steal tags from another CPU.

AFAICT, there is no way at the qla_target driver level to enforce
per-session queue_depth + reflect the depth at the initiator port, so
the number of tags needs to be the worst case number of HW descriptors
that a single session can consume + number of unacknowledged
descriptors.

So the question is, is there already a define somewhere in qla2xxx code
that TCM_QLA2XXX_DEFAULT_TAGS can use as a starting point..?  If not,
what is the total number of outstanding commands that a single session
(or single port..?) can expect to handle at a given time..?

--nab

