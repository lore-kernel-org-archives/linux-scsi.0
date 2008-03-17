From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [patch] convert the scsi layer to use struct device
Date: Mon, 17 Mar 2008 00:15:25 -0400
Message-ID: <47DDF05D.8060608@emulex.com>
References: <20080313210655.GA13468@kroah.com>	 <1205514958.2904.27.camel@localhost.localdomain>	 <1205529619.2904.87.camel@localhost.localdomain>	 <1205531922.3522.57.camel@lov.site>	 <1205590788.6767.12.camel@localhost.localdomain>	 <1205594256.3109.53.camel@lov.site>	 <1205597776.6767.40.camel@localhost.localdomain>	 <1205604260.3109.133.camel@lov.site>  <47DD8139.1040802@emulex.com> <1205701470.11374.66.camel@lov.site>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:52235 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbYCQEPi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Mar 2008 00:15:38 -0400
In-Reply-To: <1205701470.11374.66.camel@lov.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, Tony Jones <tonyj@suse.de>



Kay Sievers wrote:
>> Well, the <classname> prefix came about because there was namespace overlap
>> between different classes (e.g. scsi_host and fc_host classes use the same name,
>> and I think where we originally saw this was in the way serial ports were enumerated
>> for some base systems as well).
>>
>> So I don't see how you can kill the <classname>:<devname> names by SYSFS_DEPRECATED.
> 
> With SYSFS_DEPRECATED, nothing will change. But these links don't exist
> with !SYSFS_DEPRECATED, because the class devices live in
> subdirectories, named after the class they come from, there is no
> namespace problem, or any problem to find these devices, you don't even
> need readdir() to look them up.

Ok, it should have read :
   I don't see how you can kill the <classname>:<devname> names w/ !SYSFS_DEPRECATED.

You still haven't answered my question about namespace overlap. What happens when the
device belongs to multiple classes, and the classes have the same name for the class
device ?   I don't believe we ever want to be in the case where the classes have to
understand a global namespace.

I know this exists a couple of places, because it's what drove us to using the "<class_nm>:"
prefix in the beginning.  Additionally, I know of several utilities that found a lot
of benefit to having the class name. For example, the different transports in scsi all
use the same names for their devices, which overlap with the scsi_host name. The utility
could use the prefix to understand what class the device belonged to. What do you have
to replace this with ? - a symlink to the /sys/class symlink ?  a pattern matching on
what attributes exist (and optional attributes make this ugly) ?   a new sysfs attributes
in the object, say class, that spits out the class name ?
Keeping the prefix may also be useful to distinguish between class devices and real
child devices.

-- james s
