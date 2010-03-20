From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] scsi_transport_fc: Initialize sysfs attributes with
 sysfs_attr_init
Date: Sat, 20 Mar 2010 12:44:12 -0500
Message-ID: <1269107052.4353.241.camel@mulgrave.site>
References: <20100316101453.GA9734@schmichrtp.mainz.de.ibm.com>
	 <4B9FEEBB.8090809@cs.wisc.edu>  <1268772544.30314.1.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:53363 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810Ab0CTRoS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Mar 2010 13:44:18 -0400
In-Reply-To: <1268772544.30314.1.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org

On Tue, 2010-03-16 at 13:49 -0700, James Bottomley wrote:
> On Tue, 2010-03-16 at 15:48 -0500, Mike Christie wrote:
> > On 03/16/2010 05:14 AM, Christof Schmitt wrote:
> > > With the new lockdep tracking in sysfs, sysfs_attr_init has to be used
> > > for initializing all non-static sysfs attributes. Otherwise, lockdep
> > > will warn about the missing initialization with:
> > >
> > > Mar 15 09:19:49 t6345029 kernel: BUG: key 000000002f5ae350 not in .data!
> > > Mar 15 09:19:49 t6345029 kernel: BUG: key 000000002f5ae388 not in .data!
> > > Mar 15 09:19:49 t6345029 kernel: BUG: key 000000002f5ae3c0 not in .data!
> > > Mar 15 09:19:49 t6345029 kernel: BUG: key 000000002f5ae3f8 not in .data!
> > >
> > 
> > I think iscsi needs this too, but I am not see this error message. I 
> > just tried iscsi and fc/lpfc with linus's tree and did not see those 
> > errors for either. What .config settings do I need for this? I have:
> 
> It's a lot worse than that ... every transport class plus some of the
> core attributes will need this.

Actually, it looks like we can fix all the transport classes at one go
in the attribute container code rather than doing this per-attribute.

Can someone who sees the problem check this out?

Thanks,

James

---

diff --git a/drivers/base/attribute_container.c b/drivers/base/attribute_container.c
index b9cda05..8fc200b 100644
--- a/drivers/base/attribute_container.c
+++ b/drivers/base/attribute_container.c
@@ -328,6 +328,7 @@ attribute_container_add_attrs(struct device *classdev)
 		return sysfs_create_group(&classdev->kobj, cont->grp);
 
 	for (i = 0; attrs[i]; i++) {
+		sysfs_attr_init(&attrs[i]->attr);
 		error = device_create_file(classdev, attrs[i]);
 		if (error)
 			return error;


