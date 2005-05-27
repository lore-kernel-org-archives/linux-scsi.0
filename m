From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH] Re: sleeping in scsi EH
Date: Fri, 27 May 2005 12:35:21 -0500
Message-ID: <42975A59.8030902@us.ibm.com>
References: <42968560.7020608@pobox.com> <20050527070954.GA27256@infradead.org> <4296DC49.5020907@pobox.com> <20050527084220.GA29352@infradead.org> <4296FA61.4010003@pobox.com> <42972A72.8060600@us.ibm.com> <429750D4.2060502@pobox.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:34226 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262528AbVE0Rfa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 13:35:30 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j4RHZSNi027070
	for <linux-scsi@vger.kernel.org>; Fri, 27 May 2005 13:35:28 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j4RHZSRS121662
	for <linux-scsi@vger.kernel.org>; Fri, 27 May 2005 13:35:28 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j4RHZMqG007619
	for <linux-scsi@vger.kernel.org>; Fri, 27 May 2005 13:35:23 -0400
In-Reply-To: <429750D4.2060502@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Jeff Garzik wrote:
> Brian King wrote:
> 
>>Jeff Garzik wrote:
>>
>>
>>>Christoph Hellwig wrote:
>>>
>>>
>>>
>>>>On Fri, May 27, 2005 at 04:37:29AM -0400, Jeff Garzik wrote:
>>>>
>>>>
>>>>
>>>>
>>>>>Christoph Hellwig wrote:
>>>>>
>>>>>
>>>>>
>>>>>
>>>>>>You can sleep in them.  You must however release the host lock and enable
>>>>>>irqs first and reverse that before returning.  The error handlers don't
>>>>>>need the host lock, but we're stuck with the unfortunate calling convention
>>>>>>for now.
>>>>>
>>>>>Why are we stuck with this calling convention, when everyone who cares 
>>>>>circumvents it?
>>>>
>>>>
>>>>Because no one found the time to do a full transition yet.  If you want to
>>>>update all scsi drivers feel free.  One patch per method please.
>>>
>>>
>>Jeff,
>>
>>Please add the following patch to your eh_abort locking patch for the ipr driver.
>>It fixes a race condition your patch would introduce. Thanks.
> 
> 
> Which race is introduced?  The SCSI EH does a lot of synchronization for 
> you...

I could get an interrupt from the adapter signaling a fatal error, which then prompts
ipr to reset the card by running BIST on it. The in_reset_reload indicates ipr is
currently doing this. While the card is running BIST, very bad things happen if you
try to do mmio's to the card, which is why I need to check this flag and send the
abort to the adapter while holding the host lock.

Brian

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
