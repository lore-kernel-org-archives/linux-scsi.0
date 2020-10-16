Return-Path: <SRS0=iJzJ=DX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DBFFC433E7
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Oct 2020 19:52:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA35420874
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Oct 2020 19:52:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VNDdjFTI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411162AbgJPTw6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Oct 2020 15:52:58 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:38966 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408005AbgJPTw5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Oct 2020 15:52:57 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09GJmi9N102794;
        Fri, 16 Oct 2020 19:52:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=effXNR4C+6b7hJsU2PAcDH8pgT9kz0fzwM7lh1OT8Lo=;
 b=VNDdjFTI6z+CGloE+kAyL3h9n+1SJ+S6pll7ZC2k98i7kZgw9vDVhjFHFjyu8nBRU3WL
 LnWdWuZOzNNnfm/qIic9/Sz1mnyUAa7ymNUhTwl4E6cHS3UvNN2mgeXwdxLYH01/s88y
 qcV+fK8r10jfETqpubOemRS+e4l+yaBR3fM6YtjnkIW+drCHhPnhvI/zwOHML/hfNHKs
 K/9+lajza4NP11kiL3IHZH+Y/P4TFYhQfB8J3jl/++mGDzr7n5gGEjTLSsKyaoU1e5/g
 b+UuP8fjTr2RrZTqQETW7K31rgD1l7L2sAYe5HSXjeAEfehDhmdO+4sP5Lijqps3DZlb HA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 346g8grpfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 16 Oct 2020 19:52:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09GJnnkc090722;
        Fri, 16 Oct 2020 19:52:50 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 343phsv4rc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Oct 2020 19:52:50 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09GJqnJ3014424;
        Fri, 16 Oct 2020 19:52:49 GMT
Received: from [20.15.0.8] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 16 Oct 2020 12:52:49 -0700
Subject: Re: [PATCH v3 05/17] scsi_transport_fc: Added a new rport state
 FC_PORTSTATE_MARGINAL
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
References: <1602732462-10443-1-git-send-email-muneendra.kumar@broadcom.com>
 <1602732462-10443-6-git-send-email-muneendra.kumar@broadcom.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <5ca752c2-94e1-444a-7755-f48b09b38577@oracle.com>
Date:   Fri, 16 Oct 2020 14:52:48 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <1602732462-10443-6-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9776 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010160145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9776 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 suspectscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 spamscore=0 adultscore=0
 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010160145
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/14/20 10:27 PM, Muneendra wrote:
> Added a new rport state FC_PORTSTATE_MARGINAL.
> 
> Added a new inline function fc_rport_chkmarginal_set_noretries
> which will set the SCMD_NORETRIES_ABORT bit in cmd->state if rport state
> is marginal.
> 
> Added a new argumet scsi_cmnd to the function fc_remote_port_chkready.
> Made changes in fc_remote_port_chkready function to treat marginal and
> online as same.If scsi_cmd is passed fc_rport_chkmarginal_set_noretries
> will be called.
> 
> Also made changes in fc_remote_port_delete,fc_user_scan_tgt,
> fc_timeout_deleted_rport functions  to handle the new rport state
> FC_PORTSTATE_MARGINAL.
> 
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> 
> ---
> v3:
> Rearranged the patch so that all the changes with respect to new
> rport state is part of this patch.
> Added a new argument to scsi_cmd  to fc_remote_port_chkready
> 
> v2:
> New patch
> ---
>   drivers/scsi/scsi_transport_fc.c | 40 +++++++++++++++++++-------------
>   include/scsi/scsi_transport_fc.h | 26 ++++++++++++++++++++-
>   2 files changed, 49 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index 2ff7f06203da..df66a51d62e6 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -142,20 +142,23 @@ fc_enum_name_search(host_event_code, fc_host_event_code,
>   static struct {
>   	enum fc_port_state	value;
>   	char			*name;
> +	int			matchlen;
>   } fc_port_state_names[] = {
> -	{ FC_PORTSTATE_UNKNOWN,		"Unknown" },
> -	{ FC_PORTSTATE_NOTPRESENT,	"Not Present" },
> -	{ FC_PORTSTATE_ONLINE,		"Online" },
> -	{ FC_PORTSTATE_OFFLINE,		"Offline" },
> -	{ FC_PORTSTATE_BLOCKED,		"Blocked" },
> -	{ FC_PORTSTATE_BYPASSED,	"Bypassed" },
> -	{ FC_PORTSTATE_DIAGNOSTICS,	"Diagnostics" },
> -	{ FC_PORTSTATE_LINKDOWN,	"Linkdown" },
> -	{ FC_PORTSTATE_ERROR,		"Error" },
> -	{ FC_PORTSTATE_LOOPBACK,	"Loopback" },
> -	{ FC_PORTSTATE_DELETED,		"Deleted" },
> +	{ FC_PORTSTATE_UNKNOWN,		"Unknown", 7},
> +	{ FC_PORTSTATE_NOTPRESENT,	"Not Present", 11 },
> +	{ FC_PORTSTATE_ONLINE,		"Online", 6 },
> +	{ FC_PORTSTATE_OFFLINE,		"Offline", 7 },
> +	{ FC_PORTSTATE_BLOCKED,		"Blocked", 7 },
> +	{ FC_PORTSTATE_BYPASSED,	"Bypassed", 8 },
> +	{ FC_PORTSTATE_DIAGNOSTICS,	"Diagnostics", 11 },
> +	{ FC_PORTSTATE_LINKDOWN,	"Linkdown", 8 },
> +	{ FC_PORTSTATE_ERROR,		"Error", 5 },
> +	{ FC_PORTSTATE_LOOPBACK,	"Loopback", 8 },
> +	{ FC_PORTSTATE_DELETED,		"Deleted", 7 },
> +	{ FC_PORTSTATE_MARGINAL,	"Marginal", 8 },
>   };
>   fc_enum_name_search(port_state, fc_port_state, fc_port_state_names)
> +fc_enum_name_match(port_state, fc_port_state, fc_port_state_names)
>   #define FC_PORTSTATE_MAX_NAMELEN	20
>   
>   
> @@ -2095,7 +2098,8 @@ fc_user_scan_tgt(struct Scsi_Host *shost, uint channel, uint id, u64 lun)
>   		if (rport->scsi_target_id == -1)
>   			continue;
>   
> -		if (rport->port_state != FC_PORTSTATE_ONLINE)
> +		if ((rport->port_state != FC_PORTSTATE_ONLINE) &&
> +			(rport->port_state != FC_PORTSTATE_MARGINAL))
>   			continue;
>   
>   		if ((channel == rport->channel) &&
> @@ -2958,7 +2962,8 @@ fc_remote_port_delete(struct fc_rport  *rport)
>   
>   	spin_lock_irqsave(shost->host_lock, flags);
>   
> -	if (rport->port_state != FC_PORTSTATE_ONLINE) {
> +	if ((rport->port_state != FC_PORTSTATE_ONLINE) &&
> +		(rport->port_state != FC_PORTSTATE_MARGINAL)) {
>   		spin_unlock_irqrestore(shost->host_lock, flags);
>   		return;
>   	}
> @@ -3100,7 +3105,8 @@ fc_timeout_deleted_rport(struct work_struct *work)
>   	 * target, validate it still is. If not, tear down the
>   	 * scsi_target on it.
>   	 */
> -	if ((rport->port_state == FC_PORTSTATE_ONLINE) &&
> +	if (((rport->port_state == FC_PORTSTATE_ONLINE) ||
> +		(rport->port_state == FC_PORTSTATE_MARGINAL)) &&
>   	    (rport->scsi_target_id != -1) &&
>   	    !(rport->roles & FC_PORT_ROLE_FCP_TARGET)) {
>   		dev_printk(KERN_ERR, &rport->dev,
> @@ -3243,7 +3249,8 @@ fc_scsi_scan_rport(struct work_struct *work)
>   	struct fc_internal *i = to_fc_internal(shost->transportt);
>   	unsigned long flags;
>   
> -	if ((rport->port_state == FC_PORTSTATE_ONLINE) &&
> +	if (((rport->port_state == FC_PORTSTATE_ONLINE) ||
> +		(rport->port_state == FC_PORTSTATE_ONLINE)) &&
>   	    (rport->roles & FC_PORT_ROLE_FCP_TARGET) &&
>   	    !(i->f->disable_target_scan)) {
>   		scsi_scan_target(&rport->dev, rport->channel,
> @@ -3747,7 +3754,8 @@ static blk_status_t fc_bsg_rport_prep(struct fc_rport *rport)
>   	    !(rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT))
>   		return BLK_STS_RESOURCE;
>   
> -	if (rport->port_state != FC_PORTSTATE_ONLINE)
> +	if ((rport->port_state != FC_PORTSTATE_ONLINE) &&
> +		(rport->port_state != FC_PORTSTATE_MARGINAL))
>   		return BLK_STS_IOERR;
>   
>   	return BLK_STS_OK;
> diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
> index 1c7dd35cb7a0..7d010324c1e3 100644
> --- a/include/scsi/scsi_transport_fc.h
> +++ b/include/scsi/scsi_transport_fc.h
> @@ -14,6 +14,7 @@
>   #include <linux/bsg-lib.h>
>   #include <asm/unaligned.h>
>   #include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
>   #include <scsi/scsi_netlink.h>
>   #include <scsi/scsi_host.h>
>   
> @@ -67,6 +68,7 @@ enum fc_port_state {
>   	FC_PORTSTATE_ERROR,
>   	FC_PORTSTATE_LOOPBACK,
>   	FC_PORTSTATE_DELETED,
> +	FC_PORTSTATE_MARGINAL,
>   };
>   
>   
> @@ -707,6 +709,23 @@ struct fc_function_template {
>   	unsigned long	disable_target_scan:1;
>   };
>   
> +/**
> + * fc_rport_chkmarginal_set_noretries - Set the SCMD_NORETRIES_ABORT bit
> + * in cmd->state if port state is marginal prior to initiating
> + * io to the port.
> + * @rport:	remote port to be checked
> + * @scmd:	scsi_cmd to set/clear the SCMD_NORETRIES_ABORT bit on Marginal state
> + **/
> +static inline void
> +fc_rport_chkmarginal_set_noretries(struct fc_rport *rport, struct scsi_cmnd *cmd)
> +{
> +	if ((rport->port_state == FC_PORTSTATE_MARGINAL) &&
> +		 (cmd->request->cmd_flags & REQ_FAILFAST_TRANSPORT))
> +		set_bit(SCMD_NORETRIES_ABORT, &cmd->state);
> +	else
> +		clear_bit(SCMD_NORETRIES_ABORT, &cmd->state);
> +
> +}
>   
>   /**
>    * fc_remote_port_chkready - called to validate the remote port state
> @@ -715,20 +734,25 @@ struct fc_function_template {
>    * Returns a scsi result code that can be returned by the LLDD.
>    *
>    * @rport:	remote port to be checked
> + * @cmd:	scsi_cmd to set/clear the SCMD_NORETRIES_ABORT bit on Marginal state
>    **/
>   static inline int
> -fc_remote_port_chkready(struct fc_rport *rport)
> +fc_remote_port_chkready(struct fc_rport *rport, struct scsi_cmnd *cmd)
>   {
>   	int result;
>   
>   	switch (rport->port_state) {
>   	case FC_PORTSTATE_ONLINE:
> +	case FC_PORTSTATE_MARGINAL:
>   		if (rport->roles & FC_PORT_ROLE_FCP_TARGET)
>   			result = 0;
>   		else if (rport->flags & FC_RPORT_DEVLOSS_PENDING)
>   			result = DID_IMM_RETRY << 16;
>   		else
>   			result = DID_NO_CONNECT << 16;
> +
> +		if (cmd)
> +			fc_rport_chkmarginal_set_noretries(rport, cmd);

I was just wondering why don't you do drop all the SCMD_NORETRIES_ABORT 
code and then in this function when you check for the marginal state do:

result = DID_TRANSPORT_MARGINAL;

?

So you would do:

1. Userspace calls in scsi_transport_fc and sets the port state to marginal.
2. New commands would see the above check and complete the command woth 
DID_TRANSPORT_MARGINAL.
3. If a command is retried by the scsi layer we would end up hitting 
this function and see the check and end up faling the IO like in #2. It 
would be similar to what happens when the dev loss or fast io fail 
timers fire.
