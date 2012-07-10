From: Matthias Prager <linux@matthiasprager.de>
Subject: Re: 'Device not ready' issue on mpt2sas since 3.1.10
Date: Tue, 10 Jul 2012 02:12:04 +0200
Message-ID: <4FFB7354.8040809@matthiasprager.de>
References: <4FE454CA.6080007@matthiasprager.de> <4FFAED4F.3080100@matthiasprager.de> <4FFB32E5.1050109@farcaster.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FFB32E5.1050109@farcaster.org>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Trace <maillist@farcaster.org>
Cc: linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org, Matthias Prager <linux@matthiasprager.de>
List-Id: linux-scsi@vger.kernel.org

Am 09.07.2012 21:37, schrieb Robert Trace:
>> I did some further research regarding my problem.
>> It appears to me the fault does not lie with the mpt2sas driver (not
>> that I can definitely exclude it), but with the md implementation.
> 
> I'm actually discovering some of the same issues (LSI 9211-8i w/ SATA
> disks), but I've come to a slightly different conclusion.
> 
> I noticed that when my SATA disks are on a SATA controller and they spin
> down (or are spun down via hdparm -y), then they response to TUR (TEST
> UNIT READY) commands with an OK.  Any I/O sent to these disks simply
> wait while the disks spin up and then complete as usual.
> 
> However, my SATA disks on the SAS controller respond to TUR with the
> sense error "Not Ready/Initializing command required".  Any I/O sent to
> these disks immediately fails.  You saw this in your logging:
> 
>> [  604.838640] sd 2:0:0:0: [sda] Device not ready
>> [  604.838645] sd 2:0:0:0: [sda]  Result: hostbyte=DID_OK
>> driverbyte=DRIVER_SENSE
>> [  604.838655] sd 2:0:0:0: [sda]  Sense Key : Not Ready [current]
>> [  604.838663] sd 2:0:0:0: [sda]  Add. Sense: Logical unit not ready,
>> initializing command required
>> [  604.838668] sd 2:0:0:0: [sda] CDB: Read(10): 28 00 00 00 08 00 00 00
>> 20 00
>> [  604.838680] end_request: I/O error, dev sda, sector 2048
>> [  604.838688] Buffer I/O error on device md127, logical block 0
>> [  604.838695] Buffer I/O error on device md127, logical block 1
>> [  604.838699] Buffer I/O error on device md127, logical block 2
>> [  604.838702] Buffer I/O error on device md127, logical block 3
> 
> Sending an explicit START UNIT command to these sleeping disks will wake
> them up and then they behave normally.  (BTW, you can issue TURs and
> START UNITs via the sg_turs and sg_start commands).
Thanks for these pointers.

> 
> I've reproduced this behavior on the raw disks themselves, no MD layer
> involved (although the freak-out by my MD layer is what alerted me to
> this issue too... Having your entire array punted the first time you
> access it is a little scary :-).  I'm also on raw hardware and I've seen
> this behavior on kernels 3.0.33 through 3.4.4.
This is interesting - are you sure about 3.0.33? I'm running this kernel
atm for it gives me no trouble (as opposed to >=3.1.10). The SATA disks
are spun up when I access data on them.

> 
> So, SATA disks respond differently depending on the controller they're
> on.  I don't know if this is a SCSI thing, a SAS thing or a
> firmware/driver thing for the 9211.
> 
> Now, whether or not the MD layer should be assembling arrays from
> "failed" disks is, I think, a separate issue.
I realize now in my cases the MD layer behaved correctly.

> 
> -- Rob
> 


