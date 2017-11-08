From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] aacraid: use timespec64 instead of timeval
Date: Wed, 08 Nov 2017 18:08:33 -0500
Message-ID: <yq1h8u4z7v2.fsf@oracle.com>
References: <20171107104613.3183755-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171107104613.3183755-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Tue, 7 Nov 2017 11:46:05 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, David Carroll <david.carroll@microsemi.com>, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> aacraid passes the current time to the firmware in one of two ways,
> either as year/month/day/... or as 32-bit unsigned seconds.
>
> The first one is broken on 32-bit architectures as it cannot go past
> year 2038. Using timespec64 here makes it behave properly on both
> 32-bit and 64-bit architectures, and avoids relying on signed integer
> overflow to pass times into the second interface.
>
> The interface used in aac_send_hosttime() however is still problematic
> in year 2106 when 32-bit seconds overflow. Hopefully we don't have to
> worry about aacraid by that time.

Applied to 4.15/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
