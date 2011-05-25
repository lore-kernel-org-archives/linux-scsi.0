From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/2] mvsas: add support for Task collector mode and fixed
 relative bugs
Date: Wed, 25 May 2011 13:41:47 -0700
Message-ID: <BANLkTi=xZnK6--p0gp+MAH1aRRJsPw9=Lg@mail.gmail.com>
References: <mvsas-support-task-collector-mode>
	<1303825011-6345-1-git-send-email-yxlraid@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1303825011-6345-1-git-send-email-yxlraid@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: yxlraid@gmail.com
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, yuxiangl@marvell.com, jfeng@marvell.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 26, 2011 at 6:36 AM,  <yxlraid@gmail.com> wrote:
> From: Xiangliang Yu <yuxiangl@marvell.com>
>
> 1.Add support for Task collector mode.
> 2.Fixed relative collector mode bug:
> - I/O failed when disks is on two ports
> - system hang when hotplug disk
> - system hang when unplug disk during run IO
> 3.Unlock ap->lock within .lldd_execute_task for direct mode to improv=
e performance

Can you share more details about the performance impact?  Seems like
this should be made generic across all libsas drivers... see below.

[..]
> +static int mvs_task_exec(struct sas_task *task, const int num, gfp_t=
 gfp_flags,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct =
completion *completion, int is_tmf,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct =
mvs_tmf_task *tmf)
> +{
> + =A0 =A0 =A0 struct domain_device *dev =3D task->dev;
> + =A0 =A0 =A0 struct mvs_info *mvi =3D NULL;
> + =A0 =A0 =A0 u32 rc =3D 0;
> + =A0 =A0 =A0 u32 pass =3D 0;
> + =A0 =A0 =A0 unsigned long flags =3D 0;
> +
> + =A0 =A0 =A0 mvi =3D ((struct mvs_device *)task->dev->lldd_dev)->mvi=
_info;
> +
> + =A0 =A0 =A0 if ((dev->dev_type =3D=3D SATA_DEV) && (dev->sata_dev.a=
p !=3D NULL))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irq(dev->sata_dev.ap->lock)=
;
> +
> + =A0 =A0 =A0 spin_lock_irqsave(&mvi->lock, flags);

This is fine in current code, but isn't it dangerous to assume that
libata is the only agent that might have interrupts disabled?
Especially confusing since this code turns around and uses
spin_lock_irqsave() as the very next step, which leaves a casual
reader wondering what the appropriate lock level is.

Any objections to unifying this lock management in libsas to relieve
drivers of implementing this differently/incorrectly?  I'll send a
patch.

Also, we have seen the dev->sata_dev.ap =3D=3D NULL problem as well.  H=
ave
not fully tracked it down (are we issuing i/o before
sas_ata_init_host_and_port?).  But again, shouldn't libsas be making
guarantees about the state of the sata device?  At least pm8001 and
current isci still get this wrong.  And it would be better to fix it
once for all drivers.

--
Dan
