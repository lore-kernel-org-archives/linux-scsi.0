From: Song Liu <songliubraving@fb.com>
Subject: Re: [RFC v2 2/2] scsi: add rate limit to scsi sense code uevent
Date: Thu, 8 Jun 2017 22:42:37 +0000
Message-ID: <F36FA0D9-0FB9-458A-979A-ADB74FED7A64@fb.com>
References: <20170518181456.1955523-1-songliubraving@fb.com>
 <20170518181456.1955523-3-songliubraving@fb.com>
 <1496701335.4753.220.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60623 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751475AbdFHWmu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jun 2017 18:42:50 -0400
In-Reply-To: <1496701335.4753.220.camel@localhost.localdomain>
Content-Language: en-US
Content-ID: <3B49F0E654C5E946BDA9FB4FA3B8EE97@namprd15.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "emilne@redhat.com" <emilne@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@fb.com>, "axboe@kernel.dk" <axboe@kernel.dk>, Benjamin Block <bblock@linux.vnet.ibm.com>


> On Jun 6, 2017, at 6:22 AM, Ewan D. Milne <emilne@redhat.com> wrote:
>=20
> On Thu, 2017-05-18 at 11:14 -0700, Song Liu wrote:
>> This patch adds rate limits to SCSI sense code uevets. Currently,
>> the rate limit is hard-coded to 16 events per second.
>>=20
>> The code tracks nano second time of latest 16 events in a circular
>> buffer. When a new event arrives, the time is compared against the
>> latest time in the buffer. If the difference is smaller than one
>> second, the new event is dropped.
>>=20
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>> drivers/scsi/scsi_error.c  | 15 +++++++++++++++
>> drivers/scsi/scsi_scan.c   |  4 ++++
>> include/scsi/scsi_device.h | 12 +++++++++++-
>> 3 files changed, 30 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index a49c63a..91e6b0a 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -436,11 +436,26 @@ static void scsi_send_sense_uevent(struct scsi_dev=
ice *sdev,
>> #ifdef CONFIG_SCSI_SENSE_UEVENT
>> 	struct scsi_event *evt;
>> 	unsigned char sb_len;
>> +	unsigned long flags;
>> +	u64 time_ns;
>>=20
>> 	if (!test_bit(sshdr->sense_key & 0xf,
>> 		      &sdev->sense_event_filter))
>> 		return;
>> 	evt =3D sdev_evt_alloc(SDEV_EVT_SCSI_SENSE, GFP_ATOMIC);
>> +
>> +	time_ns =3D ktime_to_ns(ktime_get());
>> +	spin_lock_irqsave(&sdev->latest_event_lock, flags);
>> +	if (time_ns - sdev->latest_event_times[sdev->latest_event_idx] <
>> +	    NSEC_PER_SEC) {
>> +		spin_unlock_irqrestore(&sdev->latest_event_lock, flags);
>> +		return;
>=20
> You have an allocated evt here, so if you return here you will leak
> kernel memory.

I will fix this in next version.=20

>=20
> This code appears to be rate limiting per-sdev.  You have to remember
> that on a large system, there could be thousands of these devices.
> You could easily end up generating 10s or 100s of thousands of events
> per second, in a very short amount of time under certain failure
> conditions.
>=20
> The udev event mechanism can realistically only process a few
> hundred events per second before it starts getting behind, due to
> the rule processing engine (the rules in userspace).
>=20
> You also have to consider that if you clog up udev with a lot of
> your events, you affect event processing for other events.
>=20

Yeah, this is great point. Would Scsi_Host level rate limiting make
sense for this type of cases? Or shall I add a global rate limit?

Thanks,
Song
