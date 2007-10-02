From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 10/16] gdth: gdth_get_status() return pointer to host
 not its index
Date: Tue, 02 Oct 2007 13:04:23 +0200
Message-ID: <470225B7.9010204@panasas.com>
References: <46FFFC8C.6080804@panasas.com> <47000270.8000209@panasas.com> <20070930212628.GC13343@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sa14.bezeqint.net ([192.115.104.29]:56140 "EHLO
	sa14.bezeqint.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbXJBLEa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 07:04:30 -0400
In-Reply-To: <20070930212628.GC13343@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com, linux-scsi <linux-scsi@vger.kernel.org>

On Sun, Sep 30 2007 at 23:26 +0200, Christoph Hellwig <hch@infradead.org> wrote:
> On Sun, Sep 30, 2007 at 10:09:20PM +0200, Boaz Harrosh wrote:
>>   - Return the interrupting host and not it's index.
>>     NULL if intr is not by gdth.
>>   - fix calling site
>>
>>   FIXME:
>>    Why are we looping on all cards? the passed dev_id
>>    can be used for pinpointing the exact interrupting
>>    card. The kernel is already looping on all sharing
>>    cards so this code makes it O(n^2).
> 
> This is just pre-historic code that makes no sense whatover in a modern
> kernel.  I'd much prefer to stop doing this and use dev_id properly.
> 
OK I'm attempting just that but please look in with me on the code
I have some questions.

>>    What is that polling mode? can we pass dev_id to
>>    gdth_get_status() and do a poll only if dev_id is
>>    NULL?
> 
> Just loop over all host adapters in gdth_wait instead and pass in the
> ha pointer.
> 

[Issue 1]
  In gdth_get_status() the first check is if(ha->irq == passed_in_irq)
  if not than no status read is attempted and 0 is returned. In this
  case gdth_interrupt() will return with out doing any advancement of states.

  Now gdth_wait() calls with gdth_interrupt(ha->irq, ha) so it means that in
  effect current code will loop on all devices but will actually read the status
  of only the waiting on card.

  [Q1] So am I safe in just dropping the loop even from gdth_wait() ?
  [Q2] When gdth_interrupt() is called by the kernel am I guaranteed that irq will
  match the ha->irq that is passed as dev_id? (Since that is what I registered
  as my interrupt routine)

[Issue 2]
  In gdth_wait() and gdth_interrupt() the globals 
  "gdth_from_wait", "wait_hanum" and "wait_index" give me the creeps.
  We are talking about hotplug API and proper lucking of adapter's list
  and this thing is just plain don't work with more than one card.

  [Q1] Do you understand all that business with gdth_polling and gdth_wait()?
       It looks like if you do gdth_polling==true than you can have only one
       card. Is that true?
  [Q2] Should I fix that? I thought of doing a __gdth_interrupt() that is called
       by gdth_interrupt() and passes all these members on the stack as parameters
       to __gdth_interrupt().
       (Actually most of them will be dropped they will not be needed)

Boaz


