From: Marc Gonzalez <marc.w.gonzalez@free.fr>
Subject: Re: [PATCH v1] scsi: Don't select SCSI_PROC_FS by default
Date: Thu, 20 Jun 2019 11:01:39 +0200
Message-ID: <e04e14b7-e1ee-c0c1-9e6d-2628d2c873a9@free.fr>
References: <2de15293-b9be-4d41-bc67-a69417f27f7a@free.fr>
 <621306ee-7ab6-9cd2-e934-94b3d6d731fc@acm.org>
 <fb2d2e74-6725-4bf2-cf6c-63c0a2a10f4f@interlog.com>
 <alpine.LNX.2.21.1906181107240.287@nippy.intranet>
 <017cf3cf-ecd8-19c2-3bbd-7e7c28042c3c@free.fr>
 <f8339103-5b45-b72d-9f87-fd4dd7b3081e@interlog.com>
 <f1f98ab0-399a-6c12-073d-ee8ad47d5588@free.fr>
 <48912bc0-8c79-408d-7ed2-c127b99b8bcc@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <48912bc0-8c79-408d-7ed2-c127b99b8bcc@interlog.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: Finn Thain <fthain@telegraphics.com.au>, Bart Van Assche <bvanassche@acm.org>, James Bottomley <jejb@linux.ibm.com>, Martin Petersen <martin.petersen@oracle.com>, SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On 19/06/2019 16:34, Douglas Gilbert wrote:

> On 2019-06-19 5:42 a.m., Marc Gonzalez wrote:
> 
>> I assume sg3_utils requires CHR_DEV_SG. Is it the case?
>>
>> If so, we would just need to enable SCSI_PROC_FS when CHR_DEV_SG is enabled.
>>
>> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
>> index 73bce9b6d037..642ca0e7d363 100644
>> --- a/drivers/scsi/Kconfig
>> +++ b/drivers/scsi/Kconfig
>> @@ -54,14 +54,12 @@ config SCSI_NETLINK
>>   config SCSI_PROC_FS
>>   	bool "legacy /proc/scsi/ support"
>>   	depends on SCSI && PROC_FS
>> -	default y
>> +	default CHR_DEV_SG
>>   	---help---
>>   	  This option enables support for the various files in
>>   	  /proc/scsi.  In Linux 2.6 this has been superseded by
>>   	  files in sysfs but many legacy applications rely on this.
>>   
>> -	  If unsure say Y.
>> -
>>   comment "SCSI support type (disk, tape, CD-ROM)"
>>   	depends on SCSI
>>   
>>
>> Would that work for you?
>> I checked that SCSI_PROC_FS=y whether CHR_DEV_SG=y or m
>> I can spin a v2, with a blurb about how sg3_utils relies on SCSI_PROC_FS.
> 
> Yes, but (see below) ...
> 
> Example of use of /proc/scsi/scsi [...]
> Now looking at /proc/scsi/device_info [...]
> 
> IMO unless there is a replacement for /proc/scsi/device_info
> then your patch should not go ahead . If it does, any reasonable
> distro should override it.
> 
> That is a black (or quirks) list that can be added to by writing an
> entry to /proc/scsi/device_info . So if a user has a device that needs
> one of those quirks defined to stop their system locking up when a
> device of that type is plugged in, and the distro or some app (say,
> that needs that device) knows about that, then it would be sad if
> /proc/scsi/device_info was missing due to the changed default that is
> being proposed.

You've made it clear that SCSI_PROC_FS is important for several classes
of hardware.

You worry that changing the Kconfig default would force distro maintainers
(we are talking about Debian/Redhat/Suse/etc right?) to actually turn the
feature on, instead of relying on the "default y" behavior (as they have
done in the past).

How likely is it that distro kernels would *not* enable CHR_DEV_SG?
(Distros tend to enable everything, and then some.)

CHR_DEV_SG is enabled in the default configs for i386 and x86_64:

$ git grep CHR_DEV_SG arch/x86/configs/
arch/x86/configs/i386_defconfig:CONFIG_CHR_DEV_SG=y
arch/x86/configs/x86_64_defconfig:CONFIG_CHR_DEV_SG=y

=> As soon as CHR_DEV_SG is enabled, SCSI_PROC_FS is also enabled.

(I work on smaller systems where we do use /proc occasionally, but we
don't enable CHR_DEV_SG or SCSI_PROC_FS.)

I think we just need to find a reasonable condition for enabling
SCSI_PROC_FS by default on "your" sytems, and not on "mine" ;-)

Regards.
