From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [RFD driver-core] Lifetime problems of the current driver model
Date: Sat, 31 Mar 2007 18:08:06 +0200
Message-ID: <20070331180806.55d572c8@gondolin.boeblingen.de.ibm.com>
References: <460CDBA6.5030608@gmail.com>
	<20070330151926.18fc12a0@gondolin.boeblingen.de.ibm.com>
	<460D0E78.3040200@gmail.com>
	<20070330154042.4c7deb72@gondolin.boeblingen.de.ibm.com>
	<460D178F.4000500@gmail.com>
	<20070330165251.7beffc7c@gondolin.boeblingen.de.ibm.com>
	<460D27E3.2050602@gmail.com>
	<20070330213101.7aa7babf@gondolin.boeblingen.de.ibm.com>
	<460DD1B0.4080605@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:41351 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbXCaQGF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 31 Mar 2007 12:06:05 -0400
In-Reply-To: <460DD1B0.4080605@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: gregkh@suse.de, hugh@veritas.com, dmitry.torokhov@gmail.com, oneukum@suse.de, maneesh@in.ibm.com, rpurdie@rpsys.net, James.Bottomley@SteelEye.com, Jeff Garzik <jgarzik@pobox.com>, lkml <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 31 Mar 2007 12:12:48 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> > Hm, but as long as dk0 is registered, it can be looked up and someone
> > could get a reference on it.
> 
> Yeah, exactly.  That's why any getting any kobject reference backed by a
> module must be accompanied by try_module_get().
> 
> int mydrv_get_dk(struct dk *dk)
> {
> 	rc = try_module_get(mydrv);
> 	if (rc)
> 		return rc;
> 	kobject_get(&dk->kobj);
> 	return 0;
> }

This works if the caller always knows which module to grab (I was
thinking about some tree-walking code).

> Exactly, in that case, module reference count must not be zero.  You and
> I are saying the same thing.  Why are we running in circle?

I hope we're not, it just makes one dizzy :)

I'll think some more about it...
