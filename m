From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi : set target can_queue from devinfo flags
Date: Wed, 14 May 2008 15:38:13 -0400
Message-ID: <1210793893.3075.6.camel@localhost.localdomain>
References: <1210700704.16304.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from med195e42.tmodns.net ([66.94.25.237]:35265 "EHLO
	atmailx07.tmomail.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751309AbYENVxf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 May 2008 17:53:35 -0400
In-Reply-To: <1210700704.16304.1.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Tue, 2008-05-13 at 13:45 -0400, James Smart wrote:
> This patch, discussed in the initial thread on target can_queue limits
> (see  http://marc.info/?l=linux-scsi&m=120944296225094&w=2 )
> allows the target can_queue limit to be obtained from the device list based on
> Inquiry data obtained during scan.
> 
> I have pinged several of the array vendors to supply target-port level values
> for their arrays. Hopefully, we will see them populate the device list with some
> real values shortly.
> 
> This patch was cut against scsi-misc-2.6, and depends on Mike Christies patches
> contained in the original thread.

Just from a point of first principles, what makes you think the target
port queue depth of an array is anything like constant?  All the
information I've got back from array vendors over the years leads me to
conclude that it's dynamically determined based on resources available
at the time the array services the request.  Additionally, I've been
told that even a heuristic rule of thumb value varies with the array
cache size (which is a quantity not reflected in the inquiry strings).

My best guess for the way of handling this is that we should be using
the Doug Leaford track_queue_full infrastructure but on a per target
bases.

James


