From: vaughan <vaughan.cao@oracle.com>
Subject: Re: PROBLEM: special sense code asc,ascq=04h,0Ch abort scsi scan
 in the middle
Date: Tue, 15 Oct 2013 11:32:18 +0800
Message-ID: <525CB742.4010409@oracle.com>
References: <525AD704.6040705@oracle.com> <525BD1EA.6000701@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <525BD1EA.6000701@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/14/2013 07:13 PM, Hannes Reinecke wrote:
> In the log, inquiry to LUN7 return a sense - asc,ascq=04h,0Ch
> (Logical unit not accessible, target port in unavailable state).
> And this is ignored, so scsi_probe_lun() returns -EIO and the scan
> process is aborted.
>
> I have two questions:
> 1. Is it correct for hardware to return a sense 04h,0Ch to inquiry
> again, even after presenting this lun in responce to REPORT_LUN
> command?
> Yes, this is correct. 'REPORT LUNS' is supported in 'Unavailable' state.
>
>> 2. Since windows and solaris can continue scan, is it reasonable for
>> linux to do the same, even for a fault-tolerance purpose?
>>
> Hmm. Yes, and no.
>
> _Actually_ this is an issue with the target, as it looks as if it
> will return the above sense code while sending an 'INQUIRY' to the
> device.
> SPC explicitely states that the INQUIRY command should _not_ fail
> for unavailable devices.
Hi all,

I found this below in spc4.
>>>
5.15.2.4.4 Target port group asymmetric access states - Standby state
While in the unavailable primary target port asymmetric access state,
the device server shall support those of
the following commands that it supports while in the active/optimized state:
a) INQUIRY (the peripheral qualifier (see 6.6.2) shall be set to 001b);
....
For those commands that are not supported, the device server shall
terminate the command with CHECK
CONDITION status, with the sense key set to NOT READY, and the
additional sense code set to LOGICAL
UNIT NOT ACCESSIBLE, TARGET PORT IN UNAVAILABLE STATE.
<<<
>From the above, I suppose the hardware may works very compliant with
spc. The case could be:
Storage is a alua supported target. Initiator sent REPORT_LUN to target,
target return all pqual=000b to it.
Then Initiator INQUIRY lun 7 which is in standby state where pqual=000b
not 001b. So this INQUIRY is regarded as
'not supported', and get terminated with CHECK_CONDITION,  sense key=NOT
READY, asc,ascq=04h,0ch.

Could you confirm if my understanding is right or wrong?

Thanks,
Vaughan
> But yeah, we probably should work around this issues.
> Nevertheless, please raise this issue with your array vendor.
>
> Please try the attached patch.
>
> Cheers,
>
> Hannes
