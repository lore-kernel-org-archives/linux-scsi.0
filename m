From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: generating a Linux WWN?
Date: Sat, 06 Oct 2007 10:04:55 -0500
Message-ID: <1191683096.3338.29.camel@localhost.localdomain>
References: <1191622146.3475.51.camel@localhost.localdomain>
	 <20071005.151131.125883267.davem@davemloft.net>
	 <1191622488.3475.54.camel@localhost.localdomain>
	 <20071005.151711.112302061.davem@davemloft.net>
	 <1191679870.3338.17.camel@localhost.localdomain>
	 <47079D64.3070000@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:43281 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756615AbXJFPE6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Oct 2007 11:04:58 -0400
In-Reply-To: <47079D64.3070000@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: David Miller <davem@davemloft.net>, ltuikov@yahoo.com, lydianconcepts@gmail.com, mdr@sgi.com, James.Smart@emulex.com, linux-scsi@vger.kernel.org

On Sat, 2007-10-06 at 10:36 -0400, Jeff Garzik wrote:
> James Bottomley wrote:
> > My problem with auto generated is that it's provably impossible to
> > generate globally unique numbers for WWNs without some internal source
> > of uniqueness (I know sparcs have this in their serial number, but most
> > PCs unfortunately don't).
> > 
> > I know the auto generated number can be statistically reasonably unique,
> > but sysadmins are lazy people.  If they run into this problem, they'll
> > take the knob with the on/off switch rather than the think about the
> > problem and specify the full WWN; and then, being busy people, they'll
> > forget about it as "problem solved".  When they do this, statistically
> > (and probably years later) there will be a cluster reboot where the
> > entire SAN simply collapses and no-one knows why ... the poor SAN
> > administrator will likely spend weeks working out the problem is.
> 
> Why, if we give lazy administrators root access, that's all they'll use, 
> and they will just think "problem solved" until a serious security issue 
> arises that takes down the cluster.
> 
> See how silly and un-Linux that logic is?  In Linux, the admin has the 
> power to make stupid decisions -- or to make informed decisions that 
> disagree your rigid "an admin should never do that" line of thought. 
> It's their hardware.
> 
> You're also using the 1% case of a 1% case of a 1% case to argue against 
> a feature that is useful in making things Just Work(tm).

So your use case for this feature is a savvy system admin whose going to
turn it on for a one time boot while he figures out what the correct WWN
override is and who will then immediately set the system up to override
properly on its next boot?  That's what seems to me to be the unlikely
scenario.

I know when I'm under the gun to solve a problem I'll do the first thing
I find that actually works.  So I'd rather only expose an interface that
allows them to get it right.

If you remember Rusty's guide to interfaces, this is a level 14 easy to
misuse interface: "The obvious use is wrong"; since the obvious use is
to put it in module parameters and have the problem go away (for
now ...).  Actually, I could be harsher and say it's level 17 "There's
no correct use" because statistically every time you use it, you expose
yourself to potential duplicate WWNs.

James


