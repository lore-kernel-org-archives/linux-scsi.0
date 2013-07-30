From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [SCSI REGRESSION] 3.10.2 or 3.10.3: arcmsr failure at bootup
 / early userspace transition
Date: Mon, 29 Jul 2013 20:28:20 -0400
Message-ID: <51F708A4.9090207@interlog.com>
References: <87r4ehfzhf.fsf@spindle.srvr.nix> <51F667C2.4020801@fastmail.fm> <87mwp5frdl.fsf@spindle.srvr.nix> <51F67959.2060803@fastmail.fm> <87fvuxdqes.fsf@spindle.srvr.nix>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87fvuxdqes.fsf@spindle.srvr.nix>
Sender: linux-kernel-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, nick.cheng@areca.com.tw, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 13-07-29 05:09 PM, Nix wrote:
> On 29 Jul 2013, Bernd Schubert uttered the following:
>
>> On 07/29/2013 03:05 PM, Nix wrote:
>>> On 29 Jul 2013, Bernd Schubert said:
>>>
>>>> Hi Nick,
>>>>
>>>> On 07/29/2013 12:10 PM, Nick Alcock wrote:
>>>>> arcmsr0: abort device command of scsi id = 0 lun = 1
>>>>> arcmsr0: abort device command of scsi id = 0 lun = 0
>>>>> arcmsr: executing bus reset eh.....num_resets=0, num_[...]
>>>>>
>>>>> arcmsr0: wait 'abort all outstanding command' timeout
>>>>> arcmsr0: executing hw bus reset ....
>>>>> arcmsr0: waiting for hw bus reset return, retry=0
>>>>> arcmsr0: waiting for hw bus reset return, retry=1
>>>>> Areca RAID Controller0: F/W V1.46 2009-01-06 & Model ARC-1210
>>>>> arcmsr: scsi  bus reset eh returns with success
>>>>> [and back to the top of the error messages again, apparently forever,
>>>>>     not that the machine would be much use without its RAID array even
>>>>>     if this loop terminated at some point, so I only gave it a couple
>>>>>     of minutes]
>>>>>
>>>>> The failure happens precisely at the moment we transition to early
>>>>> userspace, so presumably userspace I/O is failing (or something related
>>>>> to raw device access, perhaps, since the first thing it does is a
>>>>> vgscan).
>>>>>
>>>>> I haven't bisected yet (sorry, I have work to do which means this
>>>>> machine must be running right now), but nothing has changed in the
>>>>> arcmsr controller, nor in SCSI-land excepting
>>>>>
>>>>> commit 98dcc2946adbe4349ef1ef9b99873b912831edd4
>>>>> Author: Martin K. Petersen <martin.petersen@oracle.com>
>>>>> Date:   Thu Jun 6 22:15:55 2013 -0400
>
> I can now confirm that reverting this commit causes this problem to go
> away, and my machine boots fine again.
>
> Please revert (and figure out what is wrong so that 3.11 doesn't
> implode in the same way? I'm happy to assist...)

Hi,
Please supply the information that Martin Petersen asked
for.

I just examined a more recent Areca SAS RAID controller
and would describe it as the SCSI device from hell. One solution
to this problem is to modify the arcmsr driver so it returns
a more consistent set of lies to the management SCSI commands that
Martin is asking about.

Doug Gilbert
