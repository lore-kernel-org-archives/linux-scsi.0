From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [dm-devel] QUEUE_FLAG_CLUSTER?
Date: Thu, 25 Nov 2010 10:21:43 -0500
Message-ID: <yq14ob5o2d4.fsf@sermon.lab.mkp.net>
References: <85ABFDC4641C4847BA6088F2982EFD8F049D4EB8@nonamew.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:51327 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab0KYPXX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Nov 2010 10:23:23 -0500
In-Reply-To: <85ABFDC4641C4847BA6088F2982EFD8F049D4EB8@nonamew.ptu.promise.com> (Ed
	Lin's message of "Fri, 19 Nov 2010 17:24:14 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-scsi@vger.kernel.org, Promise_Linux <Promise_Linux@promise.com>

>>>>> "Ed" == "Ed Lin <- PTU" <ed.lin@promise.com>> writes:

Ed,

Ed> The dm already has function to adjust limits based on underlying
Ed> device limits. So, is it good to add the no_cluster setting to the
Ed> queue limits at the scsi side? For example, some code change like
Ed> the following?

We should never issue a command that does not adhere to the limits set
by the device driver. Upon inspection I agree this is busted and it's my
fault.

DM does not have a request_queue when stacking and as a result we ended
up with two entities tracking whether a device supports clustering or
not. And as it turns out the queue flag and the queue limits are not
always in agreement.

I've coded up a proper fix for this and will post a patch shortly. I'm
just running a bunch of tests to ensure we do the right thing...

-- 
Martin K. Petersen	Oracle Linux Engineering
