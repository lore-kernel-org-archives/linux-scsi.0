From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Scst-devel] Discussion about SCST sysfs layout and 	implementation.
Date: Fri, 17 Apr 2009 21:42:31 +0400
Message-ID: <49E8BF87.1040201@vlnb.net>
References: <49E7307A.8000205@vlnb.net> <49E77795.7080204@linux.vnet.ibm.com> 	<49E85F1C.7040106@vlnb.net> <49E8832F.6070302@linux.vnet.ibm.com> 	<ac3eb2510904170724l654b00b4k79156138f9fd926d@mail.gmail.com> 	<49E8A551.7050307@linux.vnet.ibm.com> <ac3eb2510904170903n4fa28bfdud80fe25b61be3c2a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:50451 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758066AbZDQRmZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2009 13:42:25 -0400
In-Reply-To: <ac3eb2510904170903n4fa28bfdud80fe25b61be3c2a@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Daniel Debonzi <debonzi@linux.vnet.ibm.com>, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Kay Sievers, on 04/17/2009 08:03 PM wrote:
> On Fri, Apr 17, 2009 at 17:50, Daniel Debonzi
> <debonzi@linux.vnet.ibm.com> wrote:
>> Do you mean that uses struct device is the right way to do it instead of
>> kobjects or it is just a option to get things on right places into sysfs?
> 
> You can not put kobjects in /sys/devices/ and there will be no
> disconnected kobject tree just for scsi, unless the scsi maintainers
> really want want that, and then they should create their own
> filesystem instead, and not use kobjects at all.

Perhaps I'm missing something, but why do you think sysfs hierarchy for 
a SCSI target subsystem can't be put anywhere, but only in /sys/devices?

Consider /sys/class/scsi_host/ as an example. It is very close to what 
SCST needs.

And don't forget a SCSI target subsystem, basically, has from 
implementation POV in common with the regular SCSI (initiator) subsystem 
only some constants for commands and errors and "SCSI" word in the name. 
All the internal processing is completely different, similarly to 
difference between Firefox and Apache, mutt and sendmail, NFS client and 
server.

>> I don't know this struct closely but my first impression looking to the
>> source code is that it is tied with hardware and has some complexity we
>> probably don't need. What do you think?
> 
> If you want to integrate with the current scsi devices/objects, which
> is the only sensible option I think, you have to use struct device
> devices, kobjects will not get a classification in sysfs, and will be
> invisible for userspace tools unless you do random readdir() in
> /sys/devices/ to find them.
> 
> Kay
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

