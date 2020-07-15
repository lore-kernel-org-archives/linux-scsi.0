Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F26A5C433E4
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 18:44:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8E1D20663
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 18:44:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rM0LpjYN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgGOSoB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 14:44:01 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41770 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbgGOSoA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2020 14:44:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FIgxin160980;
        Wed, 15 Jul 2020 18:43:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=JWKpchv/+S8TTdYYm0oNa7JJkhkvcdnN3xo2rg1PPFE=;
 b=rM0LpjYNsA3ht829rFmXmw52jGqdQ6+DNaMCddW84M7/gxyHyiR3jxpH7vmblvoLItrr
 sfm3XbHwoqdBkSuFvcaoyr3jGGzbiZCY5VdF43pXdJ/b9lPnjIdSvpEliW8diWN3GuMC
 3yL/x+IfPGMECVpWqYhP1UkOFAxYsVNJlfDcsCpTQQHZJocjpzlxuCGLf04iWwGxaMYT
 IDqEOKjZ7MWOgVogyRj5g1hfi4MaYAdGjd1oH4yowLTzqgVP5FM0Y1vDLNjQe2TABZk2
 azD9gjdAS1Wn3RJLjCSSTn7W35C1J/nqdU3A7b2Uu7EWKGDoCXbJXCVlMHMss3do1ZQG 5g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3275cmd53m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 18:43:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FIhdlv010199;
        Wed, 15 Jul 2020 18:43:57 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 327qb8ewbp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 18:43:56 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06FIhtm5001609;
        Wed, 15 Jul 2020 18:43:55 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 11:43:55 -0700
Subject: Re: [PATCH 7/8] scsi: target: tcmu: Implement tmr_notify callback
To:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200710104817.19462-1-bstroesser@ts.fujitsu.com>
 <20200710104817.19462-8-bstroesser@ts.fujitsu.com>
 <24d9afb0-3ea9-e83b-acf0-b44f04583a6e@oracle.com>
 <b8bb9898-6ff8-2ffb-47d6-d96534c6d315@ts.fujitsu.com>
 <a32b8b9e-c993-6709-b71e-3fbf80d0bdf3@oracle.com>
 <53776e18-675a-3eea-4be8-703433a247dd@ts.fujitsu.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <2a6a9b1d-e0cf-a68a-f060-53f000356118@oracle.com>
Date:   Wed, 15 Jul 2020 13:44:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <53776e18-675a-3eea-4be8-703433a247dd@ts.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007150144
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150144
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/15/20 10:08 AM, Bodo Stroesser wrote:
> On 2020-07-14 20:10, Mike Christie wrote:
>> On 7/13/20 7:03 AM, Bodo Stroesser wrote:
>>> On 2020-07-12 03:15, Mike Christie wrote:
>>>> On 7/10/20 5:48 AM, Bodo Stroesser wrote:
>>>
> 
> ...
> 
>>>>> +struct tcmu_tmr_entry {
>>>>> +    struct tcmu_cmd_entry_hdr hdr;
>>>>> +
>>>>> +#define TCMU_TMR_UNKNOWN        0
>>>>> +#define TCMU_TMR_ABORT_TASK        1
>>>>> +#define TCMU_TMR_ABORT_TASK_SET        2
>>>>> +#define TCMU_TMR_CLEAR_ACA        3
>>>>> +#define TCMU_TMR_CLEAR_TASK_SET        4
>>>>> +#define TCMU_TMR_LUN_RESET        5
>>>>> +#define TCMU_TMR_TARGET_WARM_RESET    6
>>>>> +#define TCMU_TMR_TARGET_COLD_RESET    7
>>>>> +/* Pseudo reset due to received PR OUT */
>>>>> +#define TCMU_TMR_LUN_RESET_PRO        128
>>>>> +    __u8 tmr_type;
>>>>> +
>>>>> +    __u8 __pad1;
>>>>> +    __u16 __pad2;
>>>>> +    __u32 cmd_cnt;
>>>>> +    __u64 __pad3;
>>>>> +    __u64 __pad4;
>>>>> +    __u16 cmd_ids[0];
>>>>> +} __packed;
>>>>> +
>>>>
>>>> Is this new request and the tmr_notify callback just supposed to 
>>>> clean up the requested commands or is it supposed to perform the 
>>>> actions of the task management function defined in the specs?
>>>>
>>>> The callback name makes it feel like it's just a notification, but 
>>>> the names above make it seem like we are supposed to execute the TMF 
>>>> in userspace. But if the latter, then how do we notify the kernel if 
>>>> the TMF was successful or failed?
>>>
>>> My plan is to have a notification only. IMHO userspace (and also tcmu
>>> or another backend) must not interfere with core's TMR handling.
>>> The new callback tmr_notify just allows backend to be helpful during
>>> TMR handling by completing in core aborted, but in backend/userspace
>>> still running commands early.
>>>
>>> Do you refer to the TCMU_TMR_* definitions? I just defined these names
>>> because TMR_* definitions are in target_core_base.h which is not exposed
>>> to userspace programs. Knowing the type of TMR that aborted a command is
>>> useful at least for userspace tracin
>>
>> I see where you are going. Makes sense to me now.
>>
>>>
>>> BTW: I hope there are enough padding fields in the tcmu_tmr_entry to
>>> allow additional session info later?
>>
>> Yes.
>>
>> One question on that. Were you going to use the tcmu_cmd_entry_hdr 
>> flags, or add a flag field to tcmu_tmr_entry?
> 
> The header has a flag field, tcmu_cmd_entry has not. So I didn't
> give tcmu_tmr_entry a flags field.
> We already use the header's uflags for the flag that tells tcmu that
> user defined an explicit length for data transfer to initiator.
> So, if a new flag is necessary I'd prefer to use header's kflags.
> 
>>
>> Or will userspace just know its enabled because we would eventually 
>> add a add/delete session callback to the backend modules. And from the 
>> add callout, we would then notify userspace of the new session and 
>> that other commands like tcmu_tmr_entry have session info in it.
>>
> 
> It is still not completely clear to me how you want to send session info
> to userspace. I assume session id will be written into a renamed padding
> field in cmd and tmr. That would be compatible to old userspace tools.

Yes.

> Since session IDs start at 1, new userspace can easily see that there is
> a valid session ID.
> 
> If userspace finds a session id it not knows yet, it could retrieve
> session info from sysFS or configFS.
> 
> But even then at least if a session is removed I think we will need a
> new tcmu_XXXXX_entry type telling userspace which session ID now is
> invalid.

I was hoping to just add a TCMU_OP for session addition/deletion. For 
the addition case we can check for unknown session ids like you 
mentioned, but just in case someone needed it I thought an addition op 
would be helpful.

> Therefore I assume that a new attribute in configFS is needed to switch
> on the per default deactivated session ID notification. Otherwise
> existing userspace tools might print errors or even exit if they see an
> entry type they don't know.
> If userspace via configFS attribute can switch session info on and off,
> there probably is no need for flags, right?

Yeah.
