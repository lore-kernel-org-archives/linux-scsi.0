From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [RFC PATCH] isci: filter broadcast change notifications during
 SMP phy resets
Date: Mon, 27 Jun 2011 11:59:57 -0400
Message-ID: <4E08A8FD.5080305@interlog.com>
References: <20110624194109.26706.58553.stgit@localhost6.localdomain6> <4E0894EC.2010509@suse.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:39678 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab1F0QAc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Jun 2011 12:00:32 -0400
In-Reply-To: <4E0894EC.2010509@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-scsi@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, dmilburn@redhat.com, jack_wang@usish.com, Jeff Skirvin <jeffrey.d.skirvin@intel.com>, yuxiangl@marvell.com, hch@lst.de

On 11-06-27 10:34 AM, Hannes Reinecke wrote:
> On 06/24/2011 09:48 PM, Dan Williams wrote:
>> From: Jeff Skirvin<jeffrey.d.skirvin@intel.com>
>>
>> When resetting a sata device in the domain we have seen occasions where
>> libsas prematurely marks a device gone in the time it takes for the
>> device to re-establish the link. This plays badly with software raid
>> arrays. Other libsas drivers have non-uniform delays in their reset
>> handlers to try to cover this condition, but not sufficient to close the
>> hole. Given that a sata device can take many seconds to recover we
>> filter bcns and poll for the device reattach state before notifying
>> libsas that the port needs the domain to be rediscovered. Once this has
>> been proven out at the lldd level we can think about uplevelling this
>> feature to a common implementation in libsas.
>>
> That's the second time something like this have come up now.
> Wouldn't it makes sense to implement something like the dev_loss_tmo mechanism
> with have for FC? That should cover this situation nicely ...

"NOTE 112 - An STP initiator port should retry connection
requests for at least the time indicated by the STP
SMP I_T NEXUS LOSS TIME field in the SMP REPORT GENERAL
response for the STP target port to which it is trying to
establish a connection." [spl2r01.pdf 9.4.3.18 page 612]

The recommended value for that field is 2000 (i.e. 2 seconds).
So 2 seconds is not enough in some circumstances?

If so, then writing a larger value to the corresponding field
in the SMP CONFIGURE GENERAL request should stop a SAS-2
self-configuring expander generating a premature Broadcast(Change)
after a SATA disk reset with a SMP PHY CONTROL request.

For SAS-1.1 expanders the LLDD or libsas needs to handle
this case.

Doug Gilbert



