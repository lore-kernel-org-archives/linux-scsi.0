Return-Path: <SRS0=ycLx=5L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6B83C2D0E5
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Mar 2020 18:34:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96C9520722
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Mar 2020 18:34:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbgCZSej (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Mar 2020 14:34:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52470 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727989AbgCZSei (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2020 14:34:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0587915CBB914;
        Thu, 26 Mar 2020 11:34:37 -0700 (PDT)
Date:   Thu, 26 Mar 2020 11:34:37 -0700 (PDT)
Message-Id: <20200326.113437.734459979907572755.davem@davemloft.net>
To:     skashyap@marvell.com
Cc:     martin.petersen@oracle.com, GR-QLogic-Storage-Upstream@marvell.com,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 5/8] qedf: Add schedule recovery handler.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200326070806.25493-6-skashyap@marvell.com>
References: <20200326070806.25493-1-skashyap@marvell.com>
        <20200326070806.25493-6-skashyap@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Mar 2020 11:34:38 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>
Date: Thu, 26 Mar 2020 00:08:03 -0700

> --- a/drivers/scsi/qedf/qedf_main.c
> +++ b/drivers/scsi/qedf/qedf_main.c
> @@ -3825,6 +3827,45 @@ static void qedf_shutdown(struct pci_dev *pdev)
>  	__qedf_remove(pdev, QEDF_MODE_NORMAL);
>  }
>  
> +/*
> + * Recovery handler code
> + */
> +void qedf_schedule_recovery_handler(void *dev)
 ...
> +void qedf_recovery_handler(struct work_struct *work)

These two functions are not referenced outside of this file, mark them
static.
