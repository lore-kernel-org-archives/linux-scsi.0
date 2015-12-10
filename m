From: Quinn Tran <quinn.tran@qlogic.com>
Subject: Re: [PATCH 09/20] qla2xxx: Change check_stop_free to always return 1
Date: Thu, 10 Dec 2015 01:06:53 +0000
Message-ID: <D28DF1C6.1B1DE%quinn.tran@qlogic.com>
References: <1449535747-2850-1-git-send-email-himanshu.madhani@qlogic.com>
 <1449535747-2850-10-git-send-email-himanshu.madhani@qlogic.com>
 <5667D092.1030701@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <5667D092.1030701@suse.de>
Content-Language: en-US
Content-ID: <9A68B953ED2D054081A95AC1E52BEDC1@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, Himanshu Madhani <himanshu.madhani@qlogic.com>
List-Id: linux-scsi@vger.kernel.org


On 12/8/15, 10:56 PM, "target-devel-owner@vger.kernel.org on behalf of
Hannes Reinecke" <target-devel-owner@vger.kernel.org on behalf of
hare@suse.de> wrote:

>On 12/08/2015 01:48 AM, Himanshu Madhani wrote:
>> From: Quinn Tran <quinn.tran@qlogic.com>
>>=20
>> change tcm_qla2xxx_check_stop_free to always return 1
>> to prevent transport_cmd_finish_abort from accidently
>> taking extra kref_put.
>>=20
>> Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
>> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
>> ---
>>  drivers/scsi/qla2xxx/tcm_qla2xxx.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>=20
>> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
>>b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
>> index 74c6e9b..366142a 100644
>> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
>> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
>> @@ -314,7 +314,8 @@ static int tcm_qla2xxx_check_stop_free(struct
>>se_cmd *se_cmd)
>>  		cmd->cmd_flags |=3D BIT_14;
>>  	}
>> =20
>> -	return target_put_sess_cmd(se_cmd);
>> +	target_put_sess_cmd(se_cmd);
>> +	return 1;
>>  }
>> =20
>>  /* tcm_qla2xxx_release_cmd - Callback from TCM Core to release
>>underlying
>>=20
>Odd. I would have expected target_put_sess_cmd() to never fail.

QT> It does not failed under normal usage.

>But if it does, doesn't it mean that the command is hosed, and we shou=
ld
>have accessed it in the first place?
>Very suspicious.

QT> here are the cases I see.  Note: The patch series is in reference o=
f
pre-Bart=B9s fix.

- cmd_kref 2 -> 1, target_put_sess_cmd return true. This is Normal case=
=2E
Backend finished with the command and send it to the Front end.

- cmd_kref 1 -> 0, target_put_sess_cmd return true.
Case 1: Early free by TCM/TMR thread.  TMR thread call 2nd check_stop.

core_tmr_drain_tmr_list->transport_cmd_finish_abort->
transport_cmd_check_stop_to_fabric

- cmd_kref 0 -> -1, target_put_sess_cmd return false.   QLA does not ca=
ll
=B3check_stop=B2 in either cases below.
Case 1: QLA cause double free the command as the command is coming out =
of
HW queue. In other word QLA access stale pointer during cleanup/free.
Case 2: QLA driver beat TMR thread by a few nano second by freeing the
command 1st(cmd_kref=3D0).  TMR thread call the extra check_stop(cmd_kr=
ef =3D
-1).  transport_cmd_finish_abort do additional kref_put (cmd_kref =3D -=
2).

void transport_cmd_finish_abort(struct se_cmd *cmd, int remove)
{
    if (transport_cmd_check_stop_to_fabric(cmd))
        return;
    if (remove)
        transport_put_cmd(cmd);
}




>
>Cheers,
>
>Hannes
>--=20
>Dr. Hannes Reinecke		      zSeries & Storage
>hare@suse.de			      +49 911 74053 688
>SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
>GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
>--
>To unsubscribe from this list: send the line "unsubscribe target-devel=
" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
