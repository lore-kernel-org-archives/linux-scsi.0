From: Hannes Reinecke <hare@suse.de>
Subject: Re: PROBLEM: special sense code asc,ascq=04h,0Ch abort scsi scan
 in the middle
Date: Tue, 15 Oct 2013 07:51:28 +0200
Message-ID: <525CD7E0.7050809@suse.de>
References: <525AD704.6040705@oracle.com> <525BD1EA.6000701@suse.de> <525CB742.4010409@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <525CB742.4010409@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: vaughan <vaughan.cao@oracle.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/15/2013 05:32 AM, vaughan wrote:
> On 10/14/2013 07:13 PM, Hannes Reinecke wrote:
>> In the log, inquiry to LUN7 return a sense - asc,ascq=3D04h,0Ch
>> (Logical unit not accessible, target port in unavailable state).
>> And this is ignored, so scsi_probe_lun() returns -EIO and the scan
>> process is aborted.
>>
>> I have two questions:
>> 1. Is it correct for hardware to return a sense 04h,0Ch to inquiry
>> again, even after presenting this lun in responce to REPORT_LUN
>> command?
>> Yes, this is correct. 'REPORT LUNS' is supported in 'Unavailable' st=
ate.
>>
>>> 2. Since windows and solaris can continue scan, is it reasonable fo=
r
>>> linux to do the same, even for a fault-tolerance purpose?
>>>
>> Hmm. Yes, and no.
>>
>> _Actually_ this is an issue with the target, as it looks as if it
>> will return the above sense code while sending an 'INQUIRY' to the
>> device.
>> SPC explicitely states that the INQUIRY command should _not_ fail
>> for unavailable devices.
> Hi all,
>=20
> I found this below in spc4.
>>>>
> 5.15.2.4.4 Target port group asymmetric access states - Standby state
> While in the unavailable primary target port asymmetric access state,
> the device server shall support those of
> the following commands that it supports while in the active/optimized=
 state:
> a) INQUIRY (the peripheral qualifier (see 6.6.2) shall be set to 001b=
);
> ....
> For those commands that are not supported, the device server shall
> terminate the command with CHECK
> CONDITION status, with the sense key set to NOT READY, and the
> additional sense code set to LOGICAL
> UNIT NOT ACCESSIBLE, TARGET PORT IN UNAVAILABLE STATE.
> <<<
> From the above, I suppose the hardware may works very compliant with
> spc. The case could be:
> Storage is a alua supported target. Initiator sent REPORT_LUN to targ=
et,
> target return all pqual=3D000b to it.
> Then Initiator INQUIRY lun 7 which is in standby state where pqual=3D=
000b
> not 001b. So this INQUIRY is regarded as
> 'not supported', and get terminated with CHECK_CONDITION,  sense key=3D=
NOT
> READY, asc,ascq=3D04h,0ch.
>=20
> Could you confirm if my understanding is right or wrong?
>=20
Wrong.

The sentence states that the device server _shall_ support those
commands, where the results should be identical as if the port would
have been in active/optimized state.

So INQUIRY always has to be supported, regardless of which primary
ALUA state the port happens to be in.

(Otherwise we'd be hard-pressed to figure out whether the port is in
'unavailable' ALUA state in the first place, as without the INQUIRY
data we couldn't even _tell_ if ALUA is supported.)

So yeah, it really looks like a firmware issue here.

But that notwithstanding, did you get a chance to test my patch?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
