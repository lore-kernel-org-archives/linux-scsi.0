From: Sergei Shtylyov <sshtylyov@mvista.com>
Subject: Re: [PATCH 14/24] libsas: prevent double completion of scmds from
 eh
Date: Sat, 17 Dec 2011 17:08:18 +0400
Message-ID: <4EEC9442.8090300@mvista.com>
References: <20111217022912.15036.85808.stgit@localhost6.localdomain6> <20111217023420.15036.51486.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20111217023420.15036.51486.stgit@localhost6.localdomain6>
Sender: linux-ide-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello.

On 17-12-2011 6:34, Dan Williams wrote:

> We invoke task->task_done() to free the task in the eh case, but at t=
his
> point we are prepared for scsi_eh_flush_done_q() to finish off the sc=
md.

> Introduce sas_end_task() to capture the final response status from th=
e
> lldd and free the task.

> Also take the opportunity to kill this warning.
> drivers/scsi/libsas/sas_scsi_host.c: In function =E2=80=98sas_end_tas=
k=E2=80=99:
> drivers/scsi/libsas/sas_scsi_host.c:102:3: warning: case value =E2=80=
=982=E2=80=99 not in enumerated type =E2=80=98enum exec_status=E2=80=99=
 [-Wswitch]

> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>   drivers/scsi/libsas/sas_scsi_host.c |   61 +++++++++++++++++++-----=
-----------
>   include/scsi/libsas.h               |    5 ++-
>   2 files changed, 37 insertions(+), 29 deletions(-)

> diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsa=
s/sas_scsi_host.c
> index f32c628..13aee61 100644
> --- a/drivers/scsi/libsas/sas_scsi_host.c
> +++ b/drivers/scsi/libsas/sas_scsi_host.c
> @@ -49,27 +49,12 @@
>   #include<linux/scatterlist.h>
>   #include<linux/libata.h>
>
> -/* ---------- SCSI Host glue ---------- */
> -
> -static void sas_scsi_task_done(struct sas_task *task)
> +/* record final status and free the task */
> +static void sas_end_task(struct scsi_cmnd *sc, struct sas_task *task=
)
>   {
>   	struct task_status_struct *ts =3D&task->task_status;
> -	struct scsi_cmnd *sc =3D task->uldd_task;
>   	int hs =3D 0, stat =3D 0;
[...]
> @@ -124,10 +109,32 @@ static void sas_scsi_task_done(struct sas_task =
*task)
>   			break;
>   		}
>   	}
> -	ASSIGN_SAS_TASK(sc, NULL);
> +
>   	sc->result =3D (hs<<  16) | stat;
> +	ASSIGN_SAS_TASK(sc, NULL);
>   	list_del_init(&task->list);
>   	sas_free_task(task);
> +}
> +
> +static void sas_scsi_task_done(struct sas_task *task)
> +{
> +	struct scsi_cmnd *sc =3D task->uldd_task;
> +
> +	if (unlikely(task->task_state_flags&  SAS_TASK_STATE_ABORTED)) {
> +		/* Aborted tasks will be completed by the error handler */
> +		SAS_DPRINTK("task done but aborted\n");
> +		return;
> +	}
> +
> +	if (unlikely(!sc)) {
> +		SAS_DPRINTK("task_done called with non existing SCSI cmnd!\n");
> +		list_del_init(&task->list);
> +		sas_free_task(task);
> +		return;
> +	}
> +
> +	ASSIGN_SAS_TASK(sc, NULL);

    Why do it twice -- once here and then in sas_end_task()?

> +	sas_end_task(sc, task);
>   	sc->scsi_done(sc);
>   }

MBR, Sergei
