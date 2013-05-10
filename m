From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [PATCH] scsi: Allow error handling timeout to be specified
Date: Fri, 10 May 2013 14:09:36 +0100
Message-ID: <518CF190.5040309@redhat.com>
References: <yq1fvxvedg6.fsf@sermon.lab.mkp.net> <1368189791.3319.31.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658Ab3EJNKS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 May 2013 09:10:18 -0400
In-Reply-To: <1368189791.3319.31.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, michaelc@cs.wisc.edu

On 05/10/2013 01:43 PM, Ewan Milne wrote:
> On Thu, 2013-05-09 at 23:11 -0400, Martin K. Petersen wrote:
>> Introduce eh_timeout which can be used for error handling purposes. This
>> was previously hardcoded to 10 seconds in the SCSI error handling
>> code. However, for some fast-fail scenarios it is necessary to be able
>> to tune this as it can take several iterations (bus device, target, bus,
>> controller) before we give up.
>>
>> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
>>
>
> Thanks for posting this.  It will be very helpful to have this
> capability, particularly when alternate paths to the device exist.

Ack - this is definitely a step forward but until we have better eh 
behaviour for FC the benefits are pretty limited. This is especially the 
case with large LU counts and certain LLDDs since some impose much 
longer timeouts (e.g. lpfc's 60s TMF timeout).

With 5 LUs presented and a single dd driving IO on lpfc I see a time to 
fail an IO of 10-11m when inducing a fabric fault that blackholes all 
traffic to a particular target port on my test setup.

Looking at where the time is being spent in this example there's around 
200s of TUR waits (3m20) and >500s waiting on TMF timeouts (foreach 
device, BDR, foreach target, etc.):

http://paste.fedoraproject.org/11473/81911241/

Environments with 100s of devices can easily spend an hour or more 
waiting for the eh to do its thing.

Regards,
Bryn.



