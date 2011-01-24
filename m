From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 17/32] scsi/ibmvstgt: use system_wq instead of vtgtd workqueue
Date: Mon, 24 Jan 2011 17:09:18 +0100
Message-ID: <AANLkTi=Fg8wjf-XfVsq0X4RWx7i8F1V7gC6-8Y5LPbnL@mail.gmail.com>
References: <1294062595-30097-1-git-send-email-tj@kernel.org> <1294062595-30097-18-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1294062595-30097-18-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>, Robert Jennings <rcj@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 3, 2011 at 2:49 PM, Tejun Heo <tj@kernel.org> wrote:
>
> The target driver is not in the memory reclaim path and doesn't need =
a
> dedicated workqueue. =A0Drop vtgtd and use system_wq instead. =A0The =
used
> work item is sync flushed on removal.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> Cc: linux-scsi@vger.kernel.org
> ---
> Only compile tested. =A0Please feel free to take it into the subsyste=
m
> tree or simply ack - I'll route it through the wq tree.
>
> Thanks.
>
> =A0drivers/scsi/ibmvscsi/ibmvstgt.c | =A0 15 ++++-----------
> =A01 files changed, 4 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/scsi/ibmvscsi/ibmvstgt.c b/drivers/scsi/ibmvscsi=
/ibmvstgt.c
> index 2256bab..47fc632 100644
> --- a/drivers/scsi/ibmvscsi/ibmvstgt.c
> +++ b/drivers/scsi/ibmvscsi/ibmvstgt.c
> @@ -74,7 +74,6 @@ struct vio_port {
> =A0 =A0 =A0 =A0struct srp_rport *rport;
> =A0};
>
> -static struct workqueue_struct *vtgtd;
> =A0static struct scsi_transport_template *ibmvstgt_transport_template=
;
>
> =A0/*
> @@ -546,7 +545,7 @@ static irqreturn_t ibmvstgt_interrupt(int dummy, =
void *data)
> =A0 =A0 =A0 =A0struct vio_port *vport =3D target_to_port(target);
>
> =A0 =A0 =A0 =A0vio_disable_interrupts(vport->dma_dev);
> - =A0 =A0 =A0 queue_work(vtgtd, &vport->crq_work);
> + =A0 =A0 =A0 schedule_work(&vport->crq_work);
>
> =A0 =A0 =A0 =A0return IRQ_HANDLED;
> =A0}
> @@ -900,6 +899,7 @@ static int ibmvstgt_remove(struct vio_dev *dev)
> =A0 =A0 =A0 =A0crq_queue_destroy(target);
> =A0 =A0 =A0 =A0srp_remove_host(shost);
> =A0 =A0 =A0 =A0scsi_remove_host(shost);
> + =A0 =A0 =A0 flush_work_sync(&vport->crq_work);
> =A0 =A0 =A0 =A0scsi_tgt_free_queue(shost);
> =A0 =A0 =A0 =A0srp_target_free(target);
> =A0 =A0 =A0 =A0kfree(vport);
> @@ -967,21 +967,15 @@ static int __init ibmvstgt_init(void)
> =A0 =A0 =A0 =A0if (!ibmvstgt_transport_template)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return err;
>
> - =A0 =A0 =A0 vtgtd =3D create_workqueue("ibmvtgtd");
> - =A0 =A0 =A0 if (!vtgtd)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto release_transport;
> -
> =A0 =A0 =A0 =A0err =3D get_system_info();
> =A0 =A0 =A0 =A0if (err)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto destroy_wq;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto release_transport;
>
> =A0 =A0 =A0 =A0err =3D vio_register_driver(&ibmvstgt_driver);
> =A0 =A0 =A0 =A0if (err)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto destroy_wq;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto release_transport;
>
> =A0 =A0 =A0 =A0return 0;
> -destroy_wq:
> - =A0 =A0 =A0 destroy_workqueue(vtgtd);
> =A0release_transport:
> =A0 =A0 =A0 =A0srp_release_transport(ibmvstgt_transport_template);
> =A0 =A0 =A0 =A0return err;
> @@ -991,7 +985,6 @@ static void __exit ibmvstgt_exit(void)
> =A0{
> =A0 =A0 =A0 =A0printk("Unregister IBM virtual SCSI driver\n");
>
> - =A0 =A0 =A0 destroy_workqueue(vtgtd);
> =A0 =A0 =A0 =A0vio_unregister_driver(&ibmvstgt_driver);
> =A0 =A0 =A0 =A0srp_release_transport(ibmvstgt_transport_template);
> =A0}

(added Brian King and Robert Jennings in CC)

Hello Tejun,

Insertion of  flush_work_sync() fixes a race - that's a good catch.
flush_work_sync() should be invoked a little earlier though because
the scheduled work may access the queue destroyed by the
crq_queue_destroy(target) call. And the CRQ interrupt should be
disabled from before flush_work_sync() is invoked until after the CRQ
has been destroyed.

Regarding the queue removal: I might have missed something, but why
would you like to remove the vtgtd work queue ? Since the ibmvstgt
driver is a storage target driver, processing latency matters. I'm
afraid that switching from a dedicated queue to the global work queue
will increase processing latency.

Bart.
