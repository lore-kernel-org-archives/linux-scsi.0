Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7258BC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 07:04:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52FD460EB4
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 07:04:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233773AbhJLHGi convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 03:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233712AbhJLHGg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 03:06:36 -0400
X-Greylist: delayed 88142 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 12 Oct 2021 00:04:34 PDT
Received: from mx3.uni-regensburg.de (mx3.uni-regensburg.de [IPv6:2001:638:a05:137:165:0:4:4e79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 973D8C06161C;
        Tue, 12 Oct 2021 00:04:34 -0700 (PDT)
Received: from mx3.uni-regensburg.de (localhost [127.0.0.1])
        by localhost (Postfix) with SMTP id 032826000054;
        Tue, 12 Oct 2021 09:04:30 +0200 (CEST)
Received: from gwsmtp.uni-regensburg.de (gwsmtp1.uni-regensburg.de [132.199.5.51])
        by mx3.uni-regensburg.de (Postfix) with ESMTP id D8F2F6000050;
        Tue, 12 Oct 2021 09:04:29 +0200 (CEST)
Received: from uni-regensburg-smtp1-MTA by gwsmtp.uni-regensburg.de
        with Novell_GroupWise; Tue, 12 Oct 2021 09:04:29 +0200
Message-Id: <6165337C020000A1000446A6@gwsmtp.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 18.3.1 
Date:   Tue, 12 Oct 2021 09:04:28 +0200
From:   "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        "Chris Leech" <cleech@redhat.com>, <qtxuning1999@sjtu.edu.cn>,
        "Lee Duncan" <lduncan@suse.com>
Cc:     "open-iscsi" <open-iscsi@googlegroups.com>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>
Subject: Re: Antw: [EXT] Re: [PATCH] scsi scsi_transport_iscsi.c: fix
 misuse of %llu in scsi_transport_iscsi.c
References: <20211009030254.205714-1-qtxuning1999@sjtu.edu.cn>
 <5daf69b365e23ceecee911c4d0f2f66a0b9ec95c.camel@perches.com>
 <6163DB2E020000A1000445F1@gwsmtp.uni-regensburg.de>
 <ae7a82c2-5b19-493a-8d61-cdccb00cf46c@oracle.com>
In-Reply-To: <ae7a82c2-5b19-493a-8d61-cdccb00cf46c@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>>> Mike Christie <michael.christie@oracle.com> schrieb am 11.10.2021 um 17:29 in
Nachricht <ae7a82c2-5b19-493a-8d61-cdccb00cf46c@oracle.com>:
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
>>>>  	if (!capable(CAP_SYS_ADMIN))
>>>>  		return -EACCES;
>>>> -	return sysfs_emit(buf, "%llu\n",
>>>> -		  (unsigned long long)iscsi_handle(priv->iscsi_transport));
>>>> +	return sysfs_emit(buf, "%p\n",
>>>> +		iscsi_ptr(priv->iscsi_transport));
>>>
>>> iscsi_transport is a pointer isn't it?
>>>
>>> so why not just
>>>
>>> 	return sysfs_emit(buf, "%p\n", priv->iscsi_transport);
>> 
>> Isn't the difference that %p outputs hex, while %u outputs decimal?
>> 
> 
> Yeah, I think this patch will break userspace, because it doesn't know it's
> a pointer. It could be doing:
> 
> sscanf(str, "%llu", &val);
> 
> The value is just later passed back to the kernel to look up a driver in
> iscsi_if_transport_lookup:
> 
>         list_for_each_entry(priv, &iscsi_transports, list) {
>                 if (tt == priv->iscsi_transport) {
> 
> so we could just replace priv->transport with an int and use an ida to assign
> the value.

I'm not in the details, but if that value is used as an ID, shouldn't it have been something like "ID%llu" right from the start?
If so it would be rather easy to use "ID%p" instead (if the syntax of the ID is left unspecified). At least nobody would treat it as a number.

Regards,
Ulrich


> 
> -- 
> You received this message because you are subscribed to the Google Groups 
> "open-iscsi" group.
> To unsubscribe from this group and stop receiving emails from it, send an 
> email to open-iscsi+unsubscribe@googlegroups.com.
> To view this discussion on the web visit 
> https://groups.google.com/d/msgid/open-iscsi/ae7a82c2-5b19-493a-8d61-cdccb00c 
> f46c%40oracle.com.




