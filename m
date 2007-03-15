From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 4/4] fc class: use transport host byte values
Date: Thu, 15 Mar 2007 09:41:59 -0400
Message-ID: <45F94D27.2090006@emulex.com>
References: <11739019681346-git-send-email-michaelc@cs.wisc.edu> <11739019693216-git-send-email-michaelc@cs.wisc.edu> <11739019703157-git-send-email-michaelc@cs.wisc.edu> <45F865D2.9020201@cs.wisc.edu>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:47739 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933549AbXCONmN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Mar 2007 09:42:13 -0400
In-Reply-To: <45F865D2.9020201@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

Background:
   The states, in the transport are:
      event               state
     --------------------------------
       n/a                running
     lose connectivity    blocked
     fastfail timeout     still blocked, but with fastfail indicator
     dev_loss timeout     unblocked/removed

Question:

The chkready helper in the transport catches race conditions where the
block is being put in place, but queuecommand is running on another cpu,
thus returning DID_IMM_RETRY.

Your patch is updating chkready to look for the case when fastfail has
fired, and returning DID_TRANSPORT_FASTFAIL  ?  Why ?  The request
queue would be blocked so there should be no call to queuecommand that
would fall into this category - unless you are assuming that fastfail
timeout is so fast that it could fall into the same race condition as
blocked.

What I think is right is - DID_TRANSPORT_FASTFAIL only is returned by
the drivers on the i/o they kill as part of the terminate_io function
invoked by fastfail (or on the new block queue kill request I mentioned
an email ago).  There should be no reason to add it to chkready unless
you are trying to be absolutely protective for the above race conditions.
(and hey - it makes sense that if you involve the request queue to kill
all io at fast fail, there won't be any io to call queuecommand for, and
even if it did get through, it'll be marked for requeuing to the request
queue who will note the fastfail kill has been called and can immediately
give it back to the upper layers with the proper status).

-- james s


