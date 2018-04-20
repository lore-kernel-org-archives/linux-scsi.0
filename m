From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] [v2] scsi: ips: fix firmware timestamps for 32-bit
Date: Fri, 20 Apr 2018 19:38:11 -0400
Message-ID: <yq1wox1fnz0.fsf@oracle.com>
References: <20180420160459.3621883-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180420160459.3621883-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Fri, 20 Apr 2018 18:04:40 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Finn Thain <fthain@telegraphics.com.au>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> do_gettimeofday() is deprecated since it will stop working in 2038 on
> 32-bit platforms, leading to incorrect times passed to the firmware.
> On 64-bit platforms the current code appears to be fine, as the
> calculation passes an 8-bit century number into the firmware that can
> represent times long in the future (possibly until 25599).
>
> Using ktime_get_real_seconds() to get a 64-bit seconds value and
> time64_to_tm() to convert it into the firmware format greatly
> simplifies the ips timekeeping code, makes 32-bit and 64-bit behave
> the same way here, and gets us closer to removing the deprecated
> interfaces.

Applied to 4.18/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
