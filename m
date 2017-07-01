From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] qla2xxx: Fix compile warning
Date: Fri, 30 Jun 2017 17:10:23 -0700
Message-ID: <1498867823.8086.17.camel@HansenPartnership.com>
References: <20170630235622.4602-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42776 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751680AbdGAAK0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Jun 2017 20:10:26 -0400
In-Reply-To: <20170630235622.4602-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

OK, the subject is technically true, but to most people "fix compile
warning" means yet another pointless patch.  This patch isn't
pointless, though, is it?  The driver is actually broken on big endian
systems without it, so the subject should probably say this because
it's important for distros triaging whether to backport this fix if
they backport the nvme components.

On Fri, 2017-06-30 at 16:56 -0700, Himanshu Madhani wrote:
> drivers/scsi/qla2xxx/qla_nvme.c: In function 'qla2x00_start_nvme_mq':
> include/uapi/linux/byteorder/big_endian.h:32:26: warning: large
> integer implicitly truncated to unsigned type [-Woverflow]
>  #define __cpu_to_le32(x) ((__force __le32)__swab32((x)))

This text doesn't explain why you've fixed the bug this way.  It has to
do with the 32 byte reads the card does for the mailbox, so you should
explain what the actual problem the compile warning picked up is and
why you fixed it by doing an entire 32 bit write.

Preferably ASAP because the merge window will open on Monday.

James
