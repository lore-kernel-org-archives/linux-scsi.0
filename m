From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH-v2 0/4] target: Eliminate se_port + t10_alua_tg_pt_gp_member
Date: Tue, 26 May 2015 11:43:02 +0200
Message-ID: <55644026.6010206@suse.de>
References: <1432623445-25776-1-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1432623445-25776-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On 05/26/2015 08:57 AM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>=20
> Hi all,
>=20
> Here is v2 series with HCH's recent changes to go ahead and drop
> all se_port + t10_alua_tg_pt_gp_member usage within target-core in
> favor of direct se_lun pointer dereference.
>=20
> This includes the original patch + minor fixes, along with two other
> improvements for killing off se_lun->lun_sep_lock via RCU pointer
> access, and converting the remaining se_lun->lun_active busy-wait
> special cases to existing percpu se_lun->lun_ref access.
>=20
> Also included in the series is a recently discussed change to go
> ahead and drop an unnecessary core_tpg_register() parameter, and
> all associated target_core_fabric_ops forward declartions within
> fabric driver code.
>=20
> The changes since -v1 include:
>=20
>   - Move ->lun_se_dev assignments under se_device->se_port_lock
>   - All proper call_rcu() in backend drivers to allow for read-side
>     critical se_device RCU to complete
>   - Add se_device->hba_index to clean up RCU dereferences within
>     scsi_port_show_attr_inst() + scsi_tgt_port_show_attr_inst()
>   - Add various rcu_dereference and lockless_dereference RCU notation
>=20
> Please review.
>=20
> --nab
>=20
=46or the whole series:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
