From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 0/2] target: 64-bit LUN support
Date: Thu, 11 Jun 2015 07:38:04 -0700
Message-ID: <55799D4C.6070505@sandisk.com>
References: <1433918483-46849-1-git-send-email-hare@suse.de>
 <5578699D.6090405@redhat.com> <55792317.5020500@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0089.outbound.protection.outlook.com ([157.56.110.89]:31944
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751133AbbFKOif (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jun 2015 10:38:35 -0400
In-Reply-To: <55792317.5020500@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On 06/10/15 22:56, Hannes Reinecke wrote:
> Actually, I've been thinking about this. Currently I'm not sure if
> we should fully embrace this route; after all, 'scsilun_to_int' is
> meant to be a conversion from the (abstract) LUN number into our
> internal representation.
> And as it's internal we're free to use whatever we like.
>
> Where we need to fix up things is in reporting; whenever we display
> LUN numbers to userspace (printk or sysfs-wise) we probably should
> use the appropriate format.
>
> I'll see if I can whip up a printk format for this.
> Never liked the '%llu' format for LUNs anyway.

Hello Hannes,

Making how LUNs are displayed dependent on the LUN addressing method 
sounds like a good idea to me. One step further would be to ensure that 
the format in which LUNs are entered through configfs matches the format 
used to display LUNs. This may require to add an additional 
configuration parameter in configfs for the LUN addressing format. E.g. 
for users who connect an AIX initiator system to LIO it would be much 
more convenient to use LUN numbers like 1, 2, 3 instead of the raw LUN 
numbers 256, 512, 768.

Thanks,

Bart.
