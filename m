From: Tejun Heo <htejun@gmail.com>
Subject: Re: [RFD driver-core] Lifetime problems of the current driver model
Date: Fri, 30 Mar 2007 22:19:52 +0900
Message-ID: <460D0E78.3040200__45486.2796389081$1175297017$gmane$org@gmail.com>
References: <460CDBA6.5030608@gmail.com> <20070330151926.18fc12a0@gondolin.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:39674 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbXC3NUA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Mar 2007 09:20:00 -0400
Received: by py-out-1112.google.com with SMTP id a29so226885pyi
        for <linux-scsi@vger.kernel.org>; Fri, 30 Mar 2007 06:20:00 -0700 (PDT)
In-Reply-To: <20070330151926.18fc12a0@gondolin.boeblingen.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: gregkh@suse.de, hugh@veritas.com, dmitry.torokhov@gmail.com, oneukum@suse.de, maneesh@in.ibm.com, rpurdie@rpsys.net, James.Bottomley@SteelEye.com, Jeff Garzik <jgarzik@pobox.com>, lkml <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Cornelia Huck wrote:
> On Fri, 30 Mar 2007 18:43:02 +0900,
> Tejun Heo <htejun@gmail.com> wrote:
> 
>> One way to solve this problem is to subordinate lifetime rule #b to
>> rule #c.  Each kobject points to its owning module such that grabbing
>> a kobject automatically grabs the module.  The problem with this
>> approach is that it requires wide update and makes kobject_get
>> heavier.
> 
> Shouldn't getting/putting the module refcount be solely done in
> kobject.c? Grab the module reference when the kobject is created and
> release the module reference in kobject_cleanup() after the release
> function has been called. This doesn't make kobject_get() heavier, and
> it ensures we don't delete the module until after the last kobject it is
> supposed to clean up has been released.

If we do that, we wouldn't be able to unload a module if there is any
kobject referencing it even when the node has no openers, so no easy way
out there.  :-(

-- 
tejun
