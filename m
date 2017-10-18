From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] sd: always retry READ CAPACITY for ALUA state transition
Date: Wed, 18 Oct 2017 07:54:44 +0200
Message-ID: <57c5e714-251a-a67c-5ce9-46205315704b@suse.de>
References: <1508224276-130348-1-git-send-email-hare@suse.de>
 <1508248652.3129.2.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46779 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752090AbdJRFys (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Oct 2017 01:54:48 -0400
In-Reply-To: <1508248652.3129.2.camel@HansenPartnership.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 10/17/2017 03:57 PM, James Bottomley wrote:
> On Tue, 2017-10-17 at 09:11 +0200, Hannes Reinecke wrote:
>> During ALUA state transitions the device might return
>> a sense code 02/04/0a (Logical unit not accessible, asymmetric
>> access state transition). As this is a transient error
>> we should just retry the READ CAPACITY call until
>> the state transition finishes and the correct
>> capacity can be returned.
> 
> This will lock up the system if some ALUA initiator gets into a state
> where it always returns transitioning and never completes, which
> doesn't look like the best way to handle problem devices.
> 
> I thought after the ALUA transition the LUN gives a unit attention ...
> can't you use that some way to trigger the capacity re-read, so do
> asynchronous event notification instead of polling forever.
> 
Hmm.
Will give it a try.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
