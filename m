From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [BUG 1/3] bsg queue oops with iscsi logout
Date: Mon, 10 Mar 2008 12:57:00 -0500
Message-ID: <47D5766C.3020206@cs.wisc.edu>
References: <20080309165359.GA24388@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:35059 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbYCJR5U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Mar 2008 13:57:20 -0400
In-Reply-To: <20080309165359.GA24388@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pete Wyckoff <pw@osc.edu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, Erez Zilber <erezz@voltaire.com>

Pete Wyckoff wrote:
> I think this used not to happen; not sure.  But I changed two things

This most likely did not happen before 2.6.25-rc* or it broke in 
slightly different ways, because iscsi used to try and do

echo 1 > /sys/block/sdX/device/delete

from userspace instead of calling scsi_remove_target from the kernel.

As you know around 2.6.21, the behavior of doing the echo to the delete 
file changed due to a driver model and scsi change and that broke the 
iscsi tools. The iscsi tools userspace removal was sort of hack in the 
first place and was racey, so we switched to removing devices/target 
like the FC class.


> lately.  2.6.25-rc1 to -rc4 and fedora 8 iscsi-initiator-utils (865) to
> fedora devel (868).  Bidi and varlen patches always too.
> 
> I'll follow with some more variations on this theme.  Looks like bsg
> needs to protect more carefully against the device going away.  Any
> ideas how best to do this?  What was the approach in sg?
> 

I think sg is broken in similar ways. The iser guys have some tests 
cases that have broken sg while IO is outstanding. I am ccing Erez.
