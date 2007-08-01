From: Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 2/4] Expose Power Management Policy option to users
Date: Wed, 01 Aug 2007 12:20:24 +0900
Message-ID: <46AFFBF8.9060002@gmail.com>
References: <20070705194909.337398431@intel.com>	<20070705130518.135e4e3c.kristen.c.accardi@intel.com>	<46AE12B6.6090408@garzik.org>	<46AED656.8070407@gmail.com>	<1185891382.2750.8.camel@laptopd505.fenrus.org>	<46AF4B05.4010700@gmail.com>	<20070731091841.857d22bb.kristen.c.accardi@intel.com>	<46AF75FA.5080502@gmail.com> <20070731132405.05b9cf06.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.186]:39937 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbXHADVh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jul 2007 23:21:37 -0400
Received: by rv-out-0910.google.com with SMTP id k20so59698rvb
        for <linux-scsi@vger.kernel.org>; Tue, 31 Jul 2007 20:21:37 -0700 (PDT)
In-Reply-To: <20070731132405.05b9cf06.kristen.c.accardi@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Jeff Garzik <jeff@garzik.org>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, edwintorok@gmail.com, axboe@kernel.dk

Kristen Carlson Accardi wrote:
> So at current rate of development and kernel release schedule, the best
> possible scenario is still 6 months away - whereas this patchset is already 
> tested and ready for merging now.

The best possible scenario is .24-rc1 merge window with or without
waiting.  With waiting, the best possible scenario is harder to achieve tho.

> Out of tree patches don't work.  Nobody tests them.  A module parameter
> will not work - we need to be able to expose the sysfs interface so that
> users may chose to turn the feature off and on at will - mainly according
> to their usage.  For example, at boot time - you want ALPM off to maximize
> performance.  Lets say when you are plugged into the wall socket, you leave
> it off, but then when you go on battery power you would want to enable it.

You can turn on and off dynamically using a module parameter.  Although
it's not a pretty interface, it should work as an interim solution if we
absolutely must merge ALPM now.

>> Due to the generosity of the ATA committee, we have, by default, at
>> least two ways to achieve link PS - HIPS and DIPS.  I dunno why but
>> someone thought we needed two.  And then, ahci people thought automatic
> 
> They thought we needed two because sometimes the device knows when it
> will be idle faster than the host can. this is why ALPM can determine
> idleness faster than any software algorithm on the host cpu can.  You
> can use ALPM without having HIPM.  You can also use it without having 
> DIPM.

I see.  I get that one way is better than another in some way.  I'm just
not convinced whether the advantage is substantial enough to justify the
complexity.

>> HIPS would be nice, which I fully agree, and added ALPM.  Unfortunately,
>> they mandated ALPM to kick in the moment command engine becomes idle, so
>> most current implementations suffer unnecessary performance hit when
>> ALPM is active.
> 
> "unnecessary" is subjective and at the moment, untrue.  You 
> have to make performance/power tradeoffs with anything, whether it's 
> CPU or your AHCI controller.  It's the current cost of getting out of these 
> sleep states even if you aren't using ALPM but just doing HIPM or DIPM 
> manually.

Having short cool-down time would remove most of performance degradation
and I'm pretty sure power consumption would stay about the same.

> But, this is why it's so critical to allow the user to 
> control when ALPM is enabled dynamically - which this patchset does.
> The medium power setting is provided for users who wish to not go to
> SLUMBER and get the higher latency cost but still have some power savings.

Note that PARTIAL also incurs noticeable performance degradation.

> I understand you are being cautious based on your prior experience, but
> again we still have no data to show that we are going to have a lot of
> problems.  Perhaps we should proceed optimistically and deal with problems
> when they actually occur rather than block something on a bet.

I would agree with you, merge it and see the fireworks in -mm if it
didn't involve user visible API.  We have an API decision to make here
and it hasn't been sufficiently considered yet.

>> The alternate way is to export flexible interface to userland and let
>> userland decide and if we're gonna do that.  SCSI sysfs just isn't the
>> place.
> 
> How about a patch? I'd love to have a flexible interface to userland,
> it was my goal to provide this with the sysfs files.  The requirement
> is that the users be able to turn ALPM off and on dynamically, and to
> be able to chose the power savings level you want - i.e. SLUMBER vs.
> PARTIAL - perferrably not using those terms since users really shouldn't
> need to know AHCI terminology just to chose a power management level.

As I wrote before, which level of interface to export to userland is
related with where to put the knowledge about working and broken
combinations.  Unfortunately, we don't have data to support one way or
the other at the moment.  All I'm saying is that we should be cautious
before introducing user-land visible interface which lives in SCSI sysfs
as it's unknown whether it would fit the reality or not.

Sorry that I don't have an alternative patch now, but something which
can relieve the situation is being worked on, so let's give it some time
and see how things turn out.  Things have to wait till the next -rc1
window anyway.

Thanks.

-- 
tejun
