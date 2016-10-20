From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/2] scsi: smartpqi: Replace semaphore sync_request_sem with mutex
Date: Thu, 20 Oct 2016 11:10:39 +0200
Message-ID: <3118730.6uvAdDZXCF@wuerfel>
References: <1476953642-2160-1-git-send-email-binoy.jayan@linaro.org> <1476953642-2160-2-git-send-email-binoy.jayan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:64671 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757426AbcJTJKy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Oct 2016 05:10:54 -0400
In-Reply-To: <1476953642-2160-2-git-send-email-binoy.jayan@linaro.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Binoy Jayan <binoy.jayan@linaro.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, kevin Barnett <kevin.barnett@microsemi.com>, Don Brace <don.brace@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thursday, October 20, 2016 2:24:01 PM CEST Binoy Jayan wrote:
> -       sema_init(&ctrl_info->sync_request_sem,
> -               PQI_RESERVED_IO_SLOTS_SYNCHRONOUS_REQUESTS);
> +       mutex_init(&ctrl_info->sync_request_mutex);
> 

Looking at this again, I see that PQI_RESERVED_IO_SLOTS_SYNCHRONOUS_REQUESTS
is '3', so this is in fact a counting semaphore rather than a mutex,
and the conversion is changing the behavior.

The patch can't go in unless you either show that it should be
a normal mutex rather than a counting semaphore, or you find a way
to keep the behavior the same.

	Arnd
