From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [patch] target: make one-bit bitfields unsigned
Date: Mon, 16 Jan 2012 18:28:47 -0800
Message-ID: <1326767327.3600.39.camel@haakon2.linux-iscsi.org>
References: <20120115113024.GE20463@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20120115113024.GE20463@elgon.mountain>
Sender: target-devel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Joern Engel <joern@logfs.org>, Roland Dreier <roland@kernel.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 2012-01-15 at 14:30 +0300, Dan Carpenter wrote:
> Signed bitfields are a problem because instead of being 1 or 0 like
> you'd expect they are 0 and -1.  It doesn't cause a problem in this case
> but sparse complains:
> 
> drivers/target/iscsi/iscsi_target_core.h:564:56: error: dubious one-bit
> signed bitfield
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/target/iscsi/iscsi_target_core.h b/drivers/target/iscsi/iscsi_target_core.h
> index f1a02da..ebf81fd 100644
> --- a/drivers/target/iscsi/iscsi_target_core.h
> +++ b/drivers/target/iscsi/iscsi_target_core.h
> @@ -561,8 +561,8 @@ struct iscsi_conn {
>  	struct hash_desc	conn_tx_hash;
>  	/* Used for scheduling TX and RX connection kthreads */
>  	cpumask_var_t		conn_cpumask;
> -	int			conn_rx_reset_cpumask:1;
> -	int			conn_tx_reset_cpumask:1;
> +	unsigned int		conn_rx_reset_cpumask:1;
> +	unsigned int		conn_tx_reset_cpumask:1;
>  	/* list_head of struct iscsi_cmd for this connection */
>  	struct list_head	conn_cmd_list;
>  	struct list_head	immed_queue_list;
> --

Applied to lio-core.  Thanks Dan!
