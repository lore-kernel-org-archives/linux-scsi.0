From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 11/11] qla2xxx: Improve RSCN handling in driver
Date: Wed, 11 Jan 2017 21:05:14 +0000
Message-ID: <1484168700.2619.26.camel@sandisk.com>
References: <1482553419-4117-1-git-send-email-himanshu.madhani@cavium.com>
         <1482553419-4117-12-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1482553419-4117-12-git-send-email-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <34D1FB944733304BACD9B7F331953BA4@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "giridhar.malavali@cavium.com" <giridhar.malavali@cavium.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2016-12-23 at 20:23 -0800, Himanshu Madhani wrote:
> +void qlt_unknown_atio_work_fn(struct delayed_work *work)
> +{
> +	struct scsi_qla_host *vha =3D container_of(work, struct scsi_qla_host,
> +		unknown_atio_work);
> +	qlt_try_to_dequeue_unknown_atios(vha, 0);
> +	return;
> +}
> +
> [ ... ]
> +	INIT_DELAYED_WORK(&base_vha->unknown_atio_work,
> +		(void (*)(struct work_struct *))qlt_unknown_atio_work_fn);

Hello Himanshu and Quinn,

Please follow the approach for delayed work that is followed elsewhere in
the kernel, namely:
* Use struct work_struct * for the argument type of delayed work functions.
* Do not use a function pointer cast in the INIT_DELAYED_WORK() macro.

This change will require to modify the container_of() expression. Here are
two examples from other kernel drivers:

	hctx =3D container_of(work, struct blk_mq_hw_ctx, delay_work.work);

	struct srp_rport *rport =3D container_of(to_delayed_work(work),
					struct srp_rport, reconnect_work);

Thanks,

Bart.=
