From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: [PATCH 1/2] resubmit cciss: kernel thread to detect changes on
	MSA2012
Date: Fri, 6 Mar 2009 20:00:30 +0000
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77885CA68ED159@GVW0547EXC.americas.hpqcorp.net>
References: <20090306181603.GA30801@roadking.ldev.net>
 <1236363867.12019.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:16708 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755750AbZCFUBZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Mar 2009 15:01:25 -0500
In-Reply-To: <1236363867.12019.2.camel@localhost.localdomain>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>, "coldwell@redhat.com" <coldwell@redhat.com>, "mikem@beardog.cca.cpqcorp.net" <mikem@beardog.cca.cpqcorp.net>

 

> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
> Sent: Friday, March 06, 2009 12:24 PM
> To: Miller, Mike (OS Dev)
> Cc: Andrew Morton; Jens Axboe; LKML; LKML-scsi; 
> coldwell@redhat.com; mikem@beardog.cca.cpqcorp.net
> Subject: Re: [PATCH 1/2] resubmit cciss: kernel thread to 
> detect changes on MSA2012
> 
> On Fri, 2009-03-06 at 12:16 -0600, Mike Miller wrote:
> > Patch 1 of 2
> > 
> > This is a resubmission of yesterdays patch to detect 
> changes on the MSA2012.
> > I hope I've addressed all concerns. This patch rearranges 
> some of the 
> > code so we also have coverage in the sg and the ioctl paths 
> as well as 
> > the main data path.
> > 
> > The MSA2012 cannot inform the driver of configuration changes since 
> > all management is out of band. This is a departure from any 
> storage we 
> > have supported in the past. We need some way to detect 
> changes on the 
> > topology so we implement this kernel thread. In some 
> instances there's 
> > nothing we can do from the driver (like LUN failure) so 
> just print out 
> > a message. In the case where logical volumes are added or 
> deleted we 
> > call rebuild_lun_table to refreash the driver's view of the world.
> > 
> > Please consider this for inclusion.
> 
> I still don't quite see how the thread stops on module 
> removal ... there needs to be an explicit kthread_stop() 
> somewhere in the clean up path.
> 
I thought that was probably needed, duh. Is there anything else I should address at the same time?

-- mikem