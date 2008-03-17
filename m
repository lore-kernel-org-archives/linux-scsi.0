From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [patch] convert the scsi layer to use struct device
Date: Mon, 17 Mar 2008 14:40:48 +0100
Message-ID: <1205761248.6338.13.camel@lov.site>
References: <1205514958.2904.27.camel@localhost.localdomain>
	 <1205529619.2904.87.camel@localhost.localdomain>
	 <1205531922.3522.57.camel@lov.site>
	 <1205590788.6767.12.camel@localhost.localdomain>
	 <1205594256.3109.53.camel@lov.site>
	 <1205597776.6767.40.camel@localhost.localdomain>
	 <1205604260.3109.133.camel@lov.site> <47DD8139.1040802@emulex.com>
	 <1205701470.11374.66.camel@lov.site> <47DDF05D.8060608@emulex.com>
	 <20080317053519.GB5229@kroah.com>  <47DE6198.5070602@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.177]:60987 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492AbYCQNkA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Mar 2008 09:40:00 -0400
In-Reply-To: <47DE6198.5070602@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: Greg KH <greg@kroah.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Tony Jones <tonyj@suse.de>

On Mon, 2008-03-17 at 08:18 -0400, James Smart wrote:
> Greg KH wrote:
> > I take it you haven't even looked at how !SYSFS_DEPRECATED works today,
> > have you?  Try it and you will see that the namespace issue has been
> > taken care of a long time ago :)
> 
> You are right...   but I would assume it can be answered without pushing
> someone back into the internals of the code to figure it out.

Oh, I already answered it in an earlier mail :)
  "these links don't exist with !SYSFS_DEPRECATED, because the
   class devices live in subdirectories, named after the class
   they come from, there is no namespace problem"

This is how a LUN looks now:
  tree /sys/devices/pci0000:00/0000:00:1d.7/usb5/5-1/5-1:1.0/host13/target13:0:0/13:0:0:0/
  /sys/devices/pci0000:00/0000:00:1d.7/usb5/5-1/5-1:1.0/host13/target13:0:0/13:0:0:0/
  |-- block
  |   `-- sdb
  |       |-- subsystem -> ../../../../../../../../../../../class/block

  |       |-- sdb1
  |       |   |-- subsystem -> ../../../../../../../../../../../../class/block

  |       |-- sdb2
  |       |   |-- subsystem -> ../../../../../../../../../../../../class/block

  |-- bsg
  |   `-- 13:0:0:0
  |       |-- subsystem -> ../../../../../../../../../../../class/bsg

  |-- scsi_disk
  |   `-- 13:0:0:0
  |       |-- subsystem -> ../../../../../../../../../../../class/scsi_disk

  |-- scsi_generic
  |   `-- sg2
  |       |-- subsystem -> ../../../../../../../../../../../class/scsi_generic

Kay

