From: Tejun Heo <htejun@gmail.com>
Subject: Re: [RFC] libata new EH document
Date: Tue, 30 Aug 2005 19:26:41 +0900
Message-ID: <43143461.7040606@gmail.com>
References: <20050829061124.GA2725@htj.dyndns.org> <43142279.3070004@tw.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <43142279.3070004@tw.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Albert Lee <albertcc@tw.ibm.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Doug Maxey <dwm@maxeymade.com>
List-Id: linux-scsi@vger.kernel.org

Albert Lee wrote:
>>
>> 4. Corresponding scmd's result code is set to
>>    SAM_STAT_CHECK_CONDITION and qc->scsidone() callback is called
>>    directly.  As we haven't filled sense data,
>>    scsi_determine_disposition() will return FAILED and SCSI EH will
>>    be scheduled.  Note that as we directly call qc->scsidone(), qc is
>>    left intact.
>>  
>>
> 
> Could we get the sense data before calling qc->scsidone()?  (Using the 
> proposed separate
> EH qc can keep the original qc intact.)
> 
> The issue:
> When a DVD drive returns MEDIUM_ERROR in the sense data, libata doesn't 
> retry the command.
> 
> For libata, when scsi_softirq() calls scsi_decide_disposition() and 
> scsi_check_sense() to determine
> how to handle the result, scsi_check_sense() always returns "fail" since 
> the sense data is not there
> yet. The sense data is requested later in the libata error handler. But 
> the command has already been
> considered as an "error".
> 
> By having the sense data ready before calling qc->scsidone(), we can 
> make the
> NEEDS_RETRY work in scsi_softirq().  So, for things like MEDIUM_ERROR, 
> the device has
> a chance to retry/recover the error. This seems to be important for 
> devices with built-in
> defect management system.

  There are two ways a scmd can leave EH - retry by scsi_queue_insert() 
and finish by scsi_finish_cmd().  I think the problem you described can 
be easily solved by choosing the former method when finishing the qc 
from EH.  Note that other advanced EH stuff like reconfiguring transport 
speed also requires retrying, so we will surely have a mechanism for 
retrying failed qc's from EH.

  Wouldn't that be enough?

  Thanks.

-- 
tejun
