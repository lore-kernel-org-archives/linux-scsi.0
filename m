From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] scsi: lpfc: use memcpy_toio instead of writeq
Date: Mon, 26 Feb 2018 10:03:58 +0100
Message-ID: <CAK8P3a1gsKOL=2epyvwnWe5LbZ0L+vHVuM5zfz3gS25ptQ2UrQ@mail.gmail.com>
References: <20180223153700.2186058-1-arnd@arndb.de> <mqdsh9p9yl3.fsf@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <mqdsh9p9yl3.fsf@linux-x5ow.site>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Feb 25, 2018 at 11:02 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> Arnd Bergmann <arnd@arndb.de> writes:
>> 32-bit architectures generally cannot use writeq(), so we now get a build
>> failure for the lpfc driver:
>>
>> drivers/scsi/lpfc/lpfc_sli.c: In function 'lpfc_sli4_wq_put':
>> drivers/scsi/lpfc/lpfc_sli.c:145:4: error: implicit declaration of function 'writeq'; did you mean 'writeb'? [-Werror=implicit-function-declaration]
> Hi Arnd,
> why can't we use the writeq() from 'io-64-nonatomic-lo-hi.h'? I always
> thought these are compat versions for 32 Bit archs and even asked James
> to do so, what's why he did the change in the first place.

That could work as well, if someone can figure out what the correct incantation
is that works on big-endian 32-bit architectures. I think the simplest
version that
works everywhere would be

lo_hi_writeq(__le32_to_cpup(__le32 __force *)p) |
(u64)__le32_to_cpup(__le32 __force *)p +1) << 32));

but this is ugly as hell and makes my head spin. I definitely would't want that
applied without being tested properly first on a variety of architectures.

There are three variants that I'd prefer over that:

- use memcpy_toio() and change the x86 implementation to guarantee aligned
  word aligned accesses on the output if at all possible (which seems to be
  a good idea anyway)
- use a loop around __raw_writeq()/__raw_writel() depending on CONFIG_64BIT
- add generic memcpy_toio_32() and memcpy_toio_64() helpers in linux/io.h
  and use those.

       Arnd
