From: subhashj@codeaurora.org
Subject: Re: [PATCH/RFC V2 07/16] scsi: support well known logical units
Date: Fri, 22 Aug 2014 00:02:30 -0000
Message-ID: <82e763120409310e9d6b332854804858.squirrel@www.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
Cc: Dolev Raviv <draviv@codeaurora.org>, james.bottomley@hansenpartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Subhash Jadavani <subhashj@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

> On Thu, Aug 14, 2014 at 04:30:58PM +0300, Dolev Raviv wrote:
>> From: Subhash Jadavani <subhashj@codeaurora.org>
>> REPORT LUNS command has "SELECT REPORT" field which controls what ty=
pe of
>> logical units to be reported by device server. According to UFS devi=
ce
standard, if this field is set to 0, REPORT LUNS would report only
report
>> standard logical units. If it's set to 1 then it would report only w=
ell
known logical unit and if it's set to 2 then device would report both
standard and well known logical units.
>> Some well-known logical units might not have scsi upper-layer driver=
s. In
>> such cases, the runtime PM reference count increased during device
enumeration will not be decreased, causing the parent device (host) to
always be on even during idle.
>> This change allows the SCSI LLD (Low Level Driver) to choose which t=
ype
of logical units should be detected.
>> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
>> Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
>> Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
>> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c ind=
ex
4a6e4ba..5a0e164 100644
>> --- a/drivers/scsi/scsi_scan.c
>> +++ b/drivers/scsi/scsi_scan.c
>> @@ -802,6 +802,14 @@ static int scsi_add_lun(struct scsi_device *sde=
v,
unsigned char *inq_result,
>>  	} else {
>>  		sdev->type =3D (inq_result[0] & 0x1f);
>>  		sdev->removable =3D (inq_result[1] & 0x80) >> 7;
>> +
>> +		/*
>> +		 * some devices may respond with wrong type for
>> +		 * well-known logical units. Force well-known type
>> +		 * to enumerate them correctly.
>> +		 */
>> +		if (scsi_is_wlun(sdev->lun) && (sdev->type !=3D TYPE_WLUN))
>> +			sdev->type =3D TYPE_WLUN;
> no need to test for TYPE_WLUN here.]

Agreed, will fix it.

>>  	switch (sdev->type) {
>> @@ -817,6 +825,7 @@ static int scsi_add_lun(struct scsi_device *sdev=
,
unsigned char *inq_result,
>>  	case TYPE_COMM:
>>  	case TYPE_RAID:
>>  	case TYPE_OSD:
>> +	case TYPE_WLUN:
>>  		sdev->writeable =3D 1;
>>  		break;
>>  	case TYPE_ROM:
> This switch statements has been removed in 3.17-rc1, please rebase yo=
ur
series on top of it.

Sure.

> While you're at it please make this patch, which
> introduce=D1=95 core scsi changes first in the series.

Ok. Will move these core changes first in the current patch series.

>> @@ -1412,6 +1421,13 @@ static int scsi_report_lun_scan(struct
>> scsi_target *starget, int bflags,
>>  	 */
>>  	memset(&scsi_cmd[1], 0, 5);
>> +	if (shost->report_wlus)
>> +		/*
>> +		 * Set "SELECT REPORT" field to 0x2 which will make device to +		=
 *
report well known logical units along with standard LUs.
>> +		 */
>> +		scsi_cmd[2] =3D 0x2;
> So we're finally getting well known LUN support.  I think we should k=
ey
this
> off the SBC compliance level and not have the drivers opt in.

If i understood this correctly, we want to make all devices report well
known LUs irrespective of device driver (LLD)'s preference? If yes then=
 i
will knock off "if (shost->report_wlus)" check.

>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 5f36788..ba9d0f0 100644
>> --- a/drivers/scsi/scsi_sysfs.c
>> +++ b/drivers/scsi/scsi_sysfs.c
>> @@ -1060,6 +1060,13 @@ int scsi_sysfs_add_sdev(struct scsi_device
*sdev)
>>  		}
>>  	}
>> +	/*
>> +	 * put runtime pm reference for well-known logical units,
>> +	 * drivers are expected to _get_* again during probe.
>> +	 */
>> +	if (scsi_is_wlun(sdev->lun))
>> +		scsi_autopm_put_device(sdev);
> Special casing the well known LUNs here seems wrong.  Shouldn't we do
this
> for any devices that don't get a driver attached to them?

Agreed, i will replace "if (scsi_is_wlun(sdev->lun))" check with "if
(sdev->sdev_gendev.driver)".

Regards,
Subhash
