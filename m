From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [PATCH] scsi_transport_fc: Initialize sysfs attributes with
 sysfs_attr_init
Date: Mon, 22 Mar 2010 11:13:09 +0100
Message-ID: <20100322101308.GA6953@schmichrtp.mainz.de.ibm.com>
References: <20100316101453.GA9734@schmichrtp.mainz.de.ibm.com>
 <4B9FEEBB.8090809@cs.wisc.edu>
 <1268772544.30314.1.camel@mulgrave.site>
 <1269107052.4353.241.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.17.163]:55618 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab0CVKNL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Mar 2010 06:13:11 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.13.1/8.13.1) with ESMTP id o2MAD9aZ007518
	for <linux-scsi@vger.kernel.org>; Mon, 22 Mar 2010 10:13:09 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o2MAD9811695900
	for <linux-scsi@vger.kernel.org>; Mon, 22 Mar 2010 11:13:09 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id o2MAD9KE010045
	for <linux-scsi@vger.kernel.org>; Mon, 22 Mar 2010 11:13:09 +0100
Content-Disposition: inline
In-Reply-To: <1269107052.4353.241.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org

On Sat, Mar 20, 2010 at 12:44:12PM -0500, James Bottomley wrote:
> On Tue, 2010-03-16 at 13:49 -0700, James Bottomley wrote:
> > On Tue, 2010-03-16 at 15:48 -0500, Mike Christie wrote:
> > > On 03/16/2010 05:14 AM, Christof Schmitt wrote:
> > > > With the new lockdep tracking in sysfs, sysfs_attr_init has to be used
> > > > for initializing all non-static sysfs attributes. Otherwise, lockdep
> > > > will warn about the missing initialization with:
> > > >
> > > > Mar 15 09:19:49 t6345029 kernel: BUG: key 000000002f5ae350 not in .data!
> > > > Mar 15 09:19:49 t6345029 kernel: BUG: key 000000002f5ae388 not in .data!
> > > > Mar 15 09:19:49 t6345029 kernel: BUG: key 000000002f5ae3c0 not in .data!
> > > > Mar 15 09:19:49 t6345029 kernel: BUG: key 000000002f5ae3f8 not in .data!
> > > >
> > > 
> > > I think iscsi needs this too, but I am not see this error message. I 
> > > just tried iscsi and fc/lpfc with linus's tree and did not see those 
> > > errors for either. What .config settings do I need for this? I have:
> > 
> > It's a lot worse than that ... every transport class plus some of the
> > core attributes will need this.
> 
> Actually, it looks like we can fix all the transport classes at one go
> in the attribute container code rather than doing this per-attribute.
> 
> Can someone who sees the problem check this out?
> 
> Thanks,
> 
> James
> 
> ---
> 
> diff --git a/drivers/base/attribute_container.c b/drivers/base/attribute_container.c
> index b9cda05..8fc200b 100644
> --- a/drivers/base/attribute_container.c
> +++ b/drivers/base/attribute_container.c
> @@ -328,6 +328,7 @@ attribute_container_add_attrs(struct device *classdev)
>  		return sysfs_create_group(&classdev->kobj, cont->grp);
> 
>  	for (i = 0; attrs[i]; i++) {
> +		sysfs_attr_init(&attrs[i]->attr);
>  		error = device_create_file(classdev, attrs[i]);
>  		if (error)
>  			return error;
> 

I just tested it with the zfcp driver and this approach works for me.
However, this would put all transport attributes in the same class for
the lock dependency tracker. For the fc_host and fc_remote_port
attributes exported for zfcp, this is no problem. I don't know if this
would be a problem for drivers using the vport_create and vport_delete
attributes.

Christof
