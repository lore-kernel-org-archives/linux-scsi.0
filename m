Return-Path: <SRS0=6jMo=EN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E736C2D0A3
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Nov 2020 01:20:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 163AB20867
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Nov 2020 01:20:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gn3C5v5B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbgKGBUX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Nov 2020 20:20:23 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:46842 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbgKGBUX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Nov 2020 20:20:23 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A71GFGx093928;
        Sat, 7 Nov 2020 01:20:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=1Py/JnasV8LqzVHVUmJx0DOcDVa/RQciogJK169ItZM=;
 b=gn3C5v5BdMHs4dS5R3BgIVxc9OIONpIY6TEaufttxwtx3aIYTC4a/flIz4RJZ9+Rrr3l
 aheRc+NUtm4XeYc6q63B0DxHjjcEJOnhBF5L16OF8wLP73LAtBRu/LdxlJOf3gQJRz8x
 zpuph7d4QTgeZyjNoWP3udDdcuBNy4ksOCku0ohtbZ/x1UpqwzyqpbCZTnOUboZzgrS+
 P635tW79x54AnfIK6bmZ+Rby2hcZxtjYazYbjKfjvFQsz4H1KaemPSmqHI058BHb2Fbw
 GmyAxUQ0g1/s4KQn2WjNuEZ8VBrT1fDyEHWkQArC964PCMoWQ9IMJPFgp00s5DZRvwfu CA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34hhw33p0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 07 Nov 2020 01:20:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A71EdP3103315;
        Sat, 7 Nov 2020 01:18:12 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34hw0qey2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 07 Nov 2020 01:18:12 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0A71IAnq001089;
        Sat, 7 Nov 2020 01:18:11 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 06 Nov 2020 17:18:08 -0800
Subject: Re: [PATCH v6 3/4] scsi_transport_fc: Added a new rport state
 FC_PORTSTATE_MARGINAL
To:     Hannes Reinecke <hare@suse.de>,
        Muneendra Kumar M <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
References: <1604556596-27228-1-git-send-email-muneendra.kumar@broadcom.com>
 <1604556596-27228-4-git-send-email-muneendra.kumar@broadcom.com>
 <e575da88-8b40-3062-9835-419456b46989@oracle.com>
 <08d150e63f2b79cd0199fb49355ce601@mail.gmail.com>
 <eed1c6b0-1b9c-572c-a9f6-8468a6996491@oracle.com>
 <e1e877f3-78d1-3038-32a5-d08af5ec7dde@suse.de>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <41e2232c-ad46-14f8-2fd5-a451fef8fcb1@oracle.com>
Date:   Fri, 6 Nov 2020 19:18:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <e1e877f3-78d1-3038-32a5-d08af5ec7dde@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9797 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 bulkscore=0
 mlxscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011070005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9797 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011070005
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/6/20 1:23 AM, Hannes Reinecke wrote:
> On 11/5/20 8:15 PM, Mike Christie wrote:
>> On 11/5/20 11:27 AM, Muneendra Kumar M wrote:
>>> Hi Mike,
>>> Thanks for the input.
>>> Below are my replies.
>>>
>>>
>>>> Hey sorry for the late reply. I was trying to test some things out but am
>>>> not sure if all drivers work the same.
>>>
>>>> For the code above, what will happen if we have passed that check in the
>>>> driver, then the driver does the report del and add sequence? Let's say
>>>> it's initially calling the abort callout, and we passed that check, we then
>>>> do the >del/add seqeuence, what will happen next? Do the fc drivers return
>>>> success or failure for the abort call. What happens for the other callouts
>>>> too?
>>>
>>>> If failure, then the eh escalates and when we call the next callout, and we
>>>> hit the check above and will clear it, so we are ok.
>>>
>>> If success then we would not get a chance to clear it right?
>>> [Muneendra]Agreed. So what about clearing the flags in fc_remote_port_del. I
>>> think this should address all the concerns?
>>>
>>>> If this is the case, then I think you need to instead go the route where
>>>> you add the eh cmd completion/decide_disposition callout. You would call
>>>> it in scmd_eh_abort_handler, scsi_eh_bus_device_reset, etc when we are
>>>> deciding if we want to retry/fail the command.
>>> [Muneendra]Sorry I didn't get what you are saying could you please elaborate
>>> on the same.
>>>
>>> In this approach you do not need the eh_timed_out changes, since we only
>>> seem to care about the port state after the eh callout has completed.
>>> [Muneendra]what about setting the SCMD_NORETRIES_ABORT bit?
>>>
>>
>> I don't think you need it. It sounds like we only care about the port state
>> when the cmd is completing. For example we have:
>>
>> 1. the case where the cmd times out, we do aborts/resets, then the
>> port state goes into marginal, then the aborts/resets complete. We want to
>> fail the cmds without retries.
>>
>> 2. If the port state is in marginal, the cmd times out, we do the aborts/resets
>> and when we are done if the port state is still marginal we want to fail the
>> cmd without retries.
>>
>> 3. If the port state is marginal (or any value), before or after the cmd
>> initially times out, but the port state goes back to online, then when the
>> aborts/resets complete we want to retry the cmd.
>>
> Actually, I don't think the third case can (or should) happen.
> A transition from marginal to online should always include a link bounce (ie a rport_del/rport_add sequence), which would cancel all outstanding commands anyway.
> And if we have the above provision we could clear the flag in rport_del() and everything would be dandy.

That is the part I didn't like or I thought could have issues:

1. What if we go back into marginal after the add() but before we have done scsi_eh_flush_done_q? You need the original looping code and some code for del() right?

2. My issue with #1 is why do we want to add code that loops over commands when we only care about the port state and when scsi_eh_flush_done_q and the abort completion code is already looping over them.

3. This is probably a matter of preference, and I can see why people would not like an extra callout. However, I like the idea that we have an eh callout for the transport class that checks if it's even worth it to run the eh code based on the port state and then we have a eh completion callout that can also check the port state and determine if it's ok.

If we had a marginal scsi_device state or even a bit then you would not actually need #3. The fc class could just set the device state/bit and we could check that in the eh completion code paths.
