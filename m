From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/3] libsas: fix/amend device gone notification in sas_deform_port()
Date: Thu, 5 May 2011 17:13:44 -0700
Message-ID: <BANLkTikhUQ6b3Y=ZAqOmHF8BtP57DQ4zqg@mail.gmail.com>
References: <20110503183526.21471.84735.stgit@localhost6.localdomain6>
	<20110503183627.21471.57988.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20110503183627.21471.57988.stgit@localhost6.localdomain6>
Sender: linux-ide-owner@vger.kernel.org
To: james.bottomley@suse.de
Cc: Haipao Fan <haipao.fan@intel.com>, linux-scsi@vger.kernel.org, David Milburn <dmilburn@redhat.com>, Maciej Trela <maciej.trela@intel.com>, linux-ide@vger.kernel.org, "Darrick J. Wong" <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, May 3, 2011 at 11:36 AM, Dan Williams <dan.j.williams@intel.com=
> wrote:
> This patch also introduces sas_device_gone() which hopefully allows
> subtle/tricky locking to be dropped from lldd drivers, like the
> following in mvsas which is broken if the ata path is ever converted =
to
> call lldd_execute_task() with irqs enabled:
[..]
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas=
/sas_expander.c
> index 505ffe3..7a785df 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -1721,13 +1721,27 @@ out:
> =A0 =A0 =A0 =A0return res;
> =A0}
>
> +/* FIXME: delete this routine when/if sas_ata stops submitting tasks
> + * with host_lock held
> + */
> +void sas_device_gone(struct domain_device *dev)
> +{
> + =A0 =A0 =A0 struct sas_rphy *rphy =3D dev->rphy;
> + =A0 =A0 =A0 struct Scsi_Host *shost =3D dev_to_shost(rphy->dev.pare=
nt);
> +
> + =A0 =A0 =A0 /* take the lock to synchronize against incoming sata i=
/o */
> + =A0 =A0 =A0 spin_lock_irq(shost->host_lock);
> + =A0 =A0 =A0 dev->gone =3D 1;
> + =A0 =A0 =A0 spin_unlock_irq(shost->host_lock);
> +}

Commit a29b5dad "libata: fix locking for sas paths" has gone in since
this patch was created so this locking no longer has any effect.

Now needs to be dev->sata_dev.ap->lock, will resubmit.

--
Dan
