From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Need help with another aic94xx sequencer problem
Date: Thu, 24 Aug 2006 09:22:49 -0500
Message-ID: <1156429369.1024.14.camel@mulgrave.il.steeleye.com>
References: <20060824085841.27630.qmail@web31810.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([64.109.89.108]:4525 "EHLO
	accolon.hansenpartnership.com") by vger.kernel.org with ESMTP
	id S1751577AbWHXOWx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Aug 2006 10:22:53 -0400
In-Reply-To: <20060824085841.27630.qmail@web31810.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: "Tarte, Robert" <Robert_Tarte@adaptec.com>, "Hammer, Jack" <Jack_Hammer@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2006-08-24 at 01:58 -0700, Luben Tuikov wrote:
> The sequencer response is correct but incomplete.  The interpretation
> is a bad compromize between SSP and STP.
> 
> TF_TMF_NO_CTX should be interpreted as TMF_RESP_FUNC_ESUPP to get
> "best of both worlds", and then upper layers would do the proper
> thing depending on the protocol.

OK ... I can do that easily; that should cause the error handler to try
with a bigger hammer.

The next problem is that this actual issue is occurring in
sas_execute_task() which takes no further action if an abort fails.  I
can easily wire in a next level ... would you recommend CLEAR_TASK_SET,
or move straight on to LOGICAL_UNIT_RESET?

James


> Of course your version of my code and my version of my code differ
> somewhat.
> 
> The fix in the sequencer is messy as is the fix in software.
> 

