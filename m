From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: fas216: fix sense buffer initialization
Date: Thu, 18 Jan 2018 21:43:59 -0500
Message-ID: <yq13732o9e8.fsf@oracle.com>
References: <20180118131650.893849-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:51702 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755055AbeASCpG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Jan 2018 21:45:06 -0500
In-Reply-To: <20180118131650.893849-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Thu, 18 Jan 2018 14:16:38 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@armlinux.org.uk>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


Arnd,

> While testing with the ARM specific memset() macro removed, I ran
> into a compiler warning that shows an old bug:
>
> drivers/scsi/arm/fas216.c: In function 'fas216_rq_sns_done':
> drivers/scsi/arm/fas216.c:2014:40: error: argument to 'sizeof' in 'memset' call is the same expression as the destination; did you mean to provide an explicit length? [-Werror=sizeof-pointer-memaccess]
>
> It turns out that the definition of the scsi_cmd structure changed back
> in linux-2.6.25, so now we clear only four bytes (sizeof(pointer)) instead
> of 96 (SCSI_SENSE_BUFFERSIZE). I did not check whether we actually need
> to initialize the buffer here, but it's clear that if we do it, we
> should use the correct size.

Applied to 4.16/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
