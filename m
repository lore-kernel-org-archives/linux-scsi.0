Return-Path: <SRS0=e+HO=7P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2E32C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Jun 2020 23:28:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EB8B20734
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Jun 2020 23:28:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M4u4AEPX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbgFBX2g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Jun 2020 19:28:36 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57532 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbgFBX2f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jun 2020 19:28:35 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052NMdbh109063;
        Tue, 2 Jun 2020 23:28:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=sCrx9mkw1LwKxJF6rw3o16WS34bUZDuSyzdvxjzrSoY=;
 b=M4u4AEPXeyck69AFEVZvJPvA5p83MN0zrDj6bGsxZxspUalF14WbNSi8wqFXEhM1+CBr
 gLym1GIGRSNuDMz1sAeZFt774UPMAkc9Dwr8neVT0LObjyDnCQvNoUoYbrMTOfmgtB2W
 iEG3yYXr5tNAAIfvv0MPnaX2DLx0VQNzVW6cv4Hsn1NiDda7XeAXG72Pl8pYTHLtVMZa
 5QPNc2exw3xP6ncv6OJPBLMYSAya2rmz3slkl6W1Ne6NqNe6CPX0gk5K9FcxQqJI34aV
 /6ZGW/BerAgte07F5TGNiYgFDsr5CxFwVM0ehnzPaK5O1r5L0ckzZpannvwTg69W0S31 aw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31dkrukheu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 23:28:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052NHeWK125508;
        Tue, 2 Jun 2020 23:26:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 31c12pymar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 23:26:33 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 052NQXeE027448;
        Tue, 2 Jun 2020 23:26:33 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jun 2020 16:26:33 -0700
Subject: Re: [PATCH v3 2/3] target: fix NULL pointer dereference
To:     Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Shirley Ma <shirley.ma@oracle.com>
References: <1591122825-2652-1-git-send-email-sudhakar.panneerselvam@oracle.com>
 <1591122825-2652-3-git-send-email-sudhakar.panneerselvam@oracle.com>
 <58f5ec86-2791-a3c6-2c0d-94b717030c42@oracle.com>
 <3df40de4-ab01-4b9c-b727-f7fafbb82b29@default>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <14f78832-9b81-4e96-0b4a-27d2acff6f71@oracle.com>
Date:   Tue, 2 Jun 2020 18:26:33 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <3df40de4-ab01-4b9c-b727-f7fafbb82b29@default>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006020161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 mlxscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 adultscore=0 mlxlogscore=999 cotscore=-2147483648 phishscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020161
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 6/2/20 5:37 PM, Sudhakar Panneerselvam wrote:
>>
>> You should follow the coding style in the rest of the code. Do "/*" then
>> start your text or do it all on one line if it fits:
>>
>> /*
>>    * Copy the CDB here to allow trace_target_cmd_complete() to
> 
> Thanks, I will fix this.
> 
>>
>>
>>> +	 * print the cdb to the trace buffers.
>>> +	 */
>>> +	memcpy(cmd->t_task_cdb, cdb, min(scsi_command_size(cdb), (unsigned
>> int)TCM_MAX_COMMAND_SIZE));
>>
>> Use 80 char cols like you did in the rest of the patch and the other code.
> 
> I recently noticed that 80 char limitation was relaxed from mainline by commit bdc48fa11e46f867ea4d75fa59ee87a7f48be144. The new limit is 100 char. I was confused whether to stick to 80 or the new limit. Let me know.
> 

I would normally stick with what's in the existing code, because it 
still says that the preferred limit is 80. For cases where readbility is 
an issue then I would go up to 100.


>>
>>> +	return ret;
>>>    }
>>>    EXPORT_SYMBOL(target_cmd_init_cdb);
>>>
>>> @@ -1455,8 +1466,6 @@ void transport_init_se_cmd(
>>>    	struct se_device *dev = cmd->se_dev;
>>>    	sense_reason_t ret;
>>>
>>> -	target_cmd_init_cdb(cmd, cdb);
>>> -
>>>    	ret = dev->transport->parse_cdb(cmd);
>>>    	if (ret == TCM_UNSUPPORTED_SCSI_OPCODE)
>>>    		pr_warn_ratelimited("%s/%s: Unsupported SCSI Opcode 0x%02x,
>> sending CHECK_CONDITION.\n",
>>> @@ -1598,6 +1607,13 @@ int target_submit_cmd_map_sgls(struct se_cmd
>> *se_cmd, struct se_session *se_sess
>>>    	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
>>>    				data_length, data_dir, task_attr, sense);
>>>
>>
>> This should maybe be in transport_init_se_cmd. It might be useful there
>> for the tmr case, if we wanted to add a trace point there too.
>>
>> At least a comment and some cleanup, because it's not obvious why we set
>> it here then also set it again in transport_lookup_cmd_lun.
> 
> Yes, I thought of initializing the cdb in transport_init_se_cmd() but realized later that TMR requests are transport level entities and hence they don't have an associated cdb with them. So, in future if we want to trace tmr request, then we may have to introduce new set of trace functions that do not reference cdb. What do you think?

I'm just talking about the LUN value and not the cdb here. In my opinion 
it's just a matter of initializing fields in transport_init_se_cmd that 
we later reference instead of having the initializations scattered 
around in multiple places.

I'm not talking about having a common trace function for the tmr and non 
tmr paths.

Also, for the cdb case the init in the target_cmd_init_cdb seems nice to 
me, because it's clear that is where we are setting up the cdb related 
fields.


> 
>>
>>
>>> +	se_cmd->orig_fe_lun = unpacked_lun; > +	rc =
>> target_cmd_init_cdb(se_cmd, cdb);
>>> +	if (rc) {
>>> +		transport_send_check_condition_and_sense(se_cmd, rc, 0);
>>
>> Can we do this before doing a get() on the cmd? If the fabric module is
>> such that it does a put() on the cmd (the callers using SCF_ACK_KREF) in
>> its cmd clean up path, then we would end up with unbalanced
>> sess->cmd_count and cmd refcounts.
>>
>> Maybe move this to after target_get_sess_cmd().
> 
> I moved it before target_get_sess_cmd() because if target_get_sess_cmd() fails then we have NULL pointer dereference issue again. For instance, the sequence

Yeah, that's why I noticed the issue :) You didn't update the 
target_get_sess_cmd failure path to do 
transport_send_check_condition_and_sense even though you moved the cdb 
init before the get() call, so the code looked off.


>    vhost_scsi_submission_wor >       target_submit_cmd_map_sgls
>         target_get_sess_cmd() -- Suppose this fails
>       transport_send_check_condition_and_sense >          trace_target_cmd_complete -- NULL ptr derefence.
> 
> Still thinking how to address both these issues together.
> 

Maybe you need a new trace call for the case where we can't fully 
initialize the cmd. It could be used for cases like where 
transport_generic_new_cmd is used directly but fails, the 
transport_handle_queue_full case, and your case where we fail during the 
initial setup.
