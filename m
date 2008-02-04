From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 7/9] scsi_dh: Add support for SDEV_PASSIVE
Date: Mon, 04 Feb 2008 14:28:34 -0600
Message-ID: <1202156914.3096.112.camel@localhost.localdomain>
References: <20080124003010.18871.84095.sendpatchset@localhost.localdomain>
	 <20080124003203.18871.52040.sendpatchset@localhost.localdomain>
	 <1202151498.3096.84.camel@localhost.localdomain>
	 <1202156151.13537.14.camel@linuxchandra>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:44564 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757549AbYBDU2k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 15:28:40 -0500
In-Reply-To: <1202156151.13537.14.camel@linuxchandra>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sekharan@us.ibm.com
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, Mike Anderson <andmike@us.ibm.com>, michaelc@cs.wisc.edu, jens.axboe@oracle.com


On Mon, 2008-02-04 at 12:15 -0800, Chandra Seetharaman wrote:
> On Mon, 2008-02-04 at 12:58 -0600, James Bottomley wrote:
> > On Wed, 2008-01-23 at 16:32 -0800, Chandra Seetharaman wrote:
> > > Subject: scsi_dh: Add support for SDEV_PASSIVE
> > > 
> > > From: Chandra Seetharaman <sekharan@us.ibm.com>
> > > 
> > > This patch adds a new device state SDEV_PASSIVE, to correspond to the
> > > passive side access of an active/passive multipathed device.
> > 
> > Really, no; this isn't right.  The state field of a SCSI device is for
> > the SCSI state model.  Passive might be a valid device mapper state, but
> 
> Hi James,
> 
> It is not the "device mapper state", it is the state of the device
> itself. These devices have active/passive paths, the passive paths will
> be represented by SDEV_PASSIVE device state in SCSI.

Yes, it is .. you're killing commands on the basis of being in this
state, which nothing in SCSI ever sets.

A proper return from a passive path is the SCSI standard NOT_READY
LOGICAL UNIT NOT READY, INITIALIZING COMMAND REQUIRED.  We expect to see
this, not the command being killed.

James


