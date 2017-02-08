From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v2] scsi/sd: release scan_mutex during sync_cache and
 start_stop
Date: Wed, 8 Feb 2017 21:15:52 +0000
Message-ID: <B1D89BEC-5455-4A51-A3BE-86C6E9A74F34@fb.com>
References: <20170208204240.4002411-1-songliubraving@fb.com>
 <20170208210258.GA8957@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43235 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751544AbdBHVQ1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2017 16:16:27 -0500
In-Reply-To: <20170208210258.GA8957@infradead.org>
Content-Language: en-US
Content-ID: <6ADDC23106641E45B56862CA60DEE7ED@namprd15.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


> On Feb 8, 2017, at 1:02 PM, Christoph Hellwig <hch@infradead.org> wrote:
>=20
> On Wed, Feb 08, 2017 at 12:42:40PM -0800, Song Liu wrote:
>> When a device is deleted through sysfs handle "delete", the code
>> locks shost->scan_mutex. If multiple devices are deleted at the
>> same time, these deletes will be handled in series.
>>=20
>> On the other hand, sd_shutdown() sometimes issues long latency
>> commands: sync cache and start_stop. It is not necessary for these
>> commands to run in series.
>>=20
>> To reduce latency of parallel "delete" requests, this patch unlock
>> shost->scan_mutex before long latency commands and relock the mutex
>> after the command.
>>=20
>> Fixed bug from previous version.
>>=20
>> Reported-by: kernel test robot <fengguang.wu@intel.com>
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>> drivers/scsi/sd.c | 15 +++++++++++++++
>> 1 file changed, 15 insertions(+)
>>=20
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 9e0783b..22add77 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -3304,6 +3304,9 @@ static int sd_start_stop_device(struct scsi_disk *=
sdkp, int start)
>> static void sd_shutdown(struct device *dev)
>> {
>> 	struct scsi_disk *sdkp =3D dev_get_drvdata(dev);
>> +	struct scsi_device *sdev;
>> +	struct Scsi_Host *shost;
>> +	bool scan_mutex_locked;
>>=20
>> 	if (!sdkp)
>> 		return;         /* this can happen */
>> @@ -3311,14 +3314,26 @@ static void sd_shutdown(struct device *dev)
>> 	if (pm_runtime_suspended(dev))
>> 		return;
>>=20
>> +	sdev =3D sdkp->device;
>> +	shost =3D sdev->host;
>> +	scan_mutex_locked =3D mutex_is_locked(&shost->scan_mutex);
>=20
> The use of mutex_is_locked outside of asserts is always bogus.
>=20
> The fix you want is most like in the caller of the method.

Hi Christoph,=20

Thanks for the feedback. The other caller (that does not hold scan_mutex)=20
of sd_shutdown() is device_shutdown() in drivers/base/core.c. I could not=20
think of a good way to lock scan_mutex there.=20

Would some variation of mutex_trylock() be a better option here?=20

Thanks,
Song
