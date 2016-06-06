From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 28/45] target: use bio op accessors
Date: Mon, 6 Jun 2016 17:43:28 +0200
Message-ID: <57559A20.10506@suse.de>
References: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
 <1465155145-10812-29-git-send-email-mchristi@redhat.com>
 <57551C57.5090507@suse.de> <57559973.1020105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <57559973.1020105@redhat.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Mike Christie <mchristi@redhat.com>, linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
List-Id: linux-scsi@vger.kernel.org

On 06/06/2016 05:40 PM, Mike Christie wrote:
> On 06/06/2016 01:46 AM, Hannes Reinecke wrote:
>> On 06/05/2016 09:32 PM, mchristi@redhat.com wrote:
>>> From: Mike Christie <mchristi@redhat.com>
>>>
>>> Separate the op from the rq_flag_bits and have the target layer
>>> set/get the bio using bio_set_op_attrs/bio_op.
>>>
>>> Signed-off-by: Mike Christie <mchristi@redhat.com>
>>> ---
>>>   drivers/target/target_core_iblock.c | 29 ++++++++++++++----------=
-----
>>>   drivers/target/target_core_pscsi.c  |  2 +-
>>>   2 files changed, 15 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/drivers/target/target_core_iblock.c b/drivers/target/t=
arget_core_iblock.c
>>> index c25109c..22af12f 100644
>>> --- a/drivers/target/target_core_iblock.c
>>> +++ b/drivers/target/target_core_iblock.c
>> [ .. ]
>>> @@ -689,18 +690,15 @@ iblock_execute_rw(struct se_cmd *cmd, struct =
scatterlist *sgl, u32 sgl_nents,
>>>   		 * Force writethrough using WRITE_FUA if a volatile write cache
>>>   		 * is not enabled, or if initiator set the Force Unit Access bi=
t.
>>>   		 */
>>> +		op =3D REQ_OP_WRITE;
>>>   		if (test_bit(QUEUE_FLAG_FUA, &q->queue_flags)) {
>>>   			if (cmd->se_cmd_flags & SCF_FUA)
>>> -				rw =3D WRITE_FUA;
>>> +				op_flags =3D WRITE_FUA;
>>>   			else if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags))
>>> -				rw =3D WRITE_FUA;
>>> -			else
>>> -				rw =3D WRITE;
>>> -		} else {
>>> -			rw =3D WRITE;
>>> +				op_flags =3D WRITE_FUA;
>>>   		}
>> Wrong intendation.
>
> It should be ok. That line is for the QUEUE_FLAG_WC test. We end up w=
ith:
>
> op =3D REQ_OP_WRITE;
> if (test_bit(QUEUE_FLAG_FUA, &q->queue_flags)) {
> 	if (cmd->se_cmd_flags & SCF_FUA)
> 		op_flags =3D WRITE_FUA;
> 	else if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags))
> 		op_flags =3D WRITE_FUA;
> }
>
>
>
>
Indeed, you are correct.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
