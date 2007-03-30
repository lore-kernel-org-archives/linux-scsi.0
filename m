From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [RFD driver-core] Lifetime problems of the current driver model
Date: Fri, 30 Mar 2007 16:52:51 +0200
Message-ID: <20070330165251.7beffc7c__28434.2101579115$1175300124$gmane$org@gondolin.boeblingen.de.ibm.com>
References: <460CDBA6.5030608@gmail.com>
	<20070330151926.18fc12a0@gondolin.boeblingen.de.ibm.com>
	<460D0E78.3040200@gmail.com>
	<20070330154042.4c7deb72@gondolin.boeblingen.de.ibm.com>
	<460D178F.4000500@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:7262 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbXC3Out (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Mar 2007 10:50:49 -0400
In-Reply-To: <460D178F.4000500@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: gregkh@suse.de, hugh@veritas.com, dmitry.torokhov@gmail.com, oneukum@suse.de, maneesh@in.ibm.com, rpurdie@rpsys.net, James.Bottomley@SteelEye.com, Jeff Garzik <jgarzik@pobox.com>, lkml <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 30 Mar 2007 22:58:39 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> It's a little bit more convoluted than that.  Module reference count of
> zero doesn't indicate that there is no one referencing the module.  It
> just means that the module can be unloaded.  ie. There still can be any
> number of kobjects with release function backed by the module but as
> long as all of them can be deleted and released by module exit function,
> the module is unloadable at that point.
> 
> IOW, module reference count does not count number of objects depending
> on the module.  It counts the number of active usages of those objects.

We must make sure that the module is never deleted while there may be
calls to ->release functions - the exit function can only return when
all ->release calls have returned. This can be guaranteed if we (1)
don't allow the module to unload if there are outstanding kobjects (we
may need a "self destruct" knob then) or (2) make sure the ->release
functions are outside of the module (see, for example,
drivers/s390/s390_rdev.c).

(Gah, that stuff is always giving me headaches. Sorry if I'm not making
sense...)
