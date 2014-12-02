From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 0/2] mpt{2,3}sas remove disconnected phys on topology
 change
Date: Tue, 02 Dec 2014 15:07:14 +0100
Message-ID: <547DC792.6070506@redhat.com>
References: <1375351291-27107-1-git-send-email-jvesely@redhat.com> <57e91c7f7bc1d3e0cd511f828ec8140b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <57e91c7f7bc1d3e0cd511f828ec8140b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Jan Vesely <jvesely@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: hch@infradead.org
List-Id: linux-scsi@vger.kernel.org

Hi Sreekanth,

I think this should be handled as any other change with an usual
patch sent to the list, 'git revert 3520f9c779' and 'git revert 963ba22b90'
will create the patches for you.

Cheers,
Tomas

On 12/02/2014 02:18 PM, Sreekanth Reddy wrote:
> Hi James/Chris
>
> We are observing below issue due to this patch set code changes
>
> Issue Description:
>      Drives connected Enclosure/Expander won't be visible to the OS if any
> one remove and add expander cable with in DMD (Device Missing Delay) time
> period (also if any power-off and power-on the Enclosure with in the DMD
> period).
>
> i.e.
> Due to this code changes; driver will unregister the Enclosure port or
> target PHY with SCSI transport layer, whenever driver receives "SAS
> TOPOLOGY CHANGE LIST EVENT" with reason code set to "PHY link status
> change" and phy link rate is Zero. Firmware usually send this type of "SAS
> TOPOLOGY CHANGE LIST EVENT" event whenever drive is missing. but still
> here DMD timer has not yet expired so normally driver should not
> unregister the target with the SCSI transport layer instead it will move
> the state of the  drive to blocked state (so it won't receive any IOs from
> SML for this drive).
>
> Normally, Driver should only unregister the target with SCSI transport
> layer only when driver receives "SAS TOPOLOGY CHANGE LIST EVENT" with
> reason code set to "Target Remove". Firmware will send this event when the
> DMD timer expires for the missing drive. If drive comes back with in the
> DMD period then firmware won't send this target remove event and so driver
> won't unregister the target drive with the SCSI transport layer. Driver
> will just unblock the target drive to start IOs to this drive.
>
> So, can you please revert this patch set changes back in the latest
> upstream kernel and if possible on stable kernels.
> I checked with the Redhat team and there are fine to revert back these
> patch set changes.
>
> Regards,
> Sreekanth
>
>> -----Original Message-----
>> From: Jan Vesely [mailto:jvesely@redhat.com]
>> Sent: Thursday, August 01, 2013 3:31 PM
>> To: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
>> Cc: Jan Vesely; Nandigama, Nagalakshmi; Reddy, Sreekanth; Tomas Henzl
>> Subject: [PATCH 0/2] mpt{2,3}sas remove disconnected phys on topology
>> change
>>
>> From: Jan Vesely <jvesely@redhat.com>
>>
>> These two patches add phy removal on link loss. This change keeps sysfs
>> up- to-date with actually connected phys. Without these patches,
>> disconnected phys remain listed under their former ports.
>>
>> tested on both mpt2sas and mpt3sas hw.
>>
>> CC: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
>> CC: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
>> CC: Tomas Henzl <thenzl@redhat.com>
>> Signed-off-by: Jan Vesely <jvesely@redhat.com>
>>
>> Jan Vesely (2):
>>  mpt2sas: Remove phys on topology change.
>>  mpt3sas: Remove phys on topology change
>>
>> drivers/scsi/mpt2sas/mpt2sas_transport.c |    5 ++++-
>> drivers/scsi/mpt3sas/mpt3sas_transport.c |    5 ++++-
>> 2 files changed, 8 insertions(+), 2 deletions(-)
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
