From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: 2.6.20-rc6-mm1
Date: Tue, 30 Jan 2007 21:10:12 +0100
Message-ID: <45BFA624.4040400@gmail.com>
References: <20070127234928.64d8e437.akpm@osdl.org>	<45BC7A26.1080303@gmail.com>	<20070129232727.96e580ac.akpm@osdl.org> <20070130113055.431ad91a.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751242AbXA3UKS@vger.kernel.org>
In-Reply-To: <20070130113055.431ad91a.akpm@osdl.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, Miles Lane <miles.lane@gmail.com>, Anton Altaparmakov <aia21@cantab.net>, Pierre Ossman <drzeus@drzeus.cx>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

Andrew Morton napsal(a):
> On Mon, 29 Jan 2007 23:27:27 -0800
> Andrew Morton <akpm@osdl.org> wrote:
> 
>> On Sun, 28 Jan 2007 11:25:42 +0100
>> Jiri Slaby <jirislaby@gmail.com> wrote:
>>
>>> Andrew Morton napsal(a):
>>>> Temporarily at
>>>>
>>>> 	http://userweb.kernel.org/~akpm/2.6.20-rc6-mm1/
>>> I'm still seeing this during bootup:
>>> BUG: at /home/l/latest/xxx/arch/i386/mm/highmem.c:52 kmap_atomic()
>>>   [<c0104ffb>] show_trace_log_lvl+0x1a/0x30
>>>   [<c01056b5>] show_trace+0x12/0x14
>>>   [<c010573c>] dump_stack+0x16/0x18
>>>   [<c011b24f>] kmap_atomic+0x16c/0x20e
>>>   [<c01b279e>] ntfs_end_buffer_async_read+0x18e/0x2ed
>>>   [<c0183352>] end_bio_bh_io_sync+0x26/0x3f
>>>   [<c0184dd4>] bio_endio+0x37/0x62
>>>   [<c01cda43>] __end_that_request_first+0x224/0x444
>>>   [<c01cdc6b>] end_that_request_chunk+0x8/0xa
>>>   [<c024507d>] scsi_end_request+0x1f/0xc7
>>>   [<c02451e6>] scsi_io_completion+0x7b/0x33a
>>>   [<c024aa5d>] sd_rw_intr+0x23/0x1ab
>>>   [<c02415ed>] scsi_finish_command+0x42/0x47
>>>   [<c0245a38>] scsi_softirq_done+0x64/0xcf
>>>   [<c01cf9e6>] blk_done_softirq+0x54/0x62
>>>   [<c0127bc5>] __do_softirq+0x75/0xde
>>>   [<c0127c69>] do_softirq+0x3b/0x3d
>>>   [<c0127ee6>] irq_exit+0x3b/0x3d
>>>   [<c0106804>] do_IRQ+0x51/0x8d
>>>   [<c0104a5f>] common_interrupt+0x23/0x28
>>>   [<c010241a>] cpu_idle+0x80/0xc3
>>>   [<c010140d>] rest_init+0x23/0x36
>>>   [<c045ea59>] start_kernel+0x3a5/0x43c
>>>   [<00000000>] 0x0
>>>   =======================
>>>
>>> I.e. KM_BIO_SRC_IRQ through softirq path.
[...]
> Actually, this isn't related to softirq-vs-hardirq.  Most interrupt

I meant that hardirq path was fixed (by adding KM_BIO_SRC_IRQ to kmap_atomic
"type !=" test in arch/i386/mm/highmem.c) and softirq was not yet.

> handlers are interruptible, so the rule is simply that KM_BIO_SRC_IRQ must
> always be taken under local_irq_disable().
> 
> A quick scan indicates that the following files might be buggy in this
> regard:
> 
> drivers/mmc/wbsd.c
> drivers/mmc/at91_mci.c
> drivers/mmc/sdhci.c
> drivers/scsi/scsi_lib.c when called from stex.c
> fs/ntfs/aops.c
> 
> Happily, KM_BIO_DST_IRQ has no users and can presumably be removed.
> 
> 
> Fixes for stex and ntfs follow.

Clean boot now.

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
