From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] 2.5.x add back missing scsi_queue_next_request calls
Date: Fri, 21 Mar 2003 14:55:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E7B6E25.6010005@splentec.com>
References: <20030319184444.A9694@beaverton.ibm.com> <3E7A317A.702@splentec.com> <20030320155215.A16187@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> On Thu, Mar 20, 2003 at 04:24:10PM -0500, Luben Tuikov wrote:
> 
>>So *ALL* this patch does is REMOVE ONE CALL TO
>>scsi_queue_next_request(q, NULL).
> 
> 
> It effectively adds one call, not removes one call.

Patrick,

Line 81 of your patch removes a function call to
scsi_queue_next_reqeust(q, NULL), as follows:

-	scsi_queue_next_request(q, NULL);

This is in the scsi_end_request() function.

In order to accomodate for this removal,
you contaminate the slab allocation implementation by
introducing ONE MORE needless __scsi_put_command()
function, this is line 9 -- this basically becomes
the original scsi_put_command().

Then you alter the implementation of scsi_put_command()
to include the call to scsi_queue_next_request(q, NULL)
in order to make up for the removed call on line 81.

So effectively you remove one function call to
scsi_queue_next_request(q, NULL) from scsi_end_request(),
and in order to accomodate this removal, you rename
scsi_put_command() to __scsi_put_command()
and then pollute/contaminate the original implementation
of scsi_put_command() to include the removed call
scsi_queue_next_request().

> Anwyay, there is a bug, and it needs to be fixed.

I just want to leave the SCSI command struct allocation
implementation ALONE -- it does its job very nicely and
should be left alone, it should be considered a black
box.

I.e. scsi_get_command(), __scsi_get_command() and scsi_put_command()
should be a black box as far as SCSI Core, ULDD, LLDD are concerned,
just because the memory management may change in the distant
future, without changing the rest of SCSI Core, ULDD and LLDD.

Furthermore, I see MORE parts of SCSI Core become black boxes
and thus SCSI Core's functionality will be defined in terms
of their _interaction_.

> 2) Call scsi_queue_next_request as needed after each scsi_put_command.

Right, this is the one!  Centralize SCSI Core's call to scsi_put_command()
somewhere -- e.g. right before the request is passed back to the
block layer/caller.  At this point we no longer need the scsi command.

As far as SCSI Core is concerned it should have only one call to
scsi_put_command() since char request also go through SCSI Core.

Also the key words here are ``as needed''.  I.e. some callers,
say LLDD, may NOT need to run the queue after scsi_put_command()
since they maybe doing their own freeing of commands for their
own purposes... (but should be allowed to piggyback mem mangmnt to
SCSI Core for command structs).

I.e. scsi_release_request() or in scsi_end_request().

Note that ULDD call scsi_release_request() and this should be ok.

LLDD upon removing a device may call a series of scsi_put_command()
which they called (scsi_get_command()*) when loaded, in which case we
DO NOT want to hit the queue, just so that those commands go
through SCSI Core to come back with errors.

* (for their [LLDD] own functioning)

> This is easy for the upper level drivers if we want to "pollute"
> scsi_release_request().

scsi_release_request() is at higher level than scsi_put_command().

Actually, if I were you, I'd try to have only one call, centralized,
to scsi_put_command(), and the same for scsi_get_command() in
all of SCSI Core.

This way, you'd have a well defined state machine for SCSI Core.

> The usage of scsi_put_command in lower-level
> drivers then requires an export of scsi_queue_next_request.

NO! It does NOT!

It does *only* if your patch is applied as you posted it yesterday.

> Are you OK with approach 2?

Yes.  As far as SCSI struct command allocation (slab) is left ALONE,
and no other functions of the sort are introduced.

-- 
Luben



