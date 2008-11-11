From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: DM does not activate the paths if there are more than one path
	in path group during failover
Date: Mon, 10 Nov 2008 18:06:28 -0800
Message-ID: <1226369188.14830.1180.camel@chandra-ubuntu>
References: <1225944321.14830.1109.camel@chandra-ubuntu>
	 <E463DF2B2E584B4A82673F53D62C2EF45BE759CF@cosmail01.lsi.com>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:48221 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbYKKCHh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Nov 2008 21:07:37 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id mAB27Cph023110
	for <linux-scsi@vger.kernel.org>; Mon, 10 Nov 2008 19:07:12 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mAB27a6S066966
	for <linux-scsi@vger.kernel.org>; Mon, 10 Nov 2008 19:07:36 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mAB274HK001137
	for <linux-scsi@vger.kernel.org>; Mon, 10 Nov 2008 19:07:07 -0700
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF45BE759CF@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, "andmike@linux.vnet.ibm.com" <andmike@linux.vnet.ibm.com>


On Mon, 2008-11-10 at 17:45 -0700, Moger, Babu wrote:
> Hi All,
>   I have noticed one more problem with device mapper today.
> 
> Summary:  If there are more than one path in the path group, device mapper does not activate the all the paths during the failover. DM only activates the first path in the path group. It does not call the function activate_path for the second path (or third so on). This seems like a major problem for me. Current code does not keep track of whether the path is already activated or not.  This leads DM using only first path and all other paths become unusable. This happens during the failover.

We do not need to send activate to each "path" as all paths in a path
group lead to the same controller and that controller is activated when
the activate is sent on the first path itself.

Is your multipathd running ?

BTW, why is the physical path state is showing "undef", it should be
"ghost" or "ready"
> 
> Test case.
> 1. Start the IO with all the paths.
> 2. Fail the active path.
> 3. Failover (mode select) will happen and passive path will be activated
> 4. Only first path in path group is activated and other paths will be failed. I would expect the DM to activate all the paths in the path group. However this does not happen.
> 
> Output of multipath -ll before the test.
> 
> mpathf (3600a0b80000f519c0000cc8a48fc7d0b) dm-2 LSI,INF-01-00
> [size=2.0G][features=0][hwhandler=1 rdac][rw]
> \_ round-robin 0 [prio=4][enabled]
>  \_ 3:0:0:0 sde 8:64  [active][undef] running
>  \_ 3:0:2:0 sdg 8:96  [active][undef] running
> \_ round-robin 0 [prio=2][enabled]
>  \_ 3:0:1:0 sdf 8:80  [active][undef] running
>  \_ 3:0:3:0 sdh 8:112 [active][undef] running
> 
> 
> Output of multipath -ll after the test. Notice that second path has failed.
> 
> mpathf (3600a0b80000f519c0000cc8a48fc7d0b) dm-2 LSI,INF-01-00
> [size=2.0G][features=0][hwhandler=1 rdac][rw]
> \_ round-robin 0 [prio=2][enabled]
>  \_ 3:0:1:0 sdf 8:80  [active][undef] running
>  \_ 3:0:3:0 sdh 8:112 [failed][undef] running
> 
> 
> Here is the patch, I have used to work-around the problem. I am sure this is not the place we want to add the fix. However, this patch should give you understanding of the problem. This patch will set the flags
> m->pg_init_required and m->queue_io whenever D-M select new path in the path group whenever the repeat_count is exhausted.
> 
> --- linux-2.6.28-rc4/drivers/md/dm-mpath.c.orig 2008-11-10 17:50:24.000000000 -0600
> +++ linux-2.6.28-rc4/drivers/md/dm-mpath.c      2008-11-10 17:51:36.000000000 -0600
> @@ -245,6 +245,10 @@ static int __choose_path_in_pg(struct mu
>         if (!path)
>                 return -ENXIO;
> 
> +       /* Set the pg_init_required flag to activate this path */
> +       m->pg_init_required = 1;
> +       m->queue_io = 1;
> +
>         m->current_pgpath = path_to_pgpath(path);
> 
>         if (m->current_pg != pg)
> 
> 
> 

