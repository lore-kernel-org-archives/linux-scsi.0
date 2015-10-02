From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] SCSI: Fix hard lockup in scsi_remove_target()
Date: Fri, 02 Oct 2015 10:25:44 +0200
Message-ID: <560E3F88.7060400@suse.de>
References: <1443774062-15638-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1443774062-15638-1-git-send-email-jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/02/2015 10:21 AM, Johannes Thumshirn wrote:
> Removing a SCSI target via scsi_remove_target() suspected to be racy.=
 When a
> sibling get's removed from the list it can occassionly happen that on=
e CPU is
> stuck endlessly looping around this code block
>=20
> list_for_each_entry(starget, &shost->__targets, siblings) {
>         if (starget->state =3D=3D STARGET_DEL)
>                 continue;
>=20
> Resulting in the following hard lockup.
>=20
> Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 0
> [...]
> Call Trace:
>  [<ffffffff8100471d>] dump_trace+0x7d/0x2d0
>  [<ffffffff81004a04>] show_stack_log_lvl+0x94/0x170
>  [<ffffffff81005cc1>] show_stack+0x21/0x50
>  [<ffffffff8151aa75>] dump_stack+0x41/0x51
>  [<ffffffff8151545a>] panic+0xc8/0x1d7
>  [<ffffffff810fbdda>] watchdog_overflow_callback+0xba/0xc0
>  [<ffffffff811336c8>] __perf_event_overflow+0x88/0x240
>  [<ffffffff8101e3aa>] intel_pmu_handle_irq+0x1fa/0x3e0
>  [<ffffffff81522836>] perf_event_nmi_handler+0x26/0x40
>  [<ffffffff81521fcd>] nmi_handle.isra.2+0x8d/0x180
>  [<ffffffff815221e6>] do_nmi+0x126/0x3c0
>  [<ffffffff8152159b>] end_repeat_nmi+0x1a/0x1e
>  [<ffffffffa00212e8>] scsi_remove_target+0x68/0x240 [scsi_mod]
>  [<ffffffff81072742>] process_one_work+0x172/0x420
>  [<ffffffff810733ba>] worker_thread+0x11a/0x3c0
>  [<ffffffff81079d34>] kthread+0xb4/0xc0
>  [<ffffffff81528cd8>] ret_from_fork+0x58/0x90
>=20
> This patch decouples the list traversal for targets and the reaping o=
f SCSI
> targets by moving to be removed targets to a separate reap list. Entr=
ies in
> this list can then be removed by the SCSI layer in a lockless manner.
>=20
> This was discovered by a partner in a 24h stress test.
>=20
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/scsi_sysfs.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
