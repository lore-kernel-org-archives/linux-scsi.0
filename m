From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [libsas PATCH v10 2/9] libsas: cleanup spurious calls to scsi_schedule_eh
Date: Fri, 16 Mar 2012 08:25:56 -0700
Message-ID: <CAA9_cmfL2=Z4Wmoq-GNYr9wSyvvbCFXoP4p6oF1_OJ01UO+UUQ@mail.gmail.com>
References: <20120311043722.27797.97791.stgit@dwillia2-linux.jf.intel.com>
	<20120311043906.27797.28938.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120311043906.27797.28938.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Mar 10, 2012 at 8:39 PM, Dan Williams <dan.j.williams@intel.com=
> wrote:
> eh is woken up automatically by the presence of failed commands,
> scsi_schedule_eh is reserved for cases where there are no failed
> commands. =A0This guarantees that host_eh_sceduled is only incremente=
d
> when an explicit eh request is made.
>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> =A0drivers/scsi/libsas/sas_ata.c =A0 =A0 =A0 | =A0 25 ---------------=
----------
> =A0drivers/scsi/libsas/sas_scsi_host.c | =A0 =A05 -----
> =A0include/scsi/sas_ata.h =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A04 ----
> =A03 files changed, 0 insertions(+), 34 deletions(-)
>
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_=
ata.c
> index bc0cecc..729a7b6 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -574,31 +574,6 @@ int sas_ata_init_host_and_port(struct domain_dev=
ice *found_dev)
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> -void sas_ata_task_abort(struct sas_task *task)
> -{
> - =A0 =A0 =A0 struct ata_queued_cmd *qc =3D task->uldd_task;
> - =A0 =A0 =A0 struct completion *waiting;
> -
> - =A0 =A0 =A0 /* Bounce SCSI-initiated commands to the SCSI EH */
> - =A0 =A0 =A0 if (qc->scsicmd) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct request_queue *q =3D qc->scsicmd=
->device->request_queue;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long flags;
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock_irqsave(q->queue_lock, flags)=
;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 blk_abort_request(qc->scsicmd->request)=
;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irqrestore(q->queue_lock, f=
lags);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 scsi_schedule_eh(qc->scsicmd->device->h=
ost);

Although we don't need this call to scsi_schedule_eh, we certainly
need to handle task->uldd_task differently for ata tasks, will resend.

--
Dan
