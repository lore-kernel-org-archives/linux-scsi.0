Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D89A8C4363A
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 16:20:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AF182076E
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 16:20:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UtsJayME"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgJ2QUX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 12:20:23 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:58666 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbgJ2QUW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 12:20:22 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TG9I77028616;
        Thu, 29 Oct 2020 16:20:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Qb6VBUK3k7CpGXxt71zuGRyOHxZAvdBPgFHOn2ueulc=;
 b=UtsJayMEp7AbYUwm+x9uV8nlRuIRtuJ1PnxxTta33jfJ+3GuCSkm3LHRrgDvC1oWEFKp
 dJtBMzxZviKGI+IWyuDRrjVvrAMIXLcC9dOW4rPB/e8LW11BKsgFrlyM8+1rTrLNYEfd
 2MrptC+3Q+uVD75JFqpJMSwS3WDeMmC7FHGs2+1k54wJ2l7HYjYz/ZoUJ6aQiyTgFNLk
 +XtifCL1q5PgVYAJxi2b0dC4d/GMukxFfopmF3oTbaYnZSY0tZp5il1a0efjcUEOKqzr
 7ziaxNVpWXODvqLFQRBc1qqVCLf1dw40ZZxMZBVqrXeG1JbPh357wJnedSBpZ8Gi0Xpc ww== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34c9sb5xd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 16:20:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TGBRcb103562;
        Thu, 29 Oct 2020 16:20:14 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 34cx6ync6q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 16:20:14 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09TGKBQA014661;
        Thu, 29 Oct 2020 16:20:11 GMT
Received: from [20.15.0.8] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 09:20:11 -0700
Subject: Re: [patch v4 4/5] scsi_transport_fc: Added a new rport state
 FC_PORTSTATE_MARGINAL
To:     Muneendra Kumar M <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
References: <1603370091-9337-1-git-send-email-muneendra.kumar@broadcom.com>
 <1603370091-9337-5-git-send-email-muneendra.kumar@broadcom.com>
 <2818f7af-e2f9-7d20-a0e6-10eb3c03c7ef@oracle.com>
 <6499e81f001ed33b8430d5f2cd863ae2@mail.gmail.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <49b9b97c-bf84-e9ac-3b74-ffbf3352e2d5@oracle.com>
Date:   Thu, 29 Oct 2020 11:20:09 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <6499e81f001ed33b8430d5f2cd863ae2@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9788 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290113
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9788 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290113
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/29/20 6:53 AM, Muneendra Kumar M wrote:
> Hi Mike,
> Below are my replies.
> 
> -----Original Message-----
> From: Mike Christie [mailto:michael.christie@oracle.com]
> Sent: Monday, October 26, 2020 10:45 PM
> To: Muneendra <muneendra.kumar@broadcom.com>; linux-scsi@vger.kernel.org;
> hare@suse.de
> Cc: jsmart2021@gmail.com; emilne@redhat.com; mkumar@redhat.com
> Subject: Re: [patch v4 4/5] scsi_transport_fc: Added a new rport state
> FC_PORTSTATE_MARGINAL
> 
> On 10/22/20 7:34 AM, Muneendra wrote:
>> @@ -2071,6 +2074,7 @@ fc_eh_timed_out(struct scsi_cmnd *scmd)  {
>>   	struct fc_rport *rport =
>> starget_to_rport(scsi_target(scmd->device));
>>
>> +	fc_rport_chkmarginal_set_noretries(rport, scmd);
>>   	if (rport->port_state == FC_PORTSTATE_BLOCKED)
>>   		return BLK_EH_RESET_TIMER;
> 
>> If we are in port state marginal above, then we will try to abort the cmd,
>> but if while doing the abort we call fc_remote_port_delete and
>> fc_remote_port_add then the port state will be online when the EH callouts
>> complete. In >this case, the port state is online in the end, but we would
>> fail the command like it was in marginal.
> [Muneendra] I have to  make sure the flag is set after the check for blocked
> state.  If blocked, it's returning BLK_EH_RESET_TIMER, so it will restart
> the eh
> timer. The io will "sit out" like this, pending, until either the adapter
> fails it back due to logout or io completion, or fastio fail or
> rport devloss timesout and invokes the abort handler to force abort .

Hey,

I'm not sure if we are talking about the same thing. If port state is 
marginal above, then we set the NORETRIES bit then return BLK_EH_DONE 
which will start up the scsi eh_abort_handler and if that fails the rest 
of the scsi eh_*_handlers.

While we are calling the eh handlers, if the driver does a 
fc_remote_port_delete then fc_remote_port_add we still have the 
NORETRIES bit set, so when we return from the eh_*_handlers we will fail 
the IO upwards.

I was trying to ask if you wanted the IO failed upwards in that case. 
Because the port state went to online, did you want the normal (cleared 
NOTRIES bit) cmd retry behavior? It sounds like below you want the 
cleared NORETRIED bit behavior, right?


> 
>> +		(rport->port_state != FC_PORTSTATE_MARGINAL)) {
>>   		spin_unlock_irqrestore(shost->host_lock, flags);
>>   		return;
> 
>> It looks like if fc_remote_port_delete is called, then we will allow that
>> function to set the port_state to blocked. If the problem is resolved then
>> fc_remote_port_add will set the state to online. So it would look like the
>> port state is >now ok in the kernel, but would userspace still have it in
>> the marginal port group?
> 
>> Did you want this behavior or did you want it to stay in marginal until
>> your daemon marks it as online?
> [Muneendra] We need this behavior.User daemon
> should not depend on the rport_state to move a path from marginal path
>   group.It should only depends on RSCN and LINKUP events/manual
> intervention. events that we look out (rscn for target-side cable  bounces
> and link up/down for initiator cable bounces) will result in
> port state changes - so although we don't drive one from the other, they are
> correlated.
> 
> Regards,
> Muneendra.
> 

