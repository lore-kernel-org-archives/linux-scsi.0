From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: Debugging scsi abort handling ?
Date: Fri, 29 Aug 2014 14:39:54 +1000 (EST)
Message-ID: <alpine.LNX.2.00.1408291419070.29948@nippy.intranet>
References: <53F8AAA8.8040407@redhat.com> <53FAE3CA.6060603@redhat.com> <53FAF80D.2070209@redhat.com> <53FB0FE3.80603@acm.org> <53FB1ACD.1040208@redhat.com> <53FF1AD8.9020800@suse.de> <53FF1DE9.5040605@redhat.com> <53FF1FE8.9060108@redhat.com>
 <53FF2199.4030300@redhat.com> <53FF2283.9000502@redhat.com> <53FF39F7.3070004@suse.de> <53FF430F.5060103@redhat.com> <53FF4709.9040801@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:52125 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbaH2Ekx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Aug 2014 00:40:53 -0400
In-Reply-To: <53FF4709.9040801@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Hans de Goede <hdegoede@redhat.com>, Bart Van Assche <bvanassche@acm.org>, SCSI development list <linux-scsi@vger.kernel.org>


On Thu, 28 Aug 2014, Hannes Reinecke wrote:

> What might happen, though, that the command is already dead and gone by 
> the time you're calling ->scsi_done() (if you call it after eh_abort). 
> So there might not _be_ a command upon which you can call ->scsi_done() 
> to start with.
> 
> Hence any LLDD need to clear up any internal references after a call to 
> eh_XXX to ensure it doesn't call ->scsi_done() an in invalid command.
> 
> So even if the LLDD returns 'FAILED' upon a call to eh_XXX it _still_ 
> needs to clear up the internal reference.

This is a question that has been bothering me too. If the host's 
eh_abort_cmd() method returns FAILED, it seems the mid-layer is liable to 
re-issue the same command to the LLD (?)

> Either that or return 'FAILED' for any later eh_XXX function until the 
> internal references can be cleared up.

So if a command may or may not "exist" after eh_abort_handler() returns 
control to the mid-layer (regardless of SUCCESS or FAILURE), then the LLD 
has to be careful about keeping track of which commands were aborted, if 
those commands are still in the process of cleanup when eh_abort_handler() 
returns.

It's hard to see how that can work when command pointers are only unique 
while a command "exists".

In effect, this would mean that EH functions cannot return at all, until 
the relevant command(s) are completely forgotten by the LLD; and that 
means the LLD itself may have to escalate abort -> device reset -> bus 
reset -> etc instead of simply returning FAILED.

-- 
