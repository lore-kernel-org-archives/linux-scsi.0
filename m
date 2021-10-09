Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7324C433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Oct 2021 04:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACF5460FD7
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Oct 2021 04:35:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbhJIEhS convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Oct 2021 00:37:18 -0400
Received: from smtp179.sjtu.edu.cn ([202.120.2.179]:48300 "EHLO
        smtp179.sjtu.edu.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbhJIEhR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Oct 2021 00:37:17 -0400
Received: from mta04.sjtu.edu.cn (mta04.sjtu.edu.cn [202.121.179.8])
        by smtp179.sjtu.edu.cn (Postfix) with ESMTPS id 34EFE100888DA;
        Sat,  9 Oct 2021 12:35:18 +0800 (CST)
Received: from localhost (localhost [127.0.0.1])
        by mta04.sjtu.edu.cn (Postfix) with ESMTP id 083D0185F5239;
        Sat,  9 Oct 2021 12:35:18 +0800 (CST)
X-Virus-Scanned: amavisd-new at mta04.sjtu.edu.cn
Received: from mta04.sjtu.edu.cn ([127.0.0.1])
        by localhost (mta04.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id jtfBzz9G5XvD; Sat,  9 Oct 2021 12:35:17 +0800 (CST)
Received: from mstore105.sjtu.edu.cn (unknown [10.118.0.105])
        by mta04.sjtu.edu.cn (Postfix) with ESMTP id C0ABB1805DA80;
        Sat,  9 Oct 2021 12:35:17 +0800 (CST)
Date:   Sat, 9 Oct 2021 12:35:17 +0800 (CST)
From:   Guo Zhi <qtxuning1999@sjtu.edu.cn>
To:     Joe Perches <joe@perches.com>
Cc:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <1054322431.5783331.1633754117686.JavaMail.zimbra@sjtu.edu.cn>
In-Reply-To: <5daf69b365e23ceecee911c4d0f2f66a0b9ec95c.camel@perches.com>
References: <20211009030254.205714-1-qtxuning1999@sjtu.edu.cn> <5daf69b365e23ceecee911c4d0f2f66a0b9ec95c.camel@perches.com>
Subject: Re: [PATCH] scsi scsi_transport_iscsi.c: fix misuse of %llu in
 scsi_transport_iscsi.c
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.166.42.95]
X-Mailer: Zimbra 8.8.15_GA_4125 (ZimbraWebClient - GC91 (Linux)/8.8.15_GA_3928)
Thread-Topic: scsi scsi_transport_iscsi.c: fix misuse of %llu in scsi_transport_iscsi.c
Thread-Index: XXuAZWa/hbD+Z5L5JVAn1uE58Jskmw==
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I will send a V2 patch.

----- 原始邮件 -----
发件人: "Joe Perches" <joe@perches.com>
收件人: "Guo Zhi" <qtxuning1999@sjtu.edu.cn>, "Lee Duncan" <lduncan@suse.com>, "Chris Leech" <cleech@redhat.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
抄送: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, "linux-kernel" <linux-kernel@vger.kernel.org>
发送时间: 星期六, 2021年 10 月 09日 上午 11:14:36
主题: Re: [PATCH] scsi scsi_transport_iscsi.c: fix misuse of %llu in scsi_transport_iscsi.c

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
