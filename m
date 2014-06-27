From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: fix deadlock on unload
Date: Thu, 26 Jun 2014 21:18:34 -0700
Message-ID: <1403842714.22367.8.camel@haakon3.risingtidesystems.com>
References: <alpine.LRH.2.02.1406231329430.8277@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1406231329430.8277@file01.intranet.prod.int.rdu2.redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Mikulas,

On Mon, 2014-06-23 at 13:42 -0400, Mikulas Patocka wrote:
> target: fix deadlock on unload
> 
> On uniprocessor preemptible kernel, target core deadlocks on unload. The
> following events happen:
> * iscsit_del_np is called
> * it calls send_sig(SIGINT, np->np_thread, 1);
> * the scheduler switches to the np_thread
> * the np_thread is woken up, it sees that kthread_should_stop() returns
>   false, so it doesn't terminate
> * the np_thread clears signals with flush_signals(current); and goes back
>   to sleep in iscsit_accept_np
> * the scheduler switches back to iscsit_del_np
> * iscsit_del_np calls kthread_stop(np->np_thread);
> * the np_thread is waiting in iscsit_accept_np and it doesn't respond to
>   kthread_stop
> 
> The deadlock could be resolved if the administrator sends SIGINT signal to
> the np_thread with killall -INT iscsi_np
> 
> The reproducible deadlock was introduced in commit
> db6077fd0b7dd41dc6ff18329cec979379071f87, but the thread-stopping code was
> racy even before.
> 
> This patch fixes the problem. Using kthread_should_stop to stop the
> np_thread is unreliable, so we test np_thread_state instead. If
> np_thread_state equals ISCSI_NP_THREAD_SHUTDOWN, the thread exits.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org
> 

Apologies for the delayed response..

Applied to target-pending/master and including in the next -rc3 PULL
request.

Also FYI, I've added '3.12+' to the stable tag to match how far back
commit db6077fd0 has been included in stable.

Thanks,

--nab
