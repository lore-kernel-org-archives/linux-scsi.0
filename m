From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v5 5/7] libsas: fix sas_unregister_ports vs sas_drain_work
Date: Mon, 16 Jan 2012 15:34:16 -0800
Message-ID: <CAA9_cmcd2+M59bMj3TkbmJEQt7RGuhCvjwSo3bqBUGkK04zB5Q@mail.gmail.com>
References: <20120114180904.25887.75601.stgit@localhost6.localdomain6>
	<20120114181029.25887.26129.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120114181029.25887.26129.stgit@localhost6.localdomain6>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org, Jacek Danecki <jacek.danecki@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, Jan 14, 2012 at 10:10 AM, Dan Williams <dan.j.williams@intel.co=
m> wrote:
> We need to hold drain_mutex across the unregistration as port down ev=
ents
> queue device removal as chained events, so we need to make sure no ot=
her
> drainers are active.
>
> [ 1118.673968] WARNING: at kernel/workqueue.c:996 __queue_work+0x11a/=
0x326()
> [ 1118.681982] Hardware name: S2600CP
> [ 1118.686193] Modules linked in: isci(-) libsas scsi_transport_sas n=
ls_utf8
> ipv6 uinput sg iTCO_wdt iTCO_vendor_support i2c_i801 i2c_core ioatdma=
 dca
> sd_mod sr_mod cdrom ahci libahci libata [last unloaded: scsi_transpor=
t_sas]
> [ 1118.709893] Pid: 6831, comm: rmmod Not tainted 3.2.0-isci+ #1
> [ 1118.716727] Call Trace:
> [ 1118.719867] =A0[<ffffffff8103e9f5>] warn_slowpath_common+0x85/0x9d
> [ 1118.727000] =A0[<ffffffff8103ea27>] warn_slowpath_null+0x1a/0x1c
> [ 1118.733942] =A0[<ffffffff81056d44>] __queue_work+0x11a/0x326
> [ 1118.740481] =A0[<ffffffff81056f99>] queue_work_on+0x1b/0x22
> [ 1118.746925] =A0[<ffffffff81057106>] queue_work+0x37/0x3e
> [ 1118.753105] =A0[<ffffffffa0120e05>] ? sas_discover_event+0x55/0x82=
 [libsas]
> [ 1118.761094] =A0[<ffffffff813217c3>] scsi_queue_work+0x42/0x44
> [ 1118.767717] =A0[<ffffffffa0120e19>] sas_discover_event+0x69/0x82 [=
libsas]
> [ 1118.775509] =A0[<ffffffffa0120f5b>] sas_unregister_dev+0xc3/0xcc [=
libsas]
> [ 1118.783319] =A0[<ffffffffa0120fae>] sas_unregister_domain_devices+=
0x4a/0xc8 [libsas]
> [ 1118.792731] =A0[<ffffffffa0120071>] sas_deform_port+0x60/0x1a6 [li=
bsas]
> [ 1118.800339] =A0[<ffffffffa01201ea>] sas_unregister_ports+0x33/0x44=
 [libsas]
> [ 1118.808342] =A0[<ffffffffa011f7e5>] sas_unregister_ha+0x41/0x6b [l=
ibsas]
> [ 1118.816055] =A0[<ffffffffa0134055>] isci_unregister+0x22/0x4d [isc=
i]
> [ 1118.823384] =A0[<ffffffffa0143040>] isci_pci_remove+0x2e/0x60 [isc=
i]
>
> Reported-by: Jacek Danecki <jacek.danecki@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> =A0drivers/scsi/libsas/sas_init.c | =A0 =A08 ++++++--
> =A01 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas=
_init.c
> index dc93e118..1e13cf4 100644
> --- a/drivers/scsi/libsas/sas_init.c
> +++ b/drivers/scsi/libsas/sas_init.c
> @@ -163,14 +163,18 @@ int sas_unregister_ha(struct sas_ha_struct *sas=
_ha)
> =A0 =A0 =A0 =A0unsigned long flags;
>
> =A0 =A0 =A0 =A0/* Set the state to unregistered to avoid further unch=
ained
> - =A0 =A0 =A0 =A0* events to be queued
> + =A0 =A0 =A0 =A0* events to be queued, but since sas_unregister_port=
s()
> + =A0 =A0 =A0 =A0* generates unchained events relative to any in prog=
ress drains
> + =A0 =A0 =A0 =A0* we need to hold drain_mutex.
> =A0 =A0 =A0 =A0 */
> + =A0 =A0 =A0 mutex_lock(&sas_ha->drain_mutex);
> =A0 =A0 =A0 =A0spin_lock_irqsave(&sas_ha->state_lock, flags);
> =A0 =A0 =A0 =A0clear_bit(SAS_HA_REGISTERED, &sas_ha->state);
> =A0 =A0 =A0 =A0spin_unlock_irqrestore(&sas_ha->state_lock, flags);
> - =A0 =A0 =A0 sas_drain_work(sas_ha);
>
> =A0 =A0 =A0 =A0sas_unregister_ports(sas_ha);
> + =A0 =A0 =A0 mutex_unlock(&sas_ha->drain_mutex);

lockdep correctly points out this won't work as we can't hold the
mutex over transport actions since, transport actions also sometimes
acquire the mutex.
