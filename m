From: "Bhanu Prakash Gollapudi" <bprakash-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/4] bnx2fc: Remove bh disable in softirq
	context
Date: Wed, 29 Feb 2012 23:26:39 -0800
Message-ID: <4F4F24AF.4030406@broadcom.com>
References: <1330370574-11983-1-git-send-email-nhorman@tuxdriver.com>
 <1330370574-11983-3-git-send-email-nhorman@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <1330370574-11983-3-git-send-email-nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
List-Unsubscribe: <https://lists.open-fcoe.org/mailman/options/devel>,
 <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.open-fcoe.org/mailman/listinfo/devel>,
 <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
Cc: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devel-s9riP+hp16TNLxjTenLetw@public.gmane.org" <devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>, "James E.J. Bottomley" <JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 2/27/2012 11:22 AM, Neil Horman wrote:
> As with the fcoe sw transport, the bnx2fc packet handler function runs only in
> softirq context.  Theres no need to disable bottom halves here
>
> Signed-off-by: Neil Horman<nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
> CC: Bhanu Prakash Gollapudi<bprakash-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> CC: "James E.J. Bottomley"<JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> CC: Vasu Dev<vasu.dev-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> CC: robert.w.love-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
> ---
>   drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> index 8c6156a..34b4a34 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> @@ -440,13 +440,13 @@ static int bnx2fc_rcv(struct sk_buff *skb, struct net_device *dev,
>   	fr->fr_dev = lport;
>
>   	bg =&bnx2fc_global;
> -	spin_lock_bh(&bg->fcoe_rx_list.lock);
> +	spin_lock(&bg->fcoe_rx_list.lock);
>
>   	__skb_queue_tail(&bg->fcoe_rx_list, skb);
>   	if (bg->fcoe_rx_list.qlen == 1)
>   		wake_up_process(bg->thread);
>
> -	spin_unlock_bh(&bg->fcoe_rx_list.lock);
> +	spin_unlock(&bg->fcoe_rx_list.lock);
>
>   	return 0;
>   err:
Changes look good to me.  Thanks.

Acked-by: Bhanu Prakash Gollapudi <bprakash-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
