From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/6] target: use 'se_dev_entry' when allocating UAs
Date: Wed, 17 Jun 2015 08:20:23 +0200
Message-ID: <558111A7.1060209@suse.de>
References: <1434009689-112909-1-git-send-email-hare@suse.de>	 <1434009689-112909-4-git-send-email-hare@suse.de> <1434521164.7916.182.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1434521164.7916.182.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On 06/17/2015 08:06 AM, Nicholas A. Bellinger wrote:
> Hey Hannes,
>=20
> Apologies for the delayed follow-up on these, one comment below.
>=20
> On Thu, 2015-06-11 at 10:01 +0200, Hannes Reinecke wrote:
>> We need to use 'se_dev_entry' as argument when allocating
>> UAs, otherwise we'll never see any UAs for an implicit
>> ALUA state transition triggered from userspace.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/target/target_core_alua.c      | 27 ++++++++++++++++++-----=
----
>>  drivers/target/target_core_pr.c        | 31 +++++++++++++++++++++++=
++------
>>  drivers/target/target_core_transport.c | 18 ++++++++++++------
>>  drivers/target/target_core_ua.c        | 23 +++--------------------
>>  drivers/target/target_core_ua.h        |  2 +-
>>  5 files changed, 59 insertions(+), 42 deletions(-)
>>
>=20
> <SNIP>
>=20
>> diff --git a/drivers/target/target_core_pr.c b/drivers/target/target=
_core_pr.c
>> index 436e30b..bb28a97 100644
>> --- a/drivers/target/target_core_pr.c
>> +++ b/drivers/target/target_core_pr.c
>> @@ -125,6 +125,25 @@ static struct t10_pr_registration *core_scsi3_l=
ocate_pr_reg(struct se_device *,
>>  					struct se_node_acl *, struct se_session *);
>>  static void core_scsi3_put_pr_reg(struct t10_pr_registration *);
>> =20
>> +static void core_scsi3_pr_ua_allocate(struct se_node_acl *nacl,
>> +				      u32 unpacked_lun, u8 asc, u8 ascq)
>> +{
>> +	struct se_dev_entry *deve;
>> +
>> +	if (!nacl)
>> +		return;
>> +
>> +	rcu_read_lock();
>> +	deve =3D target_nacl_find_deve(nacl, unpacked_lun);
>> +	if (!deve) {
>> +		rcu_read_unlock();
>> +		return;
>> +	}
>> +
>> +	core_scsi3_ua_allocate(deve, asc, ascq);
>> +	rcu_read_unlock();
>> +}
>> +
>=20
> This should be common for TCM_RESERVATION_CONFLICT case outside of PR
> code too.
>=20
> Any objections for squashing the following into your original patch..=
?
>=20
> Thank you,
>=20
> --nab
>=20
[ .. ]

None at all.
Do go ahead.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
