From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Mid-layer handling of NOT_READY conditions...
Date: Fri, 28 Jan 2005 21:46:06 -0800
Message-ID: <1106977566.9862.102.camel@plap>
References: <1106954650.9862.61.camel@plap>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch02.qlogic.com ([198.70.193.200]:51371 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S262859AbVA2Fpt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jan 2005 00:45:49 -0500
In-Reply-To: <1106954650.9862.61.camel@plap>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Fri, 2005-01-28 at 15:24 -0800, Andrew Vasquez wrote:
> ...        
> There seems to be two problem with this approach:
> 
>      1. As the storage continues to return NOT_READY,
>         scsi_decide_disposition() blindly increments cmd->retries and
>         checks against cmd->allowed, returning SUCCESS (since at this
>         point cmd->retries is always greater than cmd->allowed) -- I've
>         seen this condition loop several hundred times while the
>         NOT_READY condition clears.
>      2. as a result of the (cmd->retries > cmd->allowed) state of the
>         command, if a LLDD returns any status (other than DID_OK) which
>         could initiate a retry, the command is immediately failed.  As
>         an example, the qla2xxx driver returns DID_BUS_BUSY in case of
>         any 'transport' related problems during the exchange (dropped
>         frames, FCP protocal failures, etc.).
> 
> When the qla2xxx driver managed command queuing internally, a NOT_READY
> status would cause the lun-queue to be frozen for some period time while
> the storage settled-down.
> 

Returning back DID_IMM_RETRY for these 'transport' related conditions
would of course help in this issue -- but at the same time bring with it
several side-effects which may not be desirable.

So, beyond this particular circumstance, what would be considered a
'proper' return status for this type of event? 

> Would this be an approach to consider?  Or should we tackle the problem
> by addressing the quirky (cmd->retries > cmd->allowed) state?
> 

--
Andrew
