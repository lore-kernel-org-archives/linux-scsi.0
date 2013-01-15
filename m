From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v12 7/9] libata: scsi: no poll when ODD is powered off
Date: Tue, 15 Jan 2013 15:12:42 +0800
Message-ID: <20130115071242.GA16590@aaronlu.sh.intel.com>
References: <1357809870-18816-1-git-send-email-aaron.lu@intel.com>
 <1357809870-18816-8-git-send-email-aaron.lu@intel.com>
 <20130110195610.GL20454@htj.dyndns.org>
 <20130111021110.GB26270@aaronlu.sh.intel.com>
 <20130111021701.GA2513@mtj.dyndns.org>
 <20130111031626.GA26613@aaronlu.sh.intel.com>
 <20130111184457.GQ20454@htj.dyndns.org>
 <50F4480B.7050001@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:16718 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902Ab3AOHMC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jan 2013 02:12:02 -0500
Content-Disposition: inline
In-Reply-To: <50F4480B.7050001@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org

On Mon, Jan 14, 2013 at 01:01:47PM -0500, Jeff Garzik wrote:
> On 01/11/2013 01:44 PM, Tejun Heo wrote:
> >Hello,
> >
> >On Fri, Jan 11, 2013 at 11:16:26AM +0800, Aaron Lu wrote:
> >>OK, will make it atomic in next version, thanks for the advice.
> >>
> >>Perhaps I can add two scsi helper functions in scsi_lib.c like:
> >>
> >>void sdev_disable_disk_events(struct scsi_device *sdev)
> >>{
> >>	atomic_inc(&sdev->disk_events_disable_depth);
> >>}
> >>
> >>void sdev_enable_disk_events(struct scsi_device *sdev)
> >>{
> >>	if (WARN_ON_ONCE(atomic_read(&sdev->disk_events_disable_depth) <= 0))
> >>		return;
> >>	atomic_dec(&sdev->disk_events_disable_depth);
> >>}
> >>
> >>And call them in ATA layer. Do you like this?
> >
> >Sounds good to me.  James, how does the series look to you?
> 
> Indeed.  Want James' Acked-by for patch #1.
> 
> I think it's ready.  It can go into libata-dev.git #upstream, and be
> reverted prior to Linus push if James NAKs.

Great! Thanks.

I'll incorporate Tejun's suggestions into v13 and send them out soon.

-Aaron

