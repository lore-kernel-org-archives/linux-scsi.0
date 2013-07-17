From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
Subject: RE: mpt2sas,mpt3sas watchdog device removal
Date: Wed, 17 Jul 2013 17:33:20 +0530
Message-ID: <DCD177647606E9419ED923E0C8C4AA723006C4B1D7@inbmail02.lsi.com>
References: <20130515132401.6a8ff7fb@jlaw-desktop.mno.stratus.com>
	<20130515132948.7dc4c551@jlaw-desktop.mno.stratus.com>
	<DCD177647606E9419ED923E0C8C4AA723006C4AFF2@inbmail02.lsi.com>
	<1373976218.2148.49.camel@dabdike>
 <20130716112131.03d019ab@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:43910
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754531Ab3GQMDb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Jul 2013 08:03:31 -0400
In-Reply-To: <20130716112131.03d019ab@jlaw-desktop.mno.stratus.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>, James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Joe,

>-----Original Message-----
>From: Joe Lawrence [mailto:joe.lawrence@stratus.com]
>Sent: Tuesday, July 16, 2013 8:52 PM
>To: James Bottomley
>Cc: Reddy, Sreekanth; linux-scsi@vger.kernel.org
>Subject: Re: mpt2sas,mpt3sas watchdog device removal
>
>On Tue, 16 Jul 2013 16:03:38 +0400
>James Bottomley <James.Bottomley@hansenpartnership.com> wrote:
>
>> On Tue, 2013-07-16 at 17:30 +0530, Reddy, Sreekanth wrote:
>> > James,
>> >
>> > This patch seem to be fine. Please consider this patch.
>>
>> Where's the new version?  The one that has all of this fixed:
>>
>> > Off list, Sreekanth from LSI tested and noticed a few issues with
>> > this
>> > patch:
>> >
>> >  - mpt2sas_base_stop_watchdog is called twice: The call from
>> >    mpt2sas_base_detach is safe, but now unnecessary (as a call was
>> >    added earlier up in the PCI driver callbacks to ensure that the
>> >    watchdog was out of the way.) This second invocation can be
>> > removed.
>> >
>> >  - If the watchdog detects a bad IOC, the watchdog remains running:
>> >    The watchdog workqueue isn't cleaned up until
>> >    mpt2sas_base_stop_watchdog is called, so in the case that the
>> >    watchdog removes the device from SCSI topo, the workqueue will
>> >    remain unused until PCI .remove/.shutdown cleans it up. Perhaps a
>> >    single watchdog that iterates over all adapters would be simpler?
>> >
>> > Finally, if SCSI topo detachment is all that is interesting here,
>> > would it make more sense to move the watchdog into the MPT "scsi"
>> > code?  I haven't looked at the code yet, but this might make an MPT
>> > fusion patch easier (due to dependencies between its "scsi" and
>> > "base" modules).
>
>This patch fizzled out in May as other work took priority.  If LSI is still
>interested in these changes, I can dust off my notes and test/rebase for the
>3.11 series.
 

It would be grate help if you post the updated patch which will accommodate the fixes for above comments.   
 
>
>A few of the issues quoted above are easily fixed, however I remember
>having an outstanding question of how to best clean up the driver's per device
>watchdog workqueue:
>
>The way the MPT drivers are working right now is that the watchdog
>workqueue function _base_fault_reset_work() initiates a PCI device removal
>via kthread.  The PCI callback kthread context then tears down the device and
>cancel/flush/destroys the watchdog workqueue.
>
>This patch eliminated the kthread and its call into PCI API, simply detaching
>from the SCSI midlayer.  In my opinion, the kthread complicated device
>removal and introduced potential races if the watchdog tried removing the
>device at the same time an ordinary device removal request occurred.
>
>At the time, the best solution I had was to leave the unused workqueue
>around until its PCI device was removed.
>
>Regards,
>
>-- Joe

Regards,
Sreekanth

