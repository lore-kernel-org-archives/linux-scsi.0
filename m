From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 7/8] target_core_alua: Referrals infrastructure
Date: Wed, 18 Dec 2013 09:09:12 +0100
Message-ID: <52B15828.2000403@suse.de>
References: <1387268330-121064-1-git-send-email-hare@suse.de>	 <1387268330-121064-8-git-send-email-hare@suse.de> <1387310791.20247.312.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45127 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017Ab3LRIJO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Dec 2013 03:09:14 -0500
In-Reply-To: <1387310791.20247.312.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On 12/17/2013 09:06 PM, Nicholas A. Bellinger wrote:
> On Tue, 2013-12-17 at 09:18 +0100, Hannes Reinecke wrote:
>> Add infrastructure for referrals.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/target/target_core_alua.c     | 153 +++++++++++++++++++++++=
+++++++++++
>>  drivers/target/target_core_alua.h     |   4 +-
>>  drivers/target/target_core_configfs.c |   9 +-
>>  drivers/target/target_core_device.c   |   2 +
>>  drivers/target/target_core_sbc.c      |   5 +-
>>  drivers/target/target_core_spc.c      |  20 +++++
>>  include/scsi/scsi.h                   |   1 +
>>  include/target/target_core_base.h     |  18 ++++
>>  8 files changed, 209 insertions(+), 3 deletions(-)
>>
>=20
> Applied, with one comment below..
>=20
>> diff --git a/drivers/target/target_core_alua.c b/drivers/target/targ=
et_core_alua.c
>> index 01f0c71..dbfbf14 100644
>> --- a/drivers/target/target_core_alua.c
>> +++ b/drivers/target/target_core_alua.c
>> @@ -58,6 +58,75 @@ static LIST_HEAD(lu_gps_list);
>>  struct t10_alua_lu_gp *default_lu_gp;
>> =20
>>  /*
>> + * REPORT REFERRALS
>> + *
>> + * See sbc3r35 section 5.23
>> + */
>> +sense_reason_t
>> +target_emulate_report_referrals(struct se_cmd *cmd)
>> +{
>> +	struct se_device *dev =3D cmd->se_dev;
>> +	struct t10_alua_lba_map *map;
>> +	struct t10_alua_lba_map_member *map_mem;
>> +	unsigned char *buf;
>> +	u32 rd_len =3D 0, off;
>> +
>> +	if (cmd->data_length < 4) {
>> +		pr_warn("REPORT REFERRALS allocation length %u too"
>> +			" small\n", cmd->data_length);
>> +		return TCM_INVALID_CDB_FIELD;
>> +	}
>> +
>> +	buf =3D transport_kmap_data_sg(cmd);
>> +	if (!buf)
>> +		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>> +
>> +	off =3D 4;
>> +	spin_lock(&dev->t10_alua.lba_map_lock);
>> +	if (list_empty(&dev->t10_alua.lba_map_list)) {
>> +		spin_unlock(&dev->t10_alua.lba_map_lock);
>> +		transport_kunmap_data_sg(cmd);
>> +
>> +		return TCM_UNSUPPORTED_SCSI_OPCODE;
>> +	}
>> +
>> +	list_for_each_entry(map, &dev->t10_alua.lba_map_list,
>> +			    lba_map_list) {
>> +		int desc_num =3D off + 3;
>> +		int pg_num;
>> +
>> +		off +=3D 4;
>> +		put_unaligned_be64(map->lba_map_first_lba, &buf[off]);
>> +		off +=3D 8;
>> +		put_unaligned_be64(map->lba_map_last_lba, &buf[off]);
>> +		off +=3D 8;
>> +		rd_len +=3D 20;
>> +		pg_num =3D 0;
>> +		list_for_each_entry(map_mem, &map->lba_map_mem_list,
>> +				    lba_map_mem_list) {
>> +			buf[off++] =3D map_mem->lba_map_mem_alua_state & 0x0f;
>> +			off++;
>> +			buf[off++] =3D (map_mem->lba_map_mem_alua_pg_id >> 8) & 0xff;
>> +			buf[off++] =3D (map_mem->lba_map_mem_alua_pg_id & 0xff);
>> +			rd_len +=3D 4;
>> +			pg_num++;
>> +		}
>> +		buf[desc_num] =3D pg_num;
>> +	}
>> +	spin_unlock(&dev->t10_alua.lba_map_lock);
>> +
>=20
> The above loop needs a check based on cmd->data_length to not overflo=
w
> buf here..
>=20
> Care to send an incremental patch for this..?
>=20
On its way. Alongside a patch for the inquiry buffer size.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
