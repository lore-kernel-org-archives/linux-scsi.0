From: Pierre Berthier <berthierp@yahoo.com>
Subject: Re: memory leak while reading /proc/scsi/gdth/1
Date: Mon, 3 May 2004 03:58:47 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040503105847.71057.qmail@web41213.mail.yahoo.com>
References: <20040429195132.GC20141@logos.cnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web41213.mail.yahoo.com ([66.218.93.46]:55685 "HELO
	web41213.mail.yahoo.com") by vger.kernel.org with SMTP
	id S263636AbUECK6s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 May 2004 06:58:48 -0400
In-Reply-To: <20040429195132.GC20141@logos.cnet>
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Cc: linux-scsi@vger.kernel.org


--- Marcelo Tosatti <marcelo.tosatti@cyclades.com> wrote:
> In the meantime can you 
> turn VM debugging on
> 
> # echo 1 > /sys/vm/vm_gfp_debug
> 
> and run "cat /proc/scsi/gdth/1" ? 
> 
> There should be some backtraces in dmesg. Copy them (the full output), 
> and run then through ksymoops (using the System.map for this kernel).
> 
> Thanks!

I suppose you want this output (appearing in /var/log/messages)

ea411ae0 c0132e67 00000021 00000283 ea411bec c0390000 00000001 00000000
       c02afa00 c02afca4 00000000 00000021 ffffffff c0132a1e c0390080 c0132e7e
       c01fbd74 00000146 ea411bec c01fac99 00000000 00001000 00000000 cdf84134
Call Trace:    [__alloc_pages+639/652] [_alloc_pages+22/24]
[__get_free_pages+10/24] [gdth_ioctl_alloc+88/104] [gdth_get_info+1021/5048]
  [lru_cache_add+103/116] [do_no_page+375/508] [do_page_fault+0/1210]
[do_generic_file_read+1154/1168] [__vma_link+97/176] [do_mmap_pgoff+1076/1276]
  [error_code+52/60] [error_code+52/60] [error_code+52/60] [clear_user+46/60]
[padzero+28/32] [load_elf_binary+2490/2872]
  [load_elf_binary+0/2872] [__alloc_pages+106/652] [lru_cache_add+103/116]
[gdth_proc_info+144/152] [proc_scsi_read+68/96] [proc_file_read+242/404]
  [sys_read+143/256] [system_call+51/56]
ea411ae0 c0132e67 00000021 00000283 ea411bec c0390000 00000001 00000000
       c02afa00 c02afca4 00000000 00000021 ffffffff c0132a1e c0390080 c0132e7e
       c01fbd74 00000146 ea411bec c01fac99 00000000 00001000 00000000 e55d7035
Call Trace:    [__alloc_pages+639/652] [_alloc_pages+22/24]
[__get_free_pages+10/24] [gdth_ioctl_alloc+88/104] [gdth_get_info+1021/5048]
  [lru_cache_add+103/116] [do_no_page+375/508] [do_page_fault+0/1210]
[do_generic_file_read+1154/1168] [__vma_link+97/176] [do_mmap_pgoff+1076/1276]
  [error_code+52/60] [error_code+52/60] [error_code+52/60] [clear_user+46/60]
[padzero+28/32] [load_elf_binary+2490/2872]
  [load_elf_binary+0/2872] [gdth_proc_info+144/152] [proc_scsi_read+68/96]
[proc_file_read+242/404] [sys_read+143/256] [system_call+51/56]



Cheers
Pierre
