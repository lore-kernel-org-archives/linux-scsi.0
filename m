From: Andrew Morton <akpm@osdl.org>
Subject: Re: 2.1.6 st.o sleeping invalid context
Date: Fri, 23 Jan 2004 14:32:08 -0800
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040123143208.54b4f962.akpm@osdl.org>
References: <000701c3e1a6$ac762330$c8de11cc@black>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <000701c3e1a6$ac762330$c8de11cc@black>
To: Mike Black <mblack@csi-inc.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

"Mike Black" <mblack@csi-inc.com> wrote:
>
> Testing 2.6.1 and got the following message during boot -- apparently when loading the st.o module -- although the modules still
> loads successfully.
> 
> Jan 23 06:41:49 yeti kernel: Debug: sleeping function called from invalid context at mm/slab.c:1856
> Jan 23 06:41:49 yeti kernel: in_atomic():1, irqs_disabled():0
> Jan 23 06:41:49 yeti kernel: Call Trace:
> Jan 23 06:41:49 yeti kernel:  [<c011da0c>] __might_sleep+0xab/0xc9
> Jan 23 06:41:49 yeti kernel:  [<c0142a4a>] kmem_cache_alloc+0x74/0x76
> Jan 23 06:41:49 yeti kernel:  [<c0162e81>] cdev_alloc+0x24/0x5e
> Jan 23 06:41:49 yeti kernel:  [<f8871743>] st_probe+0x3f4/0x7c1 [st]
> Jan 23 06:41:49 yeti kernel:  [<c018f7b0>] init_dir+0x0/0x22
> Jan 23 06:41:49 yeti kernel:  [<c01f7d29>] bus_match+0x3d/0x65
> Jan 23 06:41:49 yeti kernel:  [<c01f7e42>] driver_attach+0x59/0x83
> Jan 23 06:41:49 yeti kernel:  [<c01f810b>] bus_add_driver+0x9e/0xb1
> Jan 23 06:41:49 yeti kernel:  [<f881905e>] init_st+0x5e/0x9c [st]
> Jan 23 06:41:49 yeti kernel:  [<c013898f>] sys_init_module+0x13e/0x29a
> Jan 23 06:41:49 yeti kernel:  [<c01091e3>] syscall_call+0x7/0xb
> 

st_probe() is calling cdev_alloc() under write_lock(&st_dev_arr_lock);

Optimistically Cc'ing linux-scsi...
