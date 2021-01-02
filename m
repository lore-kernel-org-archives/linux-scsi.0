Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CEA2C433E0
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Jan 2021 22:31:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DCCF207A1
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Jan 2021 22:31:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbhABWbh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Jan 2021 17:31:37 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:49106 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbhABWbg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Jan 2021 17:31:36 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 102MUrPo057361;
        Sat, 2 Jan 2021 22:30:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=CEAaNsIqzlnePH2aCjdw+slJGvweo2T/l2PR/bvFR3M=;
 b=ke7SJv6BCOza8Ou1dGbPaoGmLxVcZX2oL/3U8zuPZ9q2RxnOuSrzHos3v5IoTQQXrTv6
 obRplIxphw7l/goTnBE4D0djJtMvIEB1KVNkHZjXUXF4AgitqlIeinwS7sy/P829kQu0
 a03pCVKsoiUcsKcsxd9lT/rVOxzd9+OiHsSzrl/jJu2rfZxGMY3FOFds15lhXm6glwwx
 TOCRJtGMCRuz3fKPxzYbNuicxuT3IkKfx+qS6wOgnQvrEga9VDLTpuFK7rA706xH7DSw
 XWr5WO7f9br9xx5XaJlRn5vMe9/bZOZzPgEJXnb7GdlYENWozrFtiYAuBjzKitwDXD2M bQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 35tebah0ca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 02 Jan 2021 22:30:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 102MRMoT153553;
        Sat, 2 Jan 2021 22:30:52 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 35tfbmkfcr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Jan 2021 22:30:52 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 102MUpCG001491;
        Sat, 2 Jan 2021 22:30:51 GMT
Received: from [20.15.0.204] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 02 Jan 2021 14:30:51 -0800
Subject: Re: [PATCH 3/7] tcm qlaxx: move sess cmd list/lock to driver
To:     Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michael.christie@oracle.com>,
        himanshu.madhani@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Nilesh Javali <njavali@marvell.com>
References: <1603666998-8086-1-git-send-email-michael.christie@oracle.com>
 <1603666998-8086-4-git-send-email-michael.christie@oracle.com>
 <8d94c626-78e4-ed8c-d077-4add314f789c@acm.org>
From:   Mike Christie <michael.chritie@oracle.com>
Message-ID: <96d27c3f-6b0a-58b6-bf8a-69a18a9a85fa@oracle.com>
Date:   Sat, 2 Jan 2021 16:30:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8d94c626-78e4-ed8c-d077-4add314f789c@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9852 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 bulkscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101020142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9852 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 priorityscore=1501 spamscore=0 mlxscore=0 clxscore=1011 bulkscore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101020143
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/31/20 10:45 PM, Bart Van Assche wrote:
> On 10/25/20 4:03 PM, Mike Christie wrote:
>> @@ -617,25 +629,20 @@ static int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *mcmd, u64 lun,
>>  static struct qla_tgt_cmd *tcm_qla2xxx_find_cmd_by_tag(struct fc_port *sess,
>>      uint64_t tag)
>>  {
>> -	struct qla_tgt_cmd *cmd = NULL;
>> -	struct se_cmd *secmd;
>> +	struct qla_tgt_cmd *cmd;
>>  	unsigned long flags;
>>  
>>  	if (!sess->se_sess)
>>  		return NULL;
>>  
>> -	spin_lock_irqsave(&sess->se_sess->sess_cmd_lock, flags);
>> -	list_for_each_entry(secmd, &sess->se_sess->sess_cmd_list, se_cmd_list) {
>> -		/* skip task management functions, including tmr->task_cmd */
>> -		if (secmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
>> -			continue;
>> -
>> -		if (secmd->tag == tag) {
>> -			cmd = container_of(secmd, struct qla_tgt_cmd, se_cmd);
>> -			break;
>> -		}
>> +	spin_lock_irqsave(&sess->sess_cmd_lock, flags);
>> +	list_for_each_entry(cmd, &sess->sess_cmd_list, sess_cmd_list) {
>> +		if (cmd->se_cmd.tag == tag)
>> +			goto done;
>>  	}
>> -	spin_unlock_irqrestore(&sess->se_sess->sess_cmd_lock, flags);
>> +	cmd = NULL;
>> +done:
>> +	spin_unlock_irqrestore(&sess->sess_cmd_lock, flags);
>>  
>>  	return cmd;
>>  }
> 
> Hi Mike,
> 
> Although this behavior has not been introduced by your patch: what prevents
> that the command found by tcm_qla2xxx_find_cmd_by_tag() disappears after
> sess_cmd_lock has been unlocked and before the caller uses the qla_tgt_cmd 
> pointer? As you may know the corresponding code in SCST increments the SCSI

Nothing.

> command reference count before unlocking the lock that protects the command
> list. See also the __scst_find_cmd_by_tag() call in scst_mgmt_cmd_init().
> 

I'll send a patch for that when I get the aborted task crash fixed up. I
didn't send fixes for existing bugs in the driver like them for this patchset.
It got a little crazy. For example for the aborted task issue, I reverted the
patch that made the eh async I mentioned a while back. That fixes the crash,
but then there was a hang. So I thought I'll just convert it to the async eh
patch since either way I have to fix the driver. Himanshu was helping me figure
out how to support it, but it's not trivial.



 
