From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH] iscsi-target: Fix initial login PDU asynchronous socket
 close OOPs
Date: Fri, 26 May 2017 22:14:52 -0500
Message-ID: <5928EF2C.6090609@redhat.com>
References: <1495776751-4746-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1495776751-4746-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.com>, Sagi Grimberg <sagi@grimberg.me>, Varun Prakash <varun@chelsio.com>
List-Id: linux-scsi@vger.kernel.org

Thanks for the patch.

On 05/26/2017 12:32 AM, Nicholas A. Bellinger wrote:
>  
> -	state = iscsi_target_sk_state_check(sk);
> -	write_unlock_bh(&sk->sk_callback_lock);
> -
> -	pr_debug("iscsi_target_sk_state_change: state: %d\n", state);
> +		orig_state_change(sk);
>  
> -	if (!state) {
> -		pr_debug("iscsi_target_sk_state_change got failed state\n");
> -		schedule_delayed_work(&conn->login_cleanup_work, 0);

I think login_cleanup_work is no longer used so you can also remove it
and its code.

The patch fixes the crash for me. However, is there a possible
regression where if the initiator attempts new relogins we could run out
of memory? With the old code, we would free the login attempts resources
at this time, but with the new code the initiator will send more login
attempts and so we just keep allocating more memory for each attempt
until we run out or the login is finally able to complete.
