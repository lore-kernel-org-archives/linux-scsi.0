From: Grant Grundler <grundler@google.com>
Subject: Re: scsi traffic sniffing
Date: Tue, 1 Sep 2009 09:48:11 -0700
Message-ID: <da824cf30909010948p65d54d8cr744a4b1082f720c3@mail.gmail.com>
References: <48e952f40908312312w7765c2a1q3a4f022967735288@mail.gmail.com>
	 <48e952f40908312313u75e4d00cr3d934f1dbdd1cca9@mail.gmail.com>
	 <48e952f40908312313y372d5009mc0197dff49d3b778@mail.gmail.com>
	 <da824cf30909010906q677e59e8v17dbd3d54cd2614d@mail.gmail.com>
	 <48e952f40909010917n7590d364sc4a16317d5e7fb0a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:44528 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbZIAQsO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Sep 2009 12:48:14 -0400
Received: from zps19.corp.google.com (zps19.corp.google.com [172.25.146.19])
	by smtp-out.google.com with ESMTP id n81GmEod008913
	for <linux-scsi@vger.kernel.org>; Tue, 1 Sep 2009 17:48:15 +0100
Received: from pxi4 (pxi4.prod.google.com [10.243.27.4])
	by zps19.corp.google.com with ESMTP id n81GmCPt008494
	for <linux-scsi@vger.kernel.org>; Tue, 1 Sep 2009 09:48:12 -0700
Received: by pxi4 with SMTP id 4so116293pxi.21
        for <linux-scsi@vger.kernel.org>; Tue, 01 Sep 2009 09:48:12 -0700 (PDT)
In-Reply-To: <48e952f40909010917n7590d364sc4a16317d5e7fb0a@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jonathan Nell <crtrn13@gmail.com>
Cc: linux-scsi@vger.kernel.org

+linux-scsi

On Tue, Sep 1, 2009 at 9:17 AM, Jonathan Nell<crtrn13@gmail.com> wrote:
> 2009/9/1 Grant Grundler <grundler@google.com>:
>> The ideal tool is a protocol analyzer for whatever transport the SCS=
I
>> device is attached to.
>> Here's the slide deck from a talk I once gave at OLS outlining the H=
W
>> debug tools:
>> =C2=A0 =C2=A0http://iou.parisc-linux.org/ols_2001/slides/generated/
>>
>> (and "SCSI" in that slide deck often means Parallel SCSI transport.)
>>
>> Using the scsi_logging hooks described by Stefan Richter are often e=
nough
>> to understand where in the process something is failing.
>>
>> hth,
>> grant
>>
>
> Unfortunately I need a data dump as well so the scsi_logging hooks
> aren't going to do the job I believe.

IMHO, if a data dump is needed, a logic analyzer is probably the right =
tool.
Which transport is being used here?

=46olks might have suggestions on tools that are available. Often those=
 can
be rented for a few days/week at a time.


> My next though was to wrap the
> SG_IO ioctl call (i.e. trap it in the kernel) and have that dump the
> data from (struct sg_io_hdr).dxferp. (The ioctl sniffer would be
> useful anyway for other things).

The drawback here is it only tells you what data is being handed to
the interface card, not what data is sent to the device or how it is
sent exactly (framing, timing, etc).


> Having issues with doing the kernel trap in the newer kernel versions
> though (trying on 2.6.30). The syscall table is now read-only but for
> some reason my set_memory_rw() call is failing... Any ideas how to do
> this properly?

Nope, sorry. At least not offhand.

cheers,
grant

>
> Here are the relevant bits of code:
>
> unsigned long **find_sys_call_table(void)
> {
> =C2=A0 unsigned long **sctable;
> =C2=A0 unsigned long ptr;
>
> =C2=A0 sctable =3D NULL;
> =C2=A0 for (ptr =3D (unsigned long)&unlock_kernel;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ptr < (unsigned long)&loops_per_jiffy;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ptr +=3D sizeof(void *))
> =C2=A0 {
> =C2=A0 =C2=A0 =C2=A0unsigned long *p;
> =C2=A0 =C2=A0 =C2=A0p =3D (unsigned long *)ptr;
> =C2=A0 =C2=A0 =C2=A0if (p[__NR_close] =3D=3D (unsigned long) sys_clos=
e)
> =C2=A0 =C2=A0 =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 sctable =3D (unsigned long **)p;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 return &sctable[0];
> =C2=A0 =C2=A0 =C2=A0}
> =C2=A0 }
> =C2=A0 return NULL;
> }
>
> static int __init scsisniff_init_module(void)
> {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if ( (sys_call_table =3D find_sys_call_tab=
le()) ) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0real_ioctl =3D (int(*)(unsig=
ned int fd, unsigned int cmd,
> unsigned long arg))sys_call_table[__NR_ioctl];
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if ( set_memor=
y_rw( (unsigned
> long)sys_call_table[__NR_ioctl], 1 ) )
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0printk( "set_memory_rw: succeeded\n" );
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0else {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0printk( "set_memory_rw: failed!\n" );
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0return -1;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sys_call_table=
[__NR_ioctl] =3D (unsigned long)my_ioctl;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0 =C2=A0 =C2=A0 =C2=A0else {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -1;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0 =C2=A0 =C2=A0return 0;
> }
>
> This gives me a lovely OOPS:
>
> [ =C2=A0 71.143742] WARNING: at arch/x86/mm/pageattr.c:833
> change_page_attr_set_clr+0x1a0/0x400()
> [ =C2=A0 71.143745] Modules linked in: scsi_sniff(+) i915 binfmt_misc=
 drm
> i2c_algo_bit bridge stp bnep lp snd_hda_codec_analog snd_hda_intel
> snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm
> snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event
> snd_seq snd_timer snd_seq_device video snd psmouse tpm_infineon tpm
> ppdev soundcore serio_raw pcspkr intel_agp tpm_bios output heci(C)
> iTCO_wdt iTCO_vendor_support parport_pc parport snd_page_alloc floppy
> usbhid usb_storage e1000e
> [ =C2=A0 71.143768] Pid: 3378, comm: insmod Tainted: G =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 C
> 2.6.30.4custom-1.0 #6
> [ =C2=A0 71.143769] Call Trace:
> [ =C2=A0 71.143773] =C2=A0[<ffffffff802da6d5>] ? __vunmap+0xc5/0x110
> [ =C2=A0 71.143775] =C2=A0[<ffffffff80235200>] ? change_page_attr_set=
_clr+0x1a0/0x400
> [ =C2=A0 71.143778] =C2=A0[<ffffffff8024edf8>] warn_slowpath_common+0=
x78/0xd0
> [ =C2=A0 71.143780] =C2=A0[<ffffffff8024ee5f>] warn_slowpath_null+0xf=
/0x20
> [ =C2=A0 71.143783] =C2=A0[<ffffffff80235200>] change_page_attr_set_c=
lr+0x1a0/0x400
> [ =C2=A0 71.143785] =C2=A0[<ffffffffa0274050>] ? my_ioctl+0x0/0x120 [=
scsi_sniff]
> [ =C2=A0 71.143789] =C2=A0[<ffffffff802a6dcd>] ? marker_update_probe_=
range+0x1dd/0x2d0
> [ =C2=A0 71.143791] =C2=A0[<ffffffffa0277000>] ? scsisniff_init_modul=
e+0x0/0xf4
> [scsi_sniff]
> [ =C2=A0 71.143793] =C2=A0[<ffffffff80235b9a>] set_memory_rw+0x2a/0x3=
0
> [ =C2=A0 71.143796] =C2=A0[<ffffffff802ff000>] ? sys_fcntl+0x180/0x42=
0
> [ =C2=A0 71.143798] =C2=A0[<ffffffffa02770bb>] scsisniff_init_module+=
0xbb/0xf4
> [scsi_sniff]
> [ =C2=A0 71.143801] =C2=A0[<ffffffff8020a04c>] do_one_initcall+0x3c/0=
x180
> [ =C2=A0 71.143804] =C2=A0[<ffffffff8026b7f3>] ? __blocking_notifier_=
call_chain+0x63/0x80
> [ =C2=A0 71.143807] =C2=A0[<ffffffff8027dc0d>] sys_init_module+0xad/0=
x200
> [ =C2=A0 71.143810] =C2=A0[<ffffffff80210fc2>] system_call_fastpath+0=
x16/0x1b
> [ =C2=A0 71.143812] ---[ end trace 5b3efe312296b587 ]---
> [ =C2=A0 71.143958] set_memory_rw: failed!
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
