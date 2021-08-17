Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 530CAC4320A
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 14:04:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D63660E09
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 14:04:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239976AbhHQOEc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 10:04:32 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54310 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239975AbhHQOEc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Aug 2021 10:04:32 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17HE3GHV123392;
        Tue, 17 Aug 2021 10:03:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=cv/5fKdZgmMRdBkxY8yCXg5SeFl0/iuM4zqnLGOpJpc=;
 b=LVr25CGjvaCKFcz1dPjKrDI5aJkE9NwOMgn7CFm1duH7angTROzC2vp5ocKL44r8CGQH
 inkn04vRtMV6UI5rAx4vsKjZTBw4vVCKuXKXyRyikqdgExNI2YhWuoiwuXHWHp7B3Xc/
 3GlNMkh7XShZPxSsncg873RL8QVY/4LVKCCD7zyMdnIsbZE6nK2W9MCwEYBQXSskrlEM
 4kPwuCAcM4c0KVIYNQqODSorzbDh9EOri4ZXa/2JOAtOb8GDxWlzdAXLh2rWl8FhaTyn
 IoaMkz7nIxAYNZntRvU5niWc2R+Hw1f+n4EWVg3cGSX/o+JdVUUYYnMvza9ryksGz6rt Wg== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agcdwm5n2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Aug 2021 10:03:46 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17HE2ZYV027756;
        Tue, 17 Aug 2021 14:03:44 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3ae5f8cbfg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Aug 2021 14:03:44 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17HE3gp053936488
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 14:03:42 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 551FDAE063;
        Tue, 17 Aug 2021 14:03:42 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E12A8AE05A;
        Tue, 17 Aug 2021 14:03:41 +0000 (GMT)
Received: from li-c43276cc-23ad-11b2-a85c-bda00957cb67.ibm.com (unknown [9.145.34.10])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 Aug 2021 14:03:41 +0000 (GMT)
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
From:   Steffen Maier <maier@linux.ibm.com>
Message-ID: <c9e8ad26-f78c-94d3-5c39-8e7ac15a165a@linux.ibm.com>
Date:   Tue, 17 Aug 2021 16:03:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <fdf138d0-f730-a985-e5d5-894a14a2c978@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: eZEAPg9TxSuRIgF25agrVjMqM2aSIPjq
X-Proofpoint-GUID: eZEAPg9TxSuRIgF25agrVjMqM2aSIPjq
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-17_04:2021-08-17,2021-08-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1011 spamscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 impostorscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108170086
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/21 2:54 PM, Hannes Reinecke wrote:
> On 8/17/21 1:53 PM, Benjamin Block wrote:
>> On Tue, Aug 17, 2021 at 11:14:13AM +0200, Hannes Reinecke wrote:
>>> @@ -383,9 +385,24 @@ static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
>>>   	}
>>>   	zfcp_erp_adapter_reopen(adapter, 0, "schrh_1");
>>>   	zfcp_erp_wait(adapter);
>>> -	fc_ret = fc_block_scsi_eh(scpnt);
>>> -	if (fc_ret)
>>> -		ret = fc_ret;
>>> +retry_rport_blocked:
>>> +	spin_lock_irqsave(host->host_lock, flags);
>>> +	list_for_each_entry(port, &adapter->port_list, list) {
>>
>> You need to take the `adapter->port_list_lock` to iterate over the `port_list`.
>>
>> i.e.: read_lock_irqsave(&adapter->port_list_lock, flags);
>>
>>> +		struct fc_rport *rport = port->rport;
>>> +
>>> +		if (rport->port_state == FC_PORTSTATE_BLOCKED) {
>>> +			if (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
>>> +				ret = FAST_IO_FAIL;
>>> +			else
>>> +				ret = NEEDS_RETRY;
>>> +			break;
>>> +		}
>>> +	}
>>> +	spin_unlock_irqrestore(host->host_lock, flags);
>>> +	if (ret == NEEDS_RETRY) {
>>> +		msleep(1000);
>>> +		goto retry_rport_blocked;
>>> +	}
>>
>> I really can't say I like this open coded FC code in the driver at all.
>>
>> Is there a reason we can't use `fc_block_rport()` for all the rports of
>> the adapter?

Waiting for all rports to unblock in host_reset has been on my todo list since 
we prepared the eh callbacks to get rid of scsi_cmnd with v4.18 commits:
674595d8519f ("scsi: zfcp: decouple our scsi_eh callbacks from scsi_cmnd")
42afc6527d43 ("scsi: zfcp: decouple TMFs from scsi_cmnd by using fc_block_rport")
26f5fa9d47c1 ("scsi: zfcp: decouple SCSI setup of TMF from scsi_cmnd")
39abb11aca00 ("scsi: zfcp: decouple FSF request setup of TMF from scsi_cmnd")
e0116c91c7d8 ("scsi: zfcp: split FCP_CMND IU setup between SCSI I/O and TMF again")
266883f2f7d5 ("scsi: zfcp: decouple TMF response handler from scsi_cmnd")
822121186375 ("scsi: zfcp: decouple SCSI traces for scsi_eh / TMF from scsi_cmnd")

But the synchronization is non-trivial as Benjamin's question shows. There are 
also considerations about lock order, etc.

I'm busy with other things, so don't hold your breath until I can review and 
test the code; I don't want any regression in that recovery code.

>> We already do use it for other EH callbacks in the same file, and you
>> already look up the rports in the adapters rport-list; so using that on
>> the rports in the loop, instead of open-coding it doesn't seem bad? Or
>> is there a locking problem?
>>
>> We might waste a few cycles with that, but frankly, this is all in EH
>> and after adapter reset.. all performance concerns went our of the
>> window with that already.
>>
> 
> Question would be why we need to call fc_block_rport() at all in host reset.
> To my understanding a host reset is expected to do a full resync of the
> SAN topology, so the expectation is that after zfcp_erp_wait() the port
> list is stable (ie the HBA has finished processing all RSCNs related to
> the SAN resync).

There is more to do in zfcp than in other FC HBA drivers, e.g. LUN open 
recoveries and how they related to rport unblock:
v4.10 6f2ce1c6af37 ("scsi: zfcp: fix rport unblock race with LUN recovery").
The rport unblock is async to our internal recovery. zfcp_erp_wait() only waits 
for the latter by design.

> So can't we just drop the fc_block_rport() call here?

I don't think so.

> All the other FC drivers do fine without that ...

It would have been nice to have a common interface for all scsi_eh scopes. I.e. 
fc_block_host(struct Scsi_Host*) like we already have for 
fc_block_scsi_eh(struct scsi_cmnd*) and fc_block_rport(struct fc_rport*) [the 
latter having been introduced at the time of above eh callback preparations].
But if zfcp is the only one needing it for host_reset, having the code only in 
zfcp seems fine to me.


-- 
Mit freundlichen Gruessen / Kind regards
Steffen Maier

Linux on IBM Z Development

https://www.ibm.com/privacy/us/en/
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Matthias Hartmann
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
