From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH][RFC] scsi_transport_fc: Implement I_T nexus reset
Date: Sun, 09 Dec 2012 17:31:01 -0600
Message-ID: <50C51F35.2080608@cs.wisc.edu>
References: <1354891880-16159-1-git-send-email-hare@suse.de> <50C23C5A.9090907@cs.wisc.edu> <50C4B0DA.9090904@suse.de> <50C51C9C.3060003@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47044 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202Ab2LIXcA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Dec 2012 18:32:00 -0500
In-Reply-To: <50C51C9C.3060003@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, James Bottomley <jbottomley@parallels.com>

On 12/09/2012 05:19 PM, Mike Christie wrote:
> 
>> > 
>>> >>
>>> >>
>>>> >>> @@ -3266,8 +3271,8 @@ fc_timeout_fail_rport_io(struct work_struct *work)
>>>> >>>       if (rport->port_state != FC_PORTSTATE_BLOCKED)
>>>> >>>           return;
>>>> >>>
>>>> >>> -    rport->flags |= FC_RPORT_FAST_FAIL_TIMEDOUT;
>>>> >>>       fc_terminate_rport_io(rport);
>>>> >>> +    rport->flags |= FC_RPORT_FAST_FAIL_TIMEDOUT;
>>>> >>>   }
>>>> >>>
>>> >>
>>> >> What was the reason for moving this? For the eh case in this patch was
>>> >> it causing IO to be failed with DID_TRANSPORT_FAILFAST when we wanted it
>>> >> failed with some other error.
>>> >>
>> > I wanted to ensure that fc_terminate_rport_io() was run when checking
>> > FC_RPORT_FAST_FAIL_TIMEOUT.
>> > Without the move there is a race window between clearing the flag and
>> > calling fc_terminate_rport_io(), which one might trigger by just
>> > checking the flag.
>> > 
> What code is this? I am not sure what you mean. fc_terminate_rport_io is
> always going to get run. There does not seem to be checks in it for
> FC_RPORT_FAST_FAIL_TIMEOUT.

Ignore this. I misread your mail. I see what you meant.
