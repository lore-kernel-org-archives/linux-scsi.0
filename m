From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH] isci: filter broadcast change notifications during
 SMP phy resets
Date: Mon, 27 Jun 2011 09:49:34 -0500
Message-ID: <4E08987E.9000809@linux.vnet.ibm.com>
References: <20110624194109.26706.58553.stgit@localhost6.localdomain6> <4E0894EC.2010509@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:48451 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab1F0OuH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Jun 2011 10:50:07 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e8.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5REcF00031880
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jun 2011 10:38:15 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p5REnkXo766030
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jun 2011 10:49:47 -0400
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p5R8n99Q009212
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jun 2011 02:49:10 -0600
In-Reply-To: <4E0894EC.2010509@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-scsi@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, dmilburn@redhat.com, jack_wang@usish.com, Jeff Skirvin <jeffrey.d.skirvin@intel.com>, yuxiangl@marvell.com, hch@lst.de

On 06/27/2011 09:34 AM, Hannes Reinecke wrote:
> On 06/24/2011 09:48 PM, Dan Williams wrote:
>> From: Jeff Skirvin<jeffrey.d.skirvin@intel.com>
>>
>> When resetting a sata device in the domain we have seen occasions where
>> libsas prematurely marks a device gone in the time it takes for the
>> device to re-establish the link.  This plays badly with software raid
>> arrays.  Other libsas drivers have non-uniform delays in their reset
>> handlers to try to cover this condition, but not sufficient to close the
>> hole.  Given that a sata device can take many seconds to recover we
>> filter bcns and poll for the device reattach state before notifying
>> libsas that the port needs the domain to be rediscovered.  Once this has
>> been proven out at the lldd level we can think about uplevelling this
>> feature to a common implementation in libsas.
>>
> That's the second time something like this have come up now.
> Wouldn't it makes sense to implement something like the dev_loss_tmo mechanism with have for FC? That should cover this situation nicely ...

Yes. This would help with some non FC multipath environments as well. It would be
nice to have dev_loss_tmo / fast_io_fail_tmo available independent of the
transport class. 

-Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


