From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Scst-devel] Discussion about SCST sysfs layout and implementation.
Date: Fri, 17 Apr 2009 18:12:15 +0400
Message-ID: <49E88E3F.8030107@vlnb.net>
References: <49E7307A.8000205@vlnb.net> <49E77795.7080204@linux.vnet.ibm.com> <49E85F1C.7040106@vlnb.net> <49E8832F.6070302@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:64484 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbZDQOMQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2009 10:12:16 -0400
In-Reply-To: <49E8832F.6070302@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Debonzi <debonzi@linux.vnet.ibm.com>
Cc: scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Daniel Debonzi, on 04/17/2009 05:25 PM wrote:
>>> Vladislav Bolkhovitin wrote:
>>>> Hi All,
>>>>
>>>> Below is proposal for the SCST sysfs layout, which will replace 
>>>> existing procfs-based infrastructure. Any comments, questions and 
>>>> suggestions are welcome!
>>>>
>>>> I. SCST sysfs layout.
>>>>
>>>> Root would be /sys/scsi_tgt.
>>>>
>>>> In the root there would be the following files and subdirectories:
>>>>
>>>>  - targets - subdirectory listing names of all registered target 
>>>> drivers.
>>>>
>>>>  - devices - subdirectory listing all registered backend devices.
>>>>
>>>>  - sgv - subdirectory listing all existing SGV pools.
>>>>
>>>>  - drivers - subdirectory listing all loaded target and backend 
>>>> drivers (dev handlers).
>>>>
>>>>  - threads - RW file listing number of global SCST threads. Writing 
>>>> to that file would allow to change that value.
>>>>
>>>>  - trace_level - RW file listing SCST core logging level. Writing to 
>>>> that file would allow to change that. Example content: "out_of_mem | 
>>>> minor | pid | line | function | special | mgmt | mgmt_minor | 
>>>> mgmt_dbg | retry". See current procfs implementation of this file for 
>>>> more info.
>>>>
>>>>  - version - RO file listing version of SCST core and enabled compile 
>>>> time features. Example content: "1.0.2, EXTRACHECKS, 
>>>> DEBUG"                                                                                                                          
>>>
>>> Based on all I read this last days, I believe we are not allowed to 
>>> include the directory scsi_tgt on /sys root. I think it has to be in a 
>>> existent directory reserved for this sort of application. I just 
>>> didn't figured out which one it would be.
>> /sys/class? It already has scsi_device, scsi_disk, scsi_generic and 
>> scsi_host.
> 
> I don't think so because all the directories on /sys/class have symlinks 
> to the files somewhere else. However I noticed that many of them on my 
> system are on /sys/device/virtual

Let's go with root in /sys/class/scsi_tgt. In future, if somebody 
objects, we can easily change it.

Vlad
