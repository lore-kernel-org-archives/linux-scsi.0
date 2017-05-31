From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH] iscsi-target: Fix initial login PDU asynchronous socket
 close OOPs
Date: Wed, 31 May 2017 15:28:36 -0500
Message-ID: <592F2774.8010901@redhat.com>
References: <1495776751-4746-1-git-send-email-nab@linux-iscsi.org>
 <5928EF2C.6090609@redhat.com>
 <1496206723.27407.119.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1496206723.27407.119.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.com>, Sagi Grimberg <sagi@grimberg.me>, Varun Prakash <varun@chelsio.com>
List-Id: linux-scsi@vger.kernel.org

On 05/30/2017 11:58 PM, Nicholas A. Bellinger wrote:
> Hey MNC,
> 
> On Fri, 2017-05-26 at 22:14 -0500, Mike Christie wrote:
>> Thanks for the patch.
>>
> 
> Btw, after running DATERA's internal longevity and scale tests across
> ~20 racks on v4.1.y with this patch over the long weekend, there haven't
> been any additional regressions.
> 
>> On 05/26/2017 12:32 AM, Nicholas A. Bellinger wrote:
>>>  
>>> -	state = iscsi_target_sk_state_check(sk);
>>> -	write_unlock_bh(&sk->sk_callback_lock);
>>> -
>>> -	pr_debug("iscsi_target_sk_state_change: state: %d\n", state);
>>> +		orig_state_change(sk);
>>>  
>>> -	if (!state) {
>>> -		pr_debug("iscsi_target_sk_state_change got failed state\n");
>>> -		schedule_delayed_work(&conn->login_cleanup_work, 0);
>>
>> I think login_cleanup_work is no longer used so you can also remove it
>> and its code.
> 
> Yep, since this needs to goto stable, I left that part out for now..
> 
> Will take care of that post -rc4.
> 
>>
>> The patch fixes the crash for me. However, is there a possible
>> regression where if the initiator attempts new relogins we could run out
>> of memory? With the old code, we would free the login attempts resources
>> at this time, but with the new code the initiator will send more login
>> attempts and so we just keep allocating more memory for each attempt
>> until we run out or the login is finally able to complete.
> 
> AFAICT, no. For the two cases in question:
> 
>  - Initial login request PDU processing done within iscsi_np kthread
> context in iscsi_target_start_negotiation(), and
>  - subsequent login request PDU processing done by delayed work-queue
> kthread context in iscsi_target_do_login_rx() 
> 
> this patch doesn't change how aggressively connection cleanup happens
> for failed login attempts in the face of new connection login attempts
> for either case.
> 
> For the first case when iscsi_np process context invokes
> iscsi_target_start_negotiation() -> iscsi_target_do_login() ->
> iscsi_check_for_session_reinstatement() to wait for backend I/O to
> complete, it still blocks other new connections from being accepted on
> the specific iscsi_np process context.
> 
> This patch doesn't change this behavior.
> 
> What it does change is when the host closes the connection and
> iscsi_target_sk_state_change() gets invoked, iscsi_np process context
> waits for iscsi_check_for_session_reinstatement() to complete before
> releasing the connection resources.
> 
> However since iscsi_np process context is blocked, new connections won't
> be accepted until the new connection forcing session reinstatement
> finishes waiting for outstanding backend I/O to complete.

I was seeing this. My original mail asked about iscsi login resources
incorrectly, but like you said we do not get that far. I get a giant
backlog (1 connection request per 5 seconds that we waited) of tcp level
connection requests and drops. When the wait is done I get a flood of
"iSCSI Login negotiation failed" due to the target handling all those
now stale requests/drops.

If we do not care about the memory use at the network level for this
case (it seems like a little and reconnects are not aggressive), then
patch works ok for me. I am guessing it gets nasty to handle, so maybe
not worth it to handle right now? I tried to do it in my patch which is
why it got all crazy with the waits/wakeups :)

Thanks, and you can add a tested-by or reviewed-by from me.
