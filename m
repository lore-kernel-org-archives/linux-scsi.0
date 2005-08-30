From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [RFC] libata new EH document
Date: Tue, 30 Aug 2005 10:32:07 -0400
Message-ID: <43146DE7.1070501@adaptec.com>
References: <20050829061124.GA2725@htj.dyndns.org> <43142279.3070004@tw.ibm.com> <43143461.7040606@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:22422 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932156AbVH3OcM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Aug 2005 10:32:12 -0400
In-Reply-To: <43143461.7040606@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Albert Lee <albertcc@tw.ibm.com>, Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Doug Maxey <dwm@maxeymade.com>

On 08/30/05 06:26, Tejun Heo wrote:
> Albert Lee wrote:
> 
>>>4. Corresponding scmd's result code is set to
>>>   SAM_STAT_CHECK_CONDITION and qc->scsidone() callback is called
>>>   directly.  As we haven't filled sense data,
>>>   scsi_determine_disposition() will return FAILED and SCSI EH will
>>>   be scheduled.  Note that as we directly call qc->scsidone(), qc is
>>>   left intact.
>>> 
>>>
>>
>>Could we get the sense data before calling qc->scsidone()?  (Using the 
>>proposed separate
>>EH qc can keep the original qc intact.)
>>
>>The issue:
>>When a DVD drive returns MEDIUM_ERROR in the sense data, libata doesn't 
>>retry the command.
>>
>>For libata, when scsi_softirq() calls scsi_decide_disposition() and 
>>scsi_check_sense() to determine
>>how to handle the result, scsi_check_sense() always returns "fail" since 
>>the sense data is not there
>>yet. The sense data is requested later in the libata error handler. But 
>>the command has already been
>>considered as an "error".
>>
>>By having the sense data ready before calling qc->scsidone(), we can 
>>make the
>>NEEDS_RETRY work in scsi_softirq().  So, for things like MEDIUM_ERROR, 
>>the device has
>>a chance to retry/recover the error. This seems to be important for 
>>devices with built-in
>>defect management system.
> 
> 
>   There are two ways a scmd can leave EH - retry by scsi_queue_insert() 
> and finish by scsi_finish_cmd().  I think the problem you described can 
> be easily solved by choosing the former method when finishing the qc 
> from EH.  Note that other advanced EH stuff like reconfiguring transport 
> speed also requires retrying, so we will surely have a mechanism for 
> retrying failed qc's from EH.

What is needed is autosense simulation for ATA, so that SCSI Core doesn't
know that the device doesn't support autosense.

So, before a failed command reaches SCSI Core recovery, it should pass by
ATA layer recovery to get sense.

Note: if you send another command for execution after the failed command
_and_ no autosense is provided, then any sense data is lost -- this is further
subject to more rules set forth in SAM and SPC.

	Luben

