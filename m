From: Tejun Heo <htejun@gmail.com>
Subject: Re: [RFD driver-core] Lifetime problems of the current driver model
Date: Sat, 31 Mar 2007 00:08:19 +0900
Message-ID: <460D27E3.2050602__18359.3811969788$1175300870$gmane$org@gmail.com>
References: <460CDBA6.5030608@gmail.com>	<20070330151926.18fc12a0@gondolin.boeblingen.de.ibm.com>	<460D0E78.3040200@gmail.com>	<20070330154042.4c7deb72@gondolin.boeblingen.de.ibm.com>	<460D178F.4000500@gmail.com> <20070330165251.7beffc7c@gondolin.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.224]:8511 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852AbXC3PI0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Mar 2007 11:08:26 -0400
Received: by wr-out-0506.google.com with SMTP id 76so688224wra
        for <linux-scsi@vger.kernel.org>; Fri, 30 Mar 2007 08:08:25 -0700 (PDT)
In-Reply-To: <20070330165251.7beffc7c@gondolin.boeblingen.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: gregkh@suse.de, hugh@veritas.com, dmitry.torokhov@gmail.com, oneukum@suse.de, maneesh@in.ibm.com, rpurdie@rpsys.net, James.Bottomley@SteelEye.com, Jeff Garzik <jgarzik@pobox.com>, lkml <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Cornelia Huck wrote:
> On Fri, 30 Mar 2007 22:58:39 +0900,
> Tejun Heo <htejun@gmail.com> wrote:
> 
>> It's a little bit more convoluted than that.  Module reference count of
>> zero doesn't indicate that there is no one referencing the module.  It
>> just means that the module can be unloaded.  ie. There still can be any
>> number of kobjects with release function backed by the module but as
>> long as all of them can be deleted and released by module exit function,
>> the module is unloadable at that point.
>>
>> IOW, module reference count does not count number of objects depending
>> on the module.  It counts the number of active usages of those objects.
> 
> We must make sure that the module is never deleted while there may be
> calls to ->release functions - the exit function can only return when
> all ->release calls have returned. This can be guaranteed if we (1)
> don't allow the module to unload if there are outstanding kobjects (we
> may need a "self destruct" knob then) or (2) make sure the ->release
> functions are outside of the module (see, for example,
> drivers/s390/s390_rdev.c).

(3) make sure all existing kobjects are released by module exit function.

For example, let's say there is a hypothetical disk device /dev/dk0
driven by a hypothetical driver mydrv.  /dev/dk0 is represented like the
following in the sysfs tree.

/sys/devices/pci0000:00/0000:00:1f.0/dk0/{myknob0,myknob1}

Owner of both attrs myknob0 and myknob1 is mydrv and opening either
increases the reference counts of dk0 and mydrv and closing does the
opposite.

* When there is no opener of either knob and the /dev/dk0 isn't used by
anyone.  Reference count of dk0 is 1, mydrv 0.

* User issues rmmod mydrv.  As mydrv's reference count is zero, unload
proceeds and mydrv's exit function is called.

* mydrv's exit function looks like the following.

  mydrv_exit()
  {
	sysfs_remove_file(dk0, myknob0);
	sysfs_remove_file(dk1, myknob1);
	device_del(dk0);
	deinit controller;
	release all resources;
  }

The device_del(dk0) drops dk0's reference count to zero and its
->release is invoked immediately.

This method is widely used to allow modules to be unloaded even when
there still are valid objects if there's no active user.

> (Gah, that stuff is always giving me headaches. Sorry if I'm not making
> sense...)

Yeap, this is confusing.  Hope my explanation makes sense.

-- 
tejun
