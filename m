From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Patch?: linux-2.5.45/drivers/scsi/hosts.[ch] - Eliminate scsi_host_tmpl_list
Date: Sun, 10 Nov 2002 09:46:54 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021110094654.A26596@eng2.beaverton.ibm.com>
References: <200211100537.VAA27429@baldur.yggdrasil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200211100537.VAA27429@baldur.yggdrasil.com>; from adam@yggdrasil.com on Sat, Nov 09, 2002 at 09:37:46PM -0800
List-Id: linux-scsi@vger.kernel.org
To: "Adam J. Richter" <adam@yggdrasil.com>
Cc: hch@lst.de, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Sat, Nov 09, 2002 at 09:37:46PM -0800, Adam J. Richter wrote:
> Patrick Mansfield wrote:
> >But, there is no way to match the previous functionallity without having
> >a host name list.
> >
> >That is before the patch we can do this:
> >
> >        insmod foo; insmod bar
> >
> >And foo gets scsi4, bar scsi5. And then:
> >
> >        rmmod foo; rmmod bar
> >        insmod bar; insmod foo
> >
> >And foo should still be scsi4, bar scsi5.
> >
> >Without the host name list, the best we can do is have
> >foo become scsi5, and bar scsi4.
> 
> 	I do not understand why you think these is any change
> in behavior.
> 
> 	If you passed "scsihosts=host1,host2,host3,foo,bar", then
> you should the first foo controller will always be assigned ID 4,
> and the first bar controller will always be assigned ID 5, no matter
> how you load, unload and reload the foo and bar SCSI drivers.
> A successful scsi_register always calls scsi_hostnum; scsi_hostname
> always checks the scsihosts variable.
> 
> 	If you disagree with this, please walk me through how the
> second "insmod foo" gets scsi ID 4 when the scsihosts string has
> reserved that ID for something else.  If you can actually produce
> the behavior in real life, that would be even better.

The scenario I outlined is for the case _without_ any "scsihosts=...".

But, you point out a simple way to get around this difference in
behaviour. If a user hits the problem I listed, they could just
boot with "scsihosts=foo,bar".

I'll rediff with ... one of the scsi trees and post a modified
patch.

-- Patrick Mansfield
