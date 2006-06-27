From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 1/1] scsi: Add allow_restart sysfs class attribute
Date: Tue, 27 Jun 2006 21:45:59 +0200
Message-ID: <44A18AF7.7000504@s5r6.in-berlin.de>
References: <200606271610.k5RGAXcT005333@d03av04.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:56196 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932546AbWF0Tr5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jun 2006 15:47:57 -0400
In-Reply-To: <200606271610.k5RGAXcT005333@d03av04.boulder.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, parasietje@gmail.com

Brian King wrote:
> This is a resend of a patch I generated in response to an email sent
> by Ruben Faelens <parasietje@gmail.com>. His original email to
> linux-scsi requested a method in which he could spin down a scsi disk
> when not in use and have the kernel automatically spin it back up when
> an I/O was generated to the disk. The infrastructure to automatically
> spin a disk up has been in the scsi error handler for some time now,

I am positively surprised that this code is actually already there --- I 
didn't notice...

> but it is not enabled by default. This patch adds an sd sysfs attribute
> which allows userspace to enable this behavior.

What is the reason that the code is not enabled by default? Are there 
dependencies on command set or transport, or firmwares which won't react 
properly?

There were a few requests for auto-spinup for SBP-2 HDDs during the last 
months, e.g. https://bugzilla.novell.com/show_bug.cgi?id=183011 . Maybe 
sbp2 should switch on sdev->allow_restart for all SBP-2 direct access 
and RBC devices, or at least for those that are known to require it.
-- 
Stefan Richter
-=====-=-==- -==- ==-==
http://arcgraph.de/sr/
