From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2 4/9] target: don't depend on SCSI
Date: Mon, 6 Aug 2018 16:59:04 -0700
Message-ID: <CAGXu5jKNeep01VOwC-dWsT4iDXrkBOhHJX0+4BEBotYOx1D0Tg@mail.gmail.com>
References: <20180731195155.46664-1-keescook@chromium.org> <20180731195155.46664-5-keescook@chromium.org>
 <111cb1b0-24ba-bcb2-53d5-9665d2b4c421@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <111cb1b0-24ba-bcb2-53d5-9665d2b4c421@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>, Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Thomas Gleixner <tglx@linutronix.de>, Philippe Ombredanne <pombredanne@nexb.com>, Stephen Boyd <sboyd@codeaurora.org>, Cyrille Pitchen <cyrille.pitchen@free-electrons.com>, Juergen Gross <jgross@suse.com>, Viresh Kumar <viresh.kumar@linaro.org>, =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?=
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 6, 2018 at 4:38 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 07/31/2018 12:51 PM, Kees Cook wrote:
>> From: Christoph Hellwig <hch@lst.de>
>>
>> The core target code only needs code from scsi_common.c, which is now
>> separately selectable.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  drivers/target/Kconfig | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/target/Kconfig b/drivers/target/Kconfig
>> index 4c44d7bed01a..cb6f32ce7de8 100644
>> --- a/drivers/target/Kconfig
>> +++ b/drivers/target/Kconfig
>> @@ -1,10 +1,10 @@
>>
>>  menuconfig TARGET_CORE
>>       tristate "Generic Target Core Mod (TCM) and ConfigFS Infrastructure"
>> -     depends on SCSI && BLOCK
>> +     depends on BLOCK
>>       select CONFIGFS_FS
>>       select CRC_T10DIF
>> -     select BLK_SCSI_REQUEST # only for scsi_command_size_tbl..
>> +     select BLK_SCSI_REQUEST
>>       select SGL_ALLOC
>>       default n
>>       help
>> @@ -29,6 +29,7 @@ config TCM_FILEIO
>>
>>  config TCM_PSCSI
>>       tristate "TCM/pSCSI Subsystem Plugin for Linux/SCSI"
>> +     depends on SCSI
>>       help
>>       Say Y here to enable the TCM/pSCSI subsystem plugin for non-buffered
>>       passthrough access to Linux/SCSI device
>>
>
> Hi,
>
> This patch causes build errors in linux-next-20180806 when SCSI=m and
> LOOPBACK_TARGET=y.
>
> drivers/target/loopback/tcm_loop.o: In function `tcm_loop_port_link':
> tcm_loop.c:(.text+0x445): undefined reference to `scsi_add_device'
> drivers/target/loopback/tcm_loop.o: In function `tcm_loop_driver_remove':
> tcm_loop.c:(.text+0x55c): undefined reference to `scsi_remove_host'
> tcm_loop.c:(.text+0x564): undefined reference to `scsi_host_put'
> drivers/target/loopback/tcm_loop.o: In function `tcm_loop_submission_work':
> tcm_loop.c:(.text+0x7c4): undefined reference to `scmd_printk'
> drivers/target/loopback/tcm_loop.o: In function `tcm_loop_driver_probe':
> tcm_loop.c:(.text+0x7fb): undefined reference to `scsi_host_alloc'
> tcm_loop.c:(.text+0x85b): undefined reference to `scsi_add_host_with_dma'
> tcm_loop.c:(.text+0x896): undefined reference to `scsi_host_put'
> drivers/target/loopback/tcm_loop.o: In function `tcm_loop_port_unlink':
> tcm_loop.c:(.text+0x962): undefined reference to `scsi_device_lookup'
> tcm_loop.c:(.text+0x972): undefined reference to `scsi_remove_device'
> tcm_loop.c:(.text+0x97a): undefined reference to `scsi_device_put'
> drivers/target/loopback/tcm_loop.o:(.data+0x210): undefined reference to `scsi_change_queue_depth'

Can you send your .config? I'm struggling to get a build with SCSI=m. :P

I wonder if LOOPBACK_TARGET is just missing a "depends on SCSI" as was
added for TCM_PSCSI?

-Kees

-- 
Kees Cook
Pixel Security
