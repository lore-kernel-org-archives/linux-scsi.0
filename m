From: "Zou, Yi" <yi.zou@intel.com>
Subject: RE: [PATCH 2/3] libfc: A modular Fibre Channel library
Date: Thu, 11 Dec 2008 12:32:27 -0800
Message-ID: <7C88852EF6F99F4EB538472FCFEBE22204287E4C@orsmsx509.amr.corp.intel.com>
References: <20081209231005.17830.92133.stgit@fritz>
 <20081209231016.17830.87180.stgit@fritz>
 <20081210000333.GC23556@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:46676 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756150AbYLKXRT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Dec 2008 18:17:19 -0500
In-Reply-To: <20081210000333.GC23556@one.firstfloor.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>, "Love, Robert W" <robert.w.love@intel.com>
Cc: "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jgarzik@redhat.com" <jgarzik@redhat.com>, "davem@davemloft.net" <davem@davemloft.net>, "james.smart@emulex.com" <james.smart@emulex.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "jeykholt@cisco.com" <jeykholt@cisco.com>, "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>

>
>include/scsi/libfc.h:   struct fcoe_dev_stats   *dev_stats[NR_CPUS];
>
>NR_CPUS arrays are strongly discouraged because they lead to waste on
>kernels compiled with large NR_CPUS, ideally use per CPU data or the
>per cpu allocator or at least a dynamic allocation with
>num_possible_cpus()
>In general every use of NR_CPUS is dubious. e.g. you have some loops
>over that,
>these should be all over possible cpus. fcoe_percpu[] should be also
>per cpu data, not an array.
>
>It would probably simplify the code a lot if you just went to global
>per cpu counters instead of per cpu device counters. I don't know
>if that is feasible or not.
>
>static int __init fcoe_init(void)
>
>There are CPU hotplug races between the notifier and the
>for_each_online_cpu()
>loop (probably not a serious problem, such races are common all over
>the
>code base, just wanted to mention it)
>
Hi, Andi,
Thanks for the comments, I have submitted a patch to open-fcoe.org to
convert the foce_percpu[] to be kernel percpu var as you suggested. We
also have a dev_stats[NR_CPUS] as a member of the struct fc_lport. It
stores an array of pointers to struct fcoe_dev_stats, which keeps track
of all the statistics of fcoe traffic. The fc_lport is dynamically
allocated upon creating fcoe instance from a given network interface
name. The dev_stats are allocated initially in a for_each_online_cpu)()
loop, and after that, corresponding dev_stats is allocated/freed upon
CPU_ONLINE/CPU_DEAD event callback fcoe_cpu_callback(), do you think
this is also a problem in using NR_CPUS?

Thanks.

yi

