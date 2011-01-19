From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [RFC/PATCH] Deferred disk spinup during system resume
Date: Wed, 19 Jan 2011 02:05:31 -0500
Message-ID: <4D368D3B.7030701@pobox.com>
References: <1294795457-9006-1-git-send-email-maksim.rayskiy@gmail.com> <20110112112142.GA9610@mtj.dyndns.org> <4D2DF45B.5010101@pobox.com> <AANLkTikEusD_CvkOERsr_wr7T70g1kuU=JnBJm5ur5Wg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <AANLkTikEusD_CvkOERsr_wr7T70g1kuU=JnBJm5ur5Wg@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Maksim Rayskiy <maksim.rayskiy@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org, Linux IDE mailing list <linux-ide@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 01/12/2011 03:01 PM, Maksim Rayskiy wrote:
>>
>> The bottom line is that this patch simply wants to trigger an ATA command,
>> and return immediately, discarding the command results.  I'm not even sure a
>> "run this command in background, and discard results" facility requires the
>> EH.
>>
>
> This is why I was asking if using a workqueue instead of EH might be a
> better idea.
> EH looks like an overkill here.

A kernel modification might not even be needed.

Have you tried simply issuing READ VERIFY via bsg, and not caring if it 
completes?  bsg should be able to handle an app submitting a command, 
but never checking the 'done' list, right?  A simple shell app could execute

	write(bsg_fd, ... SCSI READ VERIFY command ...)
	exit(0)

to avoid waiting for READ VERIFY command completion, I would hope.

	Jeff



