From: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Subject: Re: QLGC,ISP SCSI driver not finding attached devices
Date: Tue, 24 Jul 2007 22:28:42 +0100 (BST)
Message-ID: <Pine.LNX.4.61.0707242116370.17959@mtfhpc.demon.co.uk>
References: <Pine.LNX.4.61.0707232315510.16213@mtfhpc.demon.co.uk>
 <1185238223.3417.42.camel@localhost.localdomain>
 <Pine.LNX.4.61.0707241758020.17959@mtfhpc.demon.co.uk>
 <20070724.124304.51855385.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20070724.124304.51855385.davem@davemloft.net>
Sender: sparclinux-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>, James.Bottomley@SteelEye.com
Cc: sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi David and James,

Thank you for your help in investigating the issues I have been having.

I thought I rememberd seeing somthing about memset.

Having changed the memset code, I have found that the ESP scsi BUS 
Timeout can be reverted back to 250ms. Both SCSI drivers are now working 
properly both built in and as modules.

Tomorows task is to see if I can get my floppy disk changes to work (my 
SS1 has an 82077, not an 82072 and it is not sun4m compatible).

Regards
 	Mark Fortescue.

On Tue, 24 Jul 2007, David Miller wrote:

> From: Mark Fortescue <mark@mtfhpc.demon.co.uk>
> Date: Tue, 24 Jul 2007 18:46:06 +0100 (BST)
>
>> Looking into the issue a bit further, it turns out the the Sparc32 memset
>> is broaken - it does not always set the last byte. As a result, the
>> Control Field is set to random value (0xE0 in this case). This explains
>> all sorts of odd issues. Next step is to fix memset. I will try again once
>> I am sure memset is working.
>
> There was a memset() fix posted recently which I am merging soon.
>
> --------------------
>
> Subject: [PATCH 2.4.25] sparc32: fix bug in sparc optimized memset
> From:	"root" <root@task.sun.mcst.ru>
> To:	wli@holomorphy.com
> Cc:	sparclinux@vger.kernel.org
> Date:	Thu, 19 Jul 2007 20:07:22 +0400
> Sender:	"David S. Miller" <davem@vger.kernel.org>
> User-Agent: Mutt/1.5.15 (2007-04-06)
> Fake-Sender:	sparclinux-owner@vger.kernel.org
>
> Sparc optimized memset (arch/sparc/lib/memset.S) does not fill last byte of the memory area,
> if area size is less than 8 bytes and start address is not word (4-bytes) aligned,
> Recent Linux kernels have same memset.S and affected by this bug too.
>
> Here is code chunk where bug located:
> /* %o0 - memory address, %o1 - size, %g3 - value */
> 8:
>     add    %o0, 1, %o0
>    subcc    %o1, 1, %o1
>    bne,a    8b
>     stb %g3, [%o0 - 1]
>
> This code should write byte every loop iteration, but last time delay instruction stb is not
> executed because branch instruction sets "annul" bit.
>
> Patch replaces bne,a by bne instruction.
>
>
>
>
>
> Error can be reproduced by simple kernel module:
>
> #include <linux/module.h>
> #include <linux/config.h>
> #include <linux/kernel.h>
> #include <linux/errno.h>
> #include <string.h>
>
> static void do_memset(void **p, int size)
> {
>        memset(p, 0x00, size);
> }
>
> static int __init memset_test_init(void)
> {
>    char fooc[8];
>    int *fooi;
>    memset(fooc, 0xba, sizeof(fooc));
>
>    do_memset((void**)(fooc + 3), 1);
>
>    fooi = (int*) fooc;
>    printk("%08X %08X\n", fooi[0], fooi[1]);
>
>    return -1;
> }
>
> static void __exit memset_test_cleanup(void)
> {
>    return;
> }
>
> module_init(memset_test_init);
> module_exit(memset_test_cleanup);
>
> MODULE_LICENSE("GPL");
> EXPORT_NO_SYMBOLS;
>
>
>
>
>
> Signed-off-by: Alexander Shmelev <ashmelev@task.sun.mcst.ru>
> ---
> --- linux-2.4.25-orig/arch/sparc/lib/memset.S	2003-11-28 21:26:19.000000000 +0300
> +++ linux-2.4.25/arch/sparc/lib/memset.S	2007-07-19 18:56:05.000000000 +0400
> @@ -163,7 +163,7 @@
> 8:
> 	 add	%o0, 1, %o0
> 	subcc	%o1, 1, %o1
> -	bne,a	8b
> +	bne	8b
> 	 EX(stb	%g3, [%o0 - 1], add %o1, 1)
> 0:
> 	retl
>
