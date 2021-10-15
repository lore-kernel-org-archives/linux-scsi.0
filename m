Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FDEDC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 07:37:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6311D611C2
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 07:37:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234062AbhJOHjH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 03:39:07 -0400
Received: from smtp181.sjtu.edu.cn ([202.120.2.181]:42162 "EHLO
        smtp181.sjtu.edu.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236258AbhJOHio (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Oct 2021 03:38:44 -0400
Received: from proxy02.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
        by smtp181.sjtu.edu.cn (Postfix) with ESMTPS id D20AF1006D5BA;
        Fri, 15 Oct 2021 15:36:33 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by proxy02.sjtu.edu.cn (Postfix) with ESMTP id ED7E6200B8924;
        Fri, 15 Oct 2021 15:36:30 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from proxy02.sjtu.edu.cn ([127.0.0.1])
        by localhost (proxy02.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id D8EEzls3b3t7; Fri, 15 Oct 2021 15:36:30 +0800 (CST)
Received: from [192.168.10.98] (unknown [202.120.40.82])
        (Authenticated sender: qtxuning1999@sjtu.edu.cn)
        by proxy02.sjtu.edu.cn (Postfix) with ESMTPSA id 220EA200C02C4;
        Fri, 15 Oct 2021 15:36:17 +0800 (CST)
Message-ID: <6772c5ef-4666-e2b5-2885-797baa939b45@sjtu.edu.cn>
Date:   Fri, 15 Oct 2021 15:36:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: Antw: [EXT] Re: [PATCH] scsi scsi_transport_iscsi.c: fix misuse
 of %llu in scsi_transport_iscsi.c
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        Chris Leech <cleech@redhat.com>, Lee Duncan <lduncan@suse.com>
Cc:     open-iscsi <open-iscsi@googlegroups.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20211009030254.205714-1-qtxuning1999@sjtu.edu.cn>
 <5daf69b365e23ceecee911c4d0f2f66a0b9ec95c.camel@perches.com>
 <6163DB2E020000A1000445F1@gwsmtp.uni-regensburg.de>
 <ae7a82c2-5b19-493a-8d61-cdccb00cf46c@oracle.com>
From:   Guo Zhi <qtxuning1999@sjtu.edu.cn>
In-Reply-To: <ae7a82c2-5b19-493a-8d61-cdccb00cf46c@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/10/11 23:29, Mike Christie wrote:
> On 10/11/21 1:35 AM, Ulrich Windl wrote:
>>>>> Joe Perches <joe@perches.com> schrieb am 09.10.2021 um 05:14 in Nachricht
>> <5daf69b365e23ceecee911c4d0f2f66a0b9ec95c.camel@perches.com>:
>>> On Sat, 2021-10-09 at 11:02 +0800, Guo Zhi wrote:
>>>> Pointers should be printed with %p or %px rather than
>>>> cast to (unsigned long long) and printed with %llu.
>>>> Change %llu to %p to print the pointer into sysfs.
>>> ][]
>>>> diff --git a/drivers/scsi/scsi_transport_iscsi.c
>>> b/drivers/scsi/scsi_transport_iscsi.c
>>> []
>>>> @@ -129,8 +129,8 @@ show_transport_handle(struct device *dev, struct
>>> device_attribute *attr,
>>>>   
>>>>
>>>>   	if (!capable(CAP_SYS_ADMIN))
>>>>   		return -EACCES;
>>>> -	return sysfs_emit(buf, "%llu\n",
>>>> -		  (unsigned long long)iscsi_handle(priv->iscsi_transport));
>>>> +	return sysfs_emit(buf, "%p\n",
>>>> +		iscsi_ptr(priv->iscsi_transport));
>>> iscsi_transport is a pointer isn't it?
>>>
>>> so why not just
>>>
>>> 	return sysfs_emit(buf, "%p\n", priv->iscsi_transport);
>> Isn't the difference that %p outputs hex, while %u outputs decimal?
>>
> Yeah, I think this patch will break userspace, because it doesn't know it's
> a pointer. It could be doing:
>
> sscanf(str, "%llu", &val);
>
> The value is just later passed back to the kernel to look up a driver in
> iscsi_if_transport_lookup:
>
>          list_for_each_entry(priv, &iscsi_transports, list) {
>                  if (tt == priv->iscsi_transport) {
>
> so we could just replace priv->transport with an int and use an ida to assign
> the value.

Taking security into consideration, We should not print kernel pointer 
into sysfs.

However if this is a special pointer to lookup a driver,  It's really 
tricky for me to fix it,

as I don't have a scsi device to test my code.


Guo


