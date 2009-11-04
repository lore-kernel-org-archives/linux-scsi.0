From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH -2nd repost 2/4] SCSI: remove unnecessary NULL test
Date: Wed, 04 Nov 2009 10:22:15 -0600
Message-ID: <4AF1AA37.5060500@cs.wisc.edu>
References: <1257351321-8281-1-git-send-email-jirislaby@gmail.com> <1257351321-8281-2-git-send-email-jirislaby@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757068AbZKDQW1@vger.kernel.org>
In-Reply-To: <1257351321-8281-2-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Slaby <jirislaby@gmail.com>
Cc: James.Bottomley@suse.de, Karen Xie <kxie@chelsio.com>, james.smart@emulex.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Adding Karen and removing adaptec since this is chelsio's driver.

Jiri Slaby wrote:
> Stanse found that c3cn is poked many times around in
> cxgb3i_conn_pdu_ready, there is no need to check if it is NULL.
> 
> Remove the test.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: James E.J. Bottomley <James.Bottomley@suse.de>
> ---
>  drivers/scsi/cxgb3i/cxgb3i_pdu.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/cxgb3i/cxgb3i_pdu.c b/drivers/scsi/cxgb3i/cxgb3i_pdu.c
> index 7091050..64bbc28 100644
> --- a/drivers/scsi/cxgb3i/cxgb3i_pdu.c
> +++ b/drivers/scsi/cxgb3i/cxgb3i_pdu.c
> @@ -461,10 +461,8 @@ void cxgb3i_conn_pdu_ready(struct s3_conn *c3cn)
>  		skb = skb_peek(&c3cn->receive_queue);
>  	}
>  	read_unlock(&c3cn->callback_lock);
> -	if (c3cn) {
> -		c3cn->copied_seq += read;
> -		cxgb3i_c3cn_rx_credits(c3cn, read);
> -	}
> +	c3cn->copied_seq += read;
> +	cxgb3i_c3cn_rx_credits(c3cn, read);
>  	conn->rxdata_octets += read;
>  
>  	if (err) {

Looks ok to me. The null check was useless since we access c3cn all over 
the function and would have oopsed before we got there.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
