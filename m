From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [RFC 19/34] iscsi-target: clear tx_thread_active
Date: Mon, 15 Feb 2016 19:07:46 +0200
Message-ID: <56C205E2.1000404@dev.mellanox.co.il>
References: <767baf547e8db884caddee17a62da36c4023f8f7.1455467089.git.varun@chelsio.com>
 <179da911feeb6481e0e06eb45f18743be02d6e90.1455467089.git.varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <179da911feeb6481e0e06eb45f18743be02d6e90.1455467089.git.varun@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, roland@kernel.org, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com
List-Id: linux-scsi@vger.kernel.org



On 14/02/2016 19:42, Varun Prakash wrote:
> clear tx_thread_active for ISCSI_TCP_CXGB4
> transport in logout_post_handler functions.
>
> Signed-off-by: Varun Prakash <varun@chelsio.com>
> ---
>   drivers/target/iscsi/iscsi_target.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 858f6e4..3dd7ba2 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -4579,7 +4579,8 @@ static void iscsit_logout_post_handler_closesession(
>   	 * always sleep waiting for RX/TX thread shutdown to complete
>   	 * within iscsit_close_connection().
>   	 */
> -	if (conn->conn_transport->transport_type == ISCSI_TCP)
> +	if ((conn->conn_transport->transport_type == ISCSI_TCP) ||
> +	    (conn->conn_transport->transport_type == ISCSI_TCP_CXGB4))
>   		sleep = cmpxchg(&conn->tx_thread_active, true, false);

Again, this is not the right way to make progress...
