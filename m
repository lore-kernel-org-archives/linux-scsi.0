From: Or Gerlitz <or.gerlitz@gmail.com>
Subject: Re: [PATCH 09/11] IB/isert: Accept RDMA_WRITE completions
Date: Sat, 11 Jan 2014 23:14:57 +0200
Message-ID: <CAJZOPZKAH6+4XPv-ua13C5skGYZHXB=tnOFT-7FSNZ5SXKhZMA@mail.gmail.com>
References: <1389285658-7037-1-git-send-email-sagig@mellanox.com>
	<1389285658-7037-10-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1389285658-7037-10-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: target-devel <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "oren@mellanox.com" <oren@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 9, 2014 at 6:40 PM, Sagi Grimberg <sagig@mellanox.com> wrote:
> In case of protected transactions, we will need to check the
> protection status of the transaction before sending SCSI response.
> So be ready for RDMA_WRITE completions. currently we don't ask
> for these completions, but for T10-PI we will.
> @@ -1721,9 +1735,9 @@ __isert_send_completion(struct iser_tx_desc *tx_desc,
>                                           isert_conn, ib_dev);
>                 break;
>         case ISER_IB_RDMA_WRITE:
> -               pr_err("isert_send_completion: Got ISER_IB_RDMA_WRITE\n");
> -               dump_stack();
> -               break;
> +               pr_debug("isert_send_completion: Got ISER_IB_RDMA_WRITE\n");
> +               atomic_dec(&isert_conn->post_send_buf_count);
> +               isert_completion_rdma_write(tx_desc, isert_cmd);

are we doing fall through here? why?
>         case ISER_IB_RDMA_READ:
>                 pr_debug("isert_send_completion: Got ISER_IB_RDMA_READ:\n");


>
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
