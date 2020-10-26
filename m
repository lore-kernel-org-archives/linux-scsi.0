Return-Path: <SRS0=a792=EB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF521C4363A
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 17:14:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A38F20882
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 17:14:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E5JLXT4K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1787461AbgJZROx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 13:14:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43192 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1787459AbgJZROw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2020 13:14:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QH8i47071671;
        Mon, 26 Oct 2020 17:14:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=i7YS2fQq/cDxu+5AgLmWVXZTnNdUanfokxU5/DKpako=;
 b=E5JLXT4KOjj8gFQrAJeMbGXMUXY5BKkkT/Q0/y5Ji3w5myaWsw9m/ildEqvilBq/Oho8
 ckm5zpOH/GeH5dypBD8HmQRmEB/3M6ghi8iTnC8U4Po6pLRLJj5OTXmyzgx17NSY0tau
 hOpM2aMn7g8bIju8if2I9s5Eyj+qZ+uyR9Rl+uoOMGHvfu+d3cV6S00vutCQVQC+W1Ba
 Jatkf2ksLi4pU8Kv/n2R8qCC7o0Siu94YZlUmPUlS+gUn/+uDms3aMEAlN6kLHWnSMde
 r34HYf4otU7RG+bGxbXCmZdrfxsCNzBa0qALOtkrNFMj5sLReNhvyCRoGzMmZgnZOoow gQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34dgm3ucyt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 17:14:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QHANKp037372;
        Mon, 26 Oct 2020 17:14:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 34cwukenm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 17:14:40 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QHEcsI007377;
        Mon, 26 Oct 2020 17:14:39 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 10:14:38 -0700
Subject: Re: [patch v4 4/5] scsi_transport_fc: Added a new rport state
 FC_PORTSTATE_MARGINAL
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
References: <1603370091-9337-1-git-send-email-muneendra.kumar@broadcom.com>
 <1603370091-9337-5-git-send-email-muneendra.kumar@broadcom.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <2818f7af-e2f9-7d20-a0e6-10eb3c03c7ef@oracle.com>
Date:   Mon, 26 Oct 2020 12:14:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1603370091-9337-5-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260116
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/22/20 7:34 AM, Muneendra wrote:
> @@ -2071,6 +2074,7 @@ fc_eh_timed_out(struct scsi_cmnd *scmd)
>  {
>  	struct fc_rport *rport = starget_to_rport(scsi_target(scmd->device));
>  
> +	fc_rport_chkmarginal_set_noretries(rport, scmd);
>  	if (rport->port_state == FC_PORTSTATE_BLOCKED)
>  		return BLK_EH_RESET_TIMER;

If we are in port state marginal above, then we will try to abort
the cmd, but if while doing the abort we call fc_remote_port_delete and
fc_remote_port_add then the port state will be online when the EH
callouts complete. In this case, the port state is online in the end, but
we would fail the command like it was in marginal.

>  
> @@ -2095,7 +2099,8 @@ fc_user_scan_tgt(struct Scsi_Host *shost, uint channel, uint id, u64 lun)
>  		if (rport->scsi_target_id == -1)
>  			continue;
>  
> -		if (rport->port_state != FC_PORTSTATE_ONLINE)
> +		if ((rport->port_state != FC_PORTSTATE_ONLINE) &&
> +			(rport->port_state != FC_PORTSTATE_MARGINAL))
>  			continue;
>  
>  		if ((channel == rport->channel) &&
> @@ -2958,7 +2963,8 @@ fc_remote_port_delete(struct fc_rport  *rport)
>  
>  	spin_lock_irqsave(shost->host_lock, flags);
>  
> -	if (rport->port_state != FC_PORTSTATE_ONLINE) {
> +	if ((rport->port_state != FC_PORTSTATE_ONLINE) &&
> +		(rport->port_state != FC_PORTSTATE_MARGINAL)) {
>  		spin_unlock_irqrestore(shost->host_lock, flags);
>  		return;

It looks like if fc_remote_port_delete is called, then we will
allow that function to set the port_state to blocked. If the
problem is resolved then fc_remote_port_add will set the state
to online. So it would look like the port state is now ok in the
kernel, but would userspace still have it in the marginal port group?

Did you want this behavior or did you want it to stay in marginal
until your daemon marks it as online?
