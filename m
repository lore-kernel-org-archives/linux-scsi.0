From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: Bug in the sg driver
Date: Mon, 6 Oct 2003 15:18:12 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031006151812.57a641d1.rddunlap@osdl.org>
References: <20031006115245.17d73f0c.rddunlap@osdl.org>
	<20031006191135.19059.qmail@dag.newtech.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:26070 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262156AbTJFW0q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Oct 2003 18:26:46 -0400
In-Reply-To: <20031006191135.19059.qmail@dag.newtech.fi>
List-Id: linux-scsi@vger.kernel.org
To: Dag Nygren <dag@newtech.fi>
Cc: linux-scsi@vger.kernel.org

On Mon, 06 Oct 2003 22:11:35 +0300 Dag Nygren <dag@newtech.fi> wrote:

| 
| > | > Any details, like kernel version, oops or panic logs, etc.?
| > | 
| > | Kernel version is 2.4.20 (Redhat 9.0 + newest upgrade)
| > | 
| > | The oops and the panic logs were not written down as the major focus
| > | was getting this (production) system up and running, sorry for that
| > 
| > Well, unless someone happens to know something about your exact
| > reported problem....
| > in general, you will get better help/responses the better your
| > problem reports are (IMHO).
| 
| Perfectly realize that. Found one report of the exact same problem
| on Google. The URL is: 
| 
| http://groups.google.fi/groups?q=hp_ltt+linux&hl=sv&lr=&ie=UTF-8&selm=zDJq.3O5.
| 11%40gated-at.bofh.it&rnum=1
| 
| The Oops trace for that is:
| kernel BUG in header file at line 162
| kernel BUG at panic.c:141!
| invalid operand: 0000
| CPU:    0
| EIP:    0010:[__out_of_line_bug+15/36] Tainted: P
| EFLAGS: 00010086
| eax: 00000026   ebx: f7928a00   ecx: 00000002 edx: 02000000
| esi: c3e8207c   edi: f79ba1f0   ebp: f79ba1d8 esp: f6fabc68
| ds: 0018   es: 0018   ss: 0018
| Process hp_ltt (pid: 590, stackpage=f6fab000)
| Stack: c026fa80 000000a2 c0202f38 000000a2 f7928a00 c3e8207c f79ba1c0 f79ba1d8
|        c02c2934 c0132070 00000000 00000000 ffffffff 00000000 0000000e 00000060
|        00000000 00000002 c0204831 c3e8207c f7928a00 f79ba1c0 0000005a 00000293
| Call Trace:    [mptscsih_AddSGE+200/832] [__alloc_pages+64/352]
|  [mptscsih_qcmd+621/1288]  [scsi_dispatch_cmd+649/904] [scsi_old_done+0/1500]
|  [scsi_request_fn+826/892]  [__scsi_insert_special+110/128]
|  [scsi_insert_special_req+26/32] [scsi_do_req+328/368]
|  [sg_common_write+587/604] [sg_cmd_done_bh+0/912] [sg_new_write+539/576]
|  [sg_ioctl+616/3004] [journal_dirty_metadata+356/396] [__alloc_pages+64/352]
|  [do_wp_page+112/668] [handle_mm_fault+135/184] [do_page_fault+380/1178]
|  [do_page_fault+0/1178] [sys_rt_sigaction+159/324] [sys_ioctl+685/746]
|  [error_code+52/60] [system_call+51/56]
| 
| Code: 0f 0b 8d 00 a6 fa 26 c0 eb fe 8d 74 26 00 8d bc 27 00 00 00

Is your oops/panic like this one?

mptscsih_qcmd is in the Fusion MPT driver.
Looks like it is having problems with a scatter-gather list
(actually with PCI mapping of it).
I can't tell if the Fusion driver begins the problem or if
sg begins it and passes it along.

Can you try a current 2.4.22 kernel?  This driver has been updated
some since 2.4.20.  I don't know that this bug is fixed, however.

If you get this bug again, please run the logged text thru ksymoops
so that it is more usable.

What makes the kernel "Tainted"?

--
~Randy
