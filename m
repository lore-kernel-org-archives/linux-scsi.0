From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] 2.5.x add back missing scsi_queue_next_request calls
Date: Fri, 21 Mar 2003 17:29:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E7B9242.9030200@splentec.com>
References: <20030319184444.A9694@beaverton.ibm.com> <3E7A317A.702@splentec.com> <20030320155215.A16187@beaverton.ibm.com> <3E7B6E25.6010005@splentec.com> <20030321123159.A6684@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
>>So effectively you remove one function call to
>>scsi_queue_next_request(q, NULL) from scsi_end_request(),
>>and in order to accomodate this removal, you rename
>>scsi_put_command() to __scsi_put_command()
>>and then pollute/contaminate the original implementation
>>of scsi_put_command() to include the removed call
>>scsi_queue_next_request().
> 
> 
> No - I'm trying to make sure scsi_queue_next_request() is called for all
> IO, not just block IO.

No problem here.  This okay.

> Please look at all the places scsi_put_command is
> called that I did *not* change.

The problem was messing with the implementation of scsi_put_command().
This was my beef.  Now I'm glad you posted a new patch.

>>Actually, if I were you, I'd try to have only one call, centralized,
>>to scsi_put_command(), and the same for scsi_get_command() in
>>all of SCSI Core.
> 
> 
> That sounds like the patch I posted, just change the name of
> scsi_put_command to scsi_put_command_and_wtf.

The problem is the spaghetti code which will result.

What I meant in ``centralizing'' is the mirroring of the prep
function -- when scsi_get_command() is called, i.e.
from the scsi_prep_fn() <-- only place in SCSI Core.*

* Ignoring of course scsi_reset_provider()...

What's scsi_prep_fn()'s counterpart?  This is where scsi_put_command()
should be called and where a decision should be made as to whether
scsi_queue_next_request() should be called (host reset, hot plugs,
queue depths...)

> I don't see any way around this, I'll post the alternate approach, it is
> worse than I orginally thought since we have to save
> scmd->device->request_queue prior to each scsi_queue_next_request.
> 
> I have no problems with you posting an alternate patch.

Here are a few thoughts on what I'd submit for a patch:
making clean, _homogeneous_ entries in SCSI Core for a
scsi request, and scsi command.  Two of each -- one
blocking and one non-blocking.  Four, total.

Homogeneous in this context means opposite of what scsi_do_req()
does: NOT to export scsi command (via scsi_done() fn for completion)
IF the ULDD has submitted a scsi_request !!!

scsi command is _part_ of scsi request, and SCSI Core instantiates it
as it needs it, so it should NOT be shown back to the ULDD for completion
purposes -- i.e. need another completion function for scsi_requests.

this way you get (block structure):
-------------------------------------------------
	submit a request R via scsi_do_req()

		instantiate a scsi command C,
		hook it up to R, (R->C)

			do work, when done,
			call scsi_done(C)

scsi_done(C):
		do needed work,
		DESTROY scsi command C
		if (R) do minimal work
		and call scsi_done_req(R)

scsi_done_req(R):
	notifies ULDD of completion status

-------------------------------------------------

This is the logical infrastructure and is mirrored
horizontally about ``do work''.

The functional structure would break this apart as those
will become separate functions.

Then you can centralize all code for instantiating
scsi commands et al. AND the code in ``do work'' can
be reused for entities who just submit scsi commands.
(This would involve a double scsi_done() one for the
command and if request, do minimal work and then call
the scsi_done_req() fn.)

This would also allow a more flexible control as the
logical path is well defined.

I *would* submit such a patch only if I had the time.

-- 
Luben



