From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 8/8] target_core_alua: Referrals configfs integration
Date: Thu, 19 Dec 2013 08:04:58 +0100
Message-ID: <52B29A9A.9020701@suse.de>
References: <1387268330-121064-1-git-send-email-hare@suse.de>	 <1387268330-121064-9-git-send-email-hare@suse.de>	 <1387313347.20247.316.camel@haakon3.risingtidesystems.com>	 <52B15999.9090207@suse.de> <1387434302.5567.35.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1387434302.5567.35.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/19/2013 07:25 AM, Nicholas A. Bellinger wrote:
> On Wed, 2013-12-18 at 09:15 +0100, Hannes Reinecke wrote:
>> On 12/17/2013 09:49 PM, Nicholas A. Bellinger wrote:
>>> On Tue, 2013-12-17 at 09:18 +0100, Hannes Reinecke wrote:
>>>> Referrals need an LBA map, which needs to be kept
>>>> consistent across all target port groups. So
>>>> instead of tying the map to the target port groups
>>>> I've implemented a single attribute containing the
>>>> entire map.
>>>>
>>>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>>>> ---
>>>>  drivers/target/target_core_alua.c      | 101 +++++++++++++++++++
>>>>  drivers/target/target_core_alua.h      |   8 ++
>>>>  drivers/target/target_core_configfs.c  | 171 ++++++++++++++++++++=
+++++++++++++
>>>>  drivers/target/target_core_device.c    |   1 +
>>>>  drivers/target/target_core_transport.c |  28 +++++-
>>>>  5 files changed, 308 insertions(+), 1 deletion(-)
>>>>
>>>
>>> Applied, with one comment below..
>>>
>>> <SNIP>
>>>
>>>> diff --git a/drivers/target/target_core_configfs.c b/drivers/targe=
t/target_core_configfs.c
>>>> index e74ef8c..1dbc1bc 100644
>>>> --- a/drivers/target/target_core_configfs.c
>>>> +++ b/drivers/target/target_core_configfs.c
>>>> @@ -1741,6 +1741,176 @@ static struct target_core_configfs_attribu=
te target_core_attr_dev_alua_lu_gp =3D {
>>>>  	.store	=3D target_core_store_alua_lu_gp,
>>>>  };
>>>> =20
>>>> +static ssize_t target_core_show_dev_lba_map(void *p, char *page)
>>>> +{
>>>> +	struct se_device *dev =3D p;
>>>> +	struct t10_alua_lba_map *map;
>>>> +	struct t10_alua_lba_map_member *mem;
>>>> +	char *b =3D page;
>>>> +	int bl =3D 0;
>>>> +	char state;
>>>> +
>>>> +	spin_lock(&dev->t10_alua.lba_map_lock);
>>>> +	if (!list_empty(&dev->t10_alua.lba_map_list))
>>>> +	    bl +=3D sprintf(b + bl, "%u %u\n",
>>>> +			  dev->t10_alua.lba_map_segment_size,
>>>> +			  dev->t10_alua.lba_map_segment_multiplier);
>>>> +	list_for_each_entry(map, &dev->t10_alua.lba_map_list, lba_map_li=
st) {
>>>> +		bl +=3D sprintf(b + bl, "%llu %llu",
>>>> +			      map->lba_map_first_lba, map->lba_map_last_lba);
>>>> +		list_for_each_entry(mem, &map->lba_map_mem_list,
>>>> +				    lba_map_mem_list) {
>>>> +			switch (mem->lba_map_mem_alua_state) {
>>>> +			case ALUA_ACCESS_STATE_ACTIVE_OPTIMIZED:
>>>> +				state =3D 'O';
>>>> +				break;
>>>> +			case ALUA_ACCESS_STATE_ACTIVE_NON_OPTIMIZED:
>>>> +				state =3D 'A';
>>>> +				break;
>>>> +			case ALUA_ACCESS_STATE_STANDBY:
>>>> +				state =3D 'S';
>>>> +				break;
>>>> +			case ALUA_ACCESS_STATE_UNAVAILABLE:
>>>> +				state =3D 'U';
>>>> +				break;
>>>> +			default:
>>>> +				state =3D '.';
>>>> +				break;
>>>> +			}
>>>> +			bl +=3D sprintf(b + bl, " %d:%c",
>>>> +				      mem->lba_map_mem_alua_pg_id, state);
>>>> +		}
>>>> +		bl +=3D sprintf(b + bl, "\n");
>>>> +	}
>>>> +	spin_unlock(&dev->t10_alua.lba_map_lock);
>>>
>>> The above loop can possibly overflow the passed *page..
>>>
>> No. This is the reverse operation to the constructor in
>> target_core_store_dev_lba_map().
>>
>> Which (per definition) can only handle maps up to one page in size.
>>
>> And hence the resulting (formatted) map as constructed by
>> target_core_show_dev_lba_map() will also fit on one page.
>>
>=20
> Sure, but AFAICT nothing prevents target_core_store_dev_lba_map() ->
> core_alua_set_lba_map() from being called multiple times, and thus
> potentially increasing target_core_show_dev_lba_map() output to large=
r
> than PAGE_SIZE..
>=20
Multiple times?

Hmm. I had envisioned the 'store' function to store the entire map,
thereby invalidating / overwriting the old one.
Didn't I implement that logic?

Have to check ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
