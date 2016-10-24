From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: Re: [PATCH 1/2] scsi: smartpqi: Replace semaphore sync_request_sem
 with mutex
Date: Mon, 24 Oct 2016 15:34:27 +0530
Message-ID: <CAHv-k_956e7bFnMedo34nJS=nQ-OC=UUic+VsAYSRL69iTeX+A@mail.gmail.com>
References: <1476953642-2160-1-git-send-email-binoy.jayan@linaro.org>
 <1476953642-2160-2-git-send-email-binoy.jayan@linaro.org> <2193537.0Se2hussi4@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2193537.0Se2hussi4@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, kevin Barnett <kevin.barnett@microsemi.com>, Don Brace <don.brace@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, Linux kernel mailing list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Arnd

On 20 October 2016 at 14:36, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday, October 20, 2016 2:24:01 PM CEST Binoy Jayan wrote:
>> Semaphores are going away in the future, so replace the semaphore
>> sync_request_sem with the a mutex lock. timeout_msecs is not used
>> for the lock sync_request_sem, so remove the timed locking too.
>>
>> Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
>
> The patch looks correct to me, but I think if you remove the support
> for handling timeouts, you should update the prototype of
> pqi_submit_raid_request_synchronous to no longer pass the timeout
> argument in the first place.

But we still need "timeout_msecs" in a call to
pqi_submit_raid_request_synchronous_with_io_request()

drivers/scsi/smartpqi/smartpqi_init.c +3484

-Binoy
