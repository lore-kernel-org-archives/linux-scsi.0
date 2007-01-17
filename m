From: Aboo Valappil <aboo@aboo.org>
Subject: Re: Linux Virtual SCSI HBAs and Virtual disks
Date: Wed, 17 Jan 2007 21:24:57 +1100
Message-ID: <45ADF979.7090003@aboo.org>
References: <45ACA765.3030701@aboo.org> <45AD80F3.6020100@torque.net> <45ADE01F.3020708@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ppp245-155.static.internode.on.net ([59.167.245.155]:41276 "EHLO
	goobu.aboo.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932268AbXAQK0L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jan 2007 05:26:11 -0500
In-Reply-To: <45ADE01F.3020708@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

Hi All,
=20
Thanks everyone to have a look at this.

I think i modified to have the latest kernel support. Unfortunately I=20
could not test it with 2.6.20 kernel due to some issues in my laptop an=
d=20
2.6.20 kernel. But it should work with 2.6.20 with this modification.

The modified version is available through=20
http://vscsihba.aboo.org/vscsihbav202.tgz.

1. I fixed the kmem_cache issue for sure.
2. I think i got around with INIT_WORK ... Made the following=20
modifications ...


Here is the change ...

[root@goobu kernel]# diff device.c ../../vscsihba2/kernel/device.c
4,8c4
<
< struct scsitap_work_t {
<       struct scsitap_session *session;
<       struct work_struct work;
< } scsitap_work;
---
 > struct work_struct scsitap_work;
230c226
< void scsitap_scan_hba (void *work)
---
 > void scsitap_scan_hba (void *ptr)
232,233c228,229
<       struct scsitap_work_t *sw=3Dcontainer_of(work,struct=20
scsitap_work_t, work)
;
<       struct scsitap_session *session=3Dsw->session;
---
 >
 >       struct scsitap_session *session=3D(struct scsitap_session *)pt=
r;
239,240c235
<
<
---
 >
267,269c262,264
<               scsitap_work.session=3Dsession;
<               SCSITAP_INIT_WORK(&scsitap_work.work,scsitap_scan_hba);
<               schedule_work(&scsitap_work.work);
---
 >
 >               INIT_WORK(&scsitap_work,scsitap_scan_hba,session);
 >               schedule_work(&scsitap_work);




[root@goobu kernel]# diff ../include/vscsihba.h=20
=2E./../vscsihba2/include/vscsihba.h
16d15
< #include <linux/version.h>
51,56d49
< #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
<         #define SCSITAP_INIT_WORK(work, func)     INIT_WORK((work),=20
(func), (void *)(work));
< #else
<         #define SCSITAP_INIT_WORK(work, func)     INIT_WORK((work), (=
=20
void (*) (struct work_struct *))(func));
< #endif
<


Aboo



Aboo

Stefan Richter wrote:
> Douglas Gilbert wrote:
>  =20
>> The table would be for different versions as it looks
>> like you may need a new one for bleeding edge kernels.
>>
>> I didn't get far trying to build the kernel module
>> against lk 2.6.20-rc5:
>>
>> # make
>> make -C /lib/modules/2.6.20-rc5/build M=3D/home/upgrades/apps/vscsih=
ba1/vscsihba1/kernel modules
>> make[1]: Entering directory `/usr/src/linux-2.6.19'
>>   CC [M]  /home/upgrades/apps/vscsihba1/vscsihba1/kernel/hba.o
>> /home/upgrades/apps/vscsihba1/vscsihba1/kernel/hba.c:26: warning: =91=
kmem_cache_t=92 is deprecated
>>   CC [M]  /home/upgrades/apps/vscsihba1/vscsihba1/kernel/device.o
>> /home/upgrades/apps/vscsihba1/vscsihba1/kernel/device.c:263:51: erro=
r: macro "INIT_WORK" passed 3 arguments, but takes just 2
>>    =20
> [...]
>
> Aboo,
>
> the workqueue API changes after 2.6.19 are for example explained here=
:
> http://lwn.net/Articles/213149/
> There are a lot of workqueue API conversion patches in 2.6.20-rc1 whi=
ch
> can be taken as example. The first step when converting to the new AP=
I
> is to determine whether the work has to be delayed sometimes or can
> always be queued as immediate work. In the latter case, a slimmed-dow=
n
> variant of delayed work is used.
>
> The conversion away from kmem_cache_t is trivial. There are also some
> patches in 2.6.20-rc1 or later to use as example.
>  =20

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
