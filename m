From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: dpt_i2o driver
Date: Tue, 2 Sep 2003 18:00:05 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030902180004.A12229@infradead.org>
References: <0998F43EAD645A47B3F6507196DD70EA256913@OTCEXC01>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:62220 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261403AbTIBRAO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2003 13:00:14 -0400
Content-Disposition: inline
In-Reply-To: <0998F43EAD645A47B3F6507196DD70EA256913@OTCEXC01>; from mark_salyzyn@adaptec.com on Tue, Sep 02, 2003 at 12:41:52PM -0400
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Mark Haverkamp <markh@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Sep 02, 2003 at 12:41:52PM -0400, Salyzyn, Mark wrote:
> 'Christoph Hellwig' [mailto:hch@infradead.org] writes:
> >> 	- use_new_eh_code was initialized thus because some kernels would
> >> have
> >> 	  the (smp) lock, but not the (up) interrupts disabled; by
> >> initializing
> >> 	  after the fact one got consistent io_request_lock behavior. Will
> >> need
> >> 	  to instrument and test the current crop of kernels I build for to
> >> see
> >> 	  if this issue is no longer there.
> >-ENOCONTEXT.  Can you quote what this is the reply to?
> 
> Context of dropping manual initialization of use_new_eh_code and proc_dir in
> the detect code. The former was a result of a workaround for some errant
> kernel trees; the later was a `mistake' resulting from the structure member
> not being present in all trees thinking that was the only reason for the
> use_new_eh_code's original inclusion. A hack with a penalty, will need to
> dehack and make sure the problem is not present in modern kernels.

Ah, okay.  I'm pretty sure 2.2 and 2.4 took io_request_lock with local
irqs disabled and 2.6 doesn't take it at all.  But who knows what fucked
up vendor trees are around..

> Hmmm, lets just delete this (mounted) array. I want to take this (mounted)
> drive to expand an array's capacity. This call is used to inform the user
> that the action that one is about to be asked to perform is being blocked
> because it would cause damage to the operating system.

In Linux 2.6 userspace should get hotplug events as soon as the the last
reference is gone and the device is deleted.  As the device is freed at
the same time you ioctl won't find it anymore anyway and thus fail..

The hotplug even is picked up by the hotplug script which currently
unfortunately are distro-specific.
