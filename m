From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] iscsi-target: Fix initial login PDU asynchronous socket
 close OOPs
Date: Wed, 31 May 2017 16:53:51 -0700
Message-ID: <1496274831.27407.153.camel@haakon3.risingtidesystems.com>
References: <1495776751-4746-1-git-send-email-nab@linux-iscsi.org>
         <5928EF2C.6090609@redhat.com>
         <1496206723.27407.119.camel@haakon3.risingtidesystems.com>
         <592F2774.8010901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <592F2774.8010901@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Mike Christie <mchristi@redhat.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.com>, Sagi Grimberg <sagi@grimberg.me>, Varun Prakash <varun@chelsio.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-05-31 at 15:28 -0500, Mike Christie wrote:
> On 05/30/2017 11:58 PM, Nicholas A. Bellinger wrote:
> > Hey MNC,
> > 
> > On Fri, 2017-05-26 at 22:14 -0500, Mike Christie wrote:
> >> Thanks for the patch.

<SNIP>

> >> The patch fixes the crash for me. However, is there a possible
> >> regression where if the initiator attempts new relogins we could run out
> >> of memory? With the old code, we would free the login attempts resources
> >> at this time, but with the new code the initiator will send more login
> >> attempts and so we just keep allocating more memory for each attempt
> >> until we run out or the login is finally able to complete.
> > 
> > AFAICT, no. For the two cases in question:
> > 
> >  - Initial login request PDU processing done within iscsi_np kthread
> > context in iscsi_target_start_negotiation(), and
> >  - subsequent login request PDU processing done by delayed work-queue
> > kthread context in iscsi_target_do_login_rx() 
> > 
> > this patch doesn't change how aggressively connection cleanup happens
> > for failed login attempts in the face of new connection login attempts
> > for either case.
> > 
> > For the first case when iscsi_np process context invokes
> > iscsi_target_start_negotiation() -> iscsi_target_do_login() ->
> > iscsi_check_for_session_reinstatement() to wait for backend I/O to
> > complete, it still blocks other new connections from being accepted on
> > the specific iscsi_np process context.
> > 
> > This patch doesn't change this behavior.
> > 
> > What it does change is when the host closes the connection and
> > iscsi_target_sk_state_change() gets invoked, iscsi_np process context
> > waits for iscsi_check_for_session_reinstatement() to complete before
> > releasing the connection resources.
> > 
> > However since iscsi_np process context is blocked, new connections won't
> > be accepted until the new connection forcing session reinstatement
> > finishes waiting for outstanding backend I/O to complete.
> 
> I was seeing this. My original mail asked about iscsi login resources
> incorrectly, but like you said we do not get that far. I get a giant
> backlog (1 connection request per 5 seconds that we waited) of tcp level
> connection requests and drops. When the wait is done I get a flood of
> "iSCSI Login negotiation failed" due to the target handling all those
> now stale requests/drops.

Ah, I see what you mean.  The TCP backlog = 256 default can fill up when
a small host side login timeout is used while iscsi_np is blocked
waiting for session reinstatement to complete.

> 
> If we do not care about the memory use at the network level for this
> case (it seems like a little and reconnects are not aggressive), then
> patch works ok for me. I am guessing it gets nasty to handle, so maybe
> not worth it to handle right now? 

Yeah, since it's a issue separate from root cause here, getting this
merged first makes sense.

> I tried to do it in my patch which is why it got all crazy with the waits/wakeups :)
> 

One option to consider is to immediately queue into delayed work-queue
context from iscsi_target_start_negotiation() instead of doing the
iscsi_target_do_login() and session reinstatement from iscsi_np context.

Just taking a quick look, this seems like it would be a pretty
straight-forward change..

> Thanks, and you can add a tested-by or reviewed-by from me.

Great, thanks MNC.

Will send out a PULL request for -rc4 shortly.
