From: david@lang.hm
Subject: Re: What still uses the block layer?
Date: Tue, 16 Oct 2007 23:07:33 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0710162302090.1538@asgard.lang.hm>
References: <200710112011.22000.rob@landley.net> <200710141845.44750.rob@landley.net>
 <20071015014503.GF9715@thunk.org>            <200710150304.00901.rob@landley.net>
 <25897.1192599264@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:44330
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbXJQGEQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 02:04:16 -0400
In-Reply-To: <25897.1192599264@turing-police.cc.vt.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Valdis.Kletnieks@vt.edu
Cc: Rob Landley <rob@landley.net>, Theodore Tso <tytso@mit.edu>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

On Wed, 17 Oct 2007, Valdis.Kletnieks@vt.edu wrote:

> On Mon, 15 Oct 2007 03:04:00 CDT, Rob Landley said:
>> I note that the eth0 and eth1 names are dynamically assigned on a first come
>> first serve basis (like scsi).  This never causes me a problem because the
>> driver loading order is constant, and once you figure out that eth0 is
>> gigabit and eth1 is the 80211g it _stays_ that way across reboots, reliably.
>> Yeah, it's a heuristic.  Hands up everybody relying on such a heuristic in
>> the real world.
>
> I've gotten burned by that heuristic enough times to not rely on it.  My last
> laptop had an ethernet on the motherboard, a *separate* ethernet in the docking
> station, an ethernet on a multifunction pcmcia card (I usually just used the
> modem side), and a wireless that looked like an ethernet - so it was possible
> for a given interface to be eth1 (if no dock and no pcmcia card) or eth3 (if
> both were present).  And that's on a laptop from almost 5 years ago.
>
> And then there's the recent Sun and Dell 1U rack-mounts that have 4 ethernets
> on the motherboard, and they *never* seem to assign in a 0,1,2,3 order that
> matches the 0 1 2 3 printed above the 4 RJ45's ;)
>
> So I have for years been a proponent of 'ethN is nailed by MAC address' :)

on the other hand, I have two systems in my lab with identical hardware, 
loaded with the same OS image, but one calls the interfaces eth0, eth1, 
eth2 while the other calls them eth12, eth13, eth14 becouse it had three 
quad cards installed in it for a few days several months ago.

also think what happens to a system if you replace a failed NIC with an 
card identical except the MAC addresses. instead of everything just 
working as before, you now have new ethX devices and are missing the old 
ethX devices.

both ways of doing things can yield nonsense results in cases where the 
other one gives perfectly useable results.

nobody is arguing that the ability to nail things down by MAC address 
(or drives by UUID) should be removed, we're just arguing that the option 
to get useable consistant names from hardware that is consistant is being 
removed and that it shouldn't be, it has it's place just like the 'best 
effort' naming.

David Lang
