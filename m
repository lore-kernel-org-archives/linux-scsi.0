From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH v2 2/5] [SCSI] ufshcd: UFS UTP Transfer requests handling
Date: Mon, 27 Feb 2012 11:50:56 +0530
Message-ID: <CALMYJDv1mPPMBSviHkKF09JOdvVz=sEMj6HuVk_TR0Zr+iFKjg@mail.gmail.com>
References: <1330067945-9128-1-git-send-email-santoshsy@gmail.com>
 <1330067945-9128-3-git-send-email-santoshsy@gmail.com> <4F493238.4020907@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <4F493238.4020907@cs.wisc.edu>
Sender: linux-samsung-soc-owner@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, arnd@linaro.org, girish.shivananjappa@linaro.org, saugata.das@linaro.org, vishak.g@samsung.com, venkat@linaro.org, k.rajesh@samsung.com, yejin.moon@samsung.com, dsaxena@linaro.org, ilho215.lee@samsung.com, nala.la@samsung.com, stephen.doel@linaro.org, sreekumar.c@samsung.com, Vinayak Holikatti <vinholikatti@gmail.com>
List-Id: linux-scsi@vger.kernel.org

>> =A0#include "ufs.h"
>> @@ -75,6 +76,8 @@ enum {
>> =A0 =A0 =A0 UFSHCD_MAX_CHANNEL =A0 =A0 =A0=3D 0,
>> =A0 =A0 =A0 UFSHCD_MAX_ID =A0 =A0 =A0 =A0 =A0 =3D 1,
>> =A0 =A0 =A0 UFSHCD_MAX_LUNS =A0 =A0 =A0 =A0 =3D 8,
>> + =A0 =A0 UFSHCD_CMD_PER_LUN =A0 =A0 =A0=3D 32,
>> + =A0 =A0 UFSHCD_CAN_QUEUE =A0 =A0 =A0 =A0=3D 32,
>
>
> Is the can queue right, or are you working around a issue in the shar=
ed
> tag map code, or is this due to how you are tracking outstanding reqs
> (just a unsigned long so limited by that)?
>
> Can you support multiple luns per host? If so, this seems low for nor=
mal
> HBAs. Is this low due to the hw or something? If you have multiple lu=
ns
> then you are going to get a burst of 32 IOs and the host will work on
> them, then when those are done we will send IO to the next device, th=
en
> repeat. For normal HBAs we would have can_queue =3D cmd_per_lun * X, =
so we
> can do IO on X devices at the same time.
>

The host can support multiple LUNS, but the UFS host controller can
support only 32 outstanding commands.
So can queue is set to 32.

>> + *
>> + * Returns 0 for success, non-zero in case of failure
>> + */
>> +static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_=
cmnd *cmd)
>> +{
>> + =A0 =A0 struct ufshcd_lrb *lrbp;
>> + =A0 =A0 struct ufs_hba *hba;
>> + =A0 =A0 unsigned long flags;
>> + =A0 =A0 int tag;
>> + =A0 =A0 int err =3D 0;
>> +
>> + =A0 =A0 hba =3D (struct ufs_hba *) &host->hostdata[0];
>
>
> Use shost_priv instead of accessing hostdata. Check the rest of the
> driver for this.
>

ok, will use shost_priv.

>> +
>> +/**
>> + * ufshcd_adjust_lun_qdepth - Update LUN queue depth if device resp=
onds with
>> + * =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SAM_STAT_TASK_SE=
T_FULL SCSI command status.
>> + * @cmd: pointer to SCSI command
>> + */
>> +static void ufshcd_adjust_lun_qdepth(struct scsi_cmnd *cmd)
>> +{
>> + =A0 =A0 struct ufs_hba *hba;
>> + =A0 =A0 int i;
>> + =A0 =A0 int lun_qdepth =3D 0;
>> +
>> + =A0 =A0 hba =3D (struct ufs_hba *) cmd->device->host->hostdata;
>> +
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* LUN queue depth can be obtained by counting outstandi=
ng commands
>> + =A0 =A0 =A0* on the LUN.
>> + =A0 =A0 =A0*/
>> + =A0 =A0 for (i =3D 0; i < hba->nutrs; i++) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (test_bit(i, &hba->outstanding_reqs)) {
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Check if the outstand=
ing command belongs
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* to the LUN which repo=
rted SAM_STAT_TASK_SET_FULL.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cmd->device->lun =3D=3D=
 hba->lrb[i].lun)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 lun_qdepth=
++;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>> +
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* LUN queue depth will be total outstanding commands, e=
xcept the
>> + =A0 =A0 =A0* command for which the LUN reported SAM_STAT_TASK_SET_=
=46ULL.
>> + =A0 =A0 =A0*/
>> + =A0 =A0 scsi_adjust_queue_depth(cmd->device, MSG_SIMPLE_TAG, lun_q=
depth - 1);
>> +}
>> +
>> +/**
>> + * ufshcd_scsi_cmd_status - Update SCSI command result based on SCS=
I status
>> + * @lrb: pointer to local reference block of completed command
>> + * @scsi_status: SCSI command status
>> + *
>> + * Returns value base on SCSI command status
>> + */
>> +static inline int
>> +ufshcd_scsi_cmd_status(struct ufshcd_lrb *lrbp, int scsi_status)
>> +{
>> + =A0 =A0 int result =3D 0;
>> +
>> + =A0 =A0 switch (scsi_status) {
>> + =A0 =A0 case SAM_STAT_GOOD:
>> + =A0 =A0 =A0 =A0 =A0 =A0 result |=3D DID_OK << 16 |
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 COMMAND_COMPLETE << 8 =
|
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SAM_STAT_GOOD;
>> + =A0 =A0 =A0 =A0 =A0 =A0 break;
>> + =A0 =A0 case SAM_STAT_CHECK_CONDITION:
>> + =A0 =A0 =A0 =A0 =A0 =A0 result |=3D DRIVER_SENSE << 24 |
>
> scsi ml will set the driver sense bit for you when it completes the
> command in scsi_finish_command. No need for the driver to touch this.
>

ok, i'll change it.

>
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DRIVER_OK << 16 |
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 COMMAND_COMPLETE << 8 =
|
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SAM_STAT_CHECK_CONDITI=
ON;
>> + =A0 =A0 =A0 =A0 =A0 =A0 ufshcd_copy_sense_data(lrbp);
>> + =A0 =A0 =A0 =A0 =A0 =A0 break;
>> + =A0 =A0 case SAM_STAT_BUSY:
>> + =A0 =A0 =A0 =A0 =A0 =A0 result |=3D DID_BUS_BUSY << 16 |
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SAM_STAT_BUSY;
>
> If you got sam stat busy just set that. You do not need to set the ho=
st
> byte and you do not want to, because the scsi_error.c handling will b=
e
> incorrect. Instead of retrying until sam stat busy is no longer retur=
ned
> (or until cmd->retries * cmd->timeout) you only get 5 retries.
>

Ok, I'll change it.

>
>> + =A0 =A0 =A0 =A0 =A0 =A0 break;
>> + =A0 =A0 case SAM_STAT_TASK_SET_FULL:
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 /*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* If a LUN reports SAM_STAT_TASK_SET_FU=
LL, then the LUN queue
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* depth needs to be adjusted to the exa=
ct number of
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* outstanding commands the LUN can hand=
le at any given time.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 ufshcd_adjust_lun_qdepth(lrbp->cmd);
>> + =A0 =A0 =A0 =A0 =A0 =A0 result |=3D DID_SOFT_ERROR << 16 |
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SAM_STAT_TASK_SET_FULL=
;
>
>
> Same here. Just set the sam stat part.
>
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 break;
>> + =A0 =A0 case SAM_STAT_TASK_ABORTED:
>> + =A0 =A0 =A0 =A0 =A0 =A0 result |=3D =A0DID_ABORT << 16 |
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ABORT_TASK << 8 |
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0SAM_STAT_TASK_ABORT=
ED;
>
> Same.
>

ok.

>> + =A0 =A0 =A0 =A0 =A0 =A0 break;
>> + =A0 =A0 default:
>> + =A0 =A0 =A0 =A0 =A0 =A0 result |=3D DID_ERROR << 16;
>> + =A0 =A0 =A0 =A0 =A0 =A0 break;
>> + =A0 =A0 } /* end of switch */
>> +
>> + =A0 =A0 return result;
>> +}
>> +
>> +/**
>> =A0/**
>> @@ -809,7 +1295,13 @@ static struct scsi_host_template ufshcd_driver=
_template =3D {
>> =A0 =A0 =A0 .module =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D THIS_MODULE,
>> =A0 =A0 =A0 .name =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D UFSHCD,
>> =A0 =A0 =A0 .proc_name =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D UFSHCD,
>> + =A0 =A0 .queuecommand =A0 =A0 =A0 =A0 =A0 =3D ufshcd_queuecommand,
>> + =A0 =A0 .slave_alloc =A0 =A0 =A0 =A0 =A0 =A0=3D ufshcd_slave_alloc=
,
>> + =A0 =A0 .slave_destroy =A0 =A0 =A0 =A0 =A0=3D ufshcd_slave_destroy=
,
>> =A0 =A0 =A0 .this_id =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D -1,
>> + =A0 =A0 .sg_tablesize =A0 =A0 =A0 =A0 =A0 =3D SG_ALL,
>> + =A0 =A0 .cmd_per_lun =A0 =A0 =A0 =A0 =A0 =A0=3D UFSHCD_CMD_PER_LUN=
,
>> + =A0 =A0 .can_queue =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D UFSHCD_CAN_QUEUE=
,
>
> Did you want a =A0change_queue_depth callout?
>
>> =A0};
>>

No, command per LUN is set to maximum outstanding commands UFS
controller can support.
In case of queue full, the queue depth for a LUN will be calculated
and set in ufshcd_adjust_lun_qdepth.
So I don't think change_queue_depth will be necessary.

Thanks for reviewing, please let me know if you find any issues in
other patches as well.

--=20
~Santosh
