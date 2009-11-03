From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [RFC] iscsi transport : add sgio pass-thru support
Date: Tue, 3 Nov 2009 09:37:03 -0500
Message-ID: <4AF0400F.2030608@emulex.com>
References: <1256853056.7154.6.camel@wookie> <4AEF715C.4030700@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:60960 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbZKCOhN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2009 09:37:13 -0500
In-Reply-To: <4AEF715C.4030700@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, open-iscsi@googlegroups.com

I actually started the patch with this in mind - making a common layer.  I was 
able to commonize:  xx_bsg_destroy_job(), xx_bsg_jobdone(), xx_softirq_done(), 
a helper for the timeout function (chkjobdone()), xx_bsg_map_buffer(), 
xx_req_to_bsgjob(), and xx_bsg_goose_queue().

However, what I was finding was I was jumping through hoops with the data 
structures (whose header where, structures within structures, nested private 
areas, etc).  Additionally, I kept finding chunks of the code flow, which had 
parallels to the items in the common routines, that had to be left within the 
transport (e.g. rx path in transport, tx in common; or vice versa) - e.g. if I 
can't encapsulate both sides of the code flow within the common code I lose 
many of the advantages - I ended up abandoning it  under the guise of 
"complexity==bad"

I can post some of the work to see if you have the same conclusion. Yes, I 
don't like the replication either.

-- james s



Mike Christie wrote:
> James Smart wrote:
>> This patch implements the same infrastructure as found in the FC transport
>> for sgio request/response handling.
>>
>> The patch creates (and exports to userland) a new header - scsi_bsg_iscsi.h
>>
>>
> 
> Sorry for the late reply. I am trying to sell my house and move.
> 
> 
> Based on your experience with fc bsg support, do you think there is some 
> common code? It looks like a lot of this is generic. I just started 
> looking at the fc bsg stuff again, so I am not sure ATM.
> 
