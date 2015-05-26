From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH-v3 00/10] target: se_node_acl + se_lun RCU conversions
Date: Tue, 26 May 2015 11:41:10 +0200
Message-ID: <55643FB6.1080301@suse.de>
References: <1432621530-24171-1-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1432621530-24171-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On 05/26/2015 08:25 AM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>=20
> Hi all,
>=20
> Here is -v3 series for converting LIO target se_node_acl + se_lun
> mapping tables from fixed size arrays to dynamic RCU hlist_heads.
>=20
> This turns fast-path I/O into a lock-less RCU reader using existing
> percpu based se_lun->lun_ref logic, and converts the RCU updater
> path to allow for an arbitrary number of LUNs for both types of
> mappings within target-core.
>=20
> As per this afternoon's email thread, the se_dev_entry->pr_comp
> has been left in place for se_dev_entry shutdown within patch #1.
> This completion is still required in order to prevent the configfs
> se_lun_acl->se_lun_group from being removed from out below the
> core_scsi3_lunacl_depend_item() caller during the special-case PR
> ALL_TG_PT=3D1 registration handling.
>=20
> The changes based on -v2 series feedback from HCH & Co include:
>=20
>   - Remove unused se_dev_entry->se_node_acl
>   - Drop unnecessary check in lunacl_undepend_item
>   - target: Drop bogus mutex_unlock in core_disable_device_list_for_n=
ode
>   - Drop left-over se_lun->lun_status
>   - target: Rename ->pr_regs to ->deve_flags + add bit definitions
>   - target: Convert se_dev_entry stats to atomic_long_t
>   - Avoid unnecessary PR target_nacl_find_deve() lookup in registrati=
on
>   - Add se_lun->lun_index for RCU dev->dev_index usage in stat.c
>   - Add various rcu_dereference and lockless_dereference RCU notation
>=20
> Please review.
>=20
> --nab
>=20
=46or the whole series:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Do you have a git tree for these changes?
As mentioned earlier, it should be fairly trivial to convert
LIO target to use 64-bit LUNs with this patchset.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
