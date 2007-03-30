From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [RFD driver-core] Lifetime problems of the current driver model
Date: Fri, 30 Mar 2007 15:19:26 +0200
Message-ID: <20070330151926.18fc12a0__47998.0907556184$1175296943$gmane$org@gondolin.boeblingen.de.ibm.com>
References: <460CDBA6.5030608@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:63382 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbXC3NRY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Mar 2007 09:17:24 -0400
In-Reply-To: <460CDBA6.5030608@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: gregkh@suse.de, hugh@veritas.com, dmitry.torokhov@gmail.com, oneukum@suse.de, maneesh@in.ibm.com, rpurdie@rpsys.net, James.Bottomley@SteelEye.com, Jeff Garzik <jgarzik@pobox.com>, lkml <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 30 Mar 2007 18:43:02 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> One way to solve this problem is to subordinate lifetime rule #b to
> rule #c.  Each kobject points to its owning module such that grabbing
> a kobject automatically grabs the module.  The problem with this
> approach is that it requires wide update and makes kobject_get
> heavier.

Shouldn't getting/putting the module refcount be solely done in
kobject.c? Grab the module reference when the kobject is created and
release the module reference in kobject_cleanup() after the release
function has been called. This doesn't make kobject_get() heavier, and
it ensures we don't delete the module until after the last kobject it is
supposed to clean up has been released.
