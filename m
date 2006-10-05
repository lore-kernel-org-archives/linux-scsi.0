From: malahal@us.ibm.com
Subject: Re: list debugging BUG() hit by aic94xx
Date: Wed, 4 Oct 2006 19:13:23 -0700
Message-ID: <20061005021323.GA29447@us.ibm.com>
References: <1159901803.3443.47.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:41903 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751325AbWJECN0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Oct 2006 22:13:26 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id k952DQg8001192
	for <linux-scsi@vger.kernel.org>; Wed, 4 Oct 2006 22:13:26 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k952DPD6116874
	for <linux-scsi@vger.kernel.org>; Wed, 4 Oct 2006 22:13:25 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k952DPWN006635
	for <linux-scsi@vger.kernel.org>; Wed, 4 Oct 2006 22:13:25 -0400
Content-Disposition: inline
In-Reply-To: <1159901803.3443.47.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

The list seems to be guarded by a spin lock while adding items to the
list. I don't see holding such a lock while removing list items. There
is some code that goes through the list without any lock either. Most of
it is single threaded, except the work queue thread (scsi_wq) and the
unload thread when we unload the driver could race.

It is quite possible that I just mis-understood this whole thing.

Thanks, Malahal.

James Bottomley [James.Bottomley@SteelEye.com] wrote:
> If someone is bored, they can take a look at this list debug error:
> 
> list_add corruption. prev->next should be dfa0b788, but was f795fd50
> ------------[ cut here ]------------
> kernel BUG at lib/list_debug.c:31!
> invalid opcode: 0000 [#1]
> SMP 
> Modules linked in: aic94xx libsas firmware_class scsi_transport_sas sd_mod scsi_transport_spi scsi_mod
> CPU:    0
> EIP:    0060:[<c01df32e>]    Not tainted VLI
> EFLAGS: 00010286   (2.6.18 #14)
> EIP is at __list_add+0x6e/0x80
> eax: 00000048   ebx: dfa0b788   ecx: 00000003   edx: 00000008
> esi: f7929bb8   edi: dfaa2888   ebp: dfeabeec   esp: dfeabed4
> ds: 007b   es: 007b   ss: 0068
> Process scsi_wq_0 (pid: 872, ti=dfeaa000 task=dfe60030 task.ti=dfeaa000)
> Stack: c030a7b8 dfa0b788 f795fd50 dfa0b76c dfaa2864 00000000 dfeabf30 f884458d 
>        dfaa2888 f7929bb8 dfa0b788 00000001 c0114da0 dfaefd24 dfa2c2f0 dfa088f4 
>        00000286 dfa08ae4 dfa0b7ec dfaa2864 dfa0b6b8 dfa0b6bc dfaefd24 dfeabf64 
> Call Trace:
>  [<f884458d>] sas_discover_domain+0x2ed/0x4c0 [libsas]
>  [<c012d3bf>] run_workqueue+0x7f/0x100
>  [<c012dca8>] worker_thread+0x148/0x170
>  [<c0130c2d>] kthread+0xfd/0x110
>  [<c0103e33>] kernel_thread_helper+0x7/0x14
>  =======================
> Code: 08 c7 04 24 78 a7 30 c0 e8 c0 e1 f3 ff 0f 0b 1a 00 77 a2 30 c0 eb c5 89 5c 24 04 89 44 24 08 c7 04 24 b8 a7 30 c0 e8 a2 e1 f3 ff <0f> 0b 1f 00 77 a2 30 c0 eb ad 90 8d b4 26 00 00 00 00 55 89 e5 
> EIP: [<c01df32e>] __list_add+0x6e/0x80 SS:ESP 0068:dfeabed4
> 
> This seems to be coming from the
> 
> 	list_add_tail(&dev->dev_list_node, &port->dev_list);
> 
> in sas_get_port_device()
> 
> James
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
