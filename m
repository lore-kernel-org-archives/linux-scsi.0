From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 3/6] block: Create scsi_sense.h for SCSI and ATAPI
Date: Tue, 22 May 2018 16:34:02 -0700
Message-ID: <66701f74-4f2b-988e-dd48-a2140694f551@infradead.org>
References: <20180522181512.39316-1-keescook@chromium.org>
 <20180522181512.39316-4-keescook@chromium.org>
 <20180522183613.GA3784@infradead.org> <yq1efi3bk3g.fsf@oracle.com>
 <CAGXu5jJ0Sice+fdpWgzBhQR=NGz-DT9qmYVdV1GeH73_q9pbmw@mail.gmail.com>
 <732f4249-5681-4a54-ec21-4ecc3d3a74e5@kernel.dk>
 <20180522191309.GA23615@infradead.org>
 <8d4af5c4-96fa-54ee-d5c1-b887b1de5a3c@kernel.dk>
 <CAGXu5j+mgGZkTDS6EDRspJKKbU=vMT4ehv9T-SekPba=ESoGDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5j+mgGZkTDS6EDRspJKKbU=vMT4ehv9T-SekPba=ESoGDg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Tejun Heo <tj@kernel.org>, Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, linux-block <linux-block@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 05/22/2018 04:31 PM, Kees Cook wrote:
> On Tue, May 22, 2018 at 12:16 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 5/22/18 1:13 PM, Christoph Hellwig wrote:
>>> On Tue, May 22, 2018 at 01:09:41PM -0600, Jens Axboe wrote:
>>>> I think Martin and Christoph are objecting to moving the code to
>>>> block/scsi_ioctl.h. I don't care too much about where the code is, but
>>>> think it would be nice to have the definitions in a separate header. But
>>>> if they prefer just pulling in all of SCSI for it, well then I guess
>>>> it's pointless to move the header bits. Seems very heavy handed to me,
>>>> though.
>>>
>>> It might be heavy handed for the 3 remaining users of drivers/ide,
>>
>> Brutal :-)
> 
> Heh. I noticed a similar sense buffer use in drivers/cdrom/cdrom.c
> too. Is this okay under the same considerations?

No.  Do not select an entire subsystem.  Use depends on it instead.


> diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
> index ad9b687a236a..220ff321c102 100644
> --- a/drivers/block/Kconfig
> +++ b/drivers/block/Kconfig
> @@ -79,7 +79,7 @@ config GDROM
>         tristate "SEGA Dreamcast GD-ROM drive"
>         depends on SH_DREAMCAST
>         select CDROM
> -       select BLK_SCSI_REQUEST # only for the generic cdrom code
> +       select SCSI
>         help
>           A standard SEGA Dreamcast comes with a modified CD ROM drive called a
>           "GD-ROM" by SEGA to signify it is capable of reading special disks
> @@ -345,7 +345,7 @@ config CDROM_PKTCDVD
>         tristate "Packet writing on CD/DVD media (DEPRECATED)"
>         depends on !UML
>         select CDROM
> -       select BLK_SCSI_REQUEST
> +       select SCSI
>         help
>           Note: This driver is deprecated and will be removed from the
>           kernel in the near future!
> diff --git a/drivers/block/paride/Kconfig b/drivers/block/paride/Kconfig
> index f8bd6ef3605a..7fdfcc5eaca5 100644
> --- a/drivers/block/paride/Kconfig
> +++ b/drivers/block/paride/Kconfig
> @@ -27,7 +27,7 @@ config PARIDE_PCD
>         tristate "Parallel port ATAPI CD-ROMs"
>         depends on PARIDE
>         select CDROM
> -       select BLK_SCSI_REQUEST # only for the generic cdrom code
> +       select SCSI
>         ---help---
>           This option enables the high-level driver for ATAPI CD-ROM devices
>           connected through a parallel port. If you chose to build PARIDE
> 
>>> but as long as that stuff just keeps working I'd rather worry about
>>> everyone else, and keep the scsi code where it belongs.
>>
>> Fine with me then, hopefully we can some day kill it off.
> 
> I'll send a v2. I found a few other things to fix up (including the
> cdrom.c one).


-- 
~Randy
