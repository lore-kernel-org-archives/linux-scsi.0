From: Helge Deller <deller@gmx.de>
Subject: Re: Undefined behaviour in drivers/scsi/sym53c8xx_2/sym_hipd.c:762:24
Date: Tue, 8 Aug 2017 00:20:21 +0200
Message-ID: <bf3cee29-26cb-6e4c-9ef2-a84459d41dec@gmx.de>
References: <d030f03a-0ccf-324b-32d6-002dfb408c16@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <d030f03a-0ccf-324b-32d6-002dfb408c16@gmx.de>
Content-Language: en-US
Sender: linux-parisc-owner@vger.kernel.org
To: Linux SCSI List <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-parisc <linux-parisc@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 05.08.2017 00:12, Helge Deller wrote:
> On the parisc platform I noticed the UBSAN warning below.
> Maybe nr_divisor isn't correctly initialized ?
> 
> [   18.625415] ================================================================================
> [   18.726489] UBSAN: Undefined behaviour in ./drivers/scsi/sym53c8xx_2/sym_hipd.c:762:24
> [   18.864911] index -1903078336 is out of range for type 'u32 [7]'
> [   18.936779] CPU: 0 PID: 1 Comm: swapper Not tainted 4.13.0-rc3-32bit+ #427
> [   19.019138] Backtrace:
> [   19.047353]  [<10191eb4>] show_stack+0x3c/0x50
> [   19.100577]  [<10ce82fc>] dump_stack+0x28/0x38
> [   19.153826]  [<10771b3c>] ubsan_epilogue+0x1c/0x60
> [   19.211229]  [<107722ec>] __ubsan_handle_out_of_bounds+0x68/0x80
> [   19.283194]  [<10924074>] sym_hcb_attach+0xc2c/0x3204
> [   19.343724]  [<107aaa38>] sba_dma_supported+0x4c/0x208
> [   19.405291]  [<10911984>] sym2_probe+0xd64/0x122c
> [   19.461661]  [<10501c64>] kernfs_add_one+0x328/0x354

I did some more debugging.

The offending line is:
	period = (11 * div_10M[np->clock_divn - 1]) / (4 * np->clock_khz);
with those values
	np->clock_divn = 7
	np->clock_khz  = 160000
	div_10M[6] = 80000000
period gets calculated as: 
	period = 1375
which is correct.

I have no clue why UBSAN reports an error here.
There is no overflow in index for div_10M array, neither is there
a u32 overflow.
Ideas?

Helge
