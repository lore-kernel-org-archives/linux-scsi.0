From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/2] scsi:netlink support in scsi and fc transports forhba
 specific messages
Date: Mon, 04 Aug 2008 02:18:39 -0500
Message-ID: <4896AD4F.2080101@cs.wisc.edu>
References: <0BB3E5E7462EEA4295BC02D49691DC07015B4249@AVEXCH1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:60326 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbYHDHTT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Aug 2008 03:19:19 -0400
In-Reply-To: <0BB3E5E7462EEA4295BC02D49691DC07015B4249@AVEXCH1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Somayajulu <david.somayajulu@qlogic.com>
Cc: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org, David Wagner <david.wagner@qlogic.com>

David Somayajulu wrote:
>> - Your recently added scsi_host_put() was very wrong. You never
>>   had a corresponding get().
> Oops. The version I was looking at for cross reference had a get() in
> scsi_host_lookup() and no corresponding put(). Looks like
> scsi_host_lookup() has changed at some point. (I think Mike Christie was
> under the same impression when he suggested this).

I think you guys are missing the get() from class_find_device or what 
versions are you guys looking at? I have this from scsi-misc from today:

         cdev = class_find_device(&shost_class, &hostnum, 
__scsi_host_match);
         if (cdev) {
                 shost = scsi_host_get(class_to_shost(cdev));
                 put_device(cdev);
         }

If class_find_device finds a device class_find_device does a get on it. +1

If class_find_device found a device (cdev is non null) 
scsi_host_lookup() does another get() on it if the host is not being 
deleted. +1 (total =2)

scsi_host_lookup will then release the get() done from 
class_find_device. -1 (total =1)

So if scsi_host_lookup returns with a host there will be a reference on 
the host that must be released when we are done with it.
