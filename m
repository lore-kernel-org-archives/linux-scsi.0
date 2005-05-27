From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] Re: sleeping in scsi EH
Date: Fri, 27 May 2005 12:54:44 -0400
Message-ID: <429750D4.2060502@pobox.com>
References: <42968560.7020608@pobox.com> <20050527070954.GA27256@infradead.org> <4296DC49.5020907@pobox.com> <20050527084220.GA29352@infradead.org> <4296FA61.4010003@pobox.com> <42972A72.8060600@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:736 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S262494AbVE0Qyw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 12:54:52 -0400
In-Reply-To: <42972A72.8060600@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Brian King wrote:
> Jeff Garzik wrote:
> 
>>Christoph Hellwig wrote:
>>
>>
>>>On Fri, May 27, 2005 at 04:37:29AM -0400, Jeff Garzik wrote:
>>>
>>>
>>>
>>>>Christoph Hellwig wrote:
>>>>
>>>>
>>>>
>>>>>You can sleep in them.  You must however release the host lock and enable
>>>>>irqs first and reverse that before returning.  The error handlers don't
>>>>>need the host lock, but we're stuck with the unfortunate calling convention
>>>>>for now.
>>>>
>>>>Why are we stuck with this calling convention, when everyone who cares 
>>>>circumvents it?
>>>
>>>
>>>Because no one found the time to do a full transition yet.  If you want to
>>>update all scsi drivers feel free.  One patch per method please.
>>
>>
> 
> Jeff,
> 
> Please add the following patch to your eh_abort locking patch for the ipr driver.
> It fixes a race condition your patch would introduce. Thanks.

Which race is introduced?  The SCSI EH does a lot of synchronization for 
you...

	Jeff



