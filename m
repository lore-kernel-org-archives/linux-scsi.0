From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: Disk Errors
Date: Tue, 1 Feb 2005 10:56:58 -0500
Message-ID: <74A9A71929931E40967CA9F27B1D7396DC00ED@hdsmsx401.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Received: from fmr15.intel.com ([192.55.52.69]:1467 "EHLO
	fmsfmr005.fm.intel.com") by vger.kernel.org with ESMTP
	id S262051AbVBAP5J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2005 10:57:09 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, dougg@torque.net, Kit Gerrits <kit@gerritsacc.nl>
Cc: linux-scsi@vger.kernel.org

Kit,

If you have another (non-RAID) SCSI system, you could take the faulty
drive there to modify the mode pages to turn on AWRE and ARRE with
either sgmode (scsirastools.sf.net) or sginfo (sg3_utils).

Otherwise, you are dependent on the tools that are provided for the
PowerEdge RAID controller.

Andy

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Douglas Gilbert
Sent: Tuesday, February 01, 2005 7:44 AM
To: Kit Gerrits
Cc: linux-scsi@vger.kernel.org
Subject: Re: Disk Errors

Kit Gerrits wrote:
> I have found 08:05 to correspond to /dev/sda5, mounted as /usr(Thanks
for
> the pointer!).
> 
> Sda is the single-drive volume
> (non-RAID, as it is only for the O/S,
> which needs to be speedy and can be pulled from tape easily).
> 
> This explains several things:
> A/ Why a single error can take an entire volume offline B/ Why the
error is
> not logged
> 	If it only took the partition offline, 
> 	it would still have been logged, 
> 	as / is mounted from sda3
> 
> And leaves one question:
> What caused the error?
> 
> There are no GROWN defects on the drive in this volume

Kit,
A block/sector is added to the grown defect list after it
has been reassigned. Reaasignment occurs automatically for
recoverable (medium) errors if the AWRE and/or ARRE bits are
set (those bits are in the read write error recovery mode page).

So there are two situations in which damaged blocks remain
accessible:
    1) unrecoverable medium errors
    2) recoverable medium errors when AWRE and/or ARRE
       are clear

Case 2) can be ignored ** or could be handled by setting
ARRE and then reading the whole disk (e.g. with dd). Both cases
can be handled with the REASSIGN BLOCKS SCSI command
once the defective logical block address (lba) or
addresses have been identified.

Using the sg3_utils package various things can be
done:
    - "sginfo -e /dev/sda" will show the AWRE and ARRE
      settings. Changing them with sginfo is a bit ugly
    - "sginfo -G /dev/sda" will show the grown defect list
      in "index" format (up to 3 other formats may be
      available)
    - "sg_dd if=/dev/sg0 of=/dev/null bs=512" will read the
      whole disk or fail at the first unrecoverable (medium)
      error. If a medium error is detected the "info"
      field is the lba of the defect. ***
    - "sg_reassign -a <lba> /dev/sda" will reassign the
      <lba> block. If this succeeds <lba> should appear
      in the grown defect list ("sginfo -G -Flogical /dev/sda").

When a logical block with unrecoverable errors is reassigned
then the new contents are vendor specific. I'm not sure how
file systems react to this.


** recoverable errors can be ignored. Assuming these
    recoverable errors occur on read operations then the
    "read error counter" log page's
    recovered error counter (one of them depending on the
    duration of the recovery process) will be incremented

*** due to error processing, it is still better to use /dev/sg0
     rather than than /dev/sda with the sg_dd utility. Recent
     changes (lk 2.6.11-rc2-bk8) make the following work:
     "sg_dd if=/dev/sda blk_sgio=1 of=/dev/null bs=512"
     in the presence of errors

Doug Gilbert

> ---------------
> Reference logs:
> ---------------
> 
> Executing: disk show defects (ID=0)
> Number of PRIMARY defects on drive: 1912 Number of GROWN defects on
drive: 0
> 
> Executing: container list
> Num          Total  Oth Chunk          Scsi   Partition    
> Label Type   Size   Ctr Size   Usage   B:ID:L Offset:Size
> ----- ------ ------ --- ------ ------- ------ -------------
>  0    Volume 8.47GB            Open    0:00:0 64.0KB:8.47GB
>  /dev/sda             NT
>  1    RAID-5 16.9GB       32KB Open    0:01:0 64.0KB:8.47GB
>  /dev/sdb             DATA             0:02:0 64.0KB:8.47GB
>                                        ?:??:?  - Missing - Mount
points it
> to:
> # /dev/sda5             5.3G  1.5G  3.6G  30% /usr
>  
> 
> 
>>-----Oorspronkelijk bericht-----
>>Van: Salyzyn, Mark [mailto:mark_salyzyn@adaptec.com]
>>Verzonden: dinsdag 1 februari 2005 4:15
>>Aan: Kit Gerrits
>>Onderwerp: RE: Disk errors
>>
>>The controller does not appear to be busted; you have a Volume and a 
>>RAID-5. Are you missing an Array?
>>
>>A two drive failure on a RAID-5 gives you an offline array.
>>
>>A single drive failure in a Volume gives you an offline array.
>>
>>You need to find who is 08:05, look through /dev for the major/minor 
>>number and relate it to the 'device'. Look through /proc/scsi/scsi and

>>/var/messages to help correlate it.
>>
>>Sincerely -- Mark Salyzyn
>>
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
