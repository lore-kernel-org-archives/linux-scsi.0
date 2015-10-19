From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: linux kernel security issuses  at ses_enclosure_data_process ,
 ses_intf_remove_enclosure, irlmp_seq_hb_idx report
Date: Mon, 19 Oct 2015 13:15:29 +0300
Message-ID: <20151019101528.GV7289@mwanda>
References: <----An------QYmAn$4202951b-482d-4d92-98c2-3466de737b40@alibaba-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19237 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbbJSKP7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Oct 2015 06:15:59 -0400
Content-Disposition: inline
In-Reply-To: <----An------QYmAn$4202951b-482d-4d92-98c2-3466de737b40@alibaba-inc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?utf-8?B?56iL5ZCbKOaIkOa3vCk=?= <chengmiao.cj@alibaba-inc.com>
Cc: security <security@kernel.org>, throber3 <throber3@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org

Thanks Berry,

James, the first two issues are SCSI things.  I'm sending patches for
them but I can't test them myself.  Especially, I'm not positive that
[patch 2/2] ses: invalid free in ses_intf_remove_enclosure() is a
complete fix.  Berry, would it be possible to test that one?

regards,
dan carpenter

On Mon, Oct 19, 2015 at 01:05:48PM +0800, =E7=A8=8B=E5=90=9B(=E6=88=90=E6=
=B7=BC) wrote:
>=20
> Deal all:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0we=C2=A0find=C2=A0=
there=C2=A0security=C2=A0issuses=C2=A0in=C2=A0kernel=C2=A04.2=EF=BC=8Ca=
slo=C2=A0check=C2=A0the=C2=A0lastest=C2=A0code=EF=BC=8Cplease=C2=A0chec=
k=C2=A0them=E3=80=82
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A01.=C2=A0ses_enclosure_data_process=C2=A0=
=C2=A0heap=C2=A0access=C2=A0overflow
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0code=EF=BC=9A=C2=A0=C2=A0=C2=A0
> =C2=A0static=C2=A0void=C2=A0ses_enclosure_data_process(struct=C2=A0en=
closure_device=C2=A0*edev,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0struct=C2=A0scsi_device=C2=A0*sdev,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0int=C2=A0create)
> =C2=A0{
> =C2=A0=C2=A0u32=C2=A0result;
> =C2=A0=C2=A0unsigned=C2=A0char=C2=A0*buf=C2=A0=3D=C2=A0NULL,=C2=A0*ty=
pe_ptr,=C2=A0*desc_ptr,=C2=A0*addl_desc_ptr=C2=A0=3D=C2=A0NULL;
> =C2=A0=C2=A0int=C2=A0i,=C2=A0j,=C2=A0page7_len,=C2=A0len,=C2=A0compon=
ents;
> =C2=A0=C2=A0struct=C2=A0ses_device=C2=A0*ses_dev=C2=A0=3D=C2=A0edev->=
scratch;
> =C2=A0=C2=A0int=C2=A0types=C2=A0=3D=C2=A0ses_dev->page1_num_types;
> =C2=A0=C2=A0unsigned=C2=A0char=C2=A0*hdr_buf=C2=A0=3D=C2=A0kzalloc(IN=
IT_ALLOC_SIZE,=C2=A0GFP_KERNEL);
>=20
> =C2=A0=C2=A0if=C2=A0(!hdr_buf)
> =C2=A0=C2=A0=C2=A0goto=C2=A0simple_populate;
>=20
> =C2=A0=C2=A0/*=C2=A0re-read=C2=A0page=C2=A010=C2=A0*/
> =C2=A0=C2=A0if=C2=A0(ses_dev->page10)
> =C2=A0=C2=A0=C2=A0ses_recv_diag(sdev,=C2=A010,=C2=A0ses_dev->page10,=C2=
=A0ses_dev->page10_len);
> =C2=A0=C2=A0/*=C2=A0Page=C2=A07=C2=A0for=C2=A0the=C2=A0descriptors=C2=
=A0is=C2=A0optional=C2=A0*/
> =C2=A0=C2=A0result=C2=A0=3D=C2=A0ses_recv_diag(sdev,=C2=A07,=C2=A0hdr=
_buf,=C2=A0INIT_ALLOC_SIZE);
> =C2=A0=C2=A0if=C2=A0(result)
> =C2=A0=C2=A0=C2=A0goto=C2=A0simple_populate;
>=20
> =C2=A0=C2=A0page7_len=C2=A0=3D=C2=A0len=C2=A0=3D=C2=A0(hdr_buf[2]=C2=A0=
<<=C2=A08)=C2=A0+=C2=A0hdr_buf[3]=C2=A0+=C2=A04;
> =C2=A0=C2=A0/*=C2=A0add=C2=A01=C2=A0for=C2=A0trailing=C2=A0'\0'=C2=A0=
we'll=C2=A0use=C2=A0*/
> =C2=A0=C2=A0buf=C2=A0=3D=C2=A0kzalloc(len=C2=A0+=C2=A01,=C2=A0GFP_KER=
NEL);
> =C2=A0=C2=A0if=C2=A0(!buf)
> =C2=A0=C2=A0=C2=A0goto=C2=A0simple_populate;
> =C2=A0=C2=A0result=C2=A0=3D=C2=A0ses_recv_diag(sdev,=C2=A07,=C2=A0buf=
,=C2=A0len);
> =C2=A0=C2=A0if=C2=A0(result)=C2=A0{
> =C2=A0=C2=A0simple_populate:
> =C2=A0=C2=A0=C2=A0kfree(buf);
> =C2=A0=C2=A0=C2=A0buf=C2=A0=3D=C2=A0NULL;
> =C2=A0=C2=A0=C2=A0desc_ptr=C2=A0=3D=C2=A0NULL;
> =C2=A0=C2=A0=C2=A0len=C2=A0=3D=C2=A00;
> =C2=A0=C2=A0=C2=A0page7_len=C2=A0=3D=C2=A00;
> =C2=A0=C2=A0}=C2=A0else=C2=A0{
> =C2=A0=C2=A0=C2=A0desc_ptr=C2=A0=3D=C2=A0buf=C2=A0+=C2=A08; =C2=A0 =C2=
=A0// if =C2=A0buf len =3D=3D 4, heap access overflow
> =C2=A0=C2=A0=C2=A0len=C2=A0=3D=C2=A0(desc_ptr[2]=C2=A0<<=C2=A08)=C2=A0=
+=C2=A0desc_ptr[3];
> =C2=A0=C2=A0=C2=A0/*=C2=A0skip=C2=A0past=C2=A0overall=C2=A0descriptor=
=C2=A0*/
> =C2=A0=C2=A0=C2=A0desc_ptr=C2=A0+=3D=C2=A0len=C2=A0+=C2=A04;
> =C2=A0=C2=A0}=C2=A0=C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0crash=C2=A0info:=C2=A0=C2=A0=C2=A0
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG:=C2=A0KASan:=C2=A0use=C2=A0after=C2=A0free=C2=A0in=C2=A0ses_enclo=
sure_data_process+0xe3a/0xe60=C2=A0[ses]=C2=A0at=C2=A0addr=C2=A0ffff880=
0ab03897b
> Read=C2=A0of=C2=A0size=C2=A01=C2=A0by=C2=A0task=C2=A0systemd-udevd/25=
80
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> BUG=C2=A0kmalloc-8=C2=A0(Tainted:=C2=A0G=C2=A0=C2=A0=C2=A0=C2=A0B=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0):=C2=A0kasan:=C2=
=A0bad=C2=A0access=C2=A0detected
> ---------------------------------------------------------------------=
--------
>=20
> INFO:=C2=A0Slab=C2=A00xffffea0002ac0e00=C2=A0objects=3D512=C2=A0used=3D=
488=C2=A0fp=3D0xffff8800ab038f80=C2=A0flags=3D0x1ffff0000000080
> INFO:=C2=A0Object=C2=A00xffff8800ab038978=C2=A0@offset=3D2424=C2=A0fp=
=3D0xffff8800ab038990
>=20
> Bytes=C2=A0b4=C2=A0ffff8800ab038968:=C2=A069=C2=A064=C2=A000=C2=A0ab=C2=
=A000=C2=A088=C2=A0ff=C2=A0ff=C2=A008=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0id..............
> Object=C2=A0ffff8800ab038978:=C2=A090=C2=A089=C2=A003=C2=A0ab=C2=A000=
=C2=A088=C2=A0ff=C2=A0ff=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0........
> CPU:=C2=A00=C2=A0PID:=C2=A02580=C2=A0Comm:=C2=A0systemd-udevd=C2=A0Ta=
inted:=C2=A0G=C2=A0=C2=A0=C2=A0=C2=A0B=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A04.2.3=C2=A0#2
> Hardware=C2=A0name:=C2=A0VMware,=C2=A0Inc.=C2=A0VMware=C2=A0Virtual=C2=
=A0Platform/440BX=C2=A0Desktop=C2=A0Reference=C2=A0Platform,=C2=A0BIOS=C2=
=A06.00=C2=A005/20/2014
> =C2=A0ffff8800ab038000=C2=A0ffff88009bcaf678=C2=A0ffffffff8280e5b9=C2=
=A00000000000000008
> =C2=A0ffff880118c07e00=C2=A0ffff88009bcaf6a8=C2=A0ffffffff8151a739=C2=
=A0ffff880118c07e00
> =C2=A0ffffea0002ac0e00=C2=A0ffff8800ab038978=C2=A00000000000000000=C2=
=A0ffff88009bcaf6d8
> Call=C2=A0Trace:
> =C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0>]=C2=A0__dump_stack=C2=A0lib/dump_stack.c:15
> =C2=A0[<ffffffff8280e5b9>]=C2=A0dump_stack+0x45/0x57=C2=A0lib/dump_st=
ack.c:50
> =C2=A0[<ffffffff8151a739>]=C2=A0print_trailer+0xf9/0x150=C2=A0mm/slub=
=2Ec:650
> =C2=A0[<ffffffff8151f8e8>]=C2=A0object_err+0x38/0x50=C2=A0mm/slub.c:6=
57
> =C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0>]=C2=A0print_address_description=C2=A0mm/kasan/report.c:120
> =C2=A0[<ffffffff81522288>]=C2=A0kasan_report_error+0x1e8/0x3f0=C2=A0m=
m/kasan/report.c:193
> =C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0>]=C2=A0kasan_report=C2=A0mm/kasan/report.c:230
> =C2=A0[<ffffffff815224d3>]=C2=A0__asan_report_load1_noabort+0x43/0x50=
=C2=A0mm/kasan/report.c:248
> =C2=A0[<ffffffff81ee8be0>]=C2=A0?=C2=A0device_private_init+0x190/0x19=
0=C2=A0drivers/base/core.c:947
> =C2=A0[<ffffffffc0ec33ca>]=C2=A0?=C2=A0ses_enclosure_data_process+0xe=
3a/0xe60=C2=A0[ses]=C2=A0drivers/scsi/ses.c:493
> =C2=A0[<ffffffffc0ec33ca>]=C2=A0ses_enclosure_data_process+0xe3a/0xe6=
0=C2=A0[ses]=C2=A0drivers/scsi/ses.c:493
> =C2=A0[<ffffffff8281ab34>]=C2=A0?=C2=A0mutex_lock+0x14/0x60=C2=A0kern=
el/locking/mutex.c:97
> =C2=A0[<ffffffffc0ec41ee>]=C2=A0ses_intf_add+0x9ae/0xded=C2=A0[ses]=C2=
=A0drivers/scsi/ses.c:712
> =C2=A0[<ffffffff81b04100>]=C2=A0?=C2=A0bust_spinlocks+0xa0/0xa0=C2=A0=
??:?
> =C2=A0[<ffffffff81ef50fe>]=C2=A0class_interface_register+0x21e/0x370=C2=
=A0drivers/base/class.c:458
> =C2=A0[<ffffffff81ef4ee0>]=C2=A0?=C2=A0class_dev_iter_exit+0x10/0x10=C2=
=A0drivers/base/class.c:344
> =C2=A0[<ffffffff81b041f0>]=C2=A0?=C2=A0kvasprintf+0xf0/0xf0=C2=A0lib/=
kasprintf.c:31
> =C2=A0[<ffffffffc0ea8000>]=C2=A0?=C2=A00xffffffffc0ea8000
> =C2=A0[<ffffffff81ffcf5c>]=C2=A0scsi_register_interface+0x3c/0x50=C2=A0=
drivers/scsi/scsi_sysfs.c:1191
> =C2=A0[<ffffffffc0ea8013>]=C2=A0ses_init+0x13/0x1000=C2=A0[ses]
> =C2=A0[<ffffffff810021b1>]=C2=A0do_one_initcall+0x141/0x2f0=C2=A0init=
/main.c:794
> =C2=A0[<ffffffff81002070>]=C2=A0?=C2=A0try_to_run_init_process+0x40/0=
x40=C2=A0init/main.c:924
> =C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0>]=C2=A0?=C2=A0kasan_poison_shadow=C2=A0mm/kasan/kasan.c:49
> =C2=A0[<ffffffff81521976>]=C2=A0?=C2=A0kasan_unpoison_shadow+0x36/0x5=
0=C2=A0mm/kasan/kasan.c:54
> =C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0>]=C2=A0?=C2=A0kasan_poison_shadow=C2=A0mm/kasan/kasan.c:49
> =C2=A0[<ffffffff81521976>]=C2=A0?=C2=A0kasan_unpoison_shadow+0x36/0x5=
0=C2=A0mm/kasan/kasan.c:54
> =C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0>]=C2=A0?=C2=A0kasan_poison_shadow=C2=A0mm/kasan/kasan.c:49
> =C2=A0[<ffffffff81521976>]=C2=A0?=C2=A0kasan_unpoison_shadow+0x36/0x5=
0=C2=A0mm/kasan/kasan.c:54
> =C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0>]=C2=A0?=C2=A0register_global=C2=A0mm/kasan/kasan.c:49
> =C2=A0[<ffffffff81521a87>]=C2=A0?=C2=A0__asan_register_globals+0x87/0=
xa0=C2=A0mm/kasan/kasan.c:462
> =C2=A0[<ffffffff8280bf94>]=C2=A0do_init_module+0x1d0/0x5a8=C2=A0kerne=
l/module.c:3231
> =C2=A0[<ffffffff812c84f8>]=C2=A0load_module+0x6c48/0x9570=C2=A0kernel=
/module.c:3535
> =C2=A0[<ffffffff812bce00>]=C2=A0?=C2=A0__symbol_put+0x90/0x90=C2=A0ke=
rnel/module.c:1051
> =C2=A0[<ffffffff812c18b0>]=C2=A0?=C2=A0module_frob_arch_sections+0x20=
/0x20=C2=A0kernel/module.c:3141
> =C2=A0[<ffffffff81575990>]=C2=A0?=C2=A0open_exec+0x50/0x50=C2=A0fs/ex=
ec.c:808
> =C2=A0[<ffffffff812bd505>]=C2=A0?=C2=A0copy_module_from_fd.isra.49+0x=
1b5/0x2c0=C2=A0kernel/module.c:2721
> =C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0>]=C2=A0SYSC_finit_module=C2=A0kernel/module.c:3618
> =C2=A0[<ffffffff812cb0f8>]=C2=A0SyS_finit_module+0x108/0x130=C2=A0ker=
nel/module.c:3599
> =C2=A0[<ffffffff812caff0>]=C2=A0?=C2=A0SyS_init_module+0x1d0/0x1d0=C2=
=A0kernel/module.c:3579
> =C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0>]=C2=A0?=C2=A0trace_sys_exit=C2=A0include/trace/events/syscalls.h:4=
2
> =C2=A0[<ffffffff8105b4f6>]=C2=A0?=C2=A0syscall_trace_leave+0x246/0x2d=
0=C2=A0arch/x86/kernel/ptrace.c:1620
> =C2=A0[<ffffffff8281f59d>]=C2=A0tracesys_phase2+0x88/0x8d=C2=A0arch/x=
86/entry/entry_64.S:265
> Memory=C2=A0state=C2=A0around=C2=A0the=C2=A0buggy=C2=A0address:
> =C2=A0ffff8800ab038800:=C2=A0fb=C2=A0fb=C2=A0fb=C2=A0fb=C2=A0fb=C2=A0=
fb=C2=A0fb=C2=A000=C2=A000=C2=A0fb=C2=A0fb=C2=A000=C2=A0fb=C2=A0fb=C2=A0=
fb=C2=A0fb
> =C2=A0ffff8800ab038880:=C2=A0fb=C2=A0fb=C2=A0fb=C2=A002=C2=A002=C2=A0=
02=C2=A002=C2=A0fb=C2=A002=C2=A002=C2=A002=C2=A002=C2=A0fb=C2=A000=C2=A0=
fb=C2=A000
> >ffff8800ab038900:=C2=A000=C2=A0fb=C2=A000=C2=A0fb=C2=A0fb=C2=A000=C2=
=A0fb=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A005=C2=
=A0fb
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0^
> =C2=A0ffff8800ab038980:=C2=A0fb=C2=A0fb=C2=A0fb=C2=A0fb=C2=A0fb=C2=A0=
fb=C2=A0fb=C2=A0fb=C2=A0fb=C2=A000=C2=A0fb=C2=A000=C2=A000=C2=A0fb=C2=A0=
00=C2=A0fb
> =C2=A0ffff8800ab038a00:=C2=A0fb=C2=A0fb=C2=A000=C2=A000=C2=A000=C2=A0=
00=C2=A0fb=C2=A0fb=C2=A0fb=C2=A0fb=C2=A0fb=C2=A0fb=C2=A0fb=C2=A0fb=C2=A0=
fb=C2=A0fb=C2=A0 =C2=A0the=C2=A0same=C2=A0issuse=C2=A0may=C2=A0be=C2=A0=
exsit=C2=A0in=C2=A0ses_intf_add=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0
> =C2=A0result=C2=A0=3D=C2=A0ses_recv_diag(sdev,=C2=A01,=C2=A0hdr_buf,=C2=
=A0INIT_ALLOC_SIZE);
> =C2=A0if=C2=A0(result)
> =C2=A0=C2=A0goto=C2=A0recv_failed;
>=20
> =C2=A0len=C2=A0=3D=C2=A0(hdr_buf[2]=C2=A0<<=C2=A08)=C2=A0+=C2=A0hdr_b=
uf[3]=C2=A0+=C2=A04;
> =C2=A0buf=C2=A0=3D=C2=A0kzalloc(len,=C2=A0GFP_KERNEL);
> =C2=A0if=C2=A0(!buf)
> =C2=A0=C2=A0goto=C2=A0err_free;
>=20
> =C2=A0result=C2=A0=3D=C2=A0ses_recv_diag(sdev,=C2=A01,=C2=A0buf,=C2=A0=
len);
> =C2=A0if=C2=A0(result)
> =C2=A0=C2=A0goto=C2=A0recv_failed;
>=20
> =C2=A0types=C2=A0=3D=C2=A00;
>=20
> =C2=A0/*=C2=A0we=C2=A0always=C2=A0have=C2=A0one=C2=A0main=C2=A0enclos=
ure=C2=A0and=C2=A0the=C2=A0rest=C2=A0are=C2=A0referred
> =C2=A0=C2=A0*=C2=A0to=C2=A0as=C2=A0secondary=C2=A0subenclosures=C2=A0=
*/
> =C2=A0num_enclosures=C2=A0=3D=C2=A0buf[1]=C2=A0+=C2=A01;
>=20
> =C2=A0/*=C2=A0begin=C2=A0at=C2=A0the=C2=A0enclosure=C2=A0descriptor=C2=
=A0*/
> =C2=A0type_ptr=C2=A0=3D=C2=A0buf=C2=A0+=C2=A08;=C2=A0=C2=A0=C2=A0//=C2=
=A0// if =C2=A0len =3D=3D 4, heap access overflow
>=20
> =C2=A0=C2=A0=C2=A0=C2=A02.=C2=A0out=C2=A0of=C2=A0bounds=C2=A0access=C2=
=A0in=C2=A0ses_intf_remove_enclosure=C2=A0
>=20
> =C2=A0783=C2=A0static=C2=A0void=C2=A0ses_intf_remove(struct=C2=A0devi=
ce=C2=A0*cdev,
> =C2=A0784=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct=C2=A0class_interface=C2=
=A0*intf)
> =C2=A0785=C2=A0{
> =C2=A0786=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct=
=C2=A0scsi_device=C2=A0*sdev=C2=A0=3D=C2=A0to_scsi_device(cdev->parent)=
;
> =C2=A0787=C2=A0
> =C2=A0788=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if=C2=A0=
(!scsi_device_enclosure(sdev))
> =C2=A0789=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ses_intf_remove_component(sde=
v);
> =C2=A0790=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0else
> =C2=A0791=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ses_intf_remove_enclosure(sde=
v);=C2=A0=C2=A0=C2=A0//=C2=A0this=C2=A0branch
> =C2=A0792=C2=A0}
>=20
> =C2=A0759=C2=A0static=C2=A0void=C2=A0ses_intf_remove_enclosure(struct=
=C2=A0scsi_device=C2=A0*sdev)
> =C2=A0760=C2=A0{
> =C2=A0761=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct=
=C2=A0enclosure_device=C2=A0*edev;
> =C2=A0762=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct=
=C2=A0ses_device=C2=A0*ses_dev;
> =C2=A0763=C2=A0
> =C2=A0764=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/*=C2=A0=
=C2=A0exact=C2=A0match=C2=A0to=C2=A0this=C2=A0enclosure=C2=A0*/
> =C2=A0765=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0edev=C2=
=A0=3D=C2=A0enclosure_find(&sdev->sdev_gendev,=C2=A0NULL);
> =C2=A0766=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if=C2=A0=
(!edev)
> =C2=A0767=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return;
> =C2=A0768=C2=A0
> =C2=A0769=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ses_de=
v=C2=A0=3D=C2=A0edev->scratch;
> =C2=A0770=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0edev->=
scratch=C2=A0=3D=C2=A0NULL;
> =C2=A0771=C2=A0
> =C2=A0772=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kfree(=
ses_dev->page10);
> =C2=A0773=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kfree(=
ses_dev->page1);
> =C2=A0774=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kfree(=
ses_dev->page2);
> =C2=A0775=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kfree(=
ses_dev);
> =C2=A0776=C2=A0
> =C2=A0777=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kfree(=
edev->component[0].scratch);=C2=A0=C2=A0//=C2=A0bad=C2=A0
> =C2=A0778=C2=A0
> =C2=A0779=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0put_de=
vice(&edev->edev);
> =C2=A0780=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0enclos=
ure_unregister(edev);
> =C2=A0781=C2=A0}
>=20
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0crash=C2=A0info=EF=BC=9A
>=20
> =C2=A0=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =C2=A0BUG:=C2=A0KASan:=C2=A0out=C2=A0of=C2=A0bounds=C2=A0access=C2=A0=
in=C2=A0ses_intf_remove+0x25d/0x270=C2=A0[ses]=C2=A0at=C2=A0addr=C2=A0f=
fff88006545b6e8
> =C2=A0Read=C2=A0of=C2=A0size=C2=A08=C2=A0by=C2=A0task=C2=A0pool/17977
> =C2=A0=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> =C2=A0BUG=C2=A0kmalloc-1024=C2=A0(Tainted:=C2=A0G=C2=A0=C2=A0=C2=A0=C2=
=A0B=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0):=C2=A0=
kasan:=C2=A0bad=C2=A0access=C2=A0detected
> =C2=A0---------------------------------------------------------------=
--------------
>=20
> =C2=A0INFO:=C2=A0Slab=C2=A00xffffea0001951600=C2=A0objects=3D32=C2=A0=
used=3D13=C2=A0fp=3D0xffff88006545f400=C2=A0flags=3D0x1ffff0000004080
> =C2=A0INFO:=C2=A0Object=C2=A00xffff88006545b400=C2=A0@offset=3D13312=C2=
=A0fp=3D0x=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(=
null)
>=20
> =C2=A0Bytes=C2=A0b4=C2=A0ffff88006545b3f0:=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b400:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A060=C2=A0c4=C2=A0e4=C2=A0c0=C2=A0ff=C2=
=A0ff=C2=A0ff=C2=A0ff=C2=A0=C2=A0........`.......
> =C2=A0Object=C2=A0ffff88006545b410:=C2=A060=C2=A0c4=C2=A0e4=C2=A0c0=C2=
=A0ff=C2=A0ff=C2=A0ff=C2=A0ff=C2=A068=C2=A029=C2=A09a=C2=A0a4=C2=A000=C2=
=A088=C2=A0ff=C2=A0ff=C2=A0=C2=A0`.......h)......
> =C2=A0Object=C2=A0ffff88006545b420:=C2=A040=C2=A054=C2=A019=C2=A02c=C2=
=A000=C2=A088=C2=A0ff=C2=A0ff=C2=A030=C2=A0ea=C2=A0d0=C2=A0a4=C2=A000=C2=
=A088=C2=A0ff=C2=A0ff=C2=A0=C2=A0@T.,....0.......
> =C2=A0Object=C2=A0ffff88006545b430:=C2=A0c0=C2=A024=C2=A006=C2=A085=C2=
=A000=C2=A088=C2=A0ff=C2=A0ff=C2=A040=C2=A02c=C2=A09a=C2=A0a4=C2=A000=C2=
=A088=C2=A0ff=C2=A0ff=C2=A0=C2=A0.$......@,......
> =C2=A0Object=C2=A0ffff88006545b440:=C2=A0e0=C2=A021=C2=A0f0=C2=A0b4=C2=
=A000=C2=A088=C2=A0ff=C2=A0ff=C2=A080=C2=A0f7=C2=A0ec=C2=A017=C2=A001=C2=
=A088=C2=A0ff=C2=A0ff=C2=A0=C2=A0.!..............
> =C2=A0Object=C2=A0ffff88006545b450:=C2=A080=C2=A0fd=C2=A04d=C2=A083=C2=
=A0ff=C2=A0ff=C2=A0ff=C2=A0ff=C2=A030=C2=A08c=C2=A06d=C2=A057=C2=A000=C2=
=A088=C2=A0ff=C2=A0ff=C2=A0=C2=A0..M.....0.mW....
> =C2=A0Object=C2=A0ffff88006545b460:=C2=A004=C2=A000=C2=A000=C2=A000=C2=
=A007=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b470:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A001=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b480:=C2=A080=C2=A0b4=C2=A045=C2=A065=C2=
=A000=C2=A088=C2=A0ff=C2=A0ff=C2=A080=C2=A0b4=C2=A045=C2=A065=C2=A000=C2=
=A088=C2=A0ff=C2=A0ff=C2=A0=C2=A0..Ee......Ee....
> =C2=A0Object=C2=A0ffff88006545b490:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b4a0:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b4b0:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b4c0:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A080=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b4d0:=C2=A060=C2=A025=C2=A006=C2=A085=C2=
=A000=C2=A088=C2=A0ff=C2=A0ff=C2=A0e0=C2=A02c=C2=A09a=C2=A0a4=C2=A000=C2=
=A088=C2=A0ff=C2=A0ff=C2=A0=C2=A0`%.......,......
> =C2=A0Object=C2=A0ffff88006545b4e0:=C2=A0ff=C2=A0ff=C2=A0ff=C2=A07f=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b4f0:=C2=A0f0=C2=A0b4=C2=A045=C2=A065=C2=
=A000=C2=A088=C2=A0ff=C2=A0ff=C2=A0f0=C2=A0b4=C2=A045=C2=A065=C2=A000=C2=
=A088=C2=A0ff=C2=A0ff=C2=A0=C2=A0..Ee......Ee....
> =C2=A0Object=C2=A0ffff88006545b500:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b510:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b520:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A090=C2=A0c8=C2=A0f0=C2=A081=C2=A0ff=C2=
=A0ff=C2=A0ff=C2=A0ff=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b530:=C2=A018=C2=A0b4=C2=A045=C2=A065=C2=
=A000=C2=A088=C2=A0ff=C2=A0ff=C2=A000=C2=A000=C2=A000=C2=A000=C2=A0ff=C2=
=A0ff=C2=A0ff=C2=A0ff=C2=A0=C2=A0..Ee............
> =C2=A0Object=C2=A0ffff88006545b540:=C2=A0ff=C2=A0ff=C2=A0ff=C2=A0ff=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b550:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b560:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A0e0=C2=A0ff=C2=A0ff=C2=A0ff=C2=A00f=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b570:=C2=A070=C2=A0b5=C2=A045=C2=A065=C2=
=A000=C2=A088=C2=A0ff=C2=A0ff=C2=A070=C2=A0b5=C2=A045=C2=A065=C2=A000=C2=
=A088=C2=A0ff=C2=A0ff=C2=A0=C2=A0p.Ee....p.Ee....
> =C2=A0Object=C2=A0ffff88006545b580:=C2=A0b0=C2=A0d8=C2=A0f0=C2=A081=C2=
=A0ff=C2=A0ff=C2=A0ff=C2=A0ff=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b590:=C2=A090=C2=A0b5=C2=A045=C2=A065=C2=
=A000=C2=A088=C2=A0ff=C2=A0ff=C2=A090=C2=A0b5=C2=A045=C2=A065=C2=A000=C2=
=A088=C2=A0ff=C2=A0ff=C2=A0=C2=A0..Ee......Ee....
> =C2=A0Object=C2=A0ffff88006545b5a0:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b5b0:=C2=A081=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A002=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b5c0:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b5d0:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b5e0:=C2=A083=C2=A0c2=C2=A0ff=C2=A0ff=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b5f0:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b600:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b610:=C2=A0ff=C2=A0ff=C2=A0ff=C2=A0ff=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b620:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b630:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A038=C2=A0b6=C2=A045=C2=A065=C2=A000=C2=
=A088=C2=A0ff=C2=A0ff=C2=A0=C2=A0........8.Ee....
> =C2=A0Object=C2=A0ffff88006545b640:=C2=A038=C2=A0b6=C2=A045=C2=A065=C2=
=A000=C2=A088=C2=A0ff=C2=A0ff=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A08.Ee............
> =C2=A0Object=C2=A0ffff88006545b650:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b660:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b670:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b680:=C2=A080=C2=A0b6=C2=A045=C2=A065=C2=
=A000=C2=A088=C2=A0ff=C2=A0ff=C2=A080=C2=A0b6=C2=A045=C2=A065=C2=A000=C2=
=A088=C2=A0ff=C2=A0ff=C2=A0=C2=A0..Ee......Ee....
> =C2=A0Object=C2=A0ffff88006545b690:=C2=A0a8=C2=A02e=C2=A028=C2=A05c=C2=
=A000=C2=A088=C2=A0ff=C2=A0ff=C2=A0b0=C2=A02e=C2=A028=C2=A05c=C2=A000=C2=
=A088=C2=A0ff=C2=A0ff=C2=A0=C2=A0..(\......(\....
> =C2=A0Object=C2=A0ffff88006545b6a0:=C2=A0b0=C2=A02e=C2=A028=C2=A05c=C2=
=A000=C2=A088=C2=A0ff=C2=A0ff=C2=A001=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0..(\............
> =C2=A0Object=C2=A0ffff88006545b6b0:=C2=A060=C2=A0c3=C2=A0e4=C2=A0c0=C2=
=A0ff=C2=A0ff=C2=A0ff=C2=A0ff=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0`...............
> =C2=A0Object=C2=A0ffff88006545b6c0:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b6d0:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A020=C2=A061=C2=A0ec=C2=A0c0=C2=A0ff=C2=
=A0ff=C2=A0ff=C2=A0ff=C2=A0=C2=A0........=C2=A0a......
> =C2=A0Object=C2=A0ffff88006545b6e0:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b6f0:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b700:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b710:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b720:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b730:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b740:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b750:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b760:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b770:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b780:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b790:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b7a0:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b7b0:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b7c0:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b7d0:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b7e0:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0Object=C2=A0ffff88006545b7f0:=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=
=A000=C2=A000=C2=A000=C2=A0=C2=A0................
> =C2=A0CPU:=C2=A03=C2=A0PID:=C2=A017977=C2=A0Comm:=C2=A0pool=C2=A0Tain=
ted:=C2=A0G=C2=A0=C2=A0=C2=A0=C2=A0B=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A04.2.3=C2=A0#2
> =C2=A0Hardware=C2=A0name:=C2=A0VMware,=C2=A0Inc.=C2=A0VMware=C2=A0Vir=
tual=C2=A0Platform/440BX=C2=A0Desktop=C2=A0Reference=C2=A0Platform,=C2=A0=
BIOS=C2=A06.00=C2=A005/20/2014
> =C2=A0=C2=A0ffff880065458000=C2=A0ffff8800a50674b8=C2=A0ffffffff8280e=
5b9=C2=A00000000000000400
> =C2=A0=C2=A0ffff880118c07500=C2=A0ffff8800a50674e8=C2=A0ffffffff8151a=
739=C2=A0ffff880118c07500
> =C2=A0=C2=A0ffffea0001951600=C2=A0ffff88006545b400=C2=A0ffffffffc0ec6=
0c0=C2=A0ffff8800a5067518
> =C2=A0Call=C2=A0Trace:
> =C2=A0=C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0>]=C2=A0__dump_stack=C2=A0lib/dump_stack.c:15
> =C2=A0=C2=A0[<ffffffff8280e5b9>]=C2=A0dump_stack+0x45/0x57=C2=A0lib/d=
ump_stack.c:50
> =C2=A0=C2=A0[<ffffffff8151a739>]=C2=A0print_trailer+0xf9/0x150=C2=A0m=
m/slub.c:650
> =C2=A0=C2=A0[<ffffffff8151f8e8>]=C2=A0object_err+0x38/0x50=C2=A0mm/sl=
ub.c:657
> =C2=A0=C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0>]=C2=A0print_address_description=C2=A0mm/kasan/report.c:120
> =C2=A0=C2=A0[<ffffffff81522288>]=C2=A0kasan_report_error+0x1e8/0x3f0=C2=
=A0mm/kasan/report.c:193
> =C2=A0=C2=A0[<ffffffff82025dec>]=C2=A0?=C2=A0sg_device_destroy+0xec/0=
x190=C2=A0drivers/scsi/sg.c:1551
> =C2=A0=C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0>]=C2=A0kasan_report=C2=A0mm/kasan/report.c:230
> =C2=A0=C2=A0[<ffffffff815225c3>]=C2=A0__asan_report_load8_noabort+0x4=
3/0x50=C2=A0mm/kasan/report.c:251
> =C2=A0=C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0>]=C2=A0?=C2=A0ses_intf_remove_enclosure=C2=A0drivers/scsi/ses=
=2Ec:777
> =C2=A0=C2=A0[<ffffffffc0ec02ed>]=C2=A0?=C2=A0ses_intf_remove+0x25d/0x=
270=C2=A0[ses]=C2=A0drivers/scsi/ses.c:791
> =C2=A0=C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0>]=C2=A0ses_intf_remove_enclosure=C2=A0drivers/scsi/ses.c:777
> =C2=A0=C2=A0[<ffffffffc0ec02ed>]=C2=A0ses_intf_remove+0x25d/0x270=C2=A0=
[ses]=C2=A0drivers/scsi/ses.c:791
> =C2=A0=C2=A0[<ffffffff81ee5f5a>]=C2=A0device_del+0x2ba/0x6b0=C2=A0dri=
vers/base/core.c:1210
> =C2=A0=C2=A0[<ffffffff81ee5ca0>]=C2=A0?=C2=A0cleanup_device_parent+0x=
f0/0xf0=C2=A0drivers/base/core.c:793
> =C2=A0=C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0>]=C2=A0?=C2=A0kobject_cleanup=C2=A0lib/kobject.c:635
> =C2=A0=C2=A0[<ffffffff81ad6239>]=C2=A0?=C2=A0kobject_release+0x139/0x=
3a0=C2=A0lib/kobject.c:658
> =C2=A0=C2=A0[<ffffffff81ee6372>]=C2=A0device_unregister+0x22/0xb0=C2=A0=
drivers/base/core.c:1250
> =C2=A0=C2=A0[<ffffffff81ffdf6a>]=C2=A0__scsi_remove_device+0x1aa/0x21=
0=C2=A0drivers/scsi/scsi_sysfs.c:1075
> =C2=A0=C2=A0[<ffffffff81ffa16f>]=C2=A0scsi_forget_host+0x10f/0x1c0=C2=
=A0drivers/scsi/scsi_scan.c:1862
> =C2=A0=C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0>]=C2=A0?=C2=A0spin_unlock_irqrestore=C2=A0include/linux/spinl=
ock.h:372
> =C2=A0=C2=A0[<ffffffff81f0ca15>]=C2=A0?=C2=A0__pm_runtime_resume+0x85=
/0xa0=C2=A0drivers/base/power/runtime.c:962
> =C2=A0=C2=A0[<ffffffff81fd2635>]=C2=A0scsi_remove_host+0xd5/0x210=C2=A0=
drivers/scsi/hosts.c:173
> =C2=A0=C2=A0[<ffffffffc0e7cbe1>]=C2=A0usb_stor_disconnect+0xe1/0x200=C2=
=A0[usb_storage]
> =C2=A0=C2=A0[<ffffffff82134d81>]=C2=A0usb_unbind_interface+0x161/0x83=
0=C2=A0drivers/usb/core/driver.c:411
> =C2=A0=C2=A0[<ffffffff81f09929>]=C2=A0?=C2=A0rpm_idle+0x29/0x5b0=C2=A0=
drivers/base/power/runtime.c:305
> =C2=A0=C2=A0[<ffffffff81ef149a>]=C2=A0__device_release_driver+0x17a/0=
x3c0=C2=A0drivers/base/dd.c:662
> =C2=A0=C2=A0[<ffffffff81eee180>]=C2=A0?=C2=A0unbind_store+0x270/0x270=
=C2=A0drivers/base/bus.c:189
> =C2=A0=C2=A0[<ffffffff81ef1703>]=C2=A0device_release_driver+0x23/0x30=
=C2=A0drivers/base/dd.c:693
> =C2=A0=C2=A0[<ffffffff81eefce4>]=C2=A0bus_remove_device+0x2d4/0x590=C2=
=A0drivers/base/bus.c:601
> =C2=A0=C2=A0[<ffffffff81ee6026>]=C2=A0device_del+0x386/0x6b0=C2=A0dri=
vers/base/core.c:1217
> =C2=A0=C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0>]=C2=A0?=C2=A0kref_sub=C2=A0include/linux/kref.h:74
> =C2=A0=C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0>]=C2=A0?=C2=A0kref_put=C2=A0include/linux/kref.h:99
> =C2=A0=C2=A0[<ffffffff81ad5e66>]=C2=A0?=C2=A0kobject_put+0x56/0xa0=C2=
=A0lib/kobject.c:675
> =C2=A0=C2=A0[<ffffffff81ee5ca0>]=C2=A0?=C2=A0cleanup_device_parent+0x=
f0/0xf0=C2=A0drivers/base/core.c:793
> =C2=A0=C2=A0[<ffffffff82140f9c>]=C2=A0?=C2=A0usb_remove_ep_devs+0x3c/=
0x80=C2=A0drivers/usb/core/endpoint.c:214
> =C2=A0=C2=A0[<ffffffff8212bcaa>]=C2=A0?=C2=A0remove_intf_ep_devs+0xfa=
/0x1a0=C2=A0drivers/usb/core/message.c:1047
> =C2=A0=C2=A0[<ffffffff8212d2e5>]=C2=A0usb_disable_device+0x1d5/0x6e0=C2=
=A0drivers/usb/core/message.c:1172
> =C2=A0=C2=A0[<ffffffff816c6fc0>]=C2=A0?=C2=A0sysfs_kf_bin_read+0x2d0/=
0x2d0=C2=A0fs/sysfs/file.c:86
> =C2=A0=C2=A0[<ffffffff8212eee6>]=C2=A0usb_set_configuration+0x236/0x1=
600=C2=A0drivers/usb/core/message.c:1766
> =C2=A0=C2=A0[<ffffffff8144b840>]=C2=A0?=C2=A0__alloc_pages_direct_com=
pact+0x280/0x280=C2=A0include/linux/mm.h:881
> =C2=A0=C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0>]=C2=A0?=C2=A0perf_event_mmap_event=C2=A0kernel/events/core.c=
:5923
> =C2=A0=C2=A0[<ffffffff81415da0>]=C2=A0?=C2=A0perf_event_mmap+0x510/0x=
9d0=C2=A0kernel/events/core.c:5957
> =C2=A0=C2=A0[<ffffffff816c6fc0>]=C2=A0?=C2=A0sysfs_kf_bin_read+0x2d0/=
0x2d0=C2=A0fs/sysfs/file.c:86
> =C2=A0=C2=A0[<ffffffff8213ef55>]=C2=A0remove_store+0x75/0x90=C2=A0dri=
vers/usb/core/sysfs.c:669
> =C2=A0=C2=A0[<ffffffff81ee3fa0>]=C2=A0?=C2=A0component_add+0x350/0x35=
0=C2=A0??:?
> =C2=A0=C2=A0[<ffffffff81ee3fdc>]=C2=A0dev_attr_store+0x3c/0x70=C2=A0d=
rivers/base/core.c:137
> =C2=A0=C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0>]=C2=A0?=C2=A0kasan_poison_shadow=C2=A0mm/kasan/kasan.c:49
> =C2=A0=C2=A0[<ffffffff815219ee>]=C2=A0?=C2=A0kasan_kmalloc+0x5e/0x70=C2=
=A0mm/kasan/kasan.c:353
> =C2=A0=C2=A0[<ffffffff816c70f1>]=C2=A0sysfs_kf_write+0x131/0x200=C2=A0=
fs/sysfs/file.c:131
> =C2=A0=C2=A0[<ffffffff816c4bed>]=C2=A0kernfs_fop_write+0x1fd/0x3a0=C2=
=A0fs/kernfs/file.c:312
> =C2=A0=C2=A0[<ffffffff815651e0>]=C2=A0__vfs_write+0xe0/0x3e0=C2=A0fs/=
read_write.c:489
> =C2=A0=C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0>]=C2=A0?=C2=A0set_pte_at=C2=A0./arch/x86/include/asm/paravirt=
=2Eh:524
> =C2=A0=C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0>]=C2=A0?=C2=A0do_anonymous_page=C2=A0mm/memory.c:2721
> =C2=A0=C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0>]=C2=A0?=C2=A0handle_pte_fault=C2=A0mm/memory.c:3258
> =C2=A0=C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0>]=C2=A0?=C2=A0__handle_mm_fault=C2=A0mm/memory.c:3379
> =C2=A0=C2=A0[<ffffffff814b654a>]=C2=A0?=C2=A0handle_mm_fault+0x160a/0=
x3470=C2=A0mm/memory.c:3408
> =C2=A0=C2=A0[<ffffffff81565100>]=C2=A0?=C2=A0__vfs_read+0x3d0/0x3d0=C2=
=A0fs/read_write.c:419
> =C2=A0=C2=A0[<ffffffff819b5470>]=C2=A0?=C2=A0common_perm+0x160/0x160=C2=
=A0security/apparmor/lsm.c:159
> =C2=A0=C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0>]=C2=A0?=C2=A0percpu_counter_add=C2=A0include/linux/percpu_co=
unter.h:53
> =C2=A0=C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0>]=C2=A0?=C2=A0percpu_counter_inc=C2=A0include/linux/percpu_co=
unter.h:177
> =C2=A0=C2=A0[<ffffffff8156d3bb>]=C2=A0?=C2=A0__sb_start_write+0xfb/0x=
2a0=C2=A0fs/super.c:1204
> =C2=A0=C2=A0[<ffffffff814b4f40>]=C2=A0?=C2=A0copy_page_range+0x12b0/0=
x12b0=C2=A0mm/memory.c:1024
> =C2=A0=C2=A0[<ffffffff8156d2c0>]=C2=A0?=C2=A0__sb_end_write+0xc0/0xc0=
=C2=A0include/linux/list.h:189
> =C2=A0=C2=A0[<ffffffff819b6c18>]=C2=A0?=C2=A0apparmor_file_permission=
+0x18/0x20=C2=A0security/apparmor/lsm.c:446
> =C2=A0=C2=A0[<ffffffff818fb8bf>]=C2=A0?=C2=A0security_file_permission=
+0x6f/0x1b0=C2=A0security/security.c:738
> =C2=A0=C2=A0[<ffffffff815665fc>]=C2=A0?=C2=A0rw_verify_area+0xbc/0x29=
0=C2=A0fs/read_write.c:404
> =C2=A0=C2=A0[<ffffffff81566be9>]=C2=A0vfs_write+0x139/0x4c0=C2=A0fs/r=
ead_write.c:538
> =C2=A0=C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0>]=C2=A0SYSC_write=C2=A0fs/read_write.c:585
> =C2=A0=C2=A0[<ffffffff815699fe>]=C2=A0SyS_write+0x10e/0x230=C2=A0fs/r=
ead_write.c:577
> =C2=A0=C2=A0[<ffffffff815698f0>]=C2=A0?=C2=A0SyS_read+0x230/0x230=C2=A0=
fs/read_write.c:559
> =C2=A0=C2=A0[<ffffffff8110dc1f>]=C2=A0?=C2=A0do_page_fault+0x2f/0x80=C2=
=A0arch/x86/mm/fault.c:1298
> =C2=A0=C2=A0[<ffffffff8281f472>]=C2=A0entry_SYSCALL_64_fastpath+0x16/=
0x75=C2=A0arch/x86/entry/entry_64.S:186
> =C2=A0Memory=C2=A0state=C2=A0around=C2=A0the=C2=A0buggy=C2=A0address:
> =C2=A0=C2=A0ffff88006545b580:=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=
=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A00=
0=C2=A000=C2=A000
> =C2=A0=C2=A0ffff88006545b600:=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=
=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A00=
0=C2=A000=C2=A000
> =C2=A0>ffff88006545b680:=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A0=
00=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A0fc=C2=A0=
fc=C2=A0fc
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0^
> =C2=A0=C2=A0ffff88006545b700:=C2=A0fc=C2=A0fc=C2=A0fc=C2=A0fc=C2=A0fc=
=C2=A0fc=C2=A0fc=C2=A0fc=C2=A0fc=C2=A0fc=C2=A0fc=C2=A0fc=C2=A0fc=C2=A0f=
c=C2=A0fc=C2=A0fc
> =C2=A0=C2=A0ffff88006545b780:=C2=A0fc=C2=A0fc=C2=A0fc=C2=A0fc=C2=A0fc=
=C2=A0fc=C2=A0fc=C2=A0fc=C2=A0fc=C2=A0fc=C2=A0fc=C2=A0fc=C2=A0fc=C2=A0f=
c=C2=A0fc=C2=A0fc
>=20
> =C2=A0=C2=A0=C2=A0=C2=A03.=C2=A0=C2=A0out=C2=A0of=C2=A0bounds=C2=A0on=
=C2=A0stack=C2=A0in=C2=A0irlmp_seq_hb_idx
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0irlmp_seq_start->=C2=A0v=C2=A0=3D=C2=A0=
irlmp_seq_hb_idx(iter,=C2=A0&off);->irlmp_seq_hb_idx
> =C2=A0static=C2=A0void=C2=A0*irlmp_seq_start(struct=C2=A0seq_file=C2=A0=
*seq,=C2=A0loff_t=C2=A0*pos)
> =C2=A0{
> =C2=A0=C2=A0struct=C2=A0irlmp_iter_state=C2=A0*iter=C2=A0=3D=C2=A0seq=
->private;
> =C2=A0=C2=A0void=C2=A0*v;
> =C2=A0=C2=A0loff_t=C2=A0off=C2=A0=3D=C2=A0*pos;
>=20
> =C2=A0=C2=A0iter->hashbin=C2=A0=3D=C2=A0NULL;
> =C2=A0=C2=A0if=C2=A0(off--=C2=A0=3D=3D=C2=A00)
> =C2=A0=C2=A0=C2=A0return=C2=A0LSAP_START_TOKEN;
>=20
> =C2=A0=C2=A0iter->hashbin=C2=A0=3D=C2=A0irlmp->unconnected_lsaps;
> =C2=A0=C2=A0v=C2=A0=3D=C2=A0irlmp_seq_hb_idx(iter,=C2=A0&off);=C2=A0=C2=
=A0=C2=A0//=C2=A0local=C2=A0var=C2=A0stack=C2=A0address
> =C2=A0=C2=A0if=C2=A0(v)
> =C2=A0=C2=A0=C2=A0return=C2=A0v;
>=20
> =C2=A0=C2=A0if=C2=A0(off--=C2=A0=3D=3D=C2=A00)
> =C2=A0=C2=A0=C2=A0return=C2=A0LINK_START_TOKEN;
>=20
> =C2=A0=C2=A0iter->hashbin=C2=A0=3D=C2=A0irlmp->links;
> =C2=A0=C2=A0return=C2=A0irlmp_seq_hb_idx(iter,=C2=A0&off);
> =C2=A0}
>=20
> =C2=A0static=C2=A0void=C2=A0*irlmp_seq_hb_idx(struct=C2=A0irlmp_iter_=
state=C2=A0*iter,=C2=A0loff_t=C2=A0*off)
> =C2=A0{
> =C2=A0=C2=A0void=C2=A0*element;
>=20
> =C2=A0=C2=A0spin_lock_irq(&iter->hashbin->hb_spinlock);
> =C2=A0=C2=A0for=C2=A0(element=C2=A0=3D=C2=A0hashbin_get_first(iter->h=
ashbin);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0element=C2=A0!=3D=C2=A0NULL=
;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0element=C2=A0=3D=C2=A0hashb=
in_get_next(iter->hashbin))=C2=A0{
> =C2=A0=C2=A0=C2=A0if=C2=A0(!off=C2=A0||=C2=A0*off--=C2=A0=3D=3D=C2=A0=
0)=C2=A0{=C2=A0=C2=A0// =C2=A0out of on stack
> =C2=A0=C2=A0=C2=A0=C2=A0/*=C2=A0NB:=C2=A0hashbin=C2=A0left=C2=A0locke=
d=C2=A0*/
> =C2=A0=C2=A0=C2=A0=C2=A0return=C2=A0element;
> =C2=A0=C2=A0=C2=A0}
> =C2=A0=C2=A0}
> =C2=A0=C2=A0spin_unlock_irq(&iter->hashbin->hb_spinlock);
> =C2=A0=C2=A0iter->hashbin=C2=A0=3D=C2=A0NULL;
> =C2=A0=C2=A0return=C2=A0NULL;
> =C2=A0}
>=20
> =C2=A0carsh=C2=A0info:
>=20
> =C2=A0BUG:=C2=A0KASan:=C2=A0out=C2=A0of=C2=A0bounds=C2=A0on=C2=A0stac=
k=C2=A0in=C2=A0irlmp_seq_hb_idx+0x16c/0x1a0=C2=A0[irda]=C2=A0at=C2=A0ad=
dr=C2=A0ffff880022c4f248
> =C2=A0Read=C2=A0of=C2=A0size=C2=A08=C2=A0by=C2=A0task=C2=A0trinity-c6=
/19325
> =C2=A0page:ffffea00008b13c0=C2=A0count:0=C2=A0mapcount:0=C2=A0mapping=
:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(null)=C2=A0=
index:0x0
> =C2=A0flags:=C2=A00x1ffff0000000000()
> =C2=A0page=C2=A0dumped=C2=A0because:=C2=A0kasan:=C2=A0bad=C2=A0access=
=C2=A0detected
> =C2=A0CPU:=C2=A00=C2=A0PID:=C2=A019325=C2=A0Comm:=C2=A0trinity-c6=C2=A0=
Tainted:=C2=A0G=C2=A0=C2=A0=C2=A0=C2=A0B=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A04.2.3=C2=A0#2
> =C2=A0Hardware=C2=A0name:=C2=A0VMware,=C2=A0Inc.=C2=A0VMware=C2=A0Vir=
tual=C2=A0Platform/440BX=C2=A0Desktop=C2=A0Reference=C2=A0Platform,=C2=A0=
BIOS=C2=A06.00=C2=A005/20/2014
> =C2=A0=C2=A0ffff8801128089e0=C2=A0ffff880022c4f108=C2=A0ffffffff8280e=
5b9=C2=A01ffffd400011627f
> =C2=A0=C2=A0ffff880022c4f1a0=C2=A0ffff880022c4f188=C2=A0ffffffff81522=
458=C2=A00000000000000010
> =C2=A0=C2=A00000000000000000=C2=A00000000000000046=C2=A0ffffed0004589=
e4a=C2=A0666666208106f6c0
> =C2=A0Call=C2=A0Trace:
> =C2=A0=C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0>]=C2=A0__dump_stack=C2=A0lib/dump_stack.c:15
> =C2=A0=C2=A0[<ffffffff8280e5b9>]=C2=A0dump_stack+0x45/0x57=C2=A0lib/d=
ump_stack.c:50
> =C2=A0=C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0>]=C2=A0print_address_description=C2=A0mm/kasan/report.c:132
> =C2=A0=C2=A0[<ffffffff81522458>]=C2=A0kasan_report_error+0x3b8/0x3f0=C2=
=A0mm/kasan/report.c:193
> =C2=A0=C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0>]=C2=A0kasan_report=C2=A0mm/kasan/report.c:230
> =C2=A0=C2=A0[<ffffffff815225c3>]=C2=A0__asan_report_load8_noabort+0x4=
3/0x50=C2=A0mm/kasan/report.c:251
> =C2=A0=C2=A0[<ffffffffc0af6bac>]=C2=A0?=C2=A0irlmp_seq_hb_idx+0x16c/0=
x1a0=C2=A0[irda]=C2=A0net/irda/irlmp.c:1842
> =C2=A0=C2=A0[<ffffffffc0af6bac>]=C2=A0irlmp_seq_hb_idx+0x16c/0x1a0=C2=
=A0[irda]=C2=A0net/irda/irlmp.c:1842
> =C2=A0=C2=A0[<ffffffffc0af6fb7>]=C2=A0irlmp_seq_start+0x147/0x230=C2=A0=
[irda]=C2=A0net/irda/irlmp.c:1864
> =C2=A0=C2=A0[<ffffffffc0af6e70>]=C2=A0?=C2=A0irlmp_seq_next+0x290/0x2=
90=C2=A0[irda]=C2=A0net/irda/irlmp.c:1888
> =C2=A0=C2=A0[<ffffffff815cd4b0>]=C2=A0seq_read+0x280/0x1150=C2=A0fs/s=
eq_file.c:225
> =C2=A0=C2=A0[<ffffffff81521bb8>]=C2=A0?=C2=A0kasan_alloc_pages+0x38/0=
x40=C2=A0mm/kasan/kasan.c:292
> =C2=A0=C2=A0[<ffffffff815cd230>]=C2=A0?=C2=A0seq_lseek+0x370/0x370=C2=
=A0fs/seq_file.c:321
> =C2=A0=C2=A0[<ffffffff81621010>]=C2=A0?=C2=A0__fsnotify_inode_delete+=
0x10/0x10=C2=A0fs/notify/fsnotify.c:37
> =C2=A0=C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0>]=C2=A0?=C2=A0copy_from_user=C2=A0./arch/x86/include/asm/uacc=
ess.h:718
> =C2=A0=C2=A0[<ffffffff81569e60>]=C2=A0?=C2=A0rw_copy_check_uvector+0x=
80/0x270=C2=A0fs/read_write.c:733
> =C2=A0=C2=A0[<ffffffff816957d1>]=C2=A0proc_reg_read+0xc1/0x180=C2=A0f=
s/proc/inode.c:202
> =C2=A0=C2=A0[<ffffffff81b0b91d>]=C2=A0?=C2=A0import_iovec+0x9d/0x420=C2=
=A0lib/iov_iter.c:802
> =C2=A0=C2=A0[<ffffffff81565608>]=C2=A0do_loop_readv_writev+0x128/0x1e=
0=C2=A0fs/read_write.c:680
> =C2=A0=C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0>]=C2=A0?=C2=A0fsnotify_perm=C2=A0include/linux/fsnotify.h:60
> =C2=A0=C2=A0[<ffffffff818fb99d>]=C2=A0?=C2=A0security_file_permission=
+0x14d/0x1b0=C2=A0security/security.c:742
> =C2=A0=C2=A0[<ffffffff81695710>]=C2=A0?=C2=A0proc_reg_write+0x180/0x1=
80=C2=A0fs/proc/internal.h:82
> =C2=A0=C2=A0[<ffffffff81695710>]=C2=A0?=C2=A0proc_reg_write+0x180/0x1=
80=C2=A0fs/proc/internal.h:82
> =C2=A0=C2=A0[<ffffffff815674f0>]=C2=A0do_readv_writev+0x580/0x690=C2=A0=
fs/read_write.c:810
> =C2=A0=C2=A0[<ffffffff81566f70>]=C2=A0?=C2=A0vfs_write+0x4c0/0x4c0=C2=
=A0include/linux/sched.h:3096
> =C2=A0=C2=A0[<ffffffff817a448c>]=C2=A0?=C2=A0__ext4_handle_dirty_meta=
data+0x4c/0x5d0=C2=A0fs/ext4/ext4_jbd2.c:264
> =C2=A0=C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0>]=C2=A0?=C2=A0touch_buffer=C2=A0fs/buffer.c:64
> =C2=A0=C2=A0[<ffffffff81602f1a>]=C2=A0?=C2=A0__find_get_block+0x1ca/0=
x2a0=C2=A0fs/buffer.c:1375
> =C2=A0=C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0>]=C2=A0?=C2=A0brelse=C2=A0include/linux/buffer_head.h:287
> =C2=A0=C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0>]=C2=A0?=C2=A0ext4_do_update_inode=C2=A0fs/ext4/inode.c:4503
> =C2=A0=C2=A0[<ffffffff816f7b60>]=C2=A0?=C2=A0ext4_mark_iloc_dirty+0x1=
3c0/0x24d0=C2=A0fs/ext4/inode.c:4937
> =C2=A0=C2=A0[<ffffffff81567669>]=C2=A0vfs_readv+0x69/0xa0=C2=A0fs/rea=
d_write.c:834
> =C2=A0=C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0>]=C2=A0kernel_readv=C2=A0fs/splice.c:582
> =C2=A0=C2=A0[<ffffffff815f7010>]=C2=A0default_file_splice_read+0x470/=
0x8f0=C2=A0fs/splice.c:658
> =C2=A0=C2=A0[<ffffffff815f6ba0>]=C2=A0?=C2=A0generic_file_splice_read=
+0x1e0/0x1e0=C2=A0fs/splice.c:531
> =C2=A0=C2=A0[<ffffffff817f6220>]=C2=A0?=C2=A0jbd2_buffer_abort_trigge=
r+0x80/0x80=C2=A0fs/jbd2/transaction.c:1277
> =C2=A0=C2=A0[<ffffffff815f2140>]=C2=A0?=C2=A0page_cache_pipe_buf_rele=
ase+0x70/0x70=C2=A0fs/splice.c:91
> =C2=A0=C2=A0[<ffffffff815e9eb0>]=C2=A0?=C2=A0__mark_inode_dirty+0x440=
/0x9e0=C2=A0fs/fs-writeback.c:2015
> =C2=A0=C2=A0[<ffffffff816ffcd8>]=C2=A0?=C2=A0ext4_da_write_end+0x378/=
0x820=C2=A0fs/ext4/inode.c:2782
> =C2=A0=C2=A0[<ffffffff816fdd10>]=C2=A0?=C2=A0ext4_write_begin+0x980/0=
x980=C2=A0fs/ext4/ext4_jbd2.h:399
> =C2=A0=C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0>]=C2=A0?=C2=A0kasan_poison_shadow=C2=A0mm/kasan/kasan.c:49
> =C2=A0=C2=A0[<ffffffff815219ee>]=C2=A0?=C2=A0kasan_kmalloc+0x5e/0x70=C2=
=A0mm/kasan/kasan.c:353
> =C2=A0=C2=A0[<ffffffff81430cfc>]=C2=A0?=C2=A0generic_perform_write+0x=
31c/0x500=C2=A0mm/filemap.c:2527
> =C2=A0=C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0>]=C2=A0?=C2=A0spin_lock=C2=A0include/linux/spinlock.h:312
> =C2=A0=C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0>]=C2=A0?=C2=A0__fsnotify_d_instantiate=C2=A0include/linux/fsn=
otify_backend.h:289
> =C2=A0=C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0>]=C2=A0?=C2=A0fsnotify_d_instantiate=C2=A0include/linux/fsnot=
ify.h:25
> =C2=A0=C2=A0[<ffffffff815a8b4f>]=C2=A0?=C2=A0__d_instantiate+0x18f/0x=
390=C2=A0fs/dcache.c:1763
> =C2=A0=C2=A0[<ffffffff815665fc>]=C2=A0?=C2=A0rw_verify_area+0xbc/0x29=
0=C2=A0fs/read_write.c:404
> =C2=A0=C2=A0[<ffffffff815f4349>]=C2=A0do_splice_to+0xd9/0x120=C2=A0fs=
/splice.c:1142
> =C2=A0=C2=A0[<ffffffff815f45cd>]=C2=A0splice_direct_to_actor+0x23d/0x=
7b0=C2=A0fs/splice.c:1214
> =C2=A0=C2=A0[<ffffffff815f1af0>]=C2=A0?=C2=A0generic_pipe_buf_nosteal=
+0x10/0x10=C2=A0fs/splice.c:560
> =C2=A0=C2=A0[<ffffffff815f4390>]=C2=A0?=C2=A0do_splice_to+0x120/0x120=
=C2=A0fs/splice.c:1137
> =C2=A0=C2=A0[<ffffffff818fb8bf>]=C2=A0?=C2=A0security_file_permission=
+0x6f/0x1b0=C2=A0security/security.c:738
> =C2=A0=C2=A0[<ffffffff815665fc>]=C2=A0?=C2=A0rw_verify_area+0xbc/0x29=
0=C2=A0fs/read_write.c:404
> =C2=A0=C2=A0[<ffffffff81aed4cd>]=C2=A0?=C2=A0timerqueue_add+0x12d/0x2=
f0=C2=A0lib/timerqueue.c:57
> =C2=A0=C2=A0[<ffffffff815f4c99>]=C2=A0do_splice_direct+0x159/0x270=C2=
=A0fs/splice.c:1325
> =C2=A0=C2=A0[<ffffffff812824ab>]=C2=A0?=C2=A0enqueue_hrtimer+0xdb/0x1=
e0=C2=A0kernel/time/hrtimer.c:877
> =C2=A0=C2=A0[<ffffffff815f4b40>]=C2=A0?=C2=A0splice_direct_to_actor+0=
x7b0/0x7b0=C2=A0include/linux/fs.h:1920
> =C2=A0=C2=A0[<ffffffff815665fc>]=C2=A0?=C2=A0rw_verify_area+0xbc/0x29=
0=C2=A0fs/read_write.c:404
> =C2=A0=C2=A0[<ffffffff81568a61>]=C2=A0do_sendfile+0x5f1/0x1250=C2=A0f=
s/read_write.c:1227
> =C2=A0=C2=A0[<ffffffff81283f60>]=C2=A0?=C2=A0hrtimer_init+0x100/0x100=
=C2=A0include/trace/events/timer.h:134
> =C2=A0=C2=A0[<ffffffff81568470>]=C2=A0?=C2=A0__compat_sys_pwritev64+0=
xc0/0xc0=C2=A0fs/read_write.c:1128
> =C2=A0=C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0>]=C2=A0?=C2=A0hrtimer_start=C2=A0include/linux/hrtimer.h:370
> =C2=A0=C2=A0[<ffffffff812878f6>]=C2=A0?=C2=A0do_setitimer+0x4b6/0x610=
=C2=A0kernel/time/itimer.c:222
> =C2=A0=C2=A0[<=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0>]=C2=A0SYSC_sendfile64=C2=A0fs/read_write.c:1288
> =C2=A0=C2=A0[<ffffffff8156b031>]=C2=A0SyS_sendfile64+0xf1/0x100=C2=A0=
fs/read_write.c:1274
> =C2=A0=C2=A0[<ffffffff8156af40>]=C2=A0?=C2=A0SyS_sendfile+0xd0/0xd0=C2=
=A0fs/read_write.c:1271
> =C2=A0=C2=A0[<ffffffff8110dc1f>]=C2=A0?=C2=A0do_page_fault+0x2f/0x80=C2=
=A0arch/x86/mm/fault.c:1298
> =C2=A0=C2=A0[<ffffffff8281f472>]=C2=A0entry_SYSCALL_64_fastpath+0x16/=
0x75=C2=A0arch/x86/entry/entry_64.S:186
> =C2=A0Memory=C2=A0state=C2=A0around=C2=A0the=C2=A0buggy=C2=A0address:
> =C2=A0=C2=A0ffff880022c4f100:=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=
=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A00=
0=C2=A000=C2=A000
> =C2=A0=C2=A0ffff880022c4f180:=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=
=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A00=
0=C2=A000=C2=A000
> =C2=A0>ffff880022c4f200:=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A0=
00=C2=A000=C2=A0f1=C2=A0f1=C2=A0f1=C2=A0f1=C2=A000=C2=A0f4=C2=A0f4=C2=A0=
f4=C2=A0f3
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0^
> =C2=A0=C2=A0ffff880022c4f280:=C2=A0f3=C2=A0f3=C2=A0f3=C2=A000=C2=A000=
=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A00=
0=C2=A000=C2=A000
> =C2=A0=C2=A0ffff880022c4f300:=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=
=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A000=C2=A0f1=C2=A0f1=C2=A0f=
1=C2=A0f1=C2=A000
> =C2=A0=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =C2=A0=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Sorry for webmail format.=C2=A0Hope=C2=A0t=
o=C2=A0receive=C2=A0your=C2=A0reply=C2=A0as=C2=A0soon=C2=A0as=C2=A0poss=
ible.=C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0Best=C2=
=A0regards
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Berry=C2=A0Cheng=C2=A0@=C2=A0Alibaba=C2=A0=
mobile=C2=A0security=C2=A0Team
>=20
>=20
>=20
>=20


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
