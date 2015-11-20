From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 00/18] ALUA device handler update, part 1
Date: Fri, 20 Nov 2015 14:58:18 -0800
Message-ID: <564FA58A.8040006@sandisk.com>
References: <1447081703-110552-1-git-send-email-hare@suse.de>
 <20151120104710.GA24871@lst.de> <564EFB65.6050603@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0070.outbound.protection.outlook.com ([65.55.169.70]:40384
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759616AbbKTW6X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Nov 2015 17:58:23 -0500
In-Reply-To: <564EFB65.6050603@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Jamed Bottomley <jbottomley@odin.com>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.com>, Ewan Milne <emilne@redhat.com>

On 11/20/2015 02:52 AM, Hannes Reinecke wrote:
> One thing, though: I don't really agree with Barts objection that
> moving to a workqueue would tie in too many resources.
> Thing is, I'm not convinces that using a work queue is allocating
> too many resources (we're speaking of 460 vs 240 bytes here).
> Also we have to retry commands for quite some time (cite the
> infamous NetApp takeover/giveback, which can take minutes).
> If we were to handle that without workqueue we'd have to initiate
> the retry from the end_io callback, causing a quite deep stack
> recursion. Which I'm not really fond of.

Hello Hannes,

Sorry if I wasn't clear enough in my previous e-mail about this topic 
but I'm more concerned about the additional memory needed for thread 
stacks and thread control data structures than about the additional 
memory needed for the workqueue. I'd like to see the ALUA device handler 
implementation scale to thousands of LUNs and target port groups. In 
case all connections between an initiator and a target port group fail, 
with a synchronous implementation of STPG we will either need a large 
number of threads (in case of one thread per STPG command) or the STPG 
commands will be serialized (if there are fewer threads than portal 
groups). Neither alternative looks attractive to me.

BTW, not all storage arrays need STPG retries. Some arrays are able to 
process an STPG command quickly (this means within a few seconds).

A previous discussion about this topic is available e.g. at 
http://thread.gmane.org/gmane.linux.scsi/105340/focus=105601.

Bart.
