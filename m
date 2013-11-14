From: David Decotigny <decot@googlers.com>
Subject: Re: [PATCH] scsi: avoid use of reclaimed reference
Date: Wed, 13 Nov 2013 18:50:58 -0800
Message-ID: <CAG88wWa-U5LoXOvBb+eOAutidgV-cyteQ5aS5EQKDkswSJnH-w@mail.gmail.com>
References: <cover.1384304973.git.decot@googlers.com> <643cda2192c25962f37c8bba65e22f70a57167d0.1384304973.git.decot@googlers.com>
 <52836B53.4080204@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <52836B53.4080204@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello,

Thank you for looking into this. I could reproduce the oops on some
Dell Poweredge R720 with the following config flags, otherwise the
problem goes un-noticed:

CONFIG_DEBUG_PAGEALLOC=y
CONFIG_DEBUG_SLAB=y

[    4.924033] BUG: unable to handle kernel paging request at ffff88000004dd10
[    4.931823] IP: [<ffffffff8139797f>] __scsi_scan_target+0x3ef/0x6f0
[    4.938846] PGD 1ba1067 PUD 1ba2067 PMD 1ba3067 PTE 800000000004d060
[    4.945985] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[    4.951074] Modules linked in:
[    4.954492] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-smp-scsi01 #1

This points to this line on the return path of scsi_report_lun_scan:
if (scsi_device_created(sdev))

Kernel is jejb/scsi/for-next at 2aee240c68ed32 and I could reproduce
the bug with other 3.x kernels on same hardware. For me, it is 100%
reproducible.

The ref counter values I indicated in my previous email are the result
of a basic instrumentation. It shows that ref count drops from 3 to 1
as a result of scsi_probe_and_add_lun(). I believe this is because the
latter calls __scsi_remove_device(sdev).

Now, if sdev reclaiming is not allowed to happen at the end of
scsi_report_lun_scan by design because someone else is expected to
hold a reference to it, then I'd be happy to add a BUG_ON() on the
return path and explicit the post-condition in the function
documentation, and also try to find out where a ref is killed by
mistake. However, if sdev relcaiming at the end of
scsi_report_lun_scan is allowed, then I'd argue that the "if
(scsi_device_created(sdev))" on the potentially reclaimed sdev is not
right, that's why I was proposing this patch.

Regards,

On Wed, Nov 13, 2013 at 4:06 AM, Bart Van Assche <bvanassche@acm.org> wrote:
> On 11/13/13 02:10, David Decotigny wrote:
>>
>> This patch avoids to use an object after it was potentially reclaimed
>> by scsi_device_put().
>>
>> Signed-off-by: David Decotigny <decot@googlers.com>
>> ---
>>   drivers/scsi/scsi_scan.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
>> index 307a811..16e4a44 100644
>> --- a/drivers/scsi/scsi_scan.c
>> +++ b/drivers/scsi/scsi_scan.c
>> @@ -1498,12 +1498,14 @@ static int scsi_report_lun_scan(struct scsi_target
>> *starget, int bflags,
>>    out_err:
>>         kfree(lun_data);
>>    out:
>> -       scsi_device_put(sdev);
>> -       if (scsi_device_created(sdev))
>> +       if (scsi_device_created(sdev)) {
>>                 /*
>>                  * the sdev we used didn't appear in the report luns scan
>>                  */
>>                 __scsi_remove_device(sdev);
>> +       }
>> +
>> +       scsi_device_put(sdev);
>>         return ret;
>>   }
>
>
> It would help if you could explain why you started looking at this code. Is
> the above patch something you came up with after having analyzed the SCSI
> mid-layer source code or perhaps as the result of a test that failed ? If
> so, which test was it that failed ?
>
> Thanks,
>
> Bart.
>
