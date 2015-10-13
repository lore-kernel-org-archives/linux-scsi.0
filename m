From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCHv5 00/36] asynchronous ALUA device handler
Date: Tue, 13 Oct 2015 08:40:31 -0700
Message-ID: <561D25EF.2060209@sandisk.com>
References: <1443523658-87622-1-git-send-email-hare@suse.de>
 <560AD88B.9050902@sandisk.com> <560BE1DC.9060600@suse.de>
 <560C5509.6050206@sandisk.com> <561CD294.3080905@suse.de>
 <561D1E3E.5030201@sandisk.com> <561D1F7D.7070803@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0086.outbound.protection.outlook.com ([157.56.111.86]:20352
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932341AbbJMPkh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Oct 2015 11:40:37 -0400
In-Reply-To: <561D1F7D.7070803@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <james.bottomley@hansenpartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 10/13/2015 08:13 AM, Hannes Reinecke wrote:
> On 10/13/2015 05:07 PM, Bart Van Assche wrote:
>> On 10/13/2015 02:44 AM, Hannes Reinecke wrote:
>>> I have rebased my patches to 4.3.0-rc5 and didn't see any lockups;
>>> tested with hpsa and lpfc, both mq enabled and disabled.
>>>
>>> Can you check if it's specific to ib_srp? Is there a way to simulate
>>> an ib_srp setup?
>>
>> This infinite loop was due to the scsi_dh_alua handler not being
>> loaded during my test (as mentioned in
>> https://www.mail-archive.com/linux-scsi@vger.kernel.org/msg42645.html).
>
> So it works with that patch?

Hello Hannes,

Manually loading the scsi_dh_alua handler or adding the patch that loads 
that handler again automatically indeed fixed the infinite loop. But I'm 
still very concerned about the scalability issues caused by submitting 
RTPG commands synchronously instead of asynchronously.

Bart.

