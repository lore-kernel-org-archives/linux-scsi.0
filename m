From: Or Gerlitz <or.gerlitz@gmail.com>
Subject: Re: [PATCH 06/11] IB/isert: Initialize T10-PI resources
Date: Sat, 11 Jan 2014 23:09:59 +0200
Message-ID: <CAJZOPZLXNkf9XYFsDa3NcYKyySg2H_ARyrVzomYmbYQVqNRPLQ@mail.gmail.com>
References: <1389285658-7037-1-git-send-email-sagig@mellanox.com>
	<1389285658-7037-7-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1389285658-7037-7-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: target-devel <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "oren@mellanox.com" <oren@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 9, 2014 at 6:40 PM, Sagi Grimberg <sagig@mellanox.com> wrote:
> @@ -557,8 +629,14 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
>                 goto out_mr;
>         }
>
> +       if (pi_support && !device->pi_capable) {
> +               pr_err("Protection information requested but not supported\n");
> +               ret = -EINVAL;
> +               goto out_mr;
> +       }
> +
>         if (device->use_fastreg) {
> -               ret = isert_conn_create_fastreg_pool(isert_conn);
> +               ret = isert_conn_create_fastreg_pool(isert_conn, pi_support);

just a nit, the pi_support bit can be looked up from the isert_conn
struct, isn't it?

>                 if (ret) {
>                         pr_err("Conn: %p failed to create fastreg pool\n",
>                                isert_conn);
> @@ -566,7 +644,7 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
>                 }
>         }
>
> -       ret = isert_conn_setup_qp(isert_conn, cma_id);
> +       ret = isert_conn_setup_qp(isert_conn, cma_id, pi_support);
>         if (ret)
>                 goto out_conn_dev;
>
> @@ -2193,7 +2271,7 @@ isert_fast_reg_mr(struct fast_reg_descriptor *fr_desc,
>         pagelist_len = isert_map_fr_pagelist(ib_dev, sg_start, sg_nents,
>                                              &fr_desc->data_frpl->page_list[0]);
>
> -       if (!fr_desc->valid) {
> +       if (!fr_desc->data_key_valid) {
>                 memset(&inv_wr, 0, sizeof(inv_wr));
>                 inv_wr.opcode = IB_WR_LOCAL_INV;
>                 inv_wr.ex.invalidate_rkey = fr_desc->data_mr->rkey;
> @@ -2225,7 +2303,7 @@ isert_fast_reg_mr(struct fast_reg_descriptor *fr_desc,
>                 pr_err("fast registration failed, ret:%d\n", ret);
>                 return ret;
>         }
> -       fr_desc->valid = false;
> +       fr_desc->data_key_valid = false;
>
>         ib_sge->lkey = fr_desc->data_mr->lkey;
>         ib_sge->addr = fr_desc->data_frpl->page_list[0] + page_off;
> diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
> index 708a069..fab8b50 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.h
> +++ b/drivers/infiniband/ulp/isert/ib_isert.h
> @@ -48,11 +48,21 @@ struct iser_tx_desc {
>         struct ib_send_wr send_wr;
>  } __packed;
>
> +struct pi_context {
> +       struct ib_mr                   *prot_mr;
> +       bool                            prot_key_valid;
> +       struct ib_fast_reg_page_list   *prot_frpl;
> +       struct ib_mr                   *sig_mr;
> +       bool                            sig_key_valid;
> +};
> +
>  struct fast_reg_descriptor {
> -       struct list_head        list;
> -       struct ib_mr            *data_mr;
> -       struct ib_fast_reg_page_list    *data_frpl;
> -       bool                    valid;
> +       struct list_head                list;
> +       struct ib_mr                   *data_mr;
> +       bool                            data_key_valid;
> +       struct ib_fast_reg_page_list   *data_frpl;
> +       bool                            protected;

no need for many bools in one structure... each one needs a bit,
correct? so embed them in one variable

> +       struct pi_context              *pi_ctx;
>  };



>
>  struct isert_rdma_wr {
> @@ -140,6 +150,7 @@ struct isert_cq_desc {
>
>  struct isert_device {
>         int                     use_fastreg;
> +       bool                    pi_capable;

this one (and its such) is/are derived from the ib device
capabilities, so I would suggest to keep a copy of the caps instead of
derived bools

>         int                     cqs_used;
>         int                     refcount;
>         int                     cq_active_qps[ISERT_MAX_CQ];
