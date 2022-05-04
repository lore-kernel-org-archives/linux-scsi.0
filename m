Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FBB8C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  4 May 2022 11:40:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348916AbiEDLo0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 May 2022 07:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241790AbiEDLoZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 May 2022 07:44:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB7013D45
        for <linux-scsi@vger.kernel.org>; Wed,  4 May 2022 04:40:49 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 244BOiJP012688;
        Wed, 4 May 2022 11:40:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=R1ATl/vHF2Jy1ODZF6LhKt+iB3B7uUWZ446Iu7JhD1k=;
 b=jv4vb/RKJqq7pTT7YnLYxNWNXnSCBH46+hvuL0v+jdSXuEdZn8RK7ytkNWamP64Lp371
 hQuCmfFPL98LwZ89GvTsTqUbgWM/caZJvNjjRvCkmu//zM2JAirXucn51Qc/xCqJMUWN
 WkvA0+vEQgIbQLb1aSBd1iZiYHVBp5HAesFSd5CXu+nGa/ae5sjz4lGO5AXNwCKoTkhf
 bAP8TBDiRtgPWuzwnQ1XDz29XF4GQl+cmQEq3eYhBNOR/unjxmHrsFS2Zld73Jmz/I1h
 NqFmBZlACndZ5TTcpcDZwZ3c7y69a+FJ8+jiOrVq+osZDddt0sy/j7ki+AysNVIt9sqf Xg== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3furke0a75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 May 2022 11:40:43 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 244BcM4l024621;
        Wed, 4 May 2022 11:40:41 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3frvcj5jbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 May 2022 11:40:40 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 244BecFd39584000
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 May 2022 11:40:38 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F868A404D;
        Wed,  4 May 2022 11:40:38 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32CFFA4051;
        Wed,  4 May 2022 11:40:38 +0000 (GMT)
Received: from [9.145.35.60] (unknown [9.145.35.60])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  4 May 2022 11:40:38 +0000 (GMT)
Message-ID: <6257e8e3-fc82-3a57-93aa-c18ff6a23bab@linux.ibm.com>
Date:   Wed, 4 May 2022 13:40:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 03/24] zfcp: open-code fc_block_scsi_eh() for host reset
Content-Language: en-US
From:   Steffen Maier <maier@linux.ibm.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Benjamin Block <bblock@linux.ibm.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20220503200704.88003-1-hare@suse.de>
 <20220503200704.88003-4-hare@suse.de>
 <719b0a4f-a6ce-8725-9afe-76a524eadba9@linux.ibm.com>
In-Reply-To: <719b0a4f-a6ce-8725-9afe-76a524eadba9@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _S63zD46rqUfNHGj3LtersKK63jYSHma
X-Proofpoint-ORIG-GUID: _S63zD46rqUfNHGj3LtersKK63jYSHma
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-04_03,2022-05-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 mlxscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205040076
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/4/22 12:46, Steffen Maier wrote:
> On 5/3/22 22:06, Hannes Reinecke wrote:
>> When issuing a host reset we should be waiting for all
>> ports to become unblocked; just waiting for one might
>> be resulting in host reset to return too early.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Cc: Steffen Maier <maier@linux.ibm.com>
>> Cc: Benjamin Block <bblock@linux.ibm.com>
>> ---
>>   drivers/s390/scsi/zfcp_scsi.c | 21 +++++++++++++++------
>>   1 file changed, 15 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
>> index 526ac240d9fe..2e615e1dcde6 100644
>> --- a/drivers/s390/scsi/zfcp_scsi.c
>> +++ b/drivers/s390/scsi/zfcp_scsi.c
>> @@ -373,9 +373,11 @@ static int zfcp_scsi_eh_target_reset_handler(struct 
>> scsi_cmnd *scpnt)
>>   static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
>>   {
>> -    struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scpnt->device);
>> -    struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
>> -    int ret = SUCCESS, fc_ret;
>> +    struct Scsi_Host *host = scpnt->device->host;
>> +    struct zfcp_adapter *adapter = (struct zfcp_adapter *)host->hostdata[0];
>> +    int ret = SUCCESS;
>> +    unsigned long flags;
>> +    struct zfcp_port *port;
>>       if (!(adapter->connection_features & FSF_FEATURE_NPIV_MODE)) {
>>           zfcp_erp_port_forced_reopen_all(adapter, 0, "schrh_p");
>> @@ -383,9 +385,16 @@ static int zfcp_scsi_eh_host_reset_handler(struct 
>> scsi_cmnd *scpnt)
>>       }
>>       zfcp_erp_adapter_reopen(adapter, 0, "schrh_1");
>>       zfcp_erp_wait(adapter);
> 
> Now internal zfcp recovery for the adapter completed, but there are async 
> pending follow-up things, such as rport(s) unblock, see below.
> 
>> -    fc_ret = fc_block_scsi_eh(scpnt);
>> -    if (fc_ret)
>> -        ret = fc_ret;
>> +
>> +    spin_lock_irqsave(&adapter->port_list_lock, flags);
> 
> zfcp_adapter.port_list_lock is of type rwlock_t:
> 
> +    read_lock_irqsave(&adapter->port_list_lock, flags);
> 
>> +    list_for_each_entry(port, &adapter->port_list, list) {
>> +        struct fc_rport *rport = port->rport;
> 
> While an rport is blocked, port->rport == NULL [zfcp_scsi_rport_block() and
> zfcp_scsi_rport_register()], so this could be a NULL pointer deref.
> 
> Typically all rports would still be blocked after above adapter recovery, until 
> they become unblocked (via zfcp's async rport_work) 
> [zfcp_erp_try_rport_unblock() near the end of lun and port recovery that happen 
> as follow-up parts of adapter recovery and before zfcp_erp_wait() returns; it 
> eventually calls zfcp_scsi_schedule_rport_register() queueing work item 
> port->rport_work on which we could do flush_work() [one prior art in 
> zfcp_init_device_configure()]].
> 
> Am starting to wonder if we would really need to sync with the async rports 
> unblocks (for this adapter) after zfcp_erp_wait() above and before any deref 
> port->rport. Either within this loop or with a separate loop before this one.
> ( Another option would be to somehow iterate rports differently via common code 
> lists so we directly get rport references. )
> 
>> +
>> +        ret = fc_block_rport(rport);

I think I just noticed that that callee includes an msleep but we hold a read 
lock on port_list_lock. That does not seem right [scheduling while atomic?!]. 
Maybe we would need an open coded version after all to be able to drop both 
locks in correct order (and re-acquire) in the open-coded copy of fc_block_rport()?

> 
> Lock order looks good, we hold port_list_lock here and fc_block_rport() takes 
> Scsi_Host host_lock, so it matches prior art:
> static void zfcp_erp_action_dismiss_adapter(struct zfcp_adapter *adapter)
>          read_lock(&adapter->port_list_lock);
>              zfcp_erp_action_dismiss_port(port);
>              spin_lock(port->adapter->scsi_host->host_lock);
> 
>> +        if (ret)
>> +            break;
> 
> So once we find the first rport with
> (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
> we would break the loop and return from zfcp_scsi_eh_host_reset_handler() with 
> FAST_IO_FAIL. Is that correct? What if there are still other blocked rports if 
> we were to continue with the loop? Or am I missing something regarding the goal 
> of "waiting for all rports to become unblocked"?
> 
> Once we completed the loop, the question arises which consolidated return code 
> would be the correct one, if we got different ret for different rports in the 
> loop. Does my previous brain dump make sense?:
> I was pondering in my own patch version what to return of just a subset
> of ports ran into fast_io_fail. And for now I thought just fast_io_fail
> would be good to let I/O bubble up for path failover, even if this would
> include of rport which meanwhile unblocked properly and would not need
> bubbling up pending requests because they could service them with a
> simple retry.
> 
>> +    }
>> +    spin_unlock_irqrestore(&adapter->port_list_lock, flags);
> 
> +    read_unlock_irqrestore(&adapter->port_list_lock, flags);
> 
>>       zfcp_dbf_scsi_eh("schrh_r", adapter, ~0, ret);
>>       return ret;
> 
> 


-- 
Mit freundlichen Gruessen / Kind regards
Steffen Maier

Linux on IBM Z and LinuxONE

https://www.ibm.com/privacy/us/en/
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen
Geschaeftsfuehrung: David Faller
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
