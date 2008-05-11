From: Thorsten Kranzkowski <dl8bcu@dl8bcu.de>
Subject: Build error: `.exit.text' referenced in section `.rodata'
Date: Sun, 11 May 2008 15:19:02 +0000
Message-ID: <20080511151902.GA733@ds20.borg.net>
Reply-To: dl8bcu@dl8bcu.de
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay2.mail.vrmd.de ([81.28.224.28]:40805 "EHLO
	relay2.mail.vrmd.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbYEKPls (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 11 May 2008 11:41:48 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rth@twiddle.net
Cc: ink@jurassic.park.msu.ru, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-alpha@vger.kernel.org


Hello,

compiling 2.6.26-rc1 (latest git) on an Alpha DS20 (ev6, everything built in,
gcc version 4.1.2) fails with the following link errors:

  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
`.exit.text' referenced in section `.rodata' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
`.exit.text' referenced in section `.rodata' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
`.exit.text' referenced in section `.rodata' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
`.exit.text' referenced in section `.rodata' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
`.exit.text' referenced in section `.rodata' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
`.exit.text' referenced in section `.rodata' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
`.exit.text' referenced in section `.rodata' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
`.exit.text' referenced in section `.rodata' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
`.exit.text' referenced in section `.rodata' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
`.exit.text' referenced in section `.rodata' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
`.exit.text' referenced in section `.rodata' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
`.exit.text' referenced in section `.rodata' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
`.exit.text' referenced in section `.rodata' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
`.exit.text' referenced in section `.rodata' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
`.exit.text' referenced in section `.rodata' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
`.exit.text' referenced in section `.rodata' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
make[1]: *** [.tmp_vmlinux1] Error 1
make: *** [sub-make] Error 2


The problem also exists in 2.6.25 and probably several previous versions. 
I didn't try to determine where it started, though.


Trying to find the root of this problem I tried this:

bash-3.00$ objdump -r --section=.rodata /usr/src/linux-2.6.26-rc1-ds20/drivers/built-in.o  |grep exit.text
0000000000015558 GPREL32           .exit.text+0x0000000000001084
000000000001555c GPREL32           .exit.text+0x0000000000001060
0000000000015560 GPREL32           .exit.text+0x0000000000001060
0000000000015564 GPREL32           .exit.text+0x0000000000001060
0000000000015568 GPREL32           .exit.text+0x0000000000001060
000000000001556c GPREL32           .exit.text+0x0000000000001060
0000000000015570 GPREL32           .exit.text+0x0000000000001060
0000000000015574 GPREL32           .exit.text+0x0000000000001060
0000000000015578 GPREL32           .exit.text+0x0000000000001068
000000000001557c GPREL32           .exit.text+0x0000000000001068
0000000000015580 GPREL32           .exit.text+0x0000000000001068
0000000000015584 GPREL32           .exit.text+0x0000000000001068
0000000000015588 GPREL32           .exit.text+0x0000000000001068
000000000001558c GPREL32           .exit.text+0x0000000000001068
0000000000015590 GPREL32           .exit.text+0x0000000000001068
0000000000015594 GPREL32           .exit.text+0x0000000000001068


bash-3.00$ objdump -t --section=.exit.text /usr/src/linux-2.6.26-rc1-ds20/drivers/built-in.o  

...
0000000000000e8c l     F .exit.text     000000000000010c 0x88 exit_st
0000000000000f98 l     F .exit.text     000000000000012c 0x88 exit_sd
00000000000010c4 l     F .exit.text     0000000000000054 0x88 exit_sr
0000000000001118 l     F .exit.text     00000000000000e0 0x88 exit_sg
00000000000011f8 l     F .exit.text     0000000000000080 0x88 exit_ch_module
0000000000001278 l     F .exit.text     0000000000000050 0x88 ses_exit
...


--> ok looks like exit_sd is the culprit, which is contained in sd.c


bash-3.00$ objdump -r --section=.rodata /usr/src/linux-2.6.26-rc1-ds20/drivers/scsi/sd.o 

...
0000000000000054 GPREL32           .text+0x000000000000316c
0000000000000058 GPREL32           .exit.text+0x00000000000000ec
000000000000005c GPREL32           .exit.text+0x00000000000000c8
0000000000000060 GPREL32           .exit.text+0x00000000000000c8
0000000000000064 GPREL32           .exit.text+0x00000000000000c8
0000000000000068 GPREL32           .exit.text+0x00000000000000c8
000000000000006c GPREL32           .exit.text+0x00000000000000c8
0000000000000070 GPREL32           .exit.text+0x00000000000000c8
0000000000000074 GPREL32           .exit.text+0x00000000000000c8
0000000000000078 GPREL32           .exit.text+0x00000000000000d0
000000000000007c GPREL32           .exit.text+0x00000000000000d0
0000000000000080 GPREL32           .exit.text+0x00000000000000d0
0000000000000084 GPREL32           .exit.text+0x00000000000000d0
0000000000000088 GPREL32           .exit.text+0x00000000000000d0
000000000000008c GPREL32           .exit.text+0x00000000000000d0
0000000000000090 GPREL32           .exit.text+0x00000000000000d0
0000000000000094 GPREL32           .exit.text+0x00000000000000d0
0000000000000098 GPREL32           .init.text+0x00000000000000a8
...


--> ok, sd.c seems to be right, now where are these symbols actually used?


objdump -r  /usr/src/linux-2.6.26-rc1-ds20/drivers/scsi/sd.o

RELOCATION RECORDS FOR [.exit.text]:
OFFSET           TYPE              VALUE
...
00000000000000b0 GPRELHIGH         .rodata+0x0000000000000058
00000000000000b4 GPRELLOW          .rodata+0x0000000000000058
...


--> so they are used from inside .exit.text which contains only one function (in sd.o):

objdump --disassemble -S  --section=.exit.text /usr/src/linux-2.6.26-rc1-ds20/drivers/scsi/sd.o

...
  94:   00 00 ba 27     ldah    gp,0(ra)
  98:   00 00 bd 23     lda     gp,0(gp)
  9c:   10 04 ff 47     clr     a0
  a0:   01 00 5f 20     lda     t1,1
  a4:   22 f6 41 48     zapnot  t1,0xf,t1
  a8:   a1 f7 41 40     cmpule  t1,0xf,t0
  ac:   0a 00 20 e4     beq     t0,d8 <exit_sd+0xd8>
  b0:   00 00 3d 24     ldah    t0,0(gp)
  b4:   00 00 21 20     lda     t0,0(t0)
  b8:   41 04 41 40     s4addq  t1,t0,t0
  bc:   00 00 21 a0     ldl     t0,0(t0)
  c0:   01 04 a1 43     addq    gp,t0,t0
  c4:   02 00 e1 6b     jmp     zero,(t0),d0 <exit_sd+0xd0>
  c8:   10 30 08 42     addl    a0,0x41,a0
  cc:   08 00 e0 c3     br      f0 <exit_sd+0xf0>
  d0:   10 30 0f 42     addl    a0,0x79,a0
  d4:   06 00 e0 c3     br      f0 <exit_sd+0xf0>
  d8:   81 00 00 00     bugchk
  dc:   25 01 00 00     call_pal        0x125
        ...
  e8:   ff ff ff c3     br      e8 <exit_sd+0xe8>
  ec:   08 00 1f 22     lda     a0,8
  f0:   00 00 7d a7     ldq     t12,0(gp)
  f4:   00 00 3d 26     ldah    a1,0(gp)
  f8:   01 00 29 21     lda     s0,1(s0)
  fc:   00 00 31 22     lda     a1,0(a1)
 100:   00 40 5b 6b     jsr     ra,(t12),104 <exit_sd+0x104>
...


I believe the problem is static int sd_major(int major_idx) being inlined
into exit_sd(). IIUC the switch statement therein uses sort of a jump table.
And the targets of this jump table can not be resolved because the section
they live in is just discarded.


applying this patch makes the problem go away:

Signed-off-by: Thorsten Kranzkowski <dl8bcu@dl8bcu.de>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 01cefbb..adf79ad 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1913,7 +1913,7 @@ err_out:
  *
  *	Note: this function unregisters this driver from the scsi mid-level.
  **/
-static void __exit exit_sd(void)
+static void exit_sd(void)
 {
 	int i;
 


compile and boot tested.

bye,
Thorsten

-- 
| Thorsten Kranzkowski        Internet: dl8bcu@dl8bcu.de                      |
| Mobile: ++49 170 1876134       Snail: Kiebitzstr. 14, 49324 Melle, Germany  |
| Ampr: dl8bcu@db0lj.#rpl.deu.eu, dl8bcu@marvin.dl8bcu.ampr.org [44.130.8.19] |
