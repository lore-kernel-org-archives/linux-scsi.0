From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] resubmit cciss: kernel thread to detect changes on
	MSA2012
Date: Fri, 06 Mar 2009 12:24:27 -0600
Message-ID: <1236363867.12019.2.camel@localhost.localdomain>
References: <20090306181603.GA30801@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:39022 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755398AbZCFSYd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Mar 2009 13:24:33 -0500
In-Reply-To: <20090306181603.GA30801@roadking.ldev.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Miller <mike.miller@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>, coldwell@redhat.com, mikem@beardog.cca.cpqcorp.net

On Fri, 2009-03-06 at 12:16 -0600, Mike Miller wrote:
> Patch 1 of 2
> 
> This is a resubmission of yesterdays patch to detect changes on the MSA2012.
> I hope I've addressed all concerns. This patch rearranges some of the code
> so we also have coverage in the sg and the ioctl paths as well as the main
> data path.
> 
> The MSA2012 cannot inform the driver of configuration changes since all
> management is out of band. This is a departure from any storage we have
> supported in the past. We need some way to detect changes on the topology so
> we implement this kernel thread. In some instances there's nothing we can do
> from the driver (like LUN failure) so just print out a message. In the case
> where logical volumes are added or deleted we call rebuild_lun_table to
> refreash the driver's view of the world.
> 
> Please consider this for inclusion.

I still don't quite see how the thread stops on module removal ... there
needs to be an explicit kthread_stop() somewhere in the clean up path.

James


