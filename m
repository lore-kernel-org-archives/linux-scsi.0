From: Tejun Heo <htejun@gmail.com>
Subject: Re: [RFC] SCSI EH document
Date: Mon, 29 Aug 2005 18:14:59 +0900
Message-ID: <4312D213.9000402@gmail.com>
References: <20050826035326.GA13392@htj.dyndns.org> <430F8AE0.7080806@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.199]:17633 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1751008AbVH2JPF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Aug 2005 05:15:05 -0400
Received: by wproxy.gmail.com with SMTP id i7so585106wra
        for <linux-scsi@vger.kernel.org>; Mon, 29 Aug 2005 02:15:04 -0700 (PDT)
In-Reply-To: <430F8AE0.7080806@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James.Bottomley@steeleye.com, luben_tuikov@adaptec.com, albertcc@tw.ibm.com, linux-scsi@vger.kernel.org


  Hi, Jeff.

Jeff Garzik wrote:
> Tejun Heo wrote:
> 
>>  Hello, fellow SCSI/ATA developers.
>>
>>  This is the first draft of SCSI EH document.  This document tries to
>> describe how SCSI EH works and what choirs should be done to maintain
>> SCSI midlayer integrity.  It's intended that this document can be used
>> as reference for implementing either fine-grained EH callbacks or
>> single eh_strategy_handler() callback.
>>
>>  I'm pretty sure that I've screwed up in (hopefully) several places,
>> so please correct me.  Also, I have several places where I'm not sure
>> or have questions, those are marked with *VERIFY* and *QUESTION*
>> respectively.  If you know the answer, please let me know.
> 
> 
> Seems sane to me at first glance.
> 
> 
>>     - EH_RESET_TIMER
>>     This indicates that more time is required to finish the
>>     command.  Timer is restarted.  This action is counted as a
>>     retry and only allowed scmd->allowed + 1(!) times.  Once the
>>     limit is reached, EH_NOT_HANDLED action is taken.
>>
>>     *NOTE* This action is racy as the LLDD could finish the scmd
>>     after the timeout has expired but before it's added back.  In
>>     such cases, scsi_done() would think that timeout has occurred
>>     and return without doing anything.  We lose completion and the
>>     command will time out again.
> 
> 
> hmmmm
> 
> 
>> [2-2-2] Post hostt->eh_strategy_handler() SCSI midlayer conditions
>>
>>  The following conditions must be true on exit from the handler.
>>
>>  - shost->host_failed is zero.
>>
>>  - Each scmd's eh_eflags field is cleared.
>>
>>  - Each scmd is in such a state that scsi_setup_cmd_retry() on the
>>    scmd doesn't make any difference.
>>
>>  - shost->eh_cmd_q is cleared.
>>
>>  - Each scmd->eh_entry is cleared.  (*VERIFY* This is currently not
>>    necessary for correct operation, but keep them cleared anyway for
>>    consistency.)
> 
> 
> Both all the list-heads need to be cleared, otherwise there may be list 
> corruption next time the element is added to the list_head.
> 

  scmd->eh_entry is never used as list head.  It's always used as list 
entry.  So, technically, it needs not be cleared, I think.  No?  The 
problem we had was w/ shost->eh_cmd_q not being cleared.

  Thanks.

-- 
tejun
