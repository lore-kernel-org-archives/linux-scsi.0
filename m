From: Jens Axboe <axboe@fb.com>
Subject: Re: [PATCH 19/22] block: DAC960: shut up format-overflow warning
Date: Fri, 14 Jul 2017 08:04:31 -0600
Message-ID: <8d2a77af-525b-5e95-03e9-bf897e96b846@fb.com>
References: <20170714120720.906842-1-arnd@arndb.de>
 <20170714120720.906842-20-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57280 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753830AbdGNOFf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Jul 2017 10:05:35 -0400
In-Reply-To: <20170714120720.906842-20-arnd@arndb.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Guenter Roeck <linux@roeck-us.net>, netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, x86@kernel.org, =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>

On 07/14/2017 06:07 AM, Arnd Bergmann wrote:
> gcc-7 points out that a large controller number would overflow the
> string length for the procfs name and the firmware version string:
> 
> drivers/block/DAC960.c: In function 'DAC960_Probe':
> drivers/block/DAC960.c:6591:38: warning: 'sprintf' may write a terminating nul past the end of the destination [-Wformat-overflow=]
> drivers/block/DAC960.c: In function 'DAC960_V1_ReadControllerConfiguration':
> drivers/block/DAC960.c:1681:40: error: '%02d' directive writing between 2 and 3 bytes into a region of size between 2 and 5 [-Werror=format-overflow=]
> drivers/block/DAC960.c:1681:40: note: directive argument in the range [0, 255]
> drivers/block/DAC960.c:1681:3: note: 'sprintf' output between 10 and 14 bytes into a destination of size 12
> 
> Both of these seem appropriately sized, and using snprintf()
> instead of sprintf() improves this by ensuring that even
> incorrect data won't cause undefined behavior here.

Thanks Arnd, added for 4.14.

-- 
Jens Axboe
