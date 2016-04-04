From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/4] libata: Implement ZBC OUT translation
Date: Mon, 4 Apr 2016 15:18:30 +0200
Message-ID: <570269A6.7090908@suse.de>
References: <1459763271-125856-1-git-send-email-hare@suse.de>
 <1459763271-125856-3-git-send-email-hare@suse.de>
 <CAJVOszABD3+qX-D5q1N74kZB4XODDFdhc56=Ktao4hV7PopCww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAJVOszABD3+qX-D5q1N74kZB4XODDFdhc56=Ktao4hV7PopCww@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Shaun Tancheff <shaun.tancheff@seagate.com>
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On 04/04/2016 03:08 PM, Shaun Tancheff wrote:
> On Mon, Apr 4, 2016 at 4:47 PM, Hannes Reinecke <hare@suse.de> wrote:
>> ZAC drives implement a 'zac management out' command template,
>> which maps onto the ZBC OUT command.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/ata/libata-eh.c       |  1 +
>>  drivers/ata/libata-scsi.c     | 73 ++++++++++++++++++++++++++++++++=
+++++++++++
>>  include/linux/ata.h           |  7 +++++
>>  include/trace/events/libata.h |  1 +
>>  4 files changed, 82 insertions(+)
>>
>> diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
>> index e947bd5..ee984f9 100644
>> --- a/drivers/ata/libata-eh.c
>> +++ b/drivers/ata/libata-eh.c
>> @@ -2481,6 +2481,7 @@ const char *ata_get_cmd_descript(u8 command)
>>                 { ATA_CMD_REQ_SENSE_DATA,       "REQUEST SENSE DATA =
EXT" },
>>                 { ATA_CMD_SANITIZE_DEVICE,      "SANITIZE DEVICE" },
>>                 { ATA_CMD_ZAC_MGMT_IN,          "ZAC MANAGEMENT IN" =
},
>> +               { ATA_CMD_ZAC_MGMT_OUT,         "ZAC MANAGEMENT OUT"=
 },
>>                 { ATA_CMD_READ_LONG,            "READ LONG (with ret=
ries)" },
>>                 { ATA_CMD_READ_LONG_ONCE,       "READ LONG (without =
retries)" },
>>                 { ATA_CMD_WRITE_LONG,           "WRITE LONG (with re=
tries)" },
>> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
>> index 21c2b40..6db2aaf 100644
>> --- a/drivers/ata/libata-scsi.c
>> +++ b/drivers/ata/libata-scsi.c
>> @@ -3451,6 +3451,76 @@ invalid_param_len:
>>         return 1;
>>  }
>>
>> +static unsigned int ata_scsi_zbc_out_xlat(struct ata_queued_cmd *qc=
)
>> +{
>> +       struct ata_taskfile *tf =3D &qc->tf;
>> +       struct scsi_cmnd *scmd =3D qc->scsicmd;
>> +       struct ata_device *dev =3D qc->dev;
>> +       const u8 *cdb =3D scmd->cmnd;
>> +       u8 reset_all, sa;
>> +       u64 block;
>> +       u32 n_block;
>> +       u16 fp =3D (u16)-1;
>> +
>> +       if (unlikely(scmd->cmd_len < 16)) {
>> +               fp =3D 15;
>> +               goto invalid_fld;
>> +       }
>> +
>> +       /*
>> +        * The service action definition got moved from
>> +        * 0x00 to 0x04 with zbc-r02, so accept both.
>> +        */
>> +       sa =3D cdb[1] & 0x1f;
>> +       /* Compatibility with ZBC r01 */
>> +       if (!sa)
>> +               sa =3D ZO_RESET_WRITE_POINTER;
>=20
> I think we can support the remaining zone commands here:
>=20
> if (!(sa =3D=3D ZO_CLOSE_ZONE || sa =3D=3D ZO_FINISH_ZONE ||
>      sa =3D=3D ZO_OPEN_ZONE || sa =3D=3D ZO_RESET_WRITE_POINTER)) {
> ...
>=20
Sure, I just didn't do it for now as none of the drives I have
actually supports this.
But yes, will be fixing it up for the next round of submissions.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
