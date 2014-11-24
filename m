From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] libsas: remove task_collector mode
Date: Mon, 24 Nov 2014 09:51:41 +0100
Message-ID: <5472F19D.3070600@suse.de>
References: <1416818502-19584-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35603 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbaKXIvn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2014 03:51:43 -0500
In-Reply-To: <1416818502-19584-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Chen Gang <gang.chen.5i5j@gmail.com>, Dan Williams <dan.j.williams@intel.com>, James Bottomley <JBottomley@Parallels.com>

On 11/24/2014 09:41 AM, Christoph Hellwig wrote:
> The task_collector mode (or "latency_injector", (C) Dan Willians) is =
an
> optional I/O path in libsas that queues up scsi commands instead of
> directly sending it to the hardware.  It generall increases latencies
> to in the optiomal case slightly reduce mmio traffic to the hardware.
>=20
> Only the obsolete aic94xx driver and the mvsas driver allowed to use
> it without recompiling the kernel, and most drivers didn't support it
> at all.
>=20
> Remove the giant blob of code to allow better optimizations for scsi-=
mq
> in the future.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  Documentation/scsi/libsas.txt       |  82 +----------------
>  drivers/scsi/aic94xx/aic94xx.h      |   2 +-
>  drivers/scsi/aic94xx/aic94xx_hwi.c  |   3 +-
>  drivers/scsi/aic94xx/aic94xx_init.c |  11 ---
>  drivers/scsi/aic94xx/aic94xx_task.c |  13 ++-
>  drivers/scsi/isci/init.c            |   2 -
>  drivers/scsi/isci/task.c            | 147 ++++++++++++++------------=
----
>  drivers/scsi/isci/task.h            |   1 -
>  drivers/scsi/libsas/sas_ata.c       |   9 +-
>  drivers/scsi/libsas/sas_expander.c  |   2 +-
>  drivers/scsi/libsas/sas_init.c      |  21 -----
>  drivers/scsi/libsas/sas_internal.h  |   2 -
>  drivers/scsi/libsas/sas_scsi_host.c | 176 +-------------------------=
----------
>  drivers/scsi/mvsas/mv_init.c        |  22 -----
>  drivers/scsi/mvsas/mv_sas.c         | 109 +---------------------
>  drivers/scsi/mvsas/mv_sas.h         |  10 +-
>  drivers/scsi/pm8001/pm8001_init.c   |   2 -
>  drivers/scsi/pm8001/pm8001_sas.c    |  22 +----
>  drivers/scsi/pm8001/pm8001_sas.h    |   3 +-
>  include/scsi/libsas.h               |  14 +--
>  20 files changed, 97 insertions(+), 556 deletions(-)
>=20
> diff --git a/Documentation/scsi/libsas.txt b/Documentation/scsi/libsa=
s.txt
> index 3cc9c78..8cac649 100644
> --- a/Documentation/scsi/libsas.txt
> +++ b/Documentation/scsi/libsas.txt
> @@ -226,9 +226,6 @@ static int register_sas_ha(struct my_sas_ha *my_h=
a)
>  	my_ha->sas_ha.lldd_dev_found =3D my_dev_found;
>  	my_ha->sas_ha.lldd_dev_gone =3D my_dev_gone;
> =20
> -	my_ha->sas_ha.lldd_max_execute_num =3D lldd_max_execute_num; (1)
> -
> -	my_ha->sas_ha.lldd_queue_size =3D ha_can_queue;
>  	my_ha->sas_ha.lldd_execute_task =3D my_execute_task;
> =20
>  	my_ha->sas_ha.lldd_abort_task     =3D my_abort_task;
> @@ -247,28 +244,6 @@ static int register_sas_ha(struct my_sas_ha *my_=
ha)
>  	return sas_register_ha(&my_ha->sas_ha);
>  }
> =20
> -(1) This is normally a LLDD parameter, something of the
> -lines of a task collector.  What it tells the SAS Layer is
> -whether the SAS layer should run in Direct Mode (default:
> -value 0 or 1) or Task Collector Mode (value greater than 1).
> -
> -In Direct Mode, the SAS Layer calls Execute Task as soon as
> -it has a command to send to the SDS, _and_ this is a single
> -command, i.e. not linked.
> -
> -Some hardware (e.g. aic94xx) has the capability to DMA more
> -than one task at a time (interrupt) from host memory.  Task
> -Collector Mode is an optional feature for HAs which support
> -this in their hardware.  (Again, it is completely optional
> -even if your hardware supports it.)
> -
> -In Task Collector Mode, the SAS Layer would do _natural_
> -coalescing of tasks and at the appropriate moment it would
> -call your driver to DMA more than one task in a single HA
> -interrupt. DMBS may want to use this by insmod/modprobe
> -setting the lldd_max_execute_num to something greater than
> -1.
> -
>  (2) SAS 1.1 does not define I_T Nexus Reset TMF.
> =20
>  Events
> @@ -325,71 +300,22 @@ PHYE_SPINUP_HOLD -- SATA is present, COMWAKE no=
t sent.
> =20
>  The Execute Command SCSI RPC:
> =20
> -	int (*lldd_execute_task)(struct sas_task *, int num,
> -				 unsigned long gfp_flags);
> +	int (*lldd_execute_task)(struct sas_task *, gfp_t gfp_flags);
> =20
> -Used to queue a task to the SAS LLDD.  @task is the tasks to
> -be executed.  @num should be the number of tasks being
> -queued at this function call (they are linked listed via
> -task::list), @gfp_mask should be the gfp_mask defining the
> -context of the caller.
> +Used to queue a task to the SAS LLDD.  @task is the task to be execu=
ted.
> +@gfp_mask is the gfp_mask defining the context of the caller.
> =20
>  This function should implement the Execute Command SCSI RPC,
> -or if you're sending a SCSI Task as linked commands, you
> -should also use this function.
> =20
> -That is, when lldd_execute_task() is called, the command(s)
> +That is, when lldd_execute_task() is called, the command
>  go out on the transport *immediately*.  There is *no*
>  queuing of any sort and at any level in a SAS LLDD.
> =20
> -The use of task::list is two-fold, one for linked commands,
> -the other discussed below.
> -
> -It is possible to queue up more than one task at a time, by
> -initializing the list element of struct sas_task, and
> -passing the number of tasks enlisted in this manner in num.
> -
>  Returns: -SAS_QUEUE_FULL, -ENOMEM, nothing was queued;
>  	 0, the task(s) were queued.
> =20
> -If you want to pass num > 1, then either
> -A) you're the only caller of this function and keep track
> -   of what you've queued to the LLDD, or
> -B) you know what you're doing and have a strategy of
> -   retrying.
> -
> -As opposed to queuing one task at a time (function call),
> -batch queuing of tasks, by having num > 1, greatly
> -simplifies LLDD code, sequencer code, and _hardware design_,
> -and has some performance advantages in certain situations
> -(DBMS).
> -
> -The LLDD advertises if it can take more than one command at
> -a time at lldd_execute_task(), by setting the
> -lldd_max_execute_num parameter (controlled by "collector"
> -module parameter in aic94xx SAS LLDD).
> -
> -You should leave this to the default 1, unless you know what
> -you're doing.
> -
> -This is a function of the LLDD, to which the SAS layer can
> -cater to.
> -
> -int lldd_queue_size
> -	The host adapter's queue size.  This is the maximum
> -number of commands the lldd can have pending to domain
> -devices on behalf of all upper layers submitting through
> -lldd_execute_task().
> -
> -You really want to set this to something (much) larger than
> -1.
> -
> -This _really_ has absolutely nothing to do with queuing.
> -There is no queuing in SAS LLDDs.
> -
>  struct sas_task {
>  	dev -- the device this task is destined to
> -	list -- must be initialized (INIT_LIST_HEAD)
>  	task_proto -- _one_ of enum sas_proto
>  	scatter -- pointer to scatter gather list array
>  	num_scatter -- number of elements in scatter
> diff --git a/drivers/scsi/aic94xx/aic94xx.h b/drivers/scsi/aic94xx/ai=
c94xx.h
> index 66cda66..26d4ad9 100644
> --- a/drivers/scsi/aic94xx/aic94xx.h
> +++ b/drivers/scsi/aic94xx/aic94xx.h
> @@ -78,7 +78,7 @@ void asd_dev_gone(struct domain_device *dev);
> =20
>  void asd_invalidate_edb(struct asd_ascb *ascb, int edb_id);
> =20
> -int  asd_execute_task(struct sas_task *, int num, gfp_t gfp_flags);
> +int  asd_execute_task(struct sas_task *task, gfp_t gfp_flags);
> =20
>  void asd_set_dmamode(struct domain_device *dev);
> =20
> diff --git a/drivers/scsi/aic94xx/aic94xx_hwi.c b/drivers/scsi/aic94x=
x/aic94xx_hwi.c
> index 4df867e..9f636a3 100644
> --- a/drivers/scsi/aic94xx/aic94xx_hwi.c
> +++ b/drivers/scsi/aic94xx/aic94xx_hwi.c
> @@ -1200,8 +1200,7 @@ static void asd_start_scb_timers(struct list_he=
ad *list)
>   * Case A: we can send the whole batch at once.  Increment "pending"
>   * in the beginning of this function, when it is checked, in order t=
o
>   * eliminate races when this function is called by multiple processe=
s.
> - * Case B: should never happen if the managing layer considers
> - * lldd_queue_size.
> + * Case B: should never happen.
>   */
>  int asd_post_ascb_list(struct asd_ha_struct *asd_ha, struct asd_ascb=
 *ascb,
>  		       int num)
> diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94=
xx/aic94xx_init.c
> index 579dc2f..49e4465 100644
> --- a/drivers/scsi/aic94xx/aic94xx_init.c
> +++ b/drivers/scsi/aic94xx/aic94xx_init.c
> @@ -49,14 +49,6 @@ MODULE_PARM_DESC(use_msi, "\n"
>  	"\tEnable(1) or disable(0) using PCI MSI.\n"
>  	"\tDefault: 0");
> =20
> -static int lldd_max_execute_num =3D 0;
> -module_param_named(collector, lldd_max_execute_num, int, S_IRUGO);
> -MODULE_PARM_DESC(collector, "\n"
> -	"\tIf greater than one, tells the SAS Layer to run in Task Collecto=
r\n"
> -	"\tMode.  If 1 or 0, tells the SAS Layer to run in Direct Mode.\n"
> -	"\tThe aic94xx SAS LLDD supports both modes.\n"
> -	"\tDefault: 0 (Direct Mode).\n");
> -
>  static struct scsi_transport_template *aic94xx_transport_template;
>  static int asd_scan_finished(struct Scsi_Host *, unsigned long);
>  static void asd_scan_start(struct Scsi_Host *);
> @@ -710,9 +702,6 @@ static int asd_register_sas_ha(struct asd_ha_stru=
ct *asd_ha)
>  	asd_ha->sas_ha.sas_port=3D sas_ports;
>  	asd_ha->sas_ha.num_phys=3D ASD_MAX_PHYS;
> =20
> -	asd_ha->sas_ha.lldd_queue_size =3D asd_ha->seq.can_queue;
> -	asd_ha->sas_ha.lldd_max_execute_num =3D lldd_max_execute_num;
> -
>  	return sas_register_ha(&asd_ha->sas_ha);
>  }
> =20
> diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94=
xx/aic94xx_task.c
> index 59b86e2..5ff1ce7 100644
> --- a/drivers/scsi/aic94xx/aic94xx_task.c
> +++ b/drivers/scsi/aic94xx/aic94xx_task.c
> @@ -543,8 +543,7 @@ static int asd_can_queue(struct asd_ha_struct *as=
d_ha, int num)
>  	return res;
>  }
> =20
> -int asd_execute_task(struct sas_task *task, const int num,
> -		     gfp_t gfp_flags)
> +int asd_execute_task(struct sas_task *task, gfp_t gfp_flags)
>  {
>  	int res =3D 0;
>  	LIST_HEAD(alist);
> @@ -553,11 +552,11 @@ int asd_execute_task(struct sas_task *task, con=
st int num,
>  	struct asd_ha_struct *asd_ha =3D task->dev->port->ha->lldd_ha;
>  	unsigned long flags;
> =20
> -	res =3D asd_can_queue(asd_ha, num);
> +	res =3D asd_can_queue(asd_ha, 1);
>  	if (res)
>  		return res;
> =20
> -	res =3D num;
> +	res =3D 1;
>  	ascb =3D asd_ascb_alloc_list(asd_ha, &res, gfp_flags);
>  	if (res) {
>  		res =3D -ENOMEM;
> @@ -568,7 +567,7 @@ int asd_execute_task(struct sas_task *task, const=
 int num,
>  	list_for_each_entry(a, &alist, list) {
>  		a->uldd_task =3D t;
>  		t->lldd_task =3D a;
> -		t =3D list_entry(t->list.next, struct sas_task, list);
> +		break;
>  	}
>  	list_for_each_entry(a, &alist, list) {
>  		t =3D a->uldd_task;
> @@ -601,7 +600,7 @@ int asd_execute_task(struct sas_task *task, const=
 int num,
>  	}
>  	list_del_init(&alist);
> =20
> -	res =3D asd_post_ascb_list(asd_ha, ascb, num);
> +	res =3D asd_post_ascb_list(asd_ha, ascb, 1);
>  	if (unlikely(res)) {
>  		a =3D NULL;
>  		__list_add(&alist, ascb->list.prev, &ascb->list);
> @@ -639,6 +638,6 @@ out_err_unmap:
>  out_err:
>  	if (ascb)
>  		asd_ascb_free_list(ascb);
> -	asd_can_dequeue(asd_ha, num);
> +	asd_can_dequeue(asd_ha, 1);
>  	return res;
>  }
Why did you not remove the last argument from asd_can_queue() and
asd_can_dequeue(), too?
With that patch it's always '1' ...

[ .. ]
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/p=
m8001_sas.c
> index 76570e6..b93f289 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -350,7 +350,7 @@ static int sas_find_local_port_id(struct domain_d=
evice *dev)
>    */
>  #define DEV_IS_GONE(pm8001_dev)	\
>  	((!pm8001_dev || (pm8001_dev->dev_type =3D=3D SAS_PHY_UNUSED)))
> -static int pm8001_task_exec(struct sas_task *task, const int num,
> +static int pm8001_task_exec(struct sas_task *task,
>  	gfp_t gfp_flags, int is_tmf, struct pm8001_tmf_task *tmf)
>  {
>  	struct domain_device *dev =3D task->dev;
> @@ -360,7 +360,6 @@ static int pm8001_task_exec(struct sas_task *task=
, const int num,
>  	struct sas_task *t =3D task;
>  	struct pm8001_ccb_info *ccb;
>  	u32 tag =3D 0xdeadbeef, rc, n_elem =3D 0;
> -	u32 n =3D num;
>  	unsigned long flags =3D 0;
> =20
>  	if (!dev->port) {
> @@ -387,18 +386,12 @@ static int pm8001_task_exec(struct sas_task *ta=
sk, const int num,
>  				spin_unlock_irqrestore(&pm8001_ha->lock, flags);
>  				t->task_done(t);
>  				spin_lock_irqsave(&pm8001_ha->lock, flags);
> -				if (n > 1)
> -					t =3D list_entry(t->list.next,
> -							struct sas_task, list);
>  				continue;
>  			} else {
>  				struct task_status_struct *ts =3D &t->task_status;
>  				ts->resp =3D SAS_TASK_UNDELIVERED;
>  				ts->stat =3D SAS_PHY_DOWN;
>  				t->task_done(t);
> -				if (n > 1)
> -					t =3D list_entry(t->list.next,
> -							struct sas_task, list);
>  				continue;
>  			}
>  		}
> @@ -460,9 +453,7 @@ static int pm8001_task_exec(struct sas_task *task=
, const int num,
>  		t->task_state_flags |=3D SAS_TASK_AT_INITIATOR;
>  		spin_unlock(&t->task_state_lock);
>  		pm8001_dev->running_req++;
> -		if (n > 1)
> -			t =3D list_entry(t->list.next, struct sas_task, list);
> -	} while (--n);
> +	} while (0);
>  	rc =3D 0;
>  	goto out_done;
> =20
This 'while' loop can go, too.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
