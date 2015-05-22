From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH-v2 0/9] target: se_node_acl + se_lun RCU conversions
Date: Fri, 22 May 2015 08:23:28 +0200
Message-ID: <555ECB60.4090406@suse.de>
References: <1432275071-28882-1-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1432275071-28882-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On 05/22/2015 08:11 AM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>=20
> Hi all,
>=20
> Here is -v2 series for converting LIO target se_node_acl + se_lun
> mapping tables from fixed size arrays to dynamic RCU hlist_heads.
>=20
> This turns fast-path I/O into a lock-less RCU reader using existing
> percpu based se_lun->lun_ref logic, and converts the RCU updater
> path to allow for an arbitrary number of LUNs for both types of
> mappings within target-core.
>=20
> This series also squashes a number of previous se_node_acl RCU
> related changes into a single commit (#1) for easier review,
> and to avoid potential bisect issues.
>=20
> There have been a number of changes since -v1, including:
>=20
>   - Mirror port->sep_rtpi in lun->lun_rtpi for RCU
>   - Drop unnecessary synchronize_rcu() usage
>   - Convert call_rcu() to kfree_rcu() usage
>   - Move hlist_del_rcu head of rcu_assign_pointer in se_dev_entry
>   - Drop unnecessary lookup deve in target_fabric_mappedlun_unlink()
>   - Add target_lun_is_rdonly helper
>   - Acquire lun_entry_mutex during core_disable_device_list_for_node
>   - Drop TRANSPORT_LUNFLAGS_*_ACCESS usage
>   - Pass se_dev_entry directly to core_disable_device_list_for_node
>   - Convert sbp-target se_lun usage to use ->login_lun
>   - Fix se_session dereference in spc_emulate_report_luns=20
>   - Fix testing for NULL instead of IS_ERR in fabric_make_lun()
>   - Convert BUG_ON to EINVAL for wrong dynamic -> explicit ACL conver=
sion=20
>   - Add missing hlist_del_rcu when swapping orig with new
>   - Add HBA_FLAGS_INTERNAL_USE checks in add/remove lun
>=20
> Please review.
>=20
Very nice.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Although it would be _perfect_ if you could move to full 64-bit
LUNs; now that the LUN array is gone there is no need to have a
limitation on the number of LUNs, and we can trivially support
64-bit LUNs ...

But then, I can easily send a patch once this one is in.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
