From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] 2.5.x add back missing scsi_queue_next_request calls
Date: Thu, 20 Mar 2003 15:52:15 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030320155215.A16187@beaverton.ibm.com>
References: <20030319184444.A9694@beaverton.ibm.com> <3E7A317A.702@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E7A317A.702@splentec.com>; from luben@splentec.com on Thu, Mar 20, 2003 at 04:24:10PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Thu, Mar 20, 2003 at 04:24:10PM -0500, Luben Tuikov wrote:
> Patrick Mansfield wrote:
> > The change to use a pool for scsi_cmnd allocations removed some
> > scsi_queue_next_request calls, this patch restores the calls, and
> > exports scsi_put_command and scsi_get_command.
> 
> And there was a point to this removal.  I did mention it on linux-scsi.
> 
> Look, don't try to make the code look as it did *before* -- there's
> always a point to a change -- I think I mentioned exactly this
> before on linux-scsi...
> 
> So *ALL* this patch does is REMOVE ONE CALL TO
> scsi_queue_next_request(q, NULL).

It effectively adds one call, not removes one call.

Anwyay, there is a bug, and it needs to be fixed.

I see 3 ways to fix this, 2 easy 1 hard:

1) Go with this patch or similiar - if there are strong opinions against
using scsi_put_command I can change the name.

2) Call scsi_queue_next_request as needed after each scsi_put_command.
This is easy for the upper level drivers if we want to "pollute"
scsi_release_request(). The usage of scsi_put_command in lower-level
drivers then requires an export of scsi_queue_next_request.

3) Deeper changes such that command completion code is handled the same
way. This might not be possible without changing upper level drivers, and
We might end up with similiar interfaces to what we have now.

Are you OK with approach 2?

James - what is your take?

-- Patrick Mansfield
