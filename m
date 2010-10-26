From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] fix id computation in scsi_eh_target_reset()
Date: Tue, 26 Oct 2010 15:13:31 -0500
Message-ID: <4CC7366B.8080203@cs.wisc.edu>
References: <AANLkTin-Tkj3Ab312usO2FWE57m3St2iG2oz881F-Zhw@mail.gmail.com>	<4CBBDC19.1090806@cs.wisc.edu>	<1288040021.5487.826.camel@mulgrave.site> <AANLkTinoSSJcKX_V+SZRz3trc6i8ozTidAsYPaM120pv@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:48817 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870Ab0JZUGm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2010 16:06:42 -0400
In-Reply-To: <AANLkTinoSSJcKX_V+SZRz3trc6i8ozTidAsYPaM120pv@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hillf Danton <dhillf@gmail.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

On 10/26/2010 09:04 AM, Hillf Danton wrote:
> On Tue, Oct 26, 2010 at 4:53 AM, James Bottomley
> <James.Bottomley@suse.de>  wrote:
>> On Mon, 2010-10-18 at 00:33 -0500, Mike Christie wrote:
>>> On 10/14/2010 09:04 AM, Hillf Danton wrote:
>>>> There seems that the id of the tgtr_scmd processed by
>>>> scsi_try_target_reset() does not match the id in case that
>>>> SUCCESS is returned by scsi_try_target_reset().
>>>>
>>>> The mismatch is fixed, and the loop to find the next highest
>>>> is also simplified.
>>>>
>>>> Signed-off-by: Hillf Danton<dhillf@gmail.com>
>>>> ---
>>>>
>>>> --- a/drivers/scsi/scsi_error.c     2010-09-13 07:07:38.000000000 +0800
>>>> +++ b/drivers/scsi/scsi_error.c     2010-10-14 21:45:56.000000000 +0800
>>>> @@ -1173,14 +1173,19 @@ static int scsi_eh_target_reset(struct S
>>>>                      list_for_each_entry(scmd, work_q, eh_entry) {
>>>>                              if (scmd_id(scmd)>    id&&
>>>>                              (!tgtr_scmd ||
>>>> -                                scmd_id(tgtr_scmd)>    scmd_id(scmd)))
>>>> +                                scmd_id(tgtr_scmd)>    scmd_id(scmd))) {
>>>>                                              tgtr_scmd = scmd;
>>>> +                                           if (1 + id == scmd_id(scmd))
>>>> +                                                   break;
>>>> +                           }
>>>>                      }
>>>>              }
>>>>              if (!tgtr_scmd)
>>>>                      /* no more commands, that's it */
>>>>                      break;
>>>>
>>>> +           id = scmd_id(tgtr_scmd);
>>>> +
>>>>              SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Sending target reset "
>>>>                                                "to target %d\n",
>>>>                                                current->comm, id));
>>>
>>>
>>> Thanks. Fixes the extra target resets I have been seeing and commands
>>> not getting cleaned up properly.
>>>
>>> Reviewed-by: Mike Christie<michaelc@cs.wisc.edu>
>>
>> The routine is still a bit fiendishly complicated, though.  What about
>> unwinding all of the id processing? it's only required if we want to do
>> target resets in numerical order (a number which has no real meaning on
>> a hot plug bus anyway).
>>
>> What about just a simple list processor that chunks down the work_q,
>> resets the target and pulls all equal targets out, like this?
>>

I was not sure if you are in a rush to get this in. I have been testing 
it, but am hitting a bug below. This does not seem to be related to your 
patch. I am hitting it with or without your patch.

Your patch looks ok, and it seems to work.


Oct 27 07:51:11 noisymax kernel: ------------[ cut here ]------------
Oct 27 07:51:11 noisymax kernel: WARNING: at lib/list_debug.c:30 
__list_add+0x8f/0xa0()
Oct 27 07:51:11 noisymax kernel: Hardware name: X7DB8
Oct 27 07:51:11 noisymax kernel: list_add corruption. prev->next should 
be next (ffff88013e86be50), but was ffff88012b7d2518. 
(prev=ffff88012b7d2518).
Oct 27 07:51:11 noisymax kernel: Modules linked in: bnx2i cnic uio 
autofs4 fcoe libfcoe libfc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 
iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 
nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables 
ipv6 ib_mthca ib_mad ib_core e1000e be2iscsi iscsi_boot_sysfs libiscsi 
scsi_transport_iscsi bnx2x crc32c libcrc32c mdio be2net 8250_pnp 8250 
serial_core shpchp button lpfc qla2xxx scsi_transport_fc [last unloaded: 
mperf]
Oct 27 07:51:11 noisymax kernel: Pid: 3076, comm: scsi_eh_12 Not tainted 
2.6.36+ #2
Oct 27 07:51:11 noisymax kernel: Call Trace:
Oct 27 07:51:11 noisymax kernel: [<ffffffff8104103a>] 
warn_slowpath_common+0x7a/0xb0
Oct 27 07:51:11 noisymax kernel: [<ffffffff81041111>] 
warn_slowpath_fmt+0x41/0x50
Oct 27 07:51:11 noisymax kernel: [<ffffffff812bf180>] ? dev_printk+0x40/0x50
Oct 27 07:51:11 noisymax kernel: [<ffffffff8122e6df>] __list_add+0x8f/0xa0
Oct 27 07:51:11 noisymax kernel: [<ffffffff812d2bd6>] 
scsi_eh_finish_cmd+0x36/0x40
Oct 27 07:51:11 noisymax kernel: [<ffffffff812d3600>] 
scsi_eh_ready_devs+0x320/0x860
Oct 27 07:51:11 noisymax kernel: [<ffffffff812d41c4>] 
scsi_error_handler+0x4a4/0x640
Oct 27 07:51:11 noisymax kernel: [<ffffffff812d3d20>] ? 
scsi_error_handler+0x0/0x640
Oct 27 07:51:11 noisymax kernel: [<ffffffff81062af6>] kthread+0x96/0xa0
Oct 27 07:51:11 noisymax kernel: [<ffffffff81003bd4>] 
kernel_thread_helper+0x4/0x10
Oct 27 07:51:11 noisymax kernel: [<ffffffff813ed180>] ? 
restore_args+0x0/0x30
Oct 27 07:51:11 noisymax kernel: [<ffffffff81062a60>] ? kthread+0x0/0xa0
Oct 27 07:51:11 noisymax kernel: [<ffffffff81003bd0>] ? 
kernel_thread_helper+0x0/0x10
Oct 27 07:51:11 noisymax kernel: ---[ end trace 74b14fae9ff067be ]---

