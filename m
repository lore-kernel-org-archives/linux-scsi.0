From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/9] target: remove SHUTDOWN_SIGS
Date: Mon, 08 Nov 2010 14:21:09 -0800
Message-ID: <1289254869.27226.84.camel@haakon2.linux-iscsi.org>
References: <20101108155601.872926000@canuck.infradead.org>
	 <20101108155647.434861866@canuck.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:35171 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870Ab0KHW0X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2010 17:26:23 -0500
In-Reply-To: <20101108155647.434861866@canuck.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, Joe Eykholt <jeykholt@cisco.com>

On Mon, 2010-11-08 at 10:56 -0500, Christoph Hellwig wrote:
> plain text document attachment (lio-fix-thread-shutdown)
> In the these days with the kthread API we should never send signals to
> kernel threads, but let start/stop be handled by the kthread helpers.
> 
> Note that the set_user_nice for all threads in the target code does not
> seem particularly nice to the rest of the system.  Please re-evaluate if
> the nice value is nessecary.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This patch is not quite correct as drivers/target/lio-target/ is
currently the last code *not* using linux/kthread.h in the tree.  I
recall running into some issue wrt to kernel sockets + signals during
the original convertion use kthread.h, but I don't recall the specifics
atm.  For now I will drop the lio-target part of this patch, and have a
look at doing this conversion to kthread.h properly during the
drivers/target/lio-target review for Boaz in the upcoming week.

Thanks!

--nab

> 
> Index: lio-core-2.6/drivers/target/lio-target/iscsi_target.c
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/lio-target/iscsi_target.c	2010-11-06 20:36:08.953253984 +0100
> +++ lio-core-2.6/drivers/target/lio-target/iscsi_target.c	2010-11-06 20:37:11.221005277 +0100
> @@ -4524,13 +4524,8 @@ int iscsi_target_tx_thread(void *arg)
>  	struct se_thread_set *ts = (struct se_thread_set *) arg;
>  	struct se_unmap_sg unmap_sg;
>  
> -	{
> -	    char name[20];
> -
> -	    memset(name, 0, 20);
> -	    sprintf(name, "%s/%u", ISCSI_TX_THREAD_NAME, ts->thread_id);
> -	    iscsi_daemon(ts->tx_thread, name, SHUTDOWN_SIGS);
> -	}
> +	set_user_nice(current, -20);
> +	ts->tx_thread = current;
>  
>  restart:
>  	conn = iscsi_tx_thread_pre_handler(ts, TARGET);
> @@ -4877,13 +4872,8 @@ int iscsi_target_rx_thread(void *arg)
>  	struct iovec iov;
>  	struct scatterlist sg;
>  
> -	{
> -	    char name[20];
> -
> -	    memset(name, 0, 20);
> -	    sprintf(name, "%s/%u", ISCSI_RX_THREAD_NAME, ts->thread_id);
> -	    iscsi_daemon(ts->rx_thread, name, SHUTDOWN_SIGS);
> -	}
> +	set_user_nice(current, -20);
> +	ts->rx_thread = current;
>  
>  restart:
>  	conn = iscsi_rx_thread_pre_handler(ts, TARGET);
> Index: lio-core-2.6/drivers/target/lio-target/iscsi_target_core.h
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/lio-target/iscsi_target_core.h	2010-11-06 20:35:44.269003880 +0100
> +++ lio-core-2.6/drivers/target/lio-target/iscsi_target_core.h	2010-11-06 20:37:38.953319148 +0100
> @@ -10,7 +10,6 @@
>  
>  #include <target/target_core_base.h>
>  
> -#define SHUTDOWN_SIGS	(sigmask(SIGKILL)|sigmask(SIGINT)|sigmask(SIGABRT))
>  #define ISCSI_MISC_IOVECS		5
>  #define ISCSI_MAX_DATASN_MISSING_COUNT	16
>  #define ISCSI_TX_THREAD_TCP_TIMEOUT	2
> @@ -258,21 +257,6 @@
>  #define TARGET_ERL_FORCE_TX_TRANSPORT_RESET		16
>  #define TARGET_ERL_FORCE_RX_TRANSPORT_RESET		17
>  
> -/*
> - * Threads and timers
> - */
> -#define iscsi_daemon(thread, name, sigs)		\
> -do {							\
> -	daemonize(name);				\
> -	current->policy = SCHED_NORMAL;			\
> -	set_user_nice(current, -20);			\
> -	spin_lock_irq(&current->sighand->siglock);	\
> -	siginitsetinv(&current->blocked, (sigs));	\
> -	recalc_sigpending();				\
> -	(thread) = current;				\
> -	spin_unlock_irq(&current->sighand->siglock);	\
> -} while (0);
> -
>  #define MOD_TIMER(t, exp) mod_timer(t, (get_jiffies_64() + exp * HZ))
>  #define SETUP_TIMER(timer, t, d, func)			\
>  	timer.expires	= (get_jiffies_64() + t * HZ);	\
> Index: lio-core-2.6/drivers/target/lio-target/iscsi_target_login.c
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/lio-target/iscsi_target_login.c	2010-11-06 20:36:08.941260061 +0100
> +++ lio-core-2.6/drivers/target/lio-target/iscsi_target_login.c	2010-11-06 20:36:42.358255815 +0100
> @@ -1011,12 +1011,8 @@ int iscsi_target_login_thread(void *arg)
>  	struct sockaddr_in sock_in;
>  	struct sockaddr_in6 sock_in6;
>  
> -	{
> -	char name[16];
> -	memset(name, 0, 16);
> -	sprintf(name, "iscsi_np");
> -	iscsi_daemon(np->np_thread, name, SHUTDOWN_SIGS);
> -	}
> +	set_user_nice(current, -20);
> +	np->np_thread = current;
>  
>  	sock = iscsi_target_setup_login_socket(np);
>  	if (!(sock)) {
> Index: lio-core-2.6/drivers/target/target_core_transport.c
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/target_core_transport.c	2010-11-06 20:34:36.070254263 +0100
> +++ lio-core-2.6/drivers/target/target_core_transport.c	2010-11-06 20:35:10.989005277 +0100
> @@ -9053,14 +9053,9 @@ static int transport_processing_thread(v
>  	struct se_device *dev = (struct se_device *) param;
>  	struct se_queue_req *qr;
>  
> -	current->policy = SCHED_NORMAL;
>  	set_user_nice(current, -20);
> -	spin_lock_irq(&current->sighand->siglock);
> -	siginitsetinv(&current->blocked, SHUTDOWN_SIGS);
> -	recalc_sigpending();
> -	spin_unlock_irq(&current->sighand->siglock);
>  
> -	while (!(kthread_should_stop())) {
> +	while (!kthread_should_stop()) {
>  		ret = wait_event_interruptible(dev->dev_queue_obj->thread_wq,
>  				atomic_read(&dev->dev_queue_obj->queue_cnt) ||
>  				kthread_should_stop());
> Index: lio-core-2.6/drivers/target/tcm_fc/tfc_cmd.c
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/tcm_fc/tfc_cmd.c	2010-11-06 20:35:19.325012122 +0100
> +++ lio-core-2.6/drivers/target/tcm_fc/tfc_cmd.c	2010-11-06 20:35:27.377011353 +0100
> @@ -649,10 +649,6 @@ int ft_thread(void *arg)
>  	int ret;
>  
>  	set_user_nice(current, -20);
> -	spin_lock_irq(&current->sighand->siglock);
> -	siginitsetinv(&current->blocked, SHUTDOWN_SIGS);
> -	recalc_sigpending();
> -	spin_unlock_irq(&current->sighand->siglock);
>  
>  	while (!(kthread_should_stop())) {
>  		ret = wait_event_interruptible(qobj->thread_wq,
> Index: lio-core-2.6/include/target/target_core_base.h
> ===================================================================
> --- lio-core-2.6.orig/include/target/target_core_base.h	2010-11-06 20:37:52.400253495 +0100
> +++ lio-core-2.6/include/target/target_core_base.h	2010-11-06 20:37:55.809255241 +0100
> @@ -10,7 +10,6 @@
>  #include "target_core_mib.h"
>  
>  #define TARGET_CORE_MOD_VERSION		"v4.0.0-rc5"
> -#define SHUTDOWN_SIGS	(sigmask(SIGKILL)|sigmask(SIGINT)|sigmask(SIGABRT))
>  
>  /* Used by transport_generic_allocate_iovecs() */
>  #define TRANSPORT_IOV_DATA_BUFFER		5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

