From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b6).
Date: Tue, 2 Dec 2003 10:10:22 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B060ED87@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [198.70.193.2] ([198.70.193.2]:35201 "EHLO AVEXCH01.qlogic.org")
	by vger.kernel.org with ESMTP id S262766AbTLBSKP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Dec 2003 13:10:15 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@SGI.com>, Jes Sorensen <jes@wildopensource.com>, Linux-SCSI <linux-scsi@vger.kernel.org>, jbarnes@SGI.com, mdr@SGI.com

On Tuesday, December 02, 2003 1:37 AM, Jeremy Higdon wrote:

> On Tue, Dec 02, 2003 at 02:01:25AM -0800, Andrew Vasquez wrote:
> > 
> > > Is it okay to read back from the request queue in register?
> > > I'm planning to generate a new patch that includes the previous
> > > changes, and I may as well generate something without the
> > > sn_mmiob. 
> > > 
> > 
> > I believe we'll need a readl() to flush the write.  Just curious, on
> > SGI ia64 machines, how many bridges must a PCI write transaction
> > cross before it reaches the target device?
> 
> It depends on what you call a bridge.  If you count chips traversed,
> it could be as many as 6, I think.  However, the system in which I
> had the problem is much smaller than that.
> 
> Here is my patch to the v8.00.00b6 driver.  It includes most of
> Jes's earlier patch, but not Christoph's patch, which I have not
> yet tried.  
>

Thanks, I've already had a running tree which included Jes's patch --
I'll add the deltas.

> If you're going to supply a way to change NVRAM without
> using BIOS (please!), then this patch can be a bit smaller.  Please
> let me know what you think. 
> 

The model with which I'm basing the NVRAM update on is the code for
PCI config space updates in drivers/pci/pci-sysfs.c (pci_config_attr).

> I added a read-after-write of the Request In register and commented
> out setting of the enable_64bit_addressing flag in the nvram config
> function. 
> 
> I returned SN2 to using nvram variables, except for data rate and
> frame size, since at least some QLA2310/2342 boards have the wrong
> values.  As you pointed out, we need the nvram node and port name
> for proper fabric operation.
> 

That's the safest path.

Regards,
Andrew Vasquez
