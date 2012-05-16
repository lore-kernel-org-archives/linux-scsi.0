From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [dm-devel] multipath_busy() stalls IO due to scsi_host_is_busy()
Date: Wed, 16 May 2012 10:27:27 -0500
Message-ID: <4FB3C75F.3070903@cs.wisc.edu>
References: <4FB39D78.9020300@itwm.fraunhofer.de> <1337177200.2985.71.camel@dabdike.int.hansenpartnership.com> <4FB3B9DE.1050903@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37952 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753950Ab2EPP1l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 May 2012 11:27:41 -0400
In-Reply-To: <4FB3B9DE.1050903@itwm.fraunhofer.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 05/16/2012 09:29 AM, Bernd Schubert wrote:
> On 05/16/2012 04:06 PM, James Bottomley wrote:
>> On Wed, 2012-05-16 at 14:28 +0200, Bernd Schubert wrote:
>>> shost->can_queue ->  62 here
>>> shost->host_busy ->  62 when one of the multipath groups does IO,
>>> further
>>> multipath groups then seem to get stalled.
>>>
>>> I'm not sure yet why multipath_busy() does not stall IO when there is a
>>> passive path in the prio group.
>>>
>>> Any idea how to properly address this problem?
>>
>> shost->can_queue is supposed to represent the maximum number of possible
>> outstanding commands per HBA (i.e. the HBA hardware limit).  Assuming
>> the driver got it right, the only way of increasing this is to buy a
>> better HBA.
> 
> HBA is a mellanox IB adapter. I have not checked yet where the limit of

What driver is this with? SRP or iSER or something else?
