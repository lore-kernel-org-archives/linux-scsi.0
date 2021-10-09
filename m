Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABEB8C433EF
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Oct 2021 03:24:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8678360FD7
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Oct 2021 03:24:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244239AbhJIDZ4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 23:25:56 -0400
Received: from smtprelay0221.hostedemail.com ([216.40.44.221]:60396 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S244213AbhJIDZz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 23:25:55 -0400
X-Greylist: delayed 558 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Oct 2021 23:25:55 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave05.hostedemail.com (Postfix) with ESMTP id EFACC181BF8A5
        for <linux-scsi@vger.kernel.org>; Sat,  9 Oct 2021 03:14:40 +0000 (UTC)
Received: from omf05.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 8CED0182CED2A;
        Sat,  9 Oct 2021 03:14:39 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf05.hostedemail.com (Postfix) with ESMTPA id 52038B2794;
        Sat,  9 Oct 2021 03:14:38 +0000 (UTC)
Message-ID: <5daf69b365e23ceecee911c4d0f2f66a0b9ec95c.camel@perches.com>
Subject: Re: [PATCH] scsi scsi_transport_iscsi.c: fix misuse of %llu in
 scsi_transport_iscsi.c
From:   Joe Perches <joe@perches.com>
To:     Guo Zhi <qtxuning1999@sjtu.edu.cn>, Lee Duncan <lduncan@suse.com>,
        Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 08 Oct 2021 20:14:36 -0700
In-Reply-To: <20211009030254.205714-1-qtxuning1999@sjtu.edu.cn>
References: <20211009030254.205714-1-qtxuning1999@sjtu.edu.cn>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 52038B2794
X-Stat-Signature: bbw3xsbbdkewqjzc9ac3mxsm7cyt9oi8
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19VniraqeieMIuZT0TmPUPv+WTE0gtE6oM=
X-HE-Tag: 1633749278-20152
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 2021-10-09 at 11:02 +0800, Guo Zhi wrote:
> Pointers should be printed with %p or %px rather than
> cast to (unsigned long long) and printed with %llu.
> Change %llu to %p to print the pointer into sysfs.
][]
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
[]
> @@ -129,8 +129,8 @@ show_transport_handle(struct device *dev, struct device_attribute *attr,
>  
> 
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EACCES;
> -	return sysfs_emit(buf, "%llu\n",
> -		  (unsigned long long)iscsi_handle(priv->iscsi_transport));
> +	return sysfs_emit(buf, "%p\n",
> +		iscsi_ptr(priv->iscsi_transport));

iscsi_transport is a pointer isn't it?

so why not just

	return sysfs_emit(buf, "%p\n", priv->iscsi_transport);

?

