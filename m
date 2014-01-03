From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Bug#733565: SIX messages per on boot console should be TWO
Date: Fri, 03 Jan 2014 15:18:36 -0500
Message-ID: <yq1ob3szun7.fsf@sermon.lab.mkp.net>
References: <87vby7l08j.fsf@jidanni.org>
	<1388373281.2900.42.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19735 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbaACUTC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jan 2014 15:19:02 -0500
In-Reply-To: <1388373281.2900.42.camel@deadeye.wl.decadent.org.uk> (Ben
	Hutchings's message of "Mon, 30 Dec 2013 04:14:41 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: jidanni@jidanni.org, 733565@bugs.debian.org, linux-scsi <linux-scsi@vger.kernel.org>

>>>>> "Ben" == Ben Hutchings <ben@decadent.org.uk> writes:

Ben> I can see that it is emitted by sd_read_cache_type(), which is
Ben> called by sd_revalidate_disk(), and that is apparently now called 3
Ben> times during probe.  Which is quite ridiculous.

We have to discover the basics of the disk before we can create the
gendisk/block device/request queue. And some of the subsequent
parameters we need can't be stored or acted upon until everything has
been set up. So some questions we have to ask several times.


Ben> And I wonder whether this situation (no caching mode page) is
Ben> really serious enough to deserve logging at ERR severity?

I guess we could extend the first_scan logic to cover the error case
scenarios. But it is quite unusual for a device to not implement the
caching mode page...

-- 
Martin K. Petersen	Oracle Linux Engineering
