From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: Re: [PATCH] aic94xx: Hotplug ex_change_count race fix
Date: Tue, 03 Oct 2006 08:30:12 -0700
Message-ID: <1159889413.7024.15.camel@localhost.localdomain>
References: <1159308320.9567.55.camel@alexis>
	 <1159885160.3443.20.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:32393 "EHLO
	e36.co.us.ibm.com") by vger.kernel.org with ESMTP id S1030220AbWJCPba
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Oct 2006 11:31:30 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e36.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k93FVU7p019888
	for <linux-scsi@vger.kernel.org>; Tue, 3 Oct 2006 11:31:30 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k93FUF9N406876
	for <linux-scsi@vger.kernel.org>; Tue, 3 Oct 2006 09:30:15 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k93FUE5X004772
	for <linux-scsi@vger.kernel.org>; Tue, 3 Oct 2006 09:30:15 -0600
In-Reply-To: <1159885160.3443.20.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2006-10-03 at 09:19 -0500, James Bottomley wrote:
> On Tue, 2006-09-26 at 15:05 -0700, Alexis Bruemmer wrote:
> > In some cases while hotplugging disks on a system with an expander the
> > broadcast primitive will be posted and begin processing before the
> > expander change count is updated.  This causes the device that triggered
> > the broadcast to not be found.
> 
> Thanks; I'll stick this in.
> 
> However, it has always struck me that this broadcast code is fragile
> because of the way event processing works.  If we get two fairly close
> together broadcast events, we'll amalgamate them into a single event and
> then stop processing as soon as we find one expander that changed, if
> you want to look at sorting that out ...

I will look into it.

--Alexis

> 
> James
> 
> 

