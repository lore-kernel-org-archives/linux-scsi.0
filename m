Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78D52C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 06:40:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56DE860C41
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 06:40:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234214AbhJKGml convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Oct 2021 02:42:41 -0400
Received: from mx1.uni-regensburg.de ([194.94.157.146]:37114 "EHLO
        mx1.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbhJKGml (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Oct 2021 02:42:41 -0400
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Oct 2021 02:42:40 EDT
Received: from mx1.uni-regensburg.de (localhost [127.0.0.1])
        by localhost (Postfix) with SMTP id 4D28A6000056;
        Mon, 11 Oct 2021 08:35:29 +0200 (CEST)
Received: from gwsmtp.uni-regensburg.de (gwsmtp1.uni-regensburg.de [132.199.5.51])
        by mx1.uni-regensburg.de (Postfix) with ESMTP id 321076000052;
        Mon, 11 Oct 2021 08:35:29 +0200 (CEST)
Received: from uni-regensburg-smtp1-MTA by gwsmtp.uni-regensburg.de
        with Novell_GroupWise; Mon, 11 Oct 2021 08:35:29 +0200
Message-Id: <6163DB2E020000A1000445F1@gwsmtp.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 18.3.1 
Date:   Mon, 11 Oct 2021 08:35:26 +0200
From:   "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        "Chris Leech" <cleech@redhat.com>, <qtxuning1999@sjtu.edu.cn>,
        "Lee Duncan" <lduncan@suse.com>
Cc:     "open-iscsi" <open-iscsi@googlegroups.com>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>
Subject: Antw: [EXT] Re: [PATCH] scsi scsi_transport_iscsi.c: fix
 misuse of %llu in scsi_transport_iscsi.c
References: <20211009030254.205714-1-qtxuning1999@sjtu.edu.cn>
 <5daf69b365e23ceecee911c4d0f2f66a0b9ec95c.camel@perches.com>
In-Reply-To: <5daf69b365e23ceecee911c4d0f2f66a0b9ec95c.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>>> Joe Perches <joe@perches.com> schrieb am 09.10.2021 um 05:14 in Nachricht
<5daf69b365e23ceecee911c4d0f2f66a0b9ec95c.camel@perches.com>:
> On Sat, 2021-10-09 at 11:02 +0800, Guo Zhi wrote:
>> Pointers should be printed with %p or %px rather than
>> cast to (unsigned long long) and printed with %llu.
>> Change %llu to %p to print the pointer into sysfs.
> ][]
>> diff --git a/drivers/scsi/scsi_transport_iscsi.c 
> b/drivers/scsi/scsi_transport_iscsi.c
> []
>> @@ -129,8 +129,8 @@ show_transport_handle(struct device *dev, struct 
> device_attribute *attr,
>>  
>> 
>>  	if (!capable(CAP_SYS_ADMIN))
>>  		return -EACCES;
>> -	return sysfs_emit(buf, "%llu\n",
>> -		  (unsigned long long)iscsi_handle(priv->iscsi_transport));
>> +	return sysfs_emit(buf, "%p\n",
>> +		iscsi_ptr(priv->iscsi_transport));
> 
> iscsi_transport is a pointer isn't it?
> 
> so why not just
> 
> 	return sysfs_emit(buf, "%p\n", priv->iscsi_transport);

Isn't the difference that %p outputs hex, while %u outputs decimal?

> 
> ?
> 
> -- 
> You received this message because you are subscribed to the Google Groups 
> "open-iscsi" group.
> To unsubscribe from this group and stop receiving emails from it, send an 
> email to open-iscsi+unsubscribe@googlegroups.com.
> To view this discussion on the web visit 
> https://groups.google.com/d/msgid/open-iscsi/5daf69b365e23ceecee911c4d0f2f66a 
> 0b9ec95c.camel%40perches.com.




