From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [RFC PATCH 2/4] scsi error: have scsi-ml call	change_queue_depth
 to handle QUEUE_FULL
Date: Tue, 16 Jun 2009 09:16:15 -0400
Message-ID: <4A379B1F.2070708@emulex.com>
References: <12427123671020-git-send-email-michaelc@cs.wisc.edu> <12427123683166-git-send-email-michaelc@cs.wisc.edu> <1242712369913-git-send-email-michaelc@cs.wisc.edu> <12427123692457-git-send-email-michaelc@cs.wisc.edu> <20090612124849.GA8017@schmichrtp.de.ibm.com> <4A368639.20701@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:43558 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbZFPNQ1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jun 2009 09:16:27 -0400
In-Reply-To: <4A368639.20701@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <linux-driver@qlogic.com>



Mike Christie wrote:
>> This was called because of a "queue full" for one SCSI device. Why do
>> you decrement the queue depth for all SCSI devices on the same host
>> and not only for one device?
>>     
>
> It should actually do it for only the devices on the same target where 
> the problem occurred. I copied the code from lpfc and qla2xxx and cannot 
> remember the reason why this is done now.  I am ccing AndrewV and JamesS.
>
>   

Agree that it should be localized to the target and not propagated to 
all targets.   Our design issue was choosing how to apply the backoff - 
did a queue full on a single lun imply the entire target is full ?  
Thus, should we reduce all luns at that point, or only the lun that saw 
the queue full.   All depends on how fast you want to ramp down the 
overall situation and how biased things get on multiple luns..  And the 
same decision on the ramp up - to we raise everyone, or let the luns 
function independently.  Raising everyone too quickly recauses the 
issue, and why would one hot lun steal capacity/queuing depth for a slow 
lun ?  There's a lot of assumptions being made in this choice on what is 
the gating resource (the io capacity of the target being equally shared 
by all luns).

-- james s


