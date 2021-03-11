Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFA96C4332E
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 18:27:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DECB65003
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 18:27:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhCKS0s convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 13:26:48 -0500
Received: from fgw20-4.mail.saunalahti.fi ([62.142.5.107]:16035 "EHLO
        fgw20-4.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229796AbhCKS00 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Mar 2021 13:26:26 -0500
X-Greylist: delayed 963 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Mar 2021 13:26:25 EST
Received: from imac.makisara.private (87-92-207-71.rev.dnainternet.fi [87.92.207.71])
        by fgw20.mail.saunalahti.fi (Halon) with ESMTPSA
        id 0a96d4ae-8295-11eb-ba24-005056bd6ce9;
        Thu, 11 Mar 2021 20:10:21 +0200 (EET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH] scsi: Fix a use after free in st_open
From:   =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= 
        <kai.makisara@kolumbus.fi>
In-Reply-To: <20210311064636.10522-1-lyl2019@mail.ustc.edu.cn>
Date:   Thu, 11 Mar 2021 20:10:18 +0200
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <00362659-A275-4415-B2B0-78E6183C8272@kolumbus.fi>
References: <20210311064636.10522-1-lyl2019@mail.ustc.edu.cn>
To:     Lv Yunlong <lyl2019@mail.ustc.edu.cn>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On 11. Mar 2021, at 8.46, Lv Yunlong <lyl2019@mail.ustc.edu.cn> wrote:
> 
> In st_open, if STp->in_use is true, STp will be freed by
> scsi_tape_put(). However, STp is still used by DEBC_printk()
> after. It is better to DEBC_printk() before scsi_tape_put().
> 
> Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

Acked-by: Kai Mäkisara <kai.makisara@kolumbus.fi>

> ---
> drivers/scsi/st.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index 841ad2fc369a..9ca536aae784 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -1269,8 +1269,8 @@ static int st_open(struct inode *inode, struct file *filp)
> 	spin_lock(&st_use_lock);
> 	if (STp->in_use) {
> 		spin_unlock(&st_use_lock);
> -		scsi_tape_put(STp);
> 		DEBC_printk(STp, "Device already in use.\n");
> +		scsi_tape_put(STp);
> 		return (-EBUSY);
> 	}

Potential problem only when debugging enabled, but should be fixed.

Thanks,
Kai

