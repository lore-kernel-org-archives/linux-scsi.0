From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [RFD driver-core] Lifetime problems of the current driver model
Date: Fri, 30 Mar 2007 15:40:42 +0200
Message-ID: <20070330154042.4c7deb72__9788.47605078972$1175297624$gmane$org@gondolin.boeblingen.de.ibm.com>
References: <460CDBA6.5030608@gmail.com>
	<20070330151926.18fc12a0@gondolin.boeblingen.de.ibm.com>
	<460D0E78.3040200@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:19188 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbXC3Nik (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Mar 2007 09:38:40 -0400
In-Reply-To: <460D0E78.3040200@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: gregkh@suse.de, hugh@veritas.com, dmitry.torokhov@gmail.com, oneukum@suse.de, maneesh@in.ibm.com, rpurdie@rpsys.net, James.Bottomley@SteelEye.com, Jeff Garzik <jgarzik@pobox.com>, lkml <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 30 Mar 2007 22:19:52 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> > Shouldn't getting/putting the module refcount be solely done in
> > kobject.c? Grab the module reference when the kobject is created and
> > release the module reference in kobject_cleanup() after the release
> > function has been called. This doesn't make kobject_get() heavier, and
> > it ensures we don't delete the module until after the last kobject it is
> > supposed to clean up has been released.
> 
> If we do that, we wouldn't be able to unload a module if there is any
> kobject referencing it even when the node has no openers, so no easy way
> out there.  :-(

But we must not unload the module when there is still a kobject around
referencing a release function in the module, or we will oops if the
kobject is finally released. If needed, the module must clean up its
kobjects in its exit function.
