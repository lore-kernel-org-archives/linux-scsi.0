From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] iscsi-target: Fix delayed logout processing greater
 than SECONDS_FOR_LOGOUT_COMP
Date: Thu, 08 Jun 2017 22:29:36 -0700
Message-ID: <1496986176.28997.19.camel@haakon3.risingtidesystems.com>
References: <1496525574-26784-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1496525574-26784-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Mike Christie <mchristi@redhat.com>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

Reviews pretty please..?

On Sat, 2017-06-03 at 21:32 +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch fixes a BUG() in iscsit_close_session() that could be
> triggered when iscsit_logout_post_handler() execution from within
> tx thread context was not run for more than SECONDS_FOR_LOGOUT_COMP
> (15 seconds), and the TCP connection didn't already close before
> then forcing tx thread context to automatically exit.
> 
> This would manifest itself during explicit logout as:
> 
> [33206.974254] 1 connection(s) still exist for iSCSI session to iqn.1993-08.org.debian:01:3f5523242179
> [33206.980184] INFO: NMI handler (kgdb_nmi_handler) took too long to run: 2100.772 msecs
> [33209.078643] ------------[ cut here ]------------
> [33209.078646] kernel BUG at drivers/target/iscsi/iscsi_target.c:4346!
> 
> Normally when explicit logout attempt fails, the tx thread context
> exits and iscsit_close_connection() from rx thread context does the
> extra cleanup once it detects conn->conn_logout_remove has not been
> cleared by the logout type specific post handlers.
> 
> To address this special case, if the logout post handler in tx thread
> context detects conn->tx_thread_active has already been cleared, simply
> return and exit in order for existing iscsit_close_connection()
> logic from rx thread context do failed logout cleanup.
> 
> Reported-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Mike Christie <mchristi@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Cc: stable@vger.kernel.org # 3.14+
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/target/iscsi/iscsi_target.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 0d8f815..c025451 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -4423,8 +4423,11 @@ static void iscsit_logout_post_handler_closesession(
>  	 * always sleep waiting for RX/TX thread shutdown to complete
>  	 * within iscsit_close_connection().
>  	 */
> -	if (!conn->conn_transport->rdma_shutdown)
> +	if (!conn->conn_transport->rdma_shutdown) {
>  		sleep = cmpxchg(&conn->tx_thread_active, true, false);
> +		if (!sleep)
> +			return;
> +	}
>  
>  	atomic_set(&conn->conn_logout_remove, 0);
>  	complete(&conn->conn_logout_comp);
> @@ -4440,8 +4443,11 @@ static void iscsit_logout_post_handler_samecid(
>  {
>  	int sleep = 1;
>  
> -	if (!conn->conn_transport->rdma_shutdown)
> +	if (!conn->conn_transport->rdma_shutdown) {
>  		sleep = cmpxchg(&conn->tx_thread_active, true, false);
> +		if (!sleep)
> +			return;
> +	}
>  
>  	atomic_set(&conn->conn_logout_remove, 0);
>  	complete(&conn->conn_logout_comp);
