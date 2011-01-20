From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [RFC/PATCH] Deferred disk spinup during system resume
Date: Thu, 20 Jan 2011 01:01:08 -0500
Message-ID: <4D37CFA4.6030601@pobox.com>
References: <1294795457-9006-1-git-send-email-maksim.rayskiy@gmail.com> <20110112112142.GA9610@mtj.dyndns.org> <4D2DF45B.5010101@pobox.com> <AANLkTikEusD_CvkOERsr_wr7T70g1kuU=JnBJm5ur5Wg@mail.gmail.com> <4D368D3B.7030701@pobox.com> <AANLkTikcrznVeySm42NDYtWtKJBypSXCRv1QsOBug5zQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <AANLkTikcrznVeySm42NDYtWtKJBypSXCRv1QsOBug5zQ@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Maksim Rayskiy <maksim.rayskiy@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org, Linux IDE mailing list <linux-ide@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 01/19/2011 03:29 PM, Maksim Rayskiy wrote:
>> A kernel modification might not even be needed.
>>
>> Have you tried simply issuing READ VERIFY via bsg, and not caring if it
>> completes?  bsg should be able to handle an app submitting a command, but
>> never checking the 'done' list, right?  A simple shell app could execute
>>
>>         write(bsg_fd, ... SCSI READ VERIFY command ...)
>>         exit(0)
>>
>> to avoid waiting for READ VERIFY command completion, I would hope.
>>
>>         Jeff
>>
>
> My question was how to speed up system resume when he the spinup
> request is coming from sd_resume(). For shell method to work I would
> have to ignore this request entirely and do READ VERIFY when system is
> fully restored.
> Can it be done without kernel modification? Tejun mentioned using
> manage_start_stop flag but had some reservations against it.

Oh, if we're talking about sd_resume(), SCSI definitely has an internal 
mechanism to fire off a request, without blocking and waiting for a 
response.  It does sound like a kernel modification, but it should be 
straightforward via existing APIs.

	Jeff



