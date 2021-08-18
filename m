Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B509C4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 11:00:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C3F56102A
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 11:00:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234485AbhHRLA6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Aug 2021 07:00:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27370 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233170AbhHRLAz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Aug 2021 07:00:55 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17IAfM8r087183;
        Wed, 18 Aug 2021 07:00:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=3C3fFRU3ZLbBi2z5exgT3SdFTpnI7Nj7kEAAetDf75Y=;
 b=YSEcKdta84JDsl96RFdluMECwrazmr1D7uhzgTIstkdw99ddi4ZCp/hUDygVrmfsv9xn
 qJOnMYamCiYiMMZQmFlTM3Ca/Xe9dLQBEwwiN+BKB181AEA8PoeqZ8lUxvfu4t92EeHa
 ksA5nV+iocfBCiyHNoH4y7T55zlRKtfumSkff2zlZdk8S4vqCHeVeA9mcBz0/Ni0n/cT
 EkNqQ0DfZq6e8l8QNfjSGuFeoBquaGaA9ZDueQxlr9X7YY3S4LJZac5c5yXvhoMYB33m
 hmBwuoDpLwh5EZis7RigkYDhrh4jpNKdT3BdnN3dkl6a9bAbccn52cd1U4nGrllho+PM dw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ag7bss8nq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 07:00:06 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17IArCfX008680;
        Wed, 18 Aug 2021 11:00:04 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3ae53hxffd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 11:00:03 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17IB01Wd55509290
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 11:00:01 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 69B824C04A;
        Wed, 18 Aug 2021 11:00:01 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 022C44C050;
        Wed, 18 Aug 2021 11:00:01 +0000 (GMT)
Received: from li-c43276cc-23ad-11b2-a85c-bda00957cb67.ibm.com (unknown [9.145.27.43])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Aug 2021 11:00:00 +0000 (GMT)
Subject: Re: [PATCH 08/51] zfcp: open-code fc_block_scsi_eh() for host reset
To:     Hannes Reinecke <hare@suse.de>,
        Benjamin Block <bblock@linux.ibm.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20210817091456.73342-1-hare@suse.de>
 <20210817091456.73342-9-hare@suse.de>
 <YRujHScPbb1Aokrj@t480-pf1aa2c2.linux.ibm.com>
 <fdf138d0-f730-a985-e5d5-894a14a2c978@suse.de>
 <c9e8ad26-f78c-94d3-5c39-8e7ac15a165a@linux.ibm.com>
 <30e9ee6e-0ce5-63ea-ba3b-a89a1f6c1705@suse.de>
From:   Steffen Maier <maier@linux.ibm.com>
Message-ID: <156b07d7-30f1-eeda-ef3c-376f767d8031@linux.ibm.com>
Date:   Wed, 18 Aug 2021 13:00:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <30e9ee6e-0ce5-63ea-ba3b-a89a1f6c1705@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: obxAs7bTH6lundc96sJ4IwaJE37lHtCF
X-Proofpoint-GUID: obxAs7bTH6lundc96sJ4IwaJE37lHtCF
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-18_03:2021-08-17,2021-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 clxscore=1015
 bulkscore=0 adultscore=0 mlxscore=0 impostorscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108180065
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/21 4:10 PM, Hannes Reinecke wrote:
> On 8/17/21 4:03 PM, Steffen Maier wrote:
>> On 8/17/21 2:54 PM, Hannes Reinecke wrote:
>>> On 8/17/21 1:53 PM, Benjamin Block wrote:
>>>> On Tue, Aug 17, 2021 at 11:14:13AM +0200, Hannes Reinecke wrote:
>>>>> @@ -383,9 +385,24 @@ static int
>>>>> zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
>>>>>        }
>>>>>        zfcp_erp_adapter_reopen(adapter, 0, "schrh_1");
>>>>>        zfcp_erp_wait(adapter);
>>>>> -    fc_ret = fc_block_scsi_eh(scpnt);
>>>>> -    if (fc_ret)
>>>>> -        ret = fc_ret;
>>>>> +retry_rport_blocked:
>>>>> +    spin_lock_irqsave(host->host_lock, flags);
>>>>> +    list_for_each_entry(port, &adapter->port_list, list) {
>>>>
>>>> You need to take the `adapter->port_list_lock` to iterate over the
>>>> `port_list`.
>>>>
>>>> i.e.: read_lock_irqsave(&adapter->port_list_lock, flags);
>>>>
>>>>> +        struct fc_rport *rport = port->rport;
>>>>> +
>>>>> +        if (rport->port_state == FC_PORTSTATE_BLOCKED) {
>>>>> +            if (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
>>>>> +                ret = FAST_IO_FAIL;
>>>>> +            else
>>>>> +                ret = NEEDS_RETRY;
>>>>> +            break;
>>>>> +        }
>>>>> +    }
>>>>> +    spin_unlock_irqrestore(host->host_lock, flags);
>>>>> +    if (ret == NEEDS_RETRY) {
>>>>> +        msleep(1000);
>>>>> +        goto retry_rport_blocked;
>>>>> +    }
>>>>
>>>> I really can't say I like this open coded FC code in the driver at all.
>>>>
>>>> Is there a reason we can't use `fc_block_rport()` for all the rports of
>>>> the adapter?
>>
>> Waiting for all rports to unblock in host_reset has been on my todo list
>> since we prepared the eh callbacks to get rid of scsi_cmnd with v4.18
>> commits:
>> 674595d8519f ("scsi: zfcp: decouple our scsi_eh callbacks from scsi_cmnd")
>> 42afc6527d43 ("scsi: zfcp: decouple TMFs from scsi_cmnd by using
>> fc_block_rport")
>> 26f5fa9d47c1 ("scsi: zfcp: decouple SCSI setup of TMF from scsi_cmnd")
>> 39abb11aca00 ("scsi: zfcp: decouple FSF request setup of TMF from
>> scsi_cmnd")
>> e0116c91c7d8 ("scsi: zfcp: split FCP_CMND IU setup between SCSI I/O and
>> TMF again")
>> 266883f2f7d5 ("scsi: zfcp: decouple TMF response handler from scsi_cmnd")
>> 822121186375 ("scsi: zfcp: decouple SCSI traces for scsi_eh / TMF from
>> scsi_cmnd")
>>
>> But the synchronization is non-trivial as Benjamin's question shows.
>> There are also considerations about lock order, etc.
>>
>> I'm busy with other things, so don't hold your breath until I can review
>> and test the code; I don't want any regression in that recovery code.
>>
>>>> We already do use it for other EH callbacks in the same file, and you
>>>> already look up the rports in the adapters rport-list; so using that on
>>>> the rports in the loop, instead of open-coding it doesn't seem bad? Or
>>>> is there a locking problem?
>>>>
>>>> We might waste a few cycles with that, but frankly, this is all in EH
>>>> and after adapter reset.. all performance concerns went our of the
>>>> window with that already.
>>>>
>>>
>>> Question would be why we need to call fc_block_rport() at all in host
>>> reset.
>>> To my understanding a host reset is expected to do a full resync of the
>>> SAN topology, so the expectation is that after zfcp_erp_wait() the port
>>> list is stable (ie the HBA has finished processing all RSCNs related to
>>> the SAN resync).
>>
>> There is more to do in zfcp than in other FC HBA drivers, e.g. LUN open
>> recoveries and how they related to rport unblock:
>> v4.10 6f2ce1c6af37 ("scsi: zfcp: fix rport unblock race with LUN
>> recovery").
>> The rport unblock is async to our internal recovery. zfcp_erp_wait()
>> only waits for the latter by design.
>>
>>> So can't we just drop the fc_block_rport() call here?
>>
>> I don't think so.
>>
>>> All the other FC drivers do fine without that ...
>>
>> It would have been nice to have a common interface for all scsi_eh
>> scopes. I.e. fc_block_host(struct Scsi_Host*) like we already have for
>> fc_block_scsi_eh(struct scsi_cmnd*) and fc_block_rport(struct fc_rport*)
>> [the latter having been introduced at the time of above eh callback
>> preparations].
>> But if zfcp is the only one needing it for host_reset, having the code
>> only in zfcp seems fine to me.
>>
>>
> Right. Just wanted to clarify that.
> If we need to use fc_block_rport() in host reset so be it; just wanted
> to clarify if this _really_ is the case (and not just some copy'n'paste
> stuff).
> I'll be reworking the patch to call fc_block_rport().

On second thought, I might have been wrong.

The argument I used with the old commit was that we must not unblock the rport 
too early with regards to zfcp-internal recovery. This is fixed within zfcp 
recovery (erp) code. So after zfcp_erp_wait() in host_reset, this is still 
ensured; and eventually the rport unblock will occur.

I guess I was rather worried about returning from the host_reset callback with 
the async rport(s) unblock still pending. After all, (some) other reset_handler 
sync with rport unblock. However I cannot remember all details right now.

Before you invest more time into this, maybe just drop this patch from the 
series for now and we solve it later on? I mean it's not necessary for the 
reset_handler function signature change.


-- 
Mit freundlichen Gruessen / Kind regards
Steffen Maier

Linux on IBM Z and LinuxONE

https://www.ibm.com/privacy/us/en/
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
