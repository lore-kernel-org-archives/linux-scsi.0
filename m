From: Aboo Valappil <aboo@aboo.org>
Subject: Re: Linux Virtual SCSI HBAs and Virtual disks
Date: Wed, 24 Jan 2007 09:12:30 +1100
Message-ID: <45B6884E.9040700@aboo.org>
References: <1e157f74d8578f24c762571c1016aab3@aboo.org> <b43c8fc9882e65d397a6465e6cb7c998@aboo.org> <45B4EAAC.5000008@s5r6.in-berlin.de> <45B60993.9070508@aboo.org> <45B64308.1060703@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ppp245-155.static.internode.on.net ([59.167.245.155]:42769 "EHLO
	goobu.aboo.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933160AbXAWWNL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jan 2007 17:13:11 -0500
In-Reply-To: <45B64308.1060703@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

Stefan Richter wrote:
> Aboo Valappil wrote:
>   
>> I implemented a new IOCTL to remove  this  scsi_host  if the user 
>> process really needs to.  This removal  will first  finish all the SCSI 
>> commands (With the above status results) queued on the scsi_host  (If at 
>> all) and then remove the scsi_host.  Also the module unload will delete 
>> all the scsi_hosts created after finishing all the commands queued with 
>> the above status and sense information.
>>     
>
> This is a valid approach, but probably more useful would be something like:
>   - userspace device server or "modprobe -r" or procfs/sysfs magic or
>     whatever else requests removal of a Scsi_Host (or merely of a single
>     scsi_device),
>   - vscsihba enters scsi_remove_host() or scsi_remove_device(),
>   - SCSI core and upper layers do whatever it takes to withdraw from
>     the respective I-T(-L) nexus gracefully (e.g. synchronize cache,
>     unlock drive door...),
>   
Does this happen automatically when the scsi_remove_host() is called, or 
I have to explicitly tell the upper layers to start shutting down 
gracefully?


