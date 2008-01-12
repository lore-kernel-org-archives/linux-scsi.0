From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi_transport_spi: convert to attribute groups
Date: Sat, 12 Jan 2008 09:34:17 -0600
Message-ID: <1200152057.3656.9.camel@localhost.localdomain>
References: <1199549907.3399.25.camel@localhost.localdomain>
	 <20080112051122.GB19894@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:45884 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751358AbYALPeX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Jan 2008 10:34:23 -0500
In-Reply-To: <20080112051122.GB19894@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>


On Fri, 2008-01-11 at 21:11 -0800, Greg KH wrote:
> On Sat, Jan 05, 2008 at 10:18:27AM -0600, James Bottomley wrote:
> > This conversion makes full use of the is_visible() callback on attribute
> > groups.  Now, each device appears only with its capability flags in the
> > transport class directory.  Previously each device appeared with the
> > capability of the host, so this is a functionality improvement.
> > Converting to attribute groups allows us to sweep away most of the home
> > grown #defines that were effectively doing the same thing.
> > 
> > James
> > 
> > ---
> > 
> > This depends on:
> > 
> > [PATCH] sysfs: add filter function to groups
> > [PATCH] fix the sysfs_add_file_to_group interfaces
> > [PATCH] attribute_container: update to use the group interface
> > [PATCH] add missing transport configure points for target and host
> > 
> > Greg and Kay, there's a nasty point in the code where I'd like to use
> > the -EEXIST return of sysfs_add_file_to_group() to indicate the file is
> > already there, however, this also dumps a stack trace and would frighten
> > users ... can we get rid of the printk and the WARN_ON(1)?
> 
> I really don't want to, as it has caught a lot of problems in the past.
> 
> What do you want to do that needs this error to happen "properly"?

The reason I'm interested is because the existence of the file is
storing information for me in the sysfs tree.  (Or rather allowing me to
forget information).  Perhaps just an API to check for the existence of
the file for an attribute would be enough?

something like sysfs_check_file_in_group(struct kobject *kobj,
		const struct attribute *attr, const char *group)

?

James

