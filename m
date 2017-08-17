From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sd: read unmap block limits even if lbpme=0
Date: Wed, 16 Aug 2017 22:11:46 -0400
Message-ID: <yq160dnndst.fsf@oracle.com>
References: <59921282.c3341c0a.a8437.1b70@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41904 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751070AbdHQCLv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2017 22:11:51 -0400
In-Reply-To: <59921282.c3341c0a.a8437.1b70@mx.google.com> (tom's message of
        "Tue, 15 Aug 2017 05:13:26 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tom.ty89@gmail.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org


Tom,

> Some devices may not be decent enough to report lbpme bit properly
> even when they do support unmap and report relevant information in the
> block limits and logical block provisioning VPDs properly (Namely,
> ASMedia ASM1351, a UAS-SATA bridge). One of the reasons is, lbpme=1 is
> not a requirement for "DeleteNotify" in Windows to be activated:

I have to confess I'm wary of interpreting values reported by a device
that messes up setting the single bit flag that enables the feature.

Before I entertain taking your patch I'd like to take a closer look to
make sure everything is gated by sdkp->lbpme.

However, instead of relying on UNMAP, does this bridge support WRITE
SAME with the UNMAP bit? Because in that case you should be able to set
provisioning_mode to WS10 or WS16 and then adjust max_write_same_blocks.

-- 
Martin K. Petersen	Oracle Linux Engineering
