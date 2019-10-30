Return-Path: <SRS0=//Xo=YX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ABA3CA9EAF
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 08:25:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 611082083E
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 08:25:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbfJ3IZT convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Oct 2019 04:25:19 -0400
Received: from mx2.uni-regensburg.de ([194.94.157.147]:41650 "EHLO
        mx2.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbfJ3IZT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Oct 2019 04:25:19 -0400
X-Greylist: delayed 520 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Oct 2019 04:25:18 EDT
Received: from mx2.uni-regensburg.de (localhost [127.0.0.1])
        by localhost (Postfix) with SMTP id 0671C6000059;
        Wed, 30 Oct 2019 09:16:36 +0100 (CET)
Received: from gwsmtp.uni-regensburg.de (gwsmtp1.uni-regensburg.de [132.199.5.51])
        by mx2.uni-regensburg.de (Postfix) with ESMTP id EB5EE6000051;
        Wed, 30 Oct 2019 09:16:35 +0100 (CET)
Received: from uni-regensburg-smtp1-MTA by gwsmtp.uni-regensburg.de
        with Novell_GroupWise; Wed, 30 Oct 2019 09:16:35 +0100
Message-Id: <5DB946E1020000A100034B9C@gwsmtp.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 18.1.1 
Date:   Wed, 30 Oct 2019 09:16:33 +0100
From:   "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To:     "open-iscsi" <open-iscsi@googlegroups.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, "Chris Leech" <cleech@redhat.com>,
        "Lee Duncan" <lduncan@suse.com>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Cc:     <liuzhiqiang26@huawei.com>, <mingfangsen@huawei.com>
Subject: Antw: [PATCH v2] scsi: avoid potential deadloop in iscsi_if_rx
 func
References: <EDBAAA0BBBA2AC4E9C8B6B81DEEE1D6915DFA0FE@dggeml505-mbs.china.huawei.com>
In-Reply-To: <EDBAAA0BBBA2AC4E9C8B6B81DEEE1D6915DFA0FE@dggeml505-mbs.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>>> "wubo (T)" <wubo40@huawei.com> schrieb am 30.10.2019 um 08:56 in Nachricht
<EDBAAA0BBBA2AC4E9C8B6B81DEEE1D6915DFA0FE@dggeml505-mbs.china.huawei.com>:
> From: Bo Wu <wubo40@huawei.com>

...
> +			if (--retries < 0) {
> +				printk(KERN_ERR "Send reply failed too many times. "
> +				       "Max supported retries %u\n", ISCSI_SEND_MAX_ALLOWED);

Just for "personal taste": Why not simplify the message to:?
+				printk(KERN_ERR "Send reply failed too many times (%u)\n",
                               ISCSI_SEND_MAX_ALLOWED);

> +				break;
> +			}
> +

Maybe place the number after "many" as an alternative. I think as the message is expected to be rare, a short variant is justified.
Also one could discuss wether the problem that originates "from external" should be KERN_ERR, or maybe just a warning, because the kernel itself can do little against that problem, and it's not a "kernel error" after all ;-)

Regards,
Ulrich




