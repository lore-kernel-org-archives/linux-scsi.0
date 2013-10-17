From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/2] target_core_alua: Referrals infrastructure
Date: Thu, 17 Oct 2013 09:38:11 +0200
Message-ID: <525F93E3.4090609@suse.de>
References: <1381908324-82135-1-git-send-email-hare@suse.de>  <1381908324-82135-2-git-send-email-hare@suse.de> <1381962496.19256.667.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42268 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591Ab3JQHiN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Oct 2013 03:38:13 -0400
In-Reply-To: <1381962496.19256.667.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Nic Bellinger <nab@daterainc.com>, Doug Gilber <dgilbert@interlog.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On 10/17/2013 12:28 AM, Nicholas A. Bellinger wrote:
> On Wed, 2013-10-16 at 09:25 +0200, Hannes Reinecke wrote:
>> Add infrastructure for referrals.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/target/target_core_alua.c     | 151 +++++++++++++++++++++++=
+++++++++++
>>  drivers/target/target_core_alua.h     |   4 +-
>>  drivers/target/target_core_configfs.c |  12 ++-
>>  drivers/target/target_core_device.c   |   2 +
>>  drivers/target/target_core_sbc.c      |   5 +-
>>  drivers/target/target_core_spc.c      |  20 +++++
>>  include/scsi/scsi.h                   |   1 +
>>  include/target/target_core_base.h     |  18 ++++
>>  8 files changed, 209 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/target/target_core_alua.c b/drivers/target/targ=
et_core_alua.c
>> index 166bee6..8f66146 100644
>> --- a/drivers/target/target_core_alua.c
>> +++ b/drivers/target/target_core_alua.c
>> @@ -56,6 +56,75 @@ static LIST_HEAD(lu_gps_list);
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
> For both of these list walks, there needs to be a check against offse=
t
> vs. ->data_length to know when the available payload length has been
> exhausted..
>=20
Right. Will be fixing it up.

[ .. ]
>> diff --git a/drivers/target/target_core_spc.c b/drivers/target/targe=
t_core_spc.c
>> index e39d442..282b5bb 100644
>> --- a/drivers/target/target_core_spc.c
>> +++ b/drivers/target/target_core_spc.c
>> @@ -476,6 +476,11 @@ spc_emulate_evpd_86(struct se_cmd *cmd, unsigne=
d char *buf)
>>  	/* If WriteCache emulation is enabled, set V_SUP */
>>  	if (spc_check_dev_wce(dev))
>>  		buf[6] =3D 0x01;
>> +	/* If an LBA map is present set R_SUP */
>> +	spin_lock(&cmd->se_dev->t10_alua.lba_map_lock);
>> +	if (!list_empty(&dev->t10_alua.lba_map_list))
>> +		buf[8] =3D 0x10;
>> +	spin_unlock(&cmd->se_dev->t10_alua.lba_map_lock);
>>  	return 0;
>>  }
>=20
> Is there ever a case where R_SUP should be reported, but lba_map_list=
 is
> empty..?
>=20
Not that I can see. If R_SUP is set it means the 'REPORT REFERRALS'
is supported. And 'REPORT REFERRALS' without a map is pretty much
pointless.

> How about a se_device attribute called 'emulate_referrals' to determi=
ne
> when to report R_SUP..?  Otherwise, perhaps using the se_lun -> se_po=
rt
> -> sep_alua_tg_pt_gp_mem -> tg_pt_gp provided bit for
> tg_pt_gp_alua_supported_states instead..?
>=20
I was thinking about the very same thing, but then figured it was
easier to equal R_SUP with !list_empty(lba_map_list) instead of
having a separate flag.
Or crawling indirections just to find the very same information ...

>> =20
>> @@ -627,6 +632,20 @@ spc_emulate_evpd_b2(struct se_cmd *cmd, unsigne=
d char *buf)
>>  	return 0;
>>  }
>> =20
>> +/* Referrals VPD page */
>> +static sense_reason_t
>> +spc_emulate_evpd_b3(struct se_cmd *cmd, unsigned char *buf)
>> +{
>> +	struct se_device *dev =3D cmd->se_dev;
>> +
>> +	buf[0] =3D dev->transport->get_device_type(dev);
>> +	buf[3] =3D 0x0c;
>> +	put_unaligned_be32(dev->t10_alua.lba_map_segment_size, &buf[8]);
>> +	put_unaligned_be32(dev->t10_alua.lba_map_segment_size, &buf[12]);
>> +
>=20
> Typo..  Offset for byte 12 should be the lba_map_segment_multiplier..
>=20
Oops ...

Will be fixing up the patch.

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
