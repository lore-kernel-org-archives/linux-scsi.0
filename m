From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [RFC][PATCH] Handle multipath paths in a path group properly
	during pg_init (was "RE: [dm-devel] DM does not activate the paths if there
	are more than one path in path group during failover")
Date: Fri, 14 Nov 2008 11:08:48 -0800
Message-ID: <1226689728.8998.76.camel@chandra-ubuntu>
References: <1225944321.14830.1109.camel@chandra-ubuntu>
	 <E463DF2B2E584B4A82673F53D62C2EF45BE759CF@cosmail01.lsi.com>
	 <20081111005920.GN16649@agk.fab.redhat.com>
	 <E463DF2B2E584B4A82673F53D62C2EF45BE75B7F@cosmail01.lsi.com>
	 <1226620138.8998.64.camel@chandra-ubuntu>
	 <20081114001205.GQ30569@agk.fab.redhat.com>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:43186 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbYKNTJL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Nov 2008 14:09:11 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id mAEJ80aw005965
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2008 12:08:00 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mAEJ8v5W070658
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2008 12:08:59 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mAEJ8tnP023060
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2008 12:08:56 -0700
In-Reply-To: <20081114001205.GQ30569@agk.fab.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Anderson <andmike@us.ibm.com>, Mike Christie <mchristi@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, asson_ronald <asson_ronald@emc.com>, Levy_Jerome <Levy_Jerome@emc.com>


On Fri, 2008-11-14 at 00:12 +0000, Alasdair G Kergon wrote:
> On Thu, Nov 13, 2008 at 03:48:58PM -0800, Chandra Seetharaman wrote:
> > The problem reported by Moger Babu was caused due to the architectural
> > change made when we moved from dm hardware handler to SCSI hardware
> > handler.
> 
> pg_init is single initialisation for the group.
> It only needs to happen on one path.

Yes, that was my initial response too.

dm hardware handlers did not maintain a "state" for each path in which
case activating/initializing the controller from one path was sufficient
for all the paths connected to the controller to work as expected.

SCSI Hardware Handlers maintain a "state" for each path, so that they
can fail an I/O at prep_fn, if the path is not an "active" path, which
is what lead to the bug Babu saw.

> 
> It sounds to me that what you're adding here is a *per-path* initialisation,
> something *separate* from (and additional to) the existing *per-group* pg_init.

No, I "replaced" the "per-group" pg_init with "per-path" init.

> 
> Has this patch been tested on EMC?

No, we have tested it with LSI RDAC. I will send a separate email to EMC
folks (on Cc here) describing the problem and the fix and ask their help
in testing.

> 
> Alasdair

