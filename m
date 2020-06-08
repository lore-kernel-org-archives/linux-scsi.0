Return-Path: <SRS0=xyUR=7V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 867C3C433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 19:02:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59EDD20853
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 19:02:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PpHVDEe0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgFHTCW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Jun 2020 15:02:22 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43526 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgFHTCW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2020 15:02:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 058Iqqku112568;
        Mon, 8 Jun 2020 19:02:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ttTYBawOltRsyU4wEKtJhIuZ8gUVNUgEWOMRfQ7ljpg=;
 b=PpHVDEe0fedqwoPXjieNJj1SffK7x1kHRHUo/1k6zzqb5AJbhjTwocOLl2IMlINgjNXr
 pazuDwqC+UUQDISBxjzlZcMY6UmXecPOEVRBwUz4FaqMxGUj7Bii41bfjCrI64GWU++A
 wXJ7MgIqhMLFZ9Mm1CGrT9v6qVl0HfvJ2fEB6XwacUoeAWtBpV5iReSwKQ9AHf+h+b4q
 7hoRFcOM8uasRQ6x+/iyvzF7rjDflgMQ19KzUBk7c+LQkPLN47a7QBX0u6gtSJSy/Nye
 A1JWxhreha/AmAXiHDpTcs+2/v3Qxcvfy3ZTugCrccUrv8mJp7YFesOPBFMhG6hKMLj5 YQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31g33m0gvs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 08 Jun 2020 19:02:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 058IwMrb140249;
        Mon, 8 Jun 2020 19:02:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 31gn23ncpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Jun 2020 19:02:16 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 058J2E27020489;
        Mon, 8 Jun 2020 19:02:15 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 08 Jun 2020 12:02:14 -0700
Subject: Re: [PATCH 11/17] target: add session sysfs class support
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
 <1591562164-9766-12-git-send-email-michael.christie@oracle.com>
 <20200608053259.GA241877@kroah.com>
 <1bb2e8f9-d433-de3b-3c4a-2ded2fa54240@oracle.com>
 <20200608163656.GA425601@kroah.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <e16dedcd-10ae-3d25-c49a-c24b5d964434@oracle.com>
Date:   Mon, 8 Jun 2020 14:02:16 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200608163656.GA425601@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9646 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=2 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006080135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9646 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 adultscore=0 spamscore=0
 cotscore=-2147483648 malwarescore=0 phishscore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006080134
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 6/8/20 11:36 AM, Greg Kroah-Hartman wrote:
> On Mon, Jun 08, 2020 at 10:35:56AM -0500, Mike Christie wrote:
>>
>>
>> On 6/8/20 12:32 AM, Greg Kroah-Hartman wrote:
>>> On Sun, Jun 07, 2020 at 03:35:58PM -0500, Mike Christie wrote:
>>>> +int target_sysfs_add_session(struct se_portal_group *se_tpg,
>>>> +			     struct se_session *se_sess)
>>>> +{
>>>> +	struct t10_transport_id *tpt_id = se_sess->tpt_id;
>>>> +	int ret;
>>>> +
>>>> +	if (!try_module_get(se_sess->tfo->module))
>>>> +		return -EINVAL;
>>>> +
>>>> +	ret = target_cp_endpoint_strs(se_tpg, se_sess);
>>>> +	if (ret)
>>>> +		goto put_mod;
>>>> +
>>>> +	se_sess->dev.groups = se_sess->tfo->session_attr_groups;
>>>> +	ret = device_add(&se_sess->dev);
>>>> +	if (ret) {
>>>> +		pr_err("Could not add session%d to sysfs. Error %d.\n",
>>>> +		       se_sess->sid, ret);
>>>> +		goto free_ep_strs;
>>>> +	}
>>>> +
>>>> +	pr_info("TCM added session-%d from [fabric: %s, target: %s, tpg %s, acl: %s] to [initiator port: %s%s%s]",
>>>> +		se_sess->sid, se_sess->fabric_name, se_sess->target_name,
>>>> +		se_sess->tpg_name, se_sess->acl_name ? se_sess->acl_name : "dynamic",
>>>> +		tpt_id->name, tpt_id->session_id ? "," : "",
>>>> +		tpt_id->session_id ? tpt_id->session_id : "");
>>>
>>> You have a 'struct device', so please use it, no need for pr_info(),
>>> always use the dev_*() calls instead.
>>>
>>> but, when drivers and kernel code is all working properly, no need to be
>>> noisy at all, this should just be a dev_dbg() call, right?
>>
>> I liked the info one, because the the code can work correctly, but the
>> remote devices we are connecting to are normally going to hit issues.
>>
>> For example every time the storage network goes down temporarily the driver
>> code will call remove function, then call the add again when it comes back
>> up. Having it always logged helps us figure out the root problem later when
>> the customer only has logs available.
> 
> Then make this a tracepoint or something, again, do not be noisy for
> normal system operations.  Do you want this to be the case for all of

What's a special case vs normal?

I would agree having a SCSI HBA in your system and having it setup 
during system boot up is normal.

I would agree hardware failing is special.

Having a remote client connect to us, lose its connected then recover 
seems special, because it's a failure case.

Even the initial connection seems like a special event, because the user 
has done some extra steps to have the client connect to us. It's like 
adding a new disk to the system which we log today or like plugging in 
or removing a USB device which we also log.


> your hardware devices all the time?
> 

I do, but I'm a kernel developer :)

For the sys admin and distro debugging type of case, yes, they want this 
type of thing logged, because they have done some extra setup to have a 
remote client connect to us. When the connection is lost and then 
re-added they want all that info logged with the lower level info we are 
already logging, so they can follow the time of events.
