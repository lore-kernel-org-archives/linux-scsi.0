From: Alexey Dobriyan <adobriyan@sw.ru>
Subject: Re: sr_mod oops (elv_next_request involved)
Date: Tue, 23 Oct 2007 14:34:52 +0400
Message-ID: <20071023103452.GA6267@localhost.sw.ru>
References: <20071022121206.GB6271@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:46342 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbXJWKfK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Oct 2007 06:35:10 -0400
Content-Disposition: inline
In-Reply-To: <20071022121206.GB6271@localhost.sw.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, akpm@osdl.org, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 04:12:06PM +0400, Alexey Dobriyan wrote:
> Steps to reproduce:
> 
> 	modprobe sr_mod

To clarify: this is done during boot sequence.

> 	rmmod sr_mod
> 	modprobe sr_mod

This -- by hand.

> BUG: unable to handle kernel paging request at virtual address f881b9f3
> printing eip: f881b9f3 *pdpt = 0000000000003001 <1>*pde = 000000000480a067 *pte = 0000000000000000 
> Oops: 0010 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> Modules linked in: sr_mod af_packet ipv6 nf_conntrack_netbios_ns nf_conntrack_ipv4 xt_state nf_conntrack xt_tcpudp ipt_REJECT iptable_filter ip_tables x_tables cpufreq_ondemand loop serio_raw k8temp hwmon amd_rng cdrom
> 
> Pid: 1981, comm: modprobe Not tainted (2.6.23-55b70a0300b873c0ec7ea6e33752af56f41250ce #4)
> EIP: 0060:[<f881b9f3>] EFLAGS: 00010086 CPU: 1
> EIP is at 0xf881b9f3
> EAX: c570b380 EBX: c56b6700 ECX: f881b9f3 EDX: c56b6700
> ESI: c570b380 EDI: c5767920 EBP: c570b380 ESP: c4b5ec0c
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process modprobe (pid: 1981, ti=c4b5e000 task=c4b60000 task.ti=c4b5e000)
> Stack: c10ab9ea c570b380 c4b5ecec c528c5c8 c56b6700 c570b380 c528c430 c11251fd 
>        c570b380 c56b6700 c10ae49a 00000001 c570b380 c56b6700 c570b380 c4b5ecec 
>        c10ae4c3 00000001 c10ae540 00000001 00000000 c4b5ecf0 c56b6700 c4b5ed18 
> Call Trace:
>  [<c10ab9ea>] elv_next_request+0x83/0xfe

> CONFIG_HWMON=m
> CONFIG_SENSORS_K8TEMP=m

Strange...

If I make CONFIG_HWMON=y, oops goes away.
If I load hwmon.ko after sr_mod.ko, oops goes away.

