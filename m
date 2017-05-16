From: Song Liu <songliubraving@fb.com>
Subject: Re: [RFC] scsi: generate uevent for SCSI sense code
Date: Tue, 16 May 2017 19:29:11 +0000
Message-ID: <B768CBBF-FD35-4EE3-B5CA-9793617D87D3@fb.com>
References: <20170504005013.2865393-1-songliubraving@fb.com>
 <20170504005013.2865393-2-songliubraving@fb.com>
 <20170516170052.GA14268@bblock-ThinkPad-W530>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48118 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753066AbdEPT3W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 16 May 2017 15:29:22 -0400
In-Reply-To: <20170516170052.GA14268@bblock-ThinkPad-W530>
Content-Language: en-US
Content-ID: <B167FA38C313EB44B34D345F640B15CD@namprd15.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Block <bblock@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@fb.com>, "axboe@kernel.dk" <axboe@kernel.dk>


> On May 16, 2017, at 10:00 AM, Benjamin Block <bblock@linux.vnet.ibm.com> =
wrote:
>=20
> Hello,
>=20
> On Wed, May 03, 2017 at 05:50:13PM -0700, Song Liu wrote:
>> This patch adds capability for SCSI layer to generate uevent for SCSI
>> sense code. The feature is gated by CONFIG_SCSI_SENSE_UEVENT.
>>=20
>> We can configure which sense keys generate uevent for each device
>> through sysfs entry sense_event_filter. For example, the following
>> enables uevent for MEDIUM_ERROR (0x03) and HARDWARE_ERROR (0x04)
>> on scsi drive sdc:
>>=20
>>    echo 0x000c > /sys/block/sdc/device/sense_event_filter
>>=20
>=20
> I know its an RFC, but the user-interface definitely needs better
> documentation. You also don't mention the 'wildcard' you document in the
> code below.
>=20
> Would there be any public tooling for this, when it gets in?
>=20
> There is already some events we can generate.. for example when the
> host-mapping changed, but I am not aware of any tooling that would ever
> make use of them (although, this probably would even be vert useful).
> And in the end that seems like dead-code for me. But maybe thats just me
> not knowing the tooling.

Hi Benjamin,=20

Thanks for these feedbacks. I will incorporate them into next version.=20

In term of tooling, we will open source useful tools we build to consume
these events. =20

>>=20
>> Here is an example output captured by udevadm:
>>=20
>> KERNEL[1214.945358] change   /devices/pci0000:00/XXXXXXX
>> ACTION=3Dchange
>> DEVPATH=3D/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/XXXXXXX
>> DEVTYPE=3Dscsi_device
>> DRIVER=3Dsd
>> LBA=3D0
>> MODALIAS=3Dscsi:t-0x00
>> SDEV_UA=3DSCSI_SENSE
>> SENSE_CODE=3D3/11/14
>> SEQNUM=3D4536
>> SIZE=3D4096
>> SUBSYSTEM=3Dscsi
>>=20
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>> drivers/scsi/Kconfig       | 14 +++++++++++
>> drivers/scsi/scsi_error.c  | 26 ++++++++++++++++++++
>> drivers/scsi/scsi_lib.c    | 27 +++++++++++++++++++--
>> drivers/scsi/scsi_sysfs.c  | 60 ++++++++++++++++++++++++++++++++++++++++=
++++++
>> include/scsi/scsi_device.h | 26 +++++++++++++++++++-
>> 5 files changed, 150 insertions(+), 3 deletions(-)
>>=20
>> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
>> index 3c52867..4f7f211 100644
>> --- a/drivers/scsi/Kconfig
>> +++ b/drivers/scsi/Kconfig
>> @@ -237,6 +237,20 @@ config SCSI_LOGGING
>> 	  there should be no noticeable performance impact as long as you have
>> 	  logging turned off.
>>=20
>> +config SCSI_SENSE_UEVENT
>> +	bool "SCSI sense code logging"
>> +	depends on SCSI
>> +	default n
>> +	---help---
>> +	  This turns on uevent for SCSI sense code.
>> +
>> +	  You can configure which sense keys generate uevent for each device
>> +	  through sysfs entry sense_event_filter. For example, the following
>> +	  enables uevent for MEDIUM_ERROR (0x03) and HARDWARE_ERROR (0x04)
>> +	  on scsi drive sdc:
>> +
>> +	  echo 0x000c > /sys/block/sdc/device/sense_event_filter
>> +
>> config SCSI_SCAN_ASYNC
>> 	bool "Asynchronous SCSI scanning"
>> 	depends on SCSI
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index d70c67c..eda150e 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -426,6 +426,31 @@ static void scsi_report_sense(struct scsi_device *s=
dev,
>> 	}
>> }
>>=20
>> +/*
>> + * generate uevent when receiving sense code from device
>> + */
>> +static void scsi_send_sense_uevent(struct scsi_device *sdev,
>> +				   struct scsi_cmnd *scmd,
>> +				   struct scsi_sense_hdr *sshdr)
>> +{
>> +#ifdef CONFIG_SCSI_SENSE_UEVENT
>> +	struct scsi_event *evt;
>> +
>> +	if (!test_bit(sshdr->sense_key & 0xf,
>> +		      &sdev->sense_event_filter))
>> +		return;
>> +	evt =3D sdev_evt_alloc(SDEV_EVT_SCSI_SENSE, GFP_ATOMIC);
>> +	if (!evt)
>> +		return;
>> +
>> +	evt->sense_evt_data.lba =3D scsi_get_lba(scmd);
>> +	evt->sense_evt_data.size =3D blk_rq_bytes(scmd->request);
>> +	memcpy(&evt->sense_evt_data.sshdr, sshdr,
>> +	       sizeof(struct scsi_sense_hdr));
>> +	sdev_evt_send(sdev, evt);
>> +#endif
>> +}
>> +
>=20
> So when I turn this CONFIG_ off, do I get all kinds of warning about
> unused variables?

I don't get any warning at this time. I will keep testing w/ and w/o
the config enabled.=20

Thanks,
Song=
