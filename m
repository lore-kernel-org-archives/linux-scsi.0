From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: generating a Linux WWN?
Date: Sat, 06 Oct 2007 09:11:10 -0500
Message-ID: <1191679870.3338.17.camel@localhost.localdomain>
References: <1191622146.3475.51.camel@localhost.localdomain>
	 <20071005.151131.125883267.davem@davemloft.net>
	 <1191622488.3475.54.camel@localhost.localdomain>
	 <20071005.151711.112302061.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:39433 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752666AbXJFOLP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Oct 2007 10:11:15 -0400
In-Reply-To: <20071005.151711.112302061.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: ltuikov@yahoo.com, jeff@garzik.org, lydianconcepts@gmail.com, mdr@sgi.com, James.Smart@emulex.com, linux-scsi@vger.kernel.org

On Fri, 2007-10-05 at 15:17 -0700, David Miller wrote:
> From: James Bottomley <James.Bottomley@SteelEye.com>
> Date: Fri, 05 Oct 2007 18:14:48 -0400
> 
> > On Fri, 2007-10-05 at 15:11 -0700, David Miller wrote:
> > > auto_wwn=1 or somthing like that
> > 
> > I'd far prefer
> > 
> > override_wwn = <fully specific WWN>
> > 
> > since I assume auto_wwn means get the kernel to generate one?
> 
> I think providing both possibilities (kernel auto-generated and user
> specified) is appropriate.

My problem with auto generated is that it's provably impossible to
generate globally unique numbers for WWNs without some internal source
of uniqueness (I know sparcs have this in their serial number, but most
PCs unfortunately don't).

I know the auto generated number can be statistically reasonably unique,
but sysadmins are lazy people.  If they run into this problem, they'll
take the knob with the on/off switch rather than the think about the
problem and specify the full WWN; and then, being busy people, they'll
forget about it as "problem solved".  When they do this, statistically
(and probably years later) there will be a cluster reboot where the
entire SAN simply collapses and no-one knows why ... the poor SAN
administrator will likely spend weeks working out the problem is.

I'd rather not give an interface which seems like a magic bullet but
which is a potential time bomb in a cluster (particularly when it has
such a long fuse).

James


