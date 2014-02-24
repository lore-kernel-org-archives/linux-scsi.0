From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH]: qla2xxx: Fix kernel panic on selective retransmission
 request.
Date: Mon, 24 Feb 2014 13:29:53 -0800
Message-ID: <1393277393.10384.14.camel@haakon3.risingtidesystems.com>
References: <201402241959.s1OJxrn2007544@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:48570 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbaBXV0g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Feb 2014 16:26:36 -0500
In-Reply-To: <201402241959.s1OJxrn2007544@wind.enjellic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: greg@enjellic.com
Cc: linux-driver@qlogic.com, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, target-devel <target-devel@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>

Hi Greg,

On Mon, 2014-02-24 at 13:59 -0600, Dr. Greg Wettstein wrote:
> From: Dr. Greg Wettstein <greg@enjellic.com> 
> 
> qla2xxx: Fix kernel panic on selective retransmission request.
>     
> A selective retransmission request (SRR) is a fibre-channel
> protocol control request which provides support for requesting
> retransmission of a data sequence in response to an issue such as
> frame loss or corruption.  These events are experienced
> infrequently in fibre-channel based networks which makes
> it difficult to test and assess codepaths which handle these
> events.
>     
> We were fortunate enough, for some definition of fortunate, to
> have a metro-area single-mode SAN link which, at 10 GBPS
> sustained load levels, would consistently generate SRR's in
> a SCST based target implementation using our SCST/in-kernel
> Qlogic target interface driver.  In response to an SRR the
> in-kernel Qlogic target driver immediately panics resulting
> in a catastrophic storage failure for serviced initiators.
>     
> The culprit was a debug statement in the qla_target.c file which
> does not verify that a pointer to the SCSI CDB is not null.
> The unchecked pointer dereference results in the kernel panic
> and resultant system failure.
>     
> The other two references to the SCSI CDB by the SRR handling code
> use a ternary operator to verify a non-null pointer is being
> acted on.  This patch simply adds a similar test to the implicated
> debug statement.
> 
> This patch is a candidate for any stable kernel being maintained
> since it addresses a potentially catastrophic event with
> minimal downside.
>     
> Signed-off-by: Dr. Greg Wettstein <greg@enjellic.com>

Applied to target-pending/master and including in the next v3.14-rc PULL
request.

Also adding a CC' to stable for >= v3.6.y code.

Thanks!

--nab

> ---
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index 2eb97d7..8cb91b4 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -3185,7 +3185,8 @@ restart:
>  		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf02c,
>  		    "SRR cmd %p (se_cmd %p, tag %d, op %x), "
>  		    "sg_cnt=%d, offset=%d", cmd, &cmd->se_cmd, cmd->tag,
> -		    se_cmd->t_task_cdb[0], cmd->sg_cnt, cmd->offset);
> +		    se_cmd->t_task_cdb ? se_cmd->t_task_cdb[0] : 0,
> +		    cmd->sg_cnt, cmd->offset);
>  
>  		qlt_handle_srr(vha, sctio, imm);
>  
> ---
> As always,
> Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
> 4206 N. 19th Ave.           Specializing in information infra-structure
> Fargo, ND  58102            development.
> PH: 701-281-1686
> FAX: 701-281-3949           EMAIL: greg@enjellic.com
> ------------------------------------------------------------------------------
> "We came, we saw, we fought, we conquered the multi-headed beast which
>  is storage for isochronous video delivery."
> 
>  Any questions on the project summary?
>                                 -- Dr. Greg Wettstein
>                                    Resurrection
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


