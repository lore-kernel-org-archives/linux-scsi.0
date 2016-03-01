From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC 19/34] iscsi-target: clear tx_thread_active
Date: Tue, 1 Mar 2016 06:59:05 -0800
Message-ID: <20160301145905.GF9738@infradead.org>
References: <cover.1455467089.git.varun@chelsio.com>
 <179da911feeb6481e0e06eb45f18743be02d6e90.1455467089.git.varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <179da911feeb6481e0e06eb45f18743be02d6e90.1455467089.git.varun@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, nab@linux-iscsi.org, roland@kernel.org, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com
List-Id: linux-scsi@vger.kernel.org

On Sun, Feb 14, 2016 at 11:12:13PM +0530, Varun Prakash wrote:
> clear tx_thread_active for ISCSI_TCP_CXGB4
> transport in logout_post_handler functions.
> 
> Signed-off-by: Varun Prakash <varun@chelsio.com>
> ---
>  drivers/target/iscsi/iscsi_target.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 858f6e4..3dd7ba2 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -4579,7 +4579,8 @@ static void iscsit_logout_post_handler_closesession(
>  	 * always sleep waiting for RX/TX thread shutdown to complete
>  	 * within iscsit_close_connection().
>  	 */
> -	if (conn->conn_transport->transport_type == ISCSI_TCP)
> +	if ((conn->conn_transport->transport_type == ISCSI_TCP) ||
> +	    (conn->conn_transport->transport_type == ISCSI_TCP_CXGB4))
>  		sleep = cmpxchg(&conn->tx_thread_active, true, false);

Just move the call to iscsit_response_queue, and this is handled much
saner.

>  
>  	atomic_set(&conn->conn_logout_remove, 0);
> @@ -4596,7 +4597,8 @@ static void iscsit_logout_post_handler_samecid(
>  {
>  	int sleep = 1;
>  
> -	if (conn->conn_transport->transport_type == ISCSI_TCP)
> +	if ((conn->conn_transport->transport_type == ISCSI_TCP) ||
> +	    (conn->conn_transport->transport_type == ISCSI_TCP_CXGB4))
>  		sleep = cmpxchg(&conn->tx_thread_active, true, false);

Same here.
