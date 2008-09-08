From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 1/3] lpfc 8.2.8 v2 : Revert target busy in favor of	transport
 disrupted
Date: Mon, 8 Sep 2008 15:52:31 -0400
Message-ID: <48C5827F.5000005@emulex.com>
References: <1220802716.6747.11.camel@localhost.localdomain> <48C57863.9050705@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:55389 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbYIHTwu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Sep 2008 15:52:50 -0400
In-Reply-To: <48C57863.9050705@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



Mike Christie wrote:
> James Smart wrote:
>> Revert the target busy response in favor of the transport disrupted
>> response for node state transitions.
> 
> Do we hit this code path if some other process has set the lpfc ndlp
> state and is calling fc_remote_port_delete? Or can we end up hitting
> this when the fc rport is FC_PORTSTATE_ONLINE (and not going to get
> deleted)? If the former, I had thought target busy was best because I
> thought it was just when we race with the fc_remote_port_delete and the
> ndlp change, and so I thought in this case we just wanted to fail with
> target busy to reflect that it was due to the race and not the transport
> problem that caused the rport deletion. That may not be logical or right
> though :) I do not care either way. I am mostly asking because if we go
> your route then I will send a patch to change the other fc drivers so
> they all do the same thing for this type of case.

It is the former.  But, chosing to do one over the other probably isn't 
meaningfully different.  For the ndlp checks to fail, it is indeed 
related to the condition that caused the delete. I figured if it's 
deleted, we're better off reporting the disruption now rather than 
later. The main reason I moved this direction is because it is the 
behavior we've been testing with (with real devices) against the new 
fastfail changes.

-- james s
