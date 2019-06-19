From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v1] scsi: Don't select SCSI_PROC_FS by default
Date: Wed, 19 Jun 2019 10:34:42 -0400
Message-ID: <48912bc0-8c79-408d-7ed2-c127b99b8bcc@interlog.com>
References: <2de15293-b9be-4d41-bc67-a69417f27f7a@free.fr>
 <621306ee-7ab6-9cd2-e934-94b3d6d731fc@acm.org>
 <fb2d2e74-6725-4bf2-cf6c-63c0a2a10f4f@interlog.com>
 <alpine.LNX.2.21.1906181107240.287@nippy.intranet>
 <017cf3cf-ecd8-19c2-3bbd-7e7c28042c3c@free.fr>
 <f8339103-5b45-b72d-9f87-fd4dd7b3081e@interlog.com>
 <f1f98ab0-399a-6c12-073d-ee8ad47d5588@free.fr>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f1f98ab0-399a-6c12-073d-ee8ad47d5588@free.fr>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Gonzalez <marc.w.gonzalez@free.fr>
Cc: Finn Thain <fthain@telegraphics.com.au>, Bart Van Assche <bvanassche@acm.org>, James Bottomley <jejb@linux.ibm.com>, Martin Petersen <martin.petersen@oracle.com>, SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On 2019-06-19 5:42 a.m., Marc Gonzalez wrote:
> On 18/06/2019 17:31, Douglas Gilbert wrote:
> 
>> On 2019-06-18 3:29 a.m., Marc Gonzalez wrote:
>>
>>> Please note that I am _in no way_ suggesting that we remove any code.
>>>
>>> I just think it might be time to stop forcing CONFIG_SCSI_PROC_FS into
>>> every config, and instead require one to explicitly request the aging
>>> feature (which makes CONFIG_SCSI_PROC_FS show up in a defconfig).
>>>
>>> Maybe we could add CONFIG_SCSI_PROC_FS to arch/x86/configs/foo ?
>>> (For which foo? In a separate patch or squashed with this one?)
>>
>> Since current sg driver usage seems to depend more on SCSI_PROC_FS
>> being "y" than other parts of the SCSI subsystem then if
>> SCSI_PROC_FS is to default to "n" in the future then a new
>> CONFIG_SG_PROC_FS variable could be added.
>>
>> If CONFIG_CHR_DEV_SG is "*" or "m" then default CONFIG_SG_PROC_FS
>> to "y"; if CONFIG_SCSI_PROC_FS is "y" then default CONFIG_SG_PROC_FS
>> to "y"; else default CONFIG_SG_PROC_FS to "n". Obviously the
>> sg driver would need to be changed to use CONFIG_SG_PROC_FS instead
>> of CONFIG_SCSI_PROC_FS .
> 
> I like your idea, and I think it might even be made slightly simpler.
> 
> I assume sg3_utils requires CHR_DEV_SG. Is it the case?
> 
> If so, we would just need to enable SCSI_PROC_FS when CHR_DEV_SG is enabled.
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 73bce9b6d037..642ca0e7d363 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -54,14 +54,12 @@ config SCSI_NETLINK
>   config SCSI_PROC_FS
>   	bool "legacy /proc/scsi/ support"
>   	depends on SCSI && PROC_FS
> -	default y
> +	default CHR_DEV_SG
>   	---help---
>   	  This option enables support for the various files in
>   	  /proc/scsi.  In Linux 2.6 this has been superseded by
>   	  files in sysfs but many legacy applications rely on this.
>   
> -	  If unsure say Y.
> -
>   comment "SCSI support type (disk, tape, CD-ROM)"
>   	depends on SCSI
>   
> 
> Would that work for you?
> I checked that SCSI_PROC_FS=y whether CHR_DEV_SG=y or m
> I can spin a v2, with a blurb about how sg3_utils relies on SCSI_PROC_FS.

Yes, but (see below) ...

>> Does that defeat the whole purpose of your proposal or could it be
>> seen as a partial step in that direction? What is the motivation
>> for this proposal?
> 
> The rationale was just to look for "special-purpose" options that are
> enabled by default, and change the default wherever possible, as a
> matter of uniformity.
> 
>> BTW We still have the non-sg related 'cat /proc/scsi/scsi' usage
>> and 'cat /proc/scsi/device_info'. And I believe the latter one is
>> writable even though its permissions say otherwise.
> 
> Any relation between SG and BSG?

Only in the sense that writing to /proc/scsi/device_info changes the
way the SCSI mid-level handles the identified device. So that is
in common with, and hence the same relation as,  sd, sr, st, ses, etc
have with the identified device (e.g. a specialized USB dongle).


Example of use of /proc/scsi/scsi

$ cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
   Vendor: Linux    Model: scsi_debug       Rev: 0188
   Type:   Direct-Access                    ANSI  SCSI revision: 07
Host: scsi0 Channel: 00 Id: 00 Lun: 01
   Vendor: Linux    Model: scsi_debug       Rev: 0188
   Type:   Direct-Access                    ANSI  SCSI revision: 07
Host: scsi0 Channel: 00 Id: 00 Lun: 02
   Vendor: Linux    Model: scsi_debug       Rev: 0188
   Type:   Direct-Access                    ANSI  SCSI revision: 07

Which can be replaced by:

$ lsscsi
[0:0:0:0]    disk    Linux    scsi_debug       0188  /dev/sda
[0:0:0:1]    disk    Linux    scsi_debug       0188  /dev/sdb
[0:0:0:2]    disk    Linux    scsi_debug       0188  /dev/sdc
[N:0:1:1]    disk    INTEL SSDPEKKF256G7L__1                    /dev/nvme0n1

Or if one really likes the "classic" look:

$ lsscsi -c
Attached devices:
Host: scsi0 Channel: 00 Target: 00 Lun: 00
   Vendor: Linux    Model: scsi_debug       Rev: 0188
   Type:   Direct-Access                    ANSI SCSI revision: 07
Host: scsi0 Channel: 00 Target: 00 Lun: 01
   Vendor: Linux    Model: scsi_debug       Rev: 0188
   Type:   Direct-Access                    ANSI SCSI revision: 07
Host: scsi0 Channel: 00 Target: 00 Lun: 02
   Vendor: Linux    Model: scsi_debug       Rev: 0188
   Type:   Direct-Access                    ANSI SCSI revision: 07


Now looking at /proc/scsi/device_info

IMO unless there is a replacement for /proc/scsi/device_info
then your patch should not go ahead . If it does, any reasonable
distro should override it.

$ cat /proc/scsi/device_info
'Aashima' 'IMAGERY 2400SP' 0x1
'CHINON' 'CD-ROM CDS-431' 0x1
'CHINON' 'CD-ROM CDS-535' 0x1
'DENON' 'DRD-25X' 0x1
...
'XYRATEX' 'RS' 0x240
'Zzyzx' 'RocketStor 500S' 0x40
'Zzyzx' 'RocketStor 2000' 0x40


That is a black (or quirks) list that can be added to by writing an
entry to /proc/scsi/device_info . So if a user has a device that needs
one of those quirks defined to stop their system locking up when a
device of that type is plugged in, and the distro or some app (say,
that needs that device) knows about that, then it would be sad if
/proc/scsi/device_info was missing due to the changed default that is
being proposed.

The word "legacy" *** is thrown around a bit too often. It is not
legacy if there is no replacement for that functionality.

Doug Gilbert


*** I'm assuming "aging feature" is a softer form of "legacy feature".
     "Classic" may be going too far the other way from "aged" and
     "legacy".
