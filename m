From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: OOPS: unplugging western digital passport drive
Date: Mon, 22 Jun 2015 09:14:15 -0400
Message-ID: <55880A27.2000008@stratus.com>
References: <Pine.LNX.4.44L0.1506171505050.1343-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c11o145.mxlogic.net ([208.65.144.68]:38724 "EHLO
	p01c11o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291AbbFVNOU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jun 2015 09:14:20 -0400
In-Reply-To: <Pine.LNX.4.44L0.1506171505050.1343-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: =?UTF-8?B?U3RhbmlzxYJhdyBQaXR1Y2hh?= <viraptor@gmail.com>, SCSI development list <linux-scsi@vger.kernel.org>

Hi Alan -- last I heard from Stan on this bug was April 14 -- he was on
"long holidays" at that time :)

-- Joe

On 06/17/2015 03:09 PM, Alan Stern wrote:
> Joe or Stanis=EF=BE=85^=EF=BE=82aw:
>=20
> I never heard anything back about this.  Does the patch fix the crash=
?
>=20
> Alan Stern
>=20
>=20
> On Wed, 18 Mar 2015, Alan Stern wrote:
>=20
>> On Wed, 18 Mar 2015, Alan Stern wrote:
>>
>>> On Tue, 17 Mar 2015, Joe Lawrence wrote:
>>>
>>>> On 03/11/2015 12:25 AM, Stanis=C3=85=E2=80=9Aaw Pitucha wrote:
>>>>> Hi linux-scsi,
>>>>> I've got another case of reproducible crash when unplugging weste=
rn
>>>>> digital passport drives. This was mentioned before in
>>>>> http://www.spinics.net/lists/linux-scsi/msg82603.html
>>>
>>> Like it says in that thread, the problem is somehow related to the =
ses
>>> driver.  If you remove or blacklist that driver, there won't be any
>>> more crashes.
>>
>> Looks like I spoke too soon.  I think the patch below will fix the=20
>> problem.  Let me know what happens.
>>
>> Alan Stern
>>
>>
>>
>>
>> Index: usb-4.0/drivers/scsi/scsi_pm.c
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> --- usb-4.0.orig/drivers/scsi/scsi_pm.c
>> +++ usb-4.0/drivers/scsi/scsi_pm.c
>> @@ -217,14 +217,18 @@ static int sdev_runtime_suspend(struct d
>>  {
>>  	const struct dev_pm_ops *pm =3D dev->driver ? dev->driver->pm : NU=
LL;
>>  	struct scsi_device *sdev =3D to_scsi_device(dev);
>> -	int err;
>> +	struct device *blk_rpm_dev =3D sdev->request_queue->dev;
>> +	int err =3D 0;
>> =20
>> -	err =3D blk_pre_runtime_suspend(sdev->request_queue);
>> -	if (err)
>> -		return err;
>> +	if (blk_rpm_dev) {
>> +		err =3D blk_pre_runtime_suspend(sdev->request_queue);
>> +		if (err)
>> +			return err;
>> +	}
>>  	if (pm && pm->runtime_suspend)
>>  		err =3D pm->runtime_suspend(dev);
>> -	blk_post_runtime_suspend(sdev->request_queue, err);
>> +	if (blk_rpm_dev)
>> +		blk_post_runtime_suspend(sdev->request_queue, err);
>> =20
>>  	return err;
>>  }
>> @@ -246,12 +250,15 @@ static int sdev_runtime_resume(struct de
>>  {
>>  	struct scsi_device *sdev =3D to_scsi_device(dev);
>>  	const struct dev_pm_ops *pm =3D dev->driver ? dev->driver->pm : NU=
LL;
>> +	struct device *blk_rpm_dev =3D sdev->request_queue->dev;
>>  	int err =3D 0;
>> =20
>> -	blk_pre_runtime_resume(sdev->request_queue);
>> +	if (blk_rpm_dev)
>> +		blk_pre_runtime_resume(sdev->request_queue);
>>  	if (pm && pm->runtime_resume)
>>  		err =3D pm->runtime_resume(dev);
>> -	blk_post_runtime_resume(sdev->request_queue, err);
>> +	if (blk_rpm_dev)
>> +		blk_post_runtime_resume(sdev->request_queue, err);
>> =20
>>  	return err;
>>  }
>>
>>
>>
>=20
>=20
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
