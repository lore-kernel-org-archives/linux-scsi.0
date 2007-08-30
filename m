From: James Smart <James.Smart@Emulex.Com>
Subject: Re: returning scsi I/O to SCSI mid layer from Fast IRQ  context
Date: Thu, 30 Aug 2007 08:49:32 -0400
Message-ID: <46D6BCDC.4030501@emulex.com>
References: <149190.47033.qm@web30103.mail.mud.yahoo.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:42443 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbXH3Mtf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Aug 2007 08:49:35 -0400
In-Reply-To: <149190.47033.qm@web30103.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Parav Pandit <paravpandit@yahoo.com>
Cc: linux-scsi@vger.kernel.org

The midlayer is written to accept scsi i/o completion (via scsi_done())
from the context of an interrupt handler.  The scsi_done() path actually
just traverses up the stack a little, then queues the request on a done
queue, and scheduls a softirq thread for actual completion processing.

The belief is the best-performing drivers call the command done routine
from the interrupt handler (otherwise, you may have 2 context switches
before completion processing).

-- james s

Parav Pandit wrote:
> Let me simplify and ask in different way.
> 
> 1. Can I return a scsi I/O by invoking scsi_done()
> from the Fast IRQ context in the Low level SCSI HBA
> driver?
> 
> 2. Is the interrupt handler right place to call
> scsi_done() and invoke SCSI mid layer? or should I
> defer to the DPC thread context?
> 
> Parav
> 
> 
> 
> --- Parav Pandit <paravpandit@yahoo.com> wrote:
> 
>> Hi,
>>
>> A low level SCSI HBA driver can return the I/O back
>> to
>> the OS from various paths.
>>
>> Some of the common possible paths
>> 1, enqueue_command itself
>> 2. Timer handler (at the time of command timeout)
>> 3. Interrupt handler (when a response is received
>> from
>> the storage)
>> 4. DPC handler thread.
>>
>> Whenever an I/O is returned from the interrupt
>> handler
>> by invoking scsi_done callback function, it will
>> invoke the SCSI mid layer.
>>
>> 1. Is it good practice to return call scsi_done
>> callback function from Interrupt handler? 
>> If no, may I know the implications of doing that?
>> (other then blocking the interrupt context for a
>> longer time)
>>
>> 2. if multiple I/Os are returned in a single
>> interrupt, how many  commands should be returned by
>> calling scsi_done before shifting to dpc thread?
>>
>> Regards,
>> Parav Pandit
>>
>>
>>
>>        
>>
> ____________________________________________________________________________________
>> Got a little couch potato? 
>> Check out fun summer activities for kids.
>>
> http://search.yahoo.com/search?fr=oni_on_mail&p=summer+activities+for+kids&cs=bz
>> -
>> To unsubscribe from this list: send the line
>> "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at 
>> http://vger.kernel.org/majordomo-info.html
>>
> 
> 
> 
>        
> ____________________________________________________________________________________Ready for the edge of your seat? 
> Check out tonight's top picks on Yahoo! TV. 
> http://tv.yahoo.com/
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
