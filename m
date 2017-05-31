From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] iscsi-target: Fix initial login PDU asynchronous socket
 close OOPs
Date: Tue, 30 May 2017 21:58:43 -0700
Message-ID: <1496206723.27407.119.camel@haakon3.risingtidesystems.com>
References: <1495776751-4746-1-git-send-email-nab@linux-iscsi.org>
         <5928EF2C.6090609@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <5928EF2C.6090609@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Mike Christie <mchristi@redhat.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.com>, Sagi Grimberg <sagi@grimberg.me>, Varun Prakash <varun@chelsio.com>
List-Id: linux-scsi@vger.kernel.org

Hey MNC,

On Fri, 2017-05-26 at 22:14 -0500, Mike Christie wrote:
> Thanks for the patch.
> 

Btw, after running DATERA's internal longevity and scale tests across
~20 racks on v4.1.y with this patch over the long weekend, there haven't
been any additional regressions.

> On 05/26/2017 12:32 AM, Nicholas A. Bellinger wrote:
> >  
> > -	state = iscsi_target_sk_state_check(sk);
> > -	write_unlock_bh(&sk->sk_callback_lock);
> > -
> > -	pr_debug("iscsi_target_sk_state_change: state: %d\n", state);
> > +		orig_state_change(sk);
> >  
> > -	if (!state) {
> > -		pr_debug("iscsi_target_sk_state_change got failed state\n");
> > -		schedule_delayed_work(&conn->login_cleanup_work, 0);
> 
> I think login_cleanup_work is no longer used so you can also remove it
> and its code.

Yep, since this needs to goto stable, I left that part out for now..

Will take care of that post -rc4.

> 
> The patch fixes the crash for me. However, is there a possible
> regression where if the initiator attempts new relogins we could run out
> of memory? With the old code, we would free the login attempts resources
> at this time, but with the new code the initiator will send more login
> attempts and so we just keep allocating more memory for each attempt
> until we run out or the login is finally able to complete.

AFAICT, no. For the two cases in question:

 - Initial login request PDU processing done within iscsi_np kthread
context in iscsi_target_start_negotiation(), and
 - subsequent login request PDU processing done by delayed work-queue
kthread context in iscsi_target_do_login_rx() 

this patch doesn't change how aggressively connection cleanup happens
for failed login attempts in the face of new connection login attempts
for either case.

For the first case when iscsi_np process context invokes
iscsi_target_start_negotiation() -> iscsi_target_do_login() ->
iscsi_check_for_session_reinstatement() to wait for backend I/O to
complete, it still blocks other new connections from being accepted on
the specific iscsi_np process context.

This patch doesn't change this behavior.

What it does change is when the host closes the connection and
iscsi_target_sk_state_change() gets invoked, iscsi_np process context
waits for iscsi_check_for_session_reinstatement() to complete before
releasing the connection resources.

However since iscsi_np process context is blocked, new connections won't
be accepted until the new connection forcing session reinstatement
finishes waiting for outstanding backend I/O to complete.

For the second case of subsequent non initial login request PDUs handled
within delayed work-queue process context, AFAICT this patch doesn't
change the original behavior either..

Namely when iscsi_target_do_login_rx() is active and host closes the
connection causing iscsi_target_sk_state_change() to be invoked, it
still checks for LOGIN_FLAGS_READ_ACTIVE and doesn't queue shutdown to
occur.

As per the original logic preceding this change, it continues to wait
for iscsi_target_do_login_rx() to complete in delayed work-queue
context, unless sock_recvmsg() returns a failure (which it should once
TCP_CLOSE occurs) or times out via iscsi_target_login_timeout().  Once
the failure is detected from iscsi_target_do_login_rx(), the remaining
connection resources are related from there.

That said, was there another case you had in mind..?
