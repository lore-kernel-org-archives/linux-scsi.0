From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH] qla2xxx: Fix NULL pointer crash due to active timer for
 ABTS
Date: Tue, 13 Feb 2018 20:07:17 +0000
Message-ID: <D5F291AA-462A-4B27-A1B6-3CD50FF42D44@cavium.com>
References: <20180212182814.4541-1-himanshu.madhani@cavium.com>
 <4a757a57-5d44-2e70-dbe3-3b969d5588fd@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0056.outbound.protection.outlook.com ([104.47.42.56]:30573
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S965574AbeBMUHT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Feb 2018 15:07:19 -0500
In-Reply-To: <4a757a57-5d44-2e70-dbe3-3b969d5588fd@huawei.com>
Content-Language: en-US
Content-ID: <89FB2618D9912745A1EFE2937B737F2B@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi John,=20

> On Feb 13, 2018, at 2:54 AM, John Garry <john.garry@huawei.com> wrote:
>=20
> On 12/02/2018 18:28, Himanshu Madhani wrote:
>> This patch fixes NULL pointer crash due to active timer running
>> for abort IOCB.
>>=20
>>> From crash dump analysis it was discoverd that get_next_timer_interrupt=
()
>> encountered a corrupted entry on the timer list.
>>=20
>> #9 [ffff95e1f6f0fd40] page_fault at ffffffff914fe8f8
>>    [exception RIP: get_next_timer_interrupt+440]
>>    RIP: ffffffff90ea3088  RSP: ffff95e1f6f0fdf0  RFLAGS: 00010013
>>    RAX: ffff95e1f6451028  RBX: 000218e2389e5f40  RCX: 00000001232ad600
>>    RDX: 0000000000000001  RSI: ffff95e1f6f0fdf0  RDI: 0000000001232ad6
>>    RBP: ffff95e1f6f0fe40   R8: ffff95e1f6451188   R9: 0000000000000001
>>    R10: 0000000000000016  R11: 0000000000000016  R12: 00000001232ad5f6
>>    R13: ffff95e1f6450000  R14: ffff95e1f6f0fdf8  R15: ffff95e1f6f0fe10
>>    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>>=20
>> Looking at the assembly of get_next_timer_interrupt(), address came
>> from %r8 (ffff95e1f6451188) which is pointing to list_head with single
>> entry at ffff95e5ff621178.
>>=20
>> 0xffffffff90ea307a <get_next_timer_interrupt+426>:      mov    (%r8),%rd=
x
>> 0xffffffff90ea307d <get_next_timer_interrupt+429>:      cmp    %r8,%rdx
>> 0xffffffff90ea3080 <get_next_timer_interrupt+432>:      je     0xfffffff=
f90ea30a7 <get_next_timer_interrupt+471>
>> 0xffffffff90ea3082 <get_next_timer_interrupt+434>:      nopw   0x0(%rax,=
%rax,1)
>> 0xffffffff90ea3088 <get_next_timer_interrupt+440>:      testb  $0x1,0x18=
(%rdx)
>>=20
>> crash> rd ffff95e1f6451188 10
>> ffff95e1f6451188:  ffff95e5ff621178 ffff95e5ff621178   x.b.....x.b.....
>> ffff95e1f6451198:  ffff95e1f6451198 ffff95e1f6451198   ..E.......E.....
>> ffff95e1f64511a8:  ffff95e1f64511a8 ffff95e1f64511a8   ..E.......E.....
>> ffff95e1f64511b8:  ffff95e77cf509a0 ffff95e77cf509a0   ...|.......|....
>> ffff95e1f64511c8:  ffff95e1f64511c8 ffff95e1f64511c8   ..E.......E.....
>>=20
>> crash> rd ffff95e5ff621178 10
>> ffff95e5ff621178:  0000000000000001 ffff95e15936aa00   ..........6Y....
>> ffff95e5ff621188:  0000000000000000 00000000ffffffff   ................
>> ffff95e5ff621198:  00000000000000a0 0000000000000010   ................
>> ffff95e5ff6211a8:  ffff95e5ff621198 000000000000000c   ..b.............
>> ffff95e5ff6211b8:  00000f5800000000 ffff95e751f8d720   ....X... ..Q....
>>=20
>> ffff95e5ff621178 belongs to freed mempool object at ffff95e5ff621080.
>>=20
>> CACHE            NAME                 OBJSIZE  ALLOCATED     TOTAL  SLAB=
S  SSIZE
>> ffff95dc7fd74d00 mnt_cache                384      19785     24948    59=
4    16k
>>   SLAB              MEMORY            NODE  TOTAL  ALLOCATED  FREE
>>   ffffdc5dabfd8800  ffff95e5ff620000     1     42         29    13
>>   FREE / [ALLOCATED]
>>    ffff95e5ff621080  (cpu 6 cache)
>>=20
>> Examining the contents of that memory reveals a pointer to a constant
>> string in the driver, "abort\0", which is set by qla24xx_async_abort_cmd=
().
>>=20
>> crash> rd ffffffffc059277c 20
>> ffffffffc059277c:  6e490074726f6261 0074707572726574   abort.Interrupt.
>> ffffffffc059278c:  00676e696c6c6f50 6920726576697244   Polling.Driver i
>> ffffffffc059279c:  646f6d207325206e 6974736554000a65   n %s mode..Testi
>> ffffffffc05927ac:  636976656420676e 786c252074612065   ng device at %lx
>> ffffffffc05927bc:  6b63656843000a2e 646f727020676e69   ...Checking prod
>> ffffffffc05927cc:  6f20444920746375 0a2e706968632066   uct ID of chip..
>> ffffffffc05927dc:  5120646e756f4600 204130303232414c   .Found QLA2200A
>> ffffffffc05927ec:  43000a2e70696843 20676e696b636568   Chip...Checking
>> ffffffffc05927fc:  65786f626c69616d 6c636e69000a2e73   mailboxes...incl
>> ffffffffc059280c:  756e696c2f656475 616d2d616d642f78   ude/linux/dma-ma
>>=20
>> crash> struct -ox srb_iocb
>> struct srb_iocb {
>>           union {
>>               struct {...} logio;
>>               struct {...} els_logo;
>>               struct {...} tmf;
>>               struct {...} fxiocb;
>>               struct {...} abt;
>>               struct ct_arg ctarg;
>>               struct {...} mbx;
>>               struct {...} nack;
>>    [0x0 ] } u;
>>    [0xb8] struct timer_list timer;
>>    [0x108] void (*timeout)(void *);
>> }
>> SIZE: 0x110
>>=20
>> crash> ! bc
>> ibase=3D16
>> obase=3D10
>> B8+40
>> F8
>>=20
>> The object is a srb_t, and at offset 0xf8 within that structure
>> (i.e. ffff95e5ff621080 + f8 -> ffff95e5ff621178) is a struct timer_list.
>>=20
>> Cc: <stable@vger.stable.com> #4.4+
>> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
>> ---
>> Hi Martin,
>>=20
>> This patch addresses crash due to NULL pointer access because driver
>> left active timer running for abort IOCB.
>>=20
>> Please apply this patch to 4.16/scsi-fixes at your earliest convenience.
>>=20
>> Thanks,
>> Himanshu
>> ---
>> drivers/scsi/qla2xxx/qla_init.c | 1 +
>> 1 file changed, 1 insertion(+)
>>=20
>> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_=
init.c
>> index 2dea1129d396..04870621e712 100644
>> --- a/drivers/scsi/qla2xxx/qla_init.c
>> +++ b/drivers/scsi/qla2xxx/qla_init.c
>> @@ -1527,6 +1527,7 @@ qla24xx_abort_sp_done(void *ptr, int res)
>> 	srb_t *sp =3D ptr;
>> 	struct srb_iocb *abt =3D &sp->u.iocb_cmd;
>>=20
>> +	del_timer(&sp->u.iocb_cmd.timer);
>=20
> Hi,
>=20
> I am not familiar with this code. But I note that this abort seems to be =
"asynchronous" (I see it's setup in qla24xx_async_abort_cmd()), so do you n=
eed the "sync" variant of del_timer() for safety? This would be to ensure t=
he timeout has not actually occurred and is racing with the "done" callback=
?
>=20

You do have a point here. I need to investigate your suggestion and see if =
we need to go with =93sync=94 variant. I=92ll update you shortly.

> Thanks,
> John
>=20
>> 	complete(&abt->u.abt.comp);
>> }
>>=20
>>=20
>=20
>=20

Thanks,
- Himanshu
