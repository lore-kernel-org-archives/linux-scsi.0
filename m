From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 2/4] null_blk: add zone open, close, and finish support
Date: Tue, 25 Jun 2019 12:36:45 +0000
Message-ID: <BYAPR04MB581665C81B89838BC022BF7BE7E30@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190621130711.21986-1-mb@lightnvm.io>
 <20190621130711.21986-3-mb@lightnvm.io>
 <BYAPR04MB5816D471063D970DDCF9AEC7E7E60@BYAPR04MB5816.namprd04.prod.outlook.com>
 <1aa6552c-ecf9-a168-df75-ec8c52ddbea6@lightnvm.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: =?iso-8859-1?Q?Matias_Bj=F8rling?= <mb@lightnvm.io>, "axboe@fb.com" <axboe@fb.com>, "hch@lst.de" <hch@lst.de>, Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Ajay Joshi <Ajay.Joshi@wdc.com>, Aravind Ramesh <Aravind.Ramesh@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "agk@redhat.com" <agk@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Matias Bjorling <Matias.Bjorling@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On 2019/06/25 20:06, Matias Bj=F8rling wrote:=0A=
> On 6/22/19 3:02 AM, Damien Le Moal wrote:=0A=
>> On 2019/06/21 22:07, Matias Bj=F8rling wrote:=0A=
>>> From: Ajay Joshi <ajay.joshi@wdc.com>=0A=
>>>=0A=
>>> Implement REQ_OP_ZONE_OPEN, REQ_OP_ZONE_CLOSE and REQ_OP_ZONE_FINISH=0A=
>>> support to allow explicit control of zone states.=0A=
>>>=0A=
>>> Signed-off-by: Ajay Joshi <ajay.joshi@wdc.com>=0A=
>>> Signed-off-by: Matias Bj=F8rling <matias.bjorling@wdc.com>=0A=
>>> ---=0A=
>>>   drivers/block/null_blk.h       |  4 ++--=0A=
>>>   drivers/block/null_blk_main.c  | 13 ++++++++++---=0A=
>>>   drivers/block/null_blk_zoned.c | 33 ++++++++++++++++++++++++++++++---=
=0A=
>>>   3 files changed, 42 insertions(+), 8 deletions(-)=0A=
>>>=0A=
>>> diff --git a/drivers/block/null_blk.h b/drivers/block/null_blk.h=0A=
>>> index 34b22d6523ba..62ef65cb0f3e 100644=0A=
>>> --- a/drivers/block/null_blk.h=0A=
>>> +++ b/drivers/block/null_blk.h=0A=
>>> @@ -93,7 +93,7 @@ int null_zone_report(struct gendisk *disk, sector_t s=
ector,=0A=
>>>   		     gfp_t gfp_mask);=0A=
>>>   void null_zone_write(struct nullb_cmd *cmd, sector_t sector,=0A=
>>>   			unsigned int nr_sectors);=0A=
>>> -void null_zone_reset(struct nullb_cmd *cmd, sector_t sector);=0A=
>>> +void null_zone_mgmt_op(struct nullb_cmd *cmd, sector_t sector);=0A=
>>>   #else=0A=
>>>   static inline int null_zone_init(struct nullb_device *dev)=0A=
>>>   {=0A=
>>> @@ -111,6 +111,6 @@ static inline void null_zone_write(struct nullb_cmd=
 *cmd, sector_t sector,=0A=
>>>   				   unsigned int nr_sectors)=0A=
>>>   {=0A=
>>>   }=0A=
>>> -static inline void null_zone_reset(struct nullb_cmd *cmd, sector_t sec=
tor) {}=0A=
>>> +static inline void null_zone_mgmt_op(struct nullb_cmd *cmd, sector_t s=
ector) {}=0A=
>>>   #endif /* CONFIG_BLK_DEV_ZONED */=0A=
>>>   #endif /* __NULL_BLK_H */=0A=
>>> diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_mai=
n.c=0A=
>>> index 447d635c79a2..5058fb980c9c 100644=0A=
>>> --- a/drivers/block/null_blk_main.c=0A=
>>> +++ b/drivers/block/null_blk_main.c=0A=
>>> @@ -1209,10 +1209,17 @@ static blk_status_t null_handle_cmd(struct null=
b_cmd *cmd)=0A=
>>>   			nr_sectors =3D blk_rq_sectors(cmd->rq);=0A=
>>>   		}=0A=
>>>   =0A=
>>> -		if (op =3D=3D REQ_OP_WRITE)=0A=
>>> +		switch (op) {=0A=
>>> +		case REQ_OP_WRITE:=0A=
>>>   			null_zone_write(cmd, sector, nr_sectors);=0A=
>>> -		else if (op =3D=3D REQ_OP_ZONE_RESET)=0A=
>>> -			null_zone_reset(cmd, sector);=0A=
>>> +			break;=0A=
>>> +		case REQ_OP_ZONE_RESET:=0A=
>>> +		case REQ_OP_ZONE_OPEN:=0A=
>>> +		case REQ_OP_ZONE_CLOSE:=0A=
>>> +		case REQ_OP_ZONE_FINISH:=0A=
>>> +			null_zone_mgmt_op(cmd, sector);=0A=
>>> +			break;=0A=
>>> +		}=0A=
>>>   	}=0A=
>>>   out:=0A=
>>>   	/* Complete IO by inline, softirq or timer */=0A=
>>> diff --git a/drivers/block/null_blk_zoned.c b/drivers/block/null_blk_zo=
ned.c=0A=
>>> index fca0c97ff1aa..47d956b2e148 100644=0A=
>>> --- a/drivers/block/null_blk_zoned.c=0A=
>>> +++ b/drivers/block/null_blk_zoned.c=0A=
>>> @@ -121,17 +121,44 @@ void null_zone_write(struct nullb_cmd *cmd, secto=
r_t sector,=0A=
>>>   	}=0A=
>>>   }=0A=
>>>   =0A=
>>> -void null_zone_reset(struct nullb_cmd *cmd, sector_t sector)=0A=
>>> +void null_zone_mgmt_op(struct nullb_cmd *cmd, sector_t sector)=0A=
>>>   {=0A=
>>>   	struct nullb_device *dev =3D cmd->nq->dev;=0A=
>>>   	unsigned int zno =3D null_zone_no(dev, sector);=0A=
>>>   	struct blk_zone *zone =3D &dev->zones[zno];=0A=
>>> +	enum req_opf op =3D req_op(cmd->rq);=0A=
>>>   =0A=
>>>   	if (zone->type =3D=3D BLK_ZONE_TYPE_CONVENTIONAL) {=0A=
>>>   		cmd->error =3D BLK_STS_IOERR;=0A=
>>>   		return;=0A=
>>>   	}=0A=
>>>   =0A=
>>> -	zone->cond =3D BLK_ZONE_COND_EMPTY;=0A=
>>> -	zone->wp =3D zone->start;=0A=
>>> +	switch (op) {=0A=
>>> +	case REQ_OP_ZONE_RESET:=0A=
>>> +		zone->cond =3D BLK_ZONE_COND_EMPTY;=0A=
>>> +		zone->wp =3D zone->start;=0A=
>>> +		return;=0A=
>>> +	case REQ_OP_ZONE_OPEN:=0A=
>>> +		if (zone->cond =3D=3D BLK_ZONE_COND_FULL) {=0A=
>>> +			cmd->error =3D BLK_STS_IOERR;=0A=
>>> +			return;=0A=
>>> +		}=0A=
>>> +		zone->cond =3D BLK_ZONE_COND_EXP_OPEN;=0A=
>>=0A=
>>=0A=
>> With ZBC, open of a full zone is a "nop". No error. So I would rather ha=
ve this as:=0A=
>>=0A=
>> 		if (zone->cond !=3D BLK_ZONE_COND_FULL)=0A=
>> 			zone->cond =3D BLK_ZONE_COND_EXP_OPEN;=0A=
>> 		=0A=
> Is this only ZBC? I can't find a reference to it in ZAC. I think it =0A=
> should fail. One is trying to open a zone that is full, one can't open =
=0A=
> it again. It's done for this round.=0A=
=0A=
Page 52/53, section 5.2.6.3.2:=0A=
=0A=
If the OPEN ALL bit is cleared to zero and the zone specified by the ZONE I=
D=0A=
field (see 5.2.4.3.3) is in Zone Condition:=0A=
a) EMPTY, IMPLICITLY OPENED, or CLOSED, then the device shall process an=0A=
Explicitly Open Zone function=0A=
(see 4.6.3.4.10) for the zone specified by the ZONE ID field;=0A=
b) EXPLICITLY OPENED or FULL, then the device shall:=0A=
	A) not change the zone's state; and=0A=
	B) return successful command completion;=0A=
=0A=
>>=0A=
>>> +		return;=0A=
>>> +	case REQ_OP_ZONE_CLOSE:=0A=
>>> +		if (zone->cond =3D=3D BLK_ZONE_COND_FULL) {=0A=
>>> +			cmd->error =3D BLK_STS_IOERR;=0A=
>>> +			return;=0A=
>>> +		}=0A=
>>> +		zone->cond =3D BLK_ZONE_COND_CLOSED;=0A=
>>=0A=
>> Sam as for open. Closing a full zone on ZBC is a nop. =0A=
> =0A=
> I think this should cause error.=0A=
=0A=
See ZAB/ZAC close command description. Same text as above, almost. Not an e=
rror.=0A=
It is a nop. ZAC page 48, section 5.2.4.3.2:=0A=
=0A=
If the CLOSE ALL bit is cleared to zero and the zone specified by the ZONE =
ID=0A=
field (see 5.2.4.3.3) is in Zone Condition:=0A=
a) IMPLICITLY OPENED, or EXPLICITLY OPENED, then the device shall process a=
=0A=
Close Zone function=0A=
(see 4.6.3.4.11) for the zone specified by the ZONE ID field;=0A=
b) EMPTY, CLOSED, or FULL, then the device shall:=0A=
	A) not change the zone's state; and=0A=
	B) return successful command completion;=0A=
=0A=
> =0A=
> And the code above would=0A=
>> also set an empty zone to closed. Finally, if the zone is open but nothi=
ng was=0A=
>> written to it, it must be returned to empty condition, not closed. =0A=
> =0A=
> Only on a reset event right? In general, if I do a expl. open, close it, =
=0A=
> it should not go to empty.=0A=
=0A=
See the zone state machine. It does return to empty from expl open if nothi=
ng=0A=
was written, that is, if the WP is still at zone start. This text is in ZAC=
=0A=
section 4.6.3.4.11 as noted above:=0A=
=0A=
For the specified zone, the Zone Condition state machine processing of this=
=0A=
function (e.g., as shown in the ZC2: Implicit_Open state (see 4.6.3.4.3))=
=0A=
results in the Zone Condition for the specified zone becoming:=0A=
a) EMPTY, if the write pointer indicates the lowest LBA in the zone and Non=
=0A=
Sequential Write Resources Active is false; or=0A=
b) CLOSED, if the write pointer does not indicate the lowest LBA in the zon=
e or=0A=
Non-Sequential Write Resources Active is true.=0A=
=0A=
> =0A=
> So something=0A=
>> like this is needed.=0A=
>>=0A=
>> 		switch (zone->cond) {=0A=
>> 		case BLK_ZONE_COND_FULL:=0A=
>> 		case BLK_ZONE_COND_EMPTY:=0A=
>> 			break;=0A=
>> 		case BLK_ZONE_COND_EXP_OPEN:=0A=
>> 			if (zone->wp =3D=3D zone->start) {=0A=
>> 				zone->cond =3D BLK_ZONE_COND_EMPTY;=0A=
>> 				break;=0A=
>> 			}=0A=
>> 		/* fallthrough */=0A=
>> 		default:=0A=
>> 			zone->cond =3D BLK_ZONE_COND_CLOSED;=0A=
>> 		}=0A=
>>=0A=
>>> +		return;=0A=
>>> +	case REQ_OP_ZONE_FINISH:=0A=
>>> +		zone->cond =3D BLK_ZONE_COND_FULL;=0A=
>>> +		zone->wp =3D zone->start + zone->len;=0A=
>>> +		return;=0A=
>>> +	default:=0A=
>>> +		/* Invalid zone condition */=0A=
>>> +		cmd->error =3D BLK_STS_IOERR;=0A=
>>> +		return;=0A=
>>> +	}=0A=
>>>   }=0A=
>>>=0A=
>>=0A=
>>=0A=
> =0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
