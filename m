From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] aic94xx: attaching to the sas transport class
Date: Sun, 19 Mar 2006 21:53:45 -0800
Message-ID: <20060320055345.GA30532@us.ibm.com>
References: <1141339085.3238.80.camel@mulgrave.il.steeleye.com> <1142646304.7462.36.camel@localhost.localdomain> <1142695445.3241.4.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:60321 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751587AbWCTFyD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Mar 2006 00:54:03 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e31.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id k2K5rw8J024682
	for <linux-scsi@vger.kernel.org>; Mon, 20 Mar 2006 00:53:58 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k2K5p0YD236544
	for <linux-scsi@vger.kernel.org>; Sun, 19 Mar 2006 22:51:00 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k2K5rwvs011697
	for <linux-scsi@vger.kernel.org>; Sun, 19 Mar 2006 22:53:58 -0700
Content-Disposition: inline
In-Reply-To: <1142695445.3241.4.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alexis Bruemmer <alexisb@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, "Tarte, Robert" <Robert_Tarte@adaptec.com>

James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Fri, 2006-03-17 at 17:45 -0800, Alexis Bruemmer wrote:
> > -       sas_begin_event(DISCE_PORT_GONE, &port->disc.disc_event_lock,
> > -                       &port->disc.pending);
> > -
> 
> I'm afraid we can't really do this ... what it's actually doing is
> removing anything that would tamper with the infinite lifetimes (like
> port removal events).  What we have to do is go the other way and make
> all the object lifetimes consistent.

Well the reason this was removed was because we where running two cleanup
operations.

We are trying to make object lifetimes consistent. I was trying to
make the following call stack work. In taking a look I guess we altered
the functionality of sas_deform_port. I assume the comment above "all the
object lifetimes consistent" is trying to get these two cases to function.

pci_unregister_driver
	asd_pci_remove
		asd_unregister_sas_ha
			sas_unregister_ha
				sas_unregister_devices
					sas_unregister_domain_devices
						sas_unregister_dev
							sas_rphy_delete
				sas_unregister_ports
				sas_unregister_scsi_host
					sas_remove_host
						do_sas_phy_delete


Currently I only have debug output for "modprobe -r aic94xx" shown below.

[1009084.596267] sas_transport_init Entered
[1009084.639153] sas_attach_transport Entered
[1009086.362102] sas_phy_add Entered phy: c0000000f3c3c1d8
[1009086.370237] sas_phy_add Entered phy: c0000000f3c3c5f0
[1009086.372232] sas_phy_add Entered phy: c0000000f3c3ca08
[1009086.376454] sas_phy_add Entered phy: c0000000ef2bd9e8
[1009086.384611] sas_phy_add Entered phy: c0000000ef2bd5d0
[1009086.388846] sas_phy_add Entered phy: c0000000ef2bcda0
[1009086.393304] sas_phy_add Entered phy: c0000000ef2bc988
[1009086.396303] sas_phy_add Entered phy: c0000000f035f338
[1009086.401681] sas_rphy_add Entered rphy: c0000000f035e2d8
[1009086.423209] sas_rphy_add Entered rphy: c0000000efc65ae8
[1009095.405030] sas_rphy_delete Entered rphy: c0000000f035e2d8
[1009095.445964] sas_rphy_delete Entered rphy: c0000000efc65ae8
[1009095.494683] sas_remove_host Entered shost: c00000000f50a548
[1009095.494701] do_sas_phy_delete Entered phy: c0000000f3c3c1d8
[1009095.494715] sas_phy_delete Entered phy: c0000000f3c3c1d8
[1009095.501915] do_sas_phy_delete Entered phy: c0000000f3c3c5f0
[1009095.501931] sas_phy_delete Entered phy: c0000000f3c3c5f0
[1009095.503865] do_sas_phy_delete Entered phy: c0000000f3c3ca08
[1009095.503882] sas_phy_delete Entered phy: c0000000f3c3ca08
[1009095.507957] do_sas_phy_delete Entered phy: c0000000ef2bd9e8
[1009095.507973] sas_phy_delete Entered phy: c0000000ef2bd9e8
[1009095.515346] do_sas_phy_delete Entered phy: c0000000ef2bd5d0
[1009095.515365] sas_phy_delete Entered phy: c0000000ef2bd5d0
[1009095.521260] do_sas_phy_delete Entered phy: c0000000ef2bcda0
[1009095.521272] sas_phy_delete Entered phy: c0000000ef2bcda0
[1009095.536930] do_sas_phy_delete Entered phy: c0000000ef2bc988
[1009095.536946] sas_phy_delete Entered phy: c0000000ef2bc988
[1009095.542064] do_sas_phy_delete Entered phy: c0000000f035f338
[1009095.542078] sas_phy_delete Entered phy: c0000000f035f338
[1009095.599971] sas_release_transport Entered
[1009095.607762] sas_transport_exit Entered

-andmike
--
Michael Anderson
andmike@us.ibm.com
