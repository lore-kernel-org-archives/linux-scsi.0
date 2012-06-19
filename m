From: Paul Guo <ggang@tilera.com>
Subject: Re: [PATCH] Unaligned data access in mvsas causes panic
Date: Tue, 19 Jun 2012 10:05:13 +0800
Message-ID: <4FDFDE59.6020903@tilera.com>
References: <4FDF31E2.2090305@tilera.com> <3ADAB9761F3E4CF2A23696CB113ED1B4@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from usmamail.tilera.com ([12.216.194.151]:53933 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab2FSCFS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jun 2012 22:05:18 -0400
In-Reply-To: <3ADAB9761F3E4CF2A23696CB113ED1B4@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>
Cc: linux-scsi@vger.kernel.org, 'Xiangliang Yu' <yuxiangl@marvell.com>

Jack,

=46ollwing is the stack. We located the code line that causes unaligned=
 data access
according to the PC address in mvs_slot_complete(). After applying the
patch, the disk io stress testing run well. Actually reading the source=
 code,
I found that it seems that slot->response is not really surely 8-byte a=
ligned.
Considering the affected code line is rarely called, we can just simply=
 use
get_unaligned_*().

Thanks,
Paul

Pid: 0, comm:              swapper, CPU: 1
  r0 : 0xfffffe43f67e2c94 r1 : 0xfffffe43f86b2450 r2 : 0xfffffe43f86b24=
50
  r3 : 0xfffffe43f86b2440 r4 : 0x0000000000000000 r5 : 0x00000000000000=
00
  r6 : 0x0000000000000000 r7 : 0x0000000000000000 r8 : 0x00000000000000=
00
  r9 : 0x0000000000000000 r10: 0xfffffe43f86b2450 r11: 0xfffffe43f86b24=
48
  r12: 0xe000003780f29b84 r13: 0x1fffffc87f0d647c r14: 0x00000000000000=
01
  r15: 0x0000000000000080 r16: 0x0000000000000040 r17: 0x00000000000000=
02
  r18: 0x0000000000000001 r19: 0xfffffe43f86b2448 r20: 0x00000000000000=
01
  r21: 0x0000000000020000 r22: 0xfffffe43ffedfaa8 r23: 0x00000000000200=
00
  r24: 0xfffffe43ffedfab0 r25: 0xfffffe43ffedfaf0 r26: 0xfffffe43ffedfa=
b8
  r27: 0xfffffe03f8a64648 r28: 0x00000000000245f0 r29: 0x00000000000024=
5f
  r30: 0xfffffe43f86b2300 r31: 0xfffffe03f8a40000 r32: 0x00000000000000=
01
  r33: 0xfffffe03f8a42590 r34: 0x0000000000000001 r35: 0x00000000000300=
01
  r36: 0xfffffe43f86b2318 r37: 0xfffffe03f8a40058 r38: 0xfffffe03f8a646=
10
  r39: 0x0000000000000001 r40: 0x0000000000000000 r41: 0x00000000000000=
00
  r42: 0xfffffe0000a856f8 r43: 0xfffffe00009a78d8 r44: 0xfffffe00008e12=
98
  r45: 0xfffffe0000a70080 r46: 0x0000000000000001 r47: 0x00000000000000=
00
  r48: 0x0000000000000000 r49: 0x0000000000000000 r50: 0x00000000000000=
00
  r51: 0x0000000000000000 r52: 0xfffffe43ffedfc40 tp : 0x000001f4ff7300=
00 =20
  sp : 0xfffffe43ffedfa90 lr : 0xfffffff7002abec0 pc : 0xfffffff7002ac3=
70=20
  ex1: 1     faultnum: 17
Starting stack dump of tid 0, pid 0 (swapper) on cpu 1 at cycle 3414659=
78177
  frame 0: 0xfffffff7002ac370 mvs_slot_complete+0x5f0/0x12a0 (sp 0xffff=
fe43ffedfa90)
  frame 1: 0xfffffff7002abec0 mvs_slot_complete+0x140/0x12a0 (sp 0xffff=
fe43ffedfa90)
  frame 2: 0xfffffff7005cc840 mvs_int_rx+0x140/0x2a0 (sp 0xfffffe43ffed=
fb00)
  frame 3: 0xfffffff7005bbaf0 mvs_94xx_isr+0xd8/0x2b8 (sp 0xfffffe43ffe=
dfb68)
  frame 4: 0xfffffff700658ba0 mvs_tasklet+0x128/0x1f8 (sp 0xfffffe43ffe=
dfba8)
  frame 5: 0xfffffff7003e8230 tasklet_action+0x178/0x2c8 (sp 0xfffffe43=
ffedfbe0)
  frame 6: 0xfffffff700103850 __do_softirq+0x210/0x398 (sp 0xfffffe43ff=
edfc40)
  frame 7: 0xfffffff700180308 do_softirq+0xc8/0x140 (sp 0xfffffe43ffedf=
cd8)
  frame 8: 0xfffffff7000bd7f0 irq_exit+0xb0/0x158 (sp 0xfffffe43ffedfcf=
0)
  frame 9: 0xfffffff70013fa58 tile_dev_intr+0x1d8/0x2f0 (sp 0xfffffe43f=
fedfd00)
  frame 10: 0xfffffff70044ca78 handle_interrupt+0x270/0x278 (sp 0xfffff=
e43ffedfd40)
   <interrupt 30 while in kernel mode>
   frame 11: 0xfffffff700143e68 _cpu_idle_nap+0x0/0x18 (sp 0xfffffe43ff=
edffb0)
   frame 12: 0xfffffff700482480 cpu_idle+0x310/0x428 (sp 0xfffffe43ffed=
ffb0)
Stack dump complete Kernel panic - not syncing:=20
 Kernel unalign fault running the idle task!
 Starting stack dump of tid 0, pid 0 (swapper) on cpu 1 at cycle 341586=
172541
   frame 0: 0xfffffff700140ee0 dump_stack+0x0/0x20 (sp 0xfffffe43ffedf4=
20)
   frame 1: 0xfffffff700283270 panic+0x150/0x3a0 (sp 0xfffffe43ffedf420=
)
   frame 2: 0xfffffff70012bff8 jit_bundle_gen+0xfd8/0x27e0 (sp 0xfffffe=
43ffedf4c8)
   frame 3: 0xfffffff7003b5b68 do_unaligned+0xc0/0x5a0 (sp 0xfffffe43ff=
edf710)
   frame 4: 0xfffffff70044ca78 handle_interrupt+0x270/0x278 (sp 0xfffff=
e43ffedf840)
   <interrupt 17 while in kernel mode>
   frame 5: 0xfffffff7002ac370 mvs_slot_complete+0x5f0/0x12a0 (sp 0xfff=
ffe43ffedfa90)
   frame 6: 0xfffffff7002abec0 mvs_slot_complete+0x140/0x12a0 (sp 0xfff=
ffe43ffedfa90)
   frame 7: 0xfffffff7005cc840 mvs_int_rx+0x140/0x2a0 (sp 0xfffffe43ffe=
dfb00)
   frame 8: 0xfffffff7005bbaf0 mvs_94xx_isr+0xd8/0x2b8 (sp 0xfffffe43ff=
edfb68)
   frame 9: 0xfffffff700658ba0 mvs_tasklet+0x128/0x1f8 (sp 0xfffffe43ff=
edfba8)
   frame 10: 0xfffffff7003e8230 tasklet_action+0x178/0x2c8 (sp 0xfffffe=
43ffedfbe0)
   frame 11: 0xfffffff700103850 __do_softirq+0x210/0x398 (sp 0xfffffe43=
ffedfc40)
   frame 12: 0xfffffff700180308 do_softirq+0xc8/0x140 (sp 0xfffffe43ffe=
dfcd8)
   frame 13: 0xfffffff7000bd7f0 irq_exit+0xb0/0x158 (sp 0xfffffe43ffedf=
cf0)
   frame 14: 0xfffffff70013fa58 tile_dev_intr+0x1d8/0x2f0 (sp 0xfffffe4=
3ffedfd00)
   frame 15: 0xfffffff70044ca78 handle_interrupt+0x270/0x278 (sp 0xffff=
fe43ffedfd40)
   <interrupt 30 while in kernel mode>
   frame 16: 0xfffffff700143e68 _cpu_idle_nap+0x0/0x18 (sp 0xfffffe43ff=
edffb0)
   frame 17: 0xfffffff700482480 cpu_idle+0x310/0x428 (sp 0xfffffe43ffed=
ffb0)
Stack dump complete Client requested halt.


> Paul=A3=AC
>=20
> Could you also share the panic info?
>=20
> Thanks.
>=20
> Jack=20
>> We encountered panic during stress tesing on our platform,
>> due to unaligned data access in the mvsas driver.
>>
>>
>> Signed-off-by: Paul Guo <ggang@tilera.com>
>> ---
>>  drivers/scsi/mvsas/mv_sas.c |    5 +++--
>>  drivers/scsi/mvsas/mv_sas.h |    1 +
>>  2 files changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas=
=2Ec
>> index fd3b283..be4989e 100644
>> --- a/drivers/scsi/mvsas/mv_sas.c
>> +++ b/drivers/scsi/mvsas/mv_sas.c
>> @@ -1852,10 +1852,11 @@ int mvs_slot_complete(struct mvs_info *mvi, =
u32
>> rx_desc, u32 flags)
>>  	}
>>
>>  	/* error info record present */
>> -	if (unlikely((rx_desc & RXQ_ERR) && (*(u64 *) slot->response))) {
>> +	if (unlikely((rx_desc & RXQ_ERR) &&
>> +		     get_unaligned_le64((u64 *) slot->response))) {
>>  		mv_dprintk("port %d slot %d rx_desc %X has error info"
>>  			"%016llX.\n", slot->port->sas_port.id, slot_idx,
>> -			 rx_desc, (u64)(*(u64 *)slot->response));
>> +			 rx_desc, get_unaligned_le64((u64
> *)slot->response));
>>  		tstat->stat =3D mvs_slot_err(mvi, task, slot_idx);
>>  		tstat->resp =3D SAS_TASK_COMPLETE;
>>  		goto out;
>> diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas=
=2Eh
>> index c04a4f5..1bc093a 100644
>> --- a/drivers/scsi/mvsas/mv_sas.h
>> +++ b/drivers/scsi/mvsas/mv_sas.h
>> @@ -39,6 +39,7 @@
>>  #include <linux/irq.h>
>>  #include <linux/slab.h>
>>  #include <linux/vmalloc.h>
>> +#include <asm/unaligned.h>
>>  #include <scsi/libsas.h>
>>  #include <scsi/scsi.h>
>>  #include <scsi/scsi_tcq.h>
>> --
>> 1.7.10.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
