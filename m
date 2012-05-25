From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH] scsi: fix hot unplug vs async scan race
Date: Fri, 25 May 2012 08:34:03 -0700
Message-ID: <CAA9_cme9j7n726kOxOupJLd4Tajjic8QwLA_LXk21B7YEH15BA@mail.gmail.com>
References: <20120525075352.27883.81838.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:32784 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab2EYPeE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 May 2012 11:34:04 -0400
Received: by vcbf11 with SMTP id f11so520254vcb.19
        for <linux-scsi@vger.kernel.org>; Fri, 25 May 2012 08:34:03 -0700 (PDT)
In-Reply-To: <20120525075352.27883.81838.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, Mike Christie <michaelc@cs.wisc.edu>, Robert Love <robert.w.love@intel.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Kashyap Desai <kashyap.desai@lsi.com>, Matthew Wilcox <matthew@wil.cx>, Dariusz Majchrzak <dariusz.majchrzak@intel.com>

[ add the folks on the cc ]

On Fri, May 25, 2012 at 12:55 AM, Dan Williams <dan.j.williams@intel.co=
m> wrote:
> The following crash results from cases where the end_device has been
> removed before scsi_sysfs_add_sdev has had a chance to run.
>
> =A0BUG: unable to handle kernel NULL pointer dereference at 000000000=
0000098
> =A0IP: [<ffffffff8115e100>] sysfs_create_dir+0x32/0xb6
> =A0...
> =A0Call Trace:
> =A0[<ffffffff8125e4a8>] kobject_add_internal+0x120/0x1e3
> =A0[<ffffffff81075149>] ? trace_hardirqs_on+0xd/0xf
> =A0[<ffffffff8125e641>] kobject_add_varg+0x41/0x50
> =A0[<ffffffff8125e70b>] kobject_add+0x64/0x66
> =A0[<ffffffff8131122b>] device_add+0x12d/0x63a
> =A0[<ffffffff814b65ea>] ? _raw_spin_unlock_irqrestore+0x47/0x56
> =A0[<ffffffff8107de15>] ? module_refcount+0x89/0xa0
> =A0[<ffffffff8132f348>] scsi_sysfs_add_sdev+0x4e/0x28a
> =A0[<ffffffff8132dcbb>] do_scan_async+0x9c/0x145
>
> ...teach scsi_sysfs_add_devices to check for deleted device before
> trying to add them.
>
> This teaches scsi_transport_sas to bypass scsi_remove_target() since =
it
> is unable to find the target from the end_device rphy since
> device_for_each_child() relies on the target device having gone throu=
gh
> a device_add().
>
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> Cc: Robert Love <robert.w.love@intel.com>
> Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
> Cc: Kashyap Desai <kashyap.desai@lsi.com>
> Cc: Matthew Wilcox <matthew@wil.cx>
> Cc: <stable@vger.kernel.org>
> [stable: v2.6.20+]
> Reported-by: Dariusz Majchrzak <dariusz.majchrzak@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>
> This is larger than I would like, but could not think of better way t=
o
> retrieve the starget from the transport device. =A0Other ideas?
>
> --
> Dan
>
>
> =A0drivers/scsi/scsi_scan.c =A0 =A0 =A0 =A0 =A0| =A0 24 +++++++++++++=
+++--------
> =A0drivers/scsi/scsi_sysfs.c =A0 =A0 =A0 =A0 | =A0 15 ++++++++++++++-
> =A0drivers/scsi/scsi_transport_sas.c | =A0 =A05 +++--
> =A0include/scsi/scsi_device.h =A0 =A0 =A0 =A0| =A0 =A05 +++--
> =A0include/scsi/scsi_transport_sas.h | =A0 =A01 +
> =A05 files changed, 37 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 01b0374..5e00e09 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1562,8 +1562,8 @@ void scsi_rescan_device(struct device *dev)
> =A0}
> =A0EXPORT_SYMBOL(scsi_rescan_device);
>
> -static void __scsi_scan_target(struct device *parent, unsigned int c=
hannel,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int id, unsigned int lun, int =
rescan)
> +static struct scsi_target *__scsi_scan_target(struct device *parent,=
 unsigned int channel,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 unsigned int id, unsigned int lun, int rescan)
> =A0{
> =A0 =A0 =A0 =A0struct Scsi_Host *shost =3D dev_to_shost(parent);
> =A0 =A0 =A0 =A0int bflags =3D 0;
> @@ -1574,11 +1574,11 @@ static void __scsi_scan_target(struct device =
*parent, unsigned int channel,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * Don't scan the host adapter
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
>
> =A0 =A0 =A0 =A0starget =3D scsi_alloc_target(parent, channel, id);
> =A0 =A0 =A0 =A0if (!starget)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
> =A0 =A0 =A0 =A0scsi_autopm_get_target(starget);
>
> =A0 =A0 =A0 =A0if (lun !=3D SCAN_WILD_CARD) {
> @@ -1611,6 +1611,8 @@ static void __scsi_scan_target(struct device *p=
arent, unsigned int channel,
> =A0 =A0 =A0 =A0scsi_target_reap(starget);
>
> =A0 =A0 =A0 =A0put_device(&starget->dev);
> +
> + =A0 =A0 =A0 return starget;
> =A0}
>
> =A0/**
> @@ -1628,23 +1630,26 @@ static void __scsi_scan_target(struct device =
*parent, unsigned int channel,
> =A0* =A0 =A0 First try a REPORT LUN scan, if that does not scan the t=
arget, do a
> =A0* =A0 =A0 sequential scan of LUNs on the target id.
> =A0**/
> -void scsi_scan_target(struct device *parent, unsigned int channel,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int id, unsigned i=
nt lun, int rescan)
> +struct scsi_target *scsi_scan_target(struct device *parent, unsigned=
 int channel,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0unsigned int id, unsigned int lun, int rescan)
> =A0{
> =A0 =A0 =A0 =A0struct Scsi_Host *shost =3D dev_to_shost(parent);
> + =A0 =A0 =A0 struct scsi_target *starget =3D NULL;
>
> =A0 =A0 =A0 =A0if (strncmp(scsi_scan_type, "none", 4) =3D=3D 0)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
>
> =A0 =A0 =A0 =A0mutex_lock(&shost->scan_mutex);
> =A0 =A0 =A0 =A0if (!shost->async_scan)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0scsi_complete_async_scans();
>
> =A0 =A0 =A0 =A0if (scsi_host_scan_allowed(shost) && scsi_autopm_get_h=
ost(shost) =3D=3D 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 __scsi_scan_target(parent, channel, id,=
 lun, rescan);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 starget =3D __scsi_scan_target(parent, =
channel, id, lun, rescan);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0scsi_autopm_put_host(shost);
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0mutex_unlock(&shost->scan_mutex);
> +
> + =A0 =A0 =A0 return starget;
> =A0}
> =A0EXPORT_SYMBOL(scsi_scan_target);
>
> @@ -1714,6 +1719,9 @@ static void scsi_sysfs_add_devices(struct Scsi_=
Host *shost)
> =A0{
> =A0 =A0 =A0 =A0struct scsi_device *sdev;
> =A0 =A0 =A0 =A0shost_for_each_device(sdev, shost) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* target removed before the device cou=
ld be added */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sdev->sdev_state =3D=3D SDEV_DEL)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!scsi_host_scan_allowed(shost) ||
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0scsi_sysfs_add_sdev(sdev) !=3D=
 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__scsi_remove_device(s=
dev);
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 04c2a27..d1293b6 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -993,12 +993,24 @@ void scsi_remove_device(struct scsi_device *sde=
v)
> =A0}
> =A0EXPORT_SYMBOL(scsi_remove_device);
>
> -static void __scsi_remove_target(struct scsi_target *starget)
> +/**
> + * __scsi_remove_target - explicitly remove a target
> + * @starget: specific target to be removed
> + *
> + * This allows a target to be removed regardless of whether it has b=
een
> + * async scanned or not. =A0scsi_remove_target() depends on
> + * device_for_each_child() and will not enumerate children that have=
 not
> + * been through device_add() yet.
> + */
> +void __scsi_remove_target(struct scsi_target *starget)
> =A0{
> =A0 =A0 =A0 =A0struct Scsi_Host *shost =3D dev_to_shost(starget->dev.=
parent);
> =A0 =A0 =A0 =A0unsigned long flags;
> =A0 =A0 =A0 =A0struct scsi_device *sdev;
>
> + =A0 =A0 =A0 if (!starget)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> +
> =A0 =A0 =A0 =A0spin_lock_irqsave(shost->host_lock, flags);
> =A0 =A0 =A0 =A0starget->reap_ref++;
> =A0restart:
> @@ -1016,6 +1028,7 @@ static void __scsi_remove_target(struct scsi_ta=
rget *starget)
> =A0 =A0 =A0 =A0spin_unlock_irqrestore(shost->host_lock, flags);
> =A0 =A0 =A0 =A0scsi_target_reap(starget);
> =A0}
> +EXPORT_SYMBOL_GPL(__scsi_remove_target);
>
> =A0static int __remove_child (struct device * dev, void * data)
> =A0{
> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_tr=
ansport_sas.c
> index f7565fc..3afb38d 100644
> --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -1592,7 +1592,7 @@ int sas_rphy_add(struct sas_rphy *rphy)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0lun =3D 0;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 scsi_scan_target(&rphy->dev, 0, rphy->s=
csi_target_id, lun, 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rphy->starget =3D scsi_scan_target(&rph=
y->dev, 0, rphy->scsi_target_id, lun, 0);
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0return 0;
> @@ -1669,7 +1669,8 @@ sas_rphy_remove(struct sas_rphy *rphy)
>
> =A0 =A0 =A0 =A0switch (rphy->identify.device_type) {
> =A0 =A0 =A0 =A0case SAS_END_DEVICE:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 scsi_remove_target(dev);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 __scsi_remove_target(rphy->starget);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rphy->starget =3D NULL;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0case SAS_EDGE_EXPANDER_DEVICE:
> =A0 =A0 =A0 =A0case SAS_FANOUT_EXPANDER_DEVICE:
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 6efb2e1..7cd0d75 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -368,12 +368,13 @@ extern int scsi_device_quiesce(struct scsi_devi=
ce *sdev);
> =A0extern void scsi_device_resume(struct scsi_device *sdev);
> =A0extern void scsi_target_quiesce(struct scsi_target *);
> =A0extern void scsi_target_resume(struct scsi_target *);
> -extern void scsi_scan_target(struct device *parent, unsigned int cha=
nnel,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int=
 id, unsigned int lun, int rescan);
> +extern struct scsi_target *scsi_scan_target(struct device *parent, u=
nsigned int channel,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 unsigned int id, unsigned int lun, int rescan);
> =A0extern void scsi_target_reap(struct scsi_target *);
> =A0extern void scsi_target_block(struct device *);
> =A0extern void scsi_target_unblock(struct device *);
> =A0extern void scsi_remove_target(struct device *);
> +extern void __scsi_remove_target(struct scsi_target *starget);
> =A0extern void int_to_scsilun(unsigned int, struct scsi_lun *);
> =A0extern int scsilun_to_int(struct scsi_lun *);
> =A0extern const char *scsi_device_state_name(enum scsi_device_state);
> diff --git a/include/scsi/scsi_transport_sas.h b/include/scsi/scsi_tr=
ansport_sas.h
> index 98b3a20..d98dcef 100644
> --- a/include/scsi/scsi_transport_sas.h
> +++ b/include/scsi/scsi_transport_sas.h
> @@ -93,6 +93,7 @@ struct sas_rphy {
> =A0 =A0 =A0 =A0struct list_head =A0 =A0 =A0 =A0list;
> =A0 =A0 =A0 =A0struct request_queue =A0 =A0*q;
> =A0 =A0 =A0 =A0u32 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 scsi_targe=
t_id;
> + =A0 =A0 =A0 struct scsi_target =A0 =A0 =A0*starget;
> =A0};
>
> =A0#define dev_to_rphy(d) \
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
