From: "nickcheng" <nick.cheng@areca.com.tw>
Subject: RE: The issue for scsi device hotplug and  hot-remove
Date: Thu, 29 May 2008 10:27:24 +0800
Message-ID: <001201c8c133$881eec80$de00a8c0@NICK>
References: <1211984704.3445.6.camel@localhost.localdomain>
Reply-To: <nick.cheng@areca.com.tw>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 60-248-88-209.HINET-IP.hinet.net ([60.248.88.209]:31620 "EHLO
	areca.com.tw" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750838AbYE2CnV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 May 2008 22:43:21 -0400
In-Reply-To: <1211984704.3445.6.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

I have settled down the issue caused by the uninitialized the struct
work_struct before getting invoked.
Actually I use the worker queue mechanism to implement the hot remove and
hot plug function, not the scsi_queue_work().
Is adopting the scsi_queue_work() preferable to my RAID driver?
Thank you for the response.
-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
Sent: Wednesday, May 28, 2008 10:25 PM
To: nick.cheng@areca.com.tw
Subject: RE: The issue for scsi device hotplug and hot-remove

On Sat, 2008-05-24 at 14:45 +0800, nickcheng wrote:
> Hi James,
> Sorry to bother you again.

You'd get a faster turn around on this if you mailed the scsi list,
since I've been away for a week.

> I study a kernel book and it says it is not allowed create new kernel
thread
> by kernel org fellows.
> I am not sure whether it is just a groundless talk.
> Because I would like to implement the discovery of scsi device hot remove
> and insert, I try to use the event worker thread in default but get the
core
> dump as the attachment.
> I am not very sure what is the root cause but because it says "kernel BUG
at
> kernel/workqueue.c:104", I guess it could be the conflict with some
modules
> in the kernel code, but just a wild guess.
> If you like, please throw me some light.

Without the traces, it's generally pretty impossible to do that.

There's no bar on using kernel threads per se.  However, we do already
have an existing hotplug system for the adding and removing of SCSI
devices.  For instance, the SAS library does all of this (hotplug add
and remove) using scsi_queue_work rather than using a separate thread
(although technically this does cause SCSI to spawn a separate workqueue
thread per host).

James


