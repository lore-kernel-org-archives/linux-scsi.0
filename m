From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] fix id computation in scsi_eh_target_reset()
Date: Wed, 27 Oct 2010 21:12:15 +0800
Message-ID: <AANLkTinQZ1dJMw1tG4N4nseTyX3iX2zthEanOGffLNHy@mail.gmail.com>
References: <AANLkTin-Tkj3Ab312usO2FWE57m3St2iG2oz881F-Zhw@mail.gmail.com>
	<4CBBDC19.1090806@cs.wisc.edu>
	<1288040021.5487.826.camel@mulgrave.site>
	<AANLkTinoSSJcKX_V+SZRz3trc6i8ozTidAsYPaM120pv@mail.gmail.com>
	<4CC7366B.8080203@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51875 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776Ab0J0NMR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Oct 2010 09:12:17 -0400
Received: by mail-ww0-f44.google.com with SMTP id 15so760949wwe.1
        for <linux-scsi@vger.kernel.org>; Wed, 27 Oct 2010 06:12:17 -0700 (PDT)
In-Reply-To: <4CC7366B.8080203@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

On Wed, Oct 27, 2010 at 4:13 AM, Mike Christie <michaelc@cs.wisc.edu> w=
rote:
> On 10/26/2010 09:04 AM, Hillf Danton wrote:
>>
>> On Tue, Oct 26, 2010 at 4:53 AM, James Bottomley
>> <James.Bottomley@suse.de> =C2=A0wrote:
>>>
>>> On Mon, 2010-10-18 at 00:33 -0500, Mike Christie wrote:
>>>>
>>>> On 10/14/2010 09:04 AM, Hillf Danton wrote:
>>>>>
>>>>> There seems that the id of the tgtr_scmd processed by
>>>>> scsi_try_target_reset() does not match the id in case that
>>>>> SUCCESS is returned by scsi_try_target_reset().
>>>>>
>>>>> The mismatch is fixed, and the loop to find the next highest
>>>>> is also simplified.
>>>>>
>>>>> Signed-off-by: Hillf Danton<dhillf@gmail.com>
>>>>> ---
>>>>>
>>>>> --- a/drivers/scsi/scsi_error.c =C2=A0 =C2=A0 2010-09-13 07:07:38=
=2E000000000 +0800
>>>>> +++ b/drivers/scsi/scsi_error.c =C2=A0 =C2=A0 2010-10-14 21:45:56=
=2E000000000 +0800
>>>>> @@ -1173,14 +1173,19 @@ static int scsi_eh_target_reset(struct S
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 list_for_each_entry(scmd, work_q, eh_entry) {
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (scmd_id(scmd)> =C2=A0 =C2=A0id&&
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (!tgtr_scmd ||
>>>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0scmd_id(tgtr_scmd)> =C2=
=A0 =C2=A0scmd_id(scmd)))
>>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0scmd_id(tgtr_scmd)> =C2=
=A0 =C2=A0scmd_id(scmd)))
>>>>> {
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 tgtr_scmd =3D scmd;
>>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (1 + id =3D=3D
>>>>> scmd_id(scmd))
>>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
>>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 }
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!tgtr_scmd)
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 /* no more commands, that's it */
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 break;
>>>>>
>>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 id =3D scmd_id(tgtr_scmd);
>>>>> +
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 SCSI_LOG_ERROR_RECOVERY=
(3, printk("%s: Sending target reset
>>>>> "
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 "to target %d\n",
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 current->comm, id));
>>>>
>>>>
>>>> Thanks. Fixes the extra target resets I have been seeing and comma=
nds
>>>> not getting cleaned up properly.
>>>>
>>>> Reviewed-by: Mike Christie<michaelc@cs.wisc.edu>
>>>
>>> The routine is still a bit fiendishly complicated, though. =C2=A0Wh=
at about
>>> unwinding all of the id processing? it's only required if we want t=
o do
>>> target resets in numerical order (a number which has no real meanin=
g on
>>> a hot plug bus anyway).
>>>
>>> What about just a simple list processor that chunks down the work_q=
,
>>> resets the target and pulls all equal targets out, like this?
>>>
>
> I was not sure if you are in a rush to get this in. I have been testi=
ng it,
> but am hitting a bug below. This does not seem to be related to your =
patch.
> I am hitting it with or without your patch.

Sorry for the rush, Mike.
Bug fix will be redelivered soon.

>
> Your patch looks ok, and it seems to work.
>
>
> Oct 27 07:51:11 noisymax kernel: ------------[ cut here ]------------
> Oct 27 07:51:11 noisymax kernel: WARNING: at lib/list_debug.c:30
> __list_add+0x8f/0xa0()
> Oct 27 07:51:11 noisymax kernel: Hardware name: X7DB8
> Oct 27 07:51:11 noisymax kernel: list_add corruption. prev->next shou=
ld be
> next (ffff88013e86be50), but was ffff88012b7d2518. (prev=3Dffff88012b=
7d2518).
> Oct 27 07:51:11 noisymax kernel: Modules linked in: bnx2i cnic uio au=
tofs4
> fcoe libfcoe libfc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4
> iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6
> nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tab=
les
> ipv6 ib_mthca ib_mad ib_core e1000e be2iscsi iscsi_boot_sysfs libiscs=
i
> scsi_transport_iscsi bnx2x crc32c libcrc32c mdio be2net 8250_pnp 8250
> serial_core shpchp button lpfc qla2xxx scsi_transport_fc [last unload=
ed:
> mperf]
> Oct 27 07:51:11 noisymax kernel: Pid: 3076, comm: scsi_eh_12 Not tain=
ted
> 2.6.36+ #2
> Oct 27 07:51:11 noisymax kernel: Call Trace:
> Oct 27 07:51:11 noisymax kernel: [<ffffffff8104103a>]
> warn_slowpath_common+0x7a/0xb0
> Oct 27 07:51:11 noisymax kernel: [<ffffffff81041111>]
> warn_slowpath_fmt+0x41/0x50
> Oct 27 07:51:11 noisymax kernel: [<ffffffff812bf180>] ? dev_printk+0x=
40/0x50
> Oct 27 07:51:11 noisymax kernel: [<ffffffff8122e6df>] __list_add+0x8f=
/0xa0
> Oct 27 07:51:11 noisymax kernel: [<ffffffff812d2bd6>]
> scsi_eh_finish_cmd+0x36/0x40
> Oct 27 07:51:11 noisymax kernel: [<ffffffff812d3600>]
> scsi_eh_ready_devs+0x320/0x860
> Oct 27 07:51:11 noisymax kernel: [<ffffffff812d41c4>]
> scsi_error_handler+0x4a4/0x640
> Oct 27 07:51:11 noisymax kernel: [<ffffffff812d3d20>] ?
> scsi_error_handler+0x0/0x640
> Oct 27 07:51:11 noisymax kernel: [<ffffffff81062af6>] kthread+0x96/0x=
a0
> Oct 27 07:51:11 noisymax kernel: [<ffffffff81003bd4>]
> kernel_thread_helper+0x4/0x10
> Oct 27 07:51:11 noisymax kernel: [<ffffffff813ed180>] ?
> restore_args+0x0/0x30
> Oct 27 07:51:11 noisymax kernel: [<ffffffff81062a60>] ? kthread+0x0/0=
xa0
> Oct 27 07:51:11 noisymax kernel: [<ffffffff81003bd0>] ?
> kernel_thread_helper+0x0/0x10
> Oct 27 07:51:11 noisymax kernel: ---[ end trace 74b14fae9ff067be ]---
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
