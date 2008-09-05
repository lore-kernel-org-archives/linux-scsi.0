From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 11/15] lpfc 8.2.8 : Update driver to use new Host byte
 error code DID_TRANSPORT_DISRUPTED
Date: Fri, 05 Sep 2008 09:30:40 -0500
Message-ID: <48C14290.3020509@cs.wisc.edu>
References: <1219629018.7890.41.camel@localhost.localdomain> <1220562498.3276.60.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45417 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbYIEOa5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Sep 2008 10:30:57 -0400
In-Reply-To: <1220562498.3276.60.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Sun, 2008-08-24 at 21:50 -0400, James Smart wrote:
>> Update driver to use new Host byte error code DID_TRANSPORT_DISRUPTED.
>>
>> This patch depends pending upstream patches described in:
>> http://marc.info/?l=linux-scsi&m=121263014808604&w=2
>>
>> Particularly:
>> http://marc.info/?l=linux-scsi&m=121263014908607&w=2
>> which defines DID_TRANSPORT_DISRUPTED.
>>
>> This patch supercedes the lpfc patch in that series:
>> http://marc.info/?l=linux-scsi&m=121263015008616&w=2
> 
> I've got this one, but only partially.  The third hunk doesn't apply:
> 

It is ok and better to drop this part below for target busy. If we 
return target busy in the queuecommand then the we will block it right 
away. If we return DID_TRANSPORT_DISRUPTED then it will not get blocked 
until the soft irq processes the command, which is a waste.


> --- 1072,1078 ----
>   	 * transport is still transitioning.
>   	 */
>   	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)) {
> + 		cmnd->result = ScsiResult(DID_TRANSPORT_DISRUPTED, 0);
>   		goto out_fail_command;
>   	}
> 
> It became a goto out_target_busy, which returns SCSI_MLQUEUE_TARGET_BUSY
> via a patch which you acked.
>

Sorry about that. We were not sure which parts of which patchset you 
were going to take so some wires got crossed.
