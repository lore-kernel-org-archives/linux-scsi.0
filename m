From: "Nicholas A. Bellinger" <nick@pyxtechnologies.com>
Subject: Re: scsi_transport_iscsi.c + transport_container_unregister() oops
Date: Wed, 27 Apr 2005 11:49:34 -0700
Message-ID: <1114627774.20844.20.camel@haakon>
References: <1114626881.20844.15.camel@haakon>  <426FDEE5.40408@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp819.mail.sc5.yahoo.com ([66.163.170.5]:33179 "HELO
	smtp819.mail.sc5.yahoo.com") by vger.kernel.org with SMTP
	id S261959AbVD0S65 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Apr 2005 14:58:57 -0400
In-Reply-To: <426FDEE5.40408@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mikenc@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

On Wed, 2005-04-27 at 11:50 -0700, Mike Christie wrote:
> Nicholas A. Bellinger wrote:
> > While adding support for the iSCSI Transport class
> > (scsi_transport_iscsi.c) to the iscsi-initiator-core stack, I ran into a
> > problem with iscsi_release_transport() and
> > transport_container_unregister().
> > 
> > When iscsi_register_transport() and iscsi_release_transport() are called
> > WITHOUT calling scsi_add_host() and scsi_remove_host() there are no
> > problems.
> > 
> > When iscsi_register_transport() and iscsi_release_transport() are called
> > WITH calling scsi_add_host() and scsi_remove_host() the following OOPs
> > appears in attribute_container_unregister during the list_empty() loop.
> > 
> > I also noticed that that transport_container_[register,unregister]()
> > calls in iscsi_[register,release]_transport() where added around
> > 2.6.12-rc1, but are not included in the scsi_transport_iscsi.c within
> > the 4.0.1.11.  
> 
> The scsi_transport_iscsi.c in 4.0.1.11 is old. That version of the driver
> was for before James's transport container code so you cannot use the
> scsi_transport_iscsi.c in there with the current driver model transport
> code.
> 
> Also you do not need to worry about sfnet compatibilty. If your changes
> are good/merged we will adapt to them. So do not worry about breaking
> us in the mean time.
> 

Just to double check as I have not had a chance to test this myself,
does iscsi_release_transport() work correctly once a scsi host has been
registered with sfnet and 2.6.12-rc3's scsi_transport_iscsi.c?

I am trying to make sure it is not something obvious I am missing on my
side.

Thanks,

-- 
Nicholas A. Bellinger <nick@pyxtechnologies.com>

