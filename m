Return-Path: <SRS0=0GAJ=6C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFB5AC352BE
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 08:31:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA91C22261
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 08:31:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgDRIbi convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Apr 2020 04:31:38 -0400
Received: from vs25.mail.saunalahti.fi ([62.142.117.202]:47350 "EHLO
        vs25.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbgDRIbh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Apr 2020 04:31:37 -0400
X-Greylist: delayed 408 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Apr 2020 04:31:35 EDT
Received: from vs25.mail.saunalahti.fi (localhost [127.0.0.1])
        by vs25.mail.saunalahti.fi (Postfix) with ESMTP id F120220DC3;
        Sat, 18 Apr 2020 11:24:45 +0300 (EEST)
Received: from gw01.mail.saunalahti.fi (gw01.mail.saunalahti.fi [195.197.172.115])
        by vs25.mail.saunalahti.fi (Postfix) with ESMTP id E5B2820D7E;
        Sat, 18 Apr 2020 11:24:45 +0300 (EEST)
Received: from [192.168.1.20] (87-100-216-152.bb.dnainternet.fi [87.100.216.152])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kh8831)
        by gw01.mail.saunalahti.fi (Postfix) with ESMTPSA id 9DDAF40006;
        Sat, 18 Apr 2020 11:24:38 +0300 (EEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH] scsi: st: remove unneeded variable 'result' in
 st_release()
From:   =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= 
        <kai.makisara@kolumbus.fi>
In-Reply-To: <20200418070605.11450-1-yanaijie@huawei.com>
Date:   Sat, 18 Apr 2020 11:24:38 +0300
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        martin.petersen@oracle.com, arnd@arndb.de,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hulk Robot <hulkci@huawei.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <ACE0F4F0-0F37-4BF3-B817-E107629975D1@kolumbus.fi>
References: <20200418070605.11450-1-yanaijie@huawei.com>
To:     Jason Yan <yanaijie@huawei.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On 18. Apr 2020, at 10.06, Jason Yan <yanaijie@huawei.com> wrote:
> 
> Also remove a strange '^L' after this function.
> 
It is the FormFeed character, put there to make viewing the source easier
(the following functions are helpers). (The FormFeed may not be as
familiar to the younger generations than it is to us who have used line
printers with hammers and drums or chains :-)

> Fix the following coccicheck warning:
> 
> drivers/scsi/st.c:1460:5-11: Unneeded variable: "result". Return "0" on
> line 1473
> 
The variable is related to the style of programming: default the return value
to zero and modify it in the code if necessary. In the current version, there
is no need (may have been at some time).

IMHO, the code checking tools should have some understanding of the
style issues. However, if the common opinion is to remove the variable,
I have to accept that.

Kai

> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Acked-by: Kai Mäkisara <kai.makisara@kolumbus.fi>

> ---
> drivers/scsi/st.c | 5 ++---
> 1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index c5f9b348b438..4bf4ab3b70f4 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -1457,7 +1457,6 @@ static int st_flush(struct file *filp, fl_owner_t id)
>    accessing this tape. */
> static int st_release(struct inode *inode, struct file *filp)
> {
> -	int result = 0;
> 	struct scsi_tape *STp = filp->private_data;
> 
> 	if (STp->door_locked == ST_LOCKED_AUTO)
> @@ -1470,9 +1469,9 @@ static int st_release(struct inode *inode, struct file *filp)
> 	scsi_autopm_put_device(STp->device);
> 	scsi_tape_put(STp);
> 
> -	return result;
> +	return 0;
> }
> -
> +
> /* The checks common to both reading and writing */
> static ssize_t rw_checks(struct scsi_tape *STp, struct file *filp, size_t count)
> {
> -- 
> 2.21.1
> 

