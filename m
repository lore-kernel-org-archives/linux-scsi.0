From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] fix leftover from default sdev attribute switch
Date: Wed, 26 Sep 2007 22:19:22 +0200
Message-ID: <1190837962.3773.102.camel@lov.localdomain>
References: <1190829289.3773.74.camel@lov.localdomain>
	 <1190831039.3359.69.camel@localhost.localdomain>
	 <1190831520.3773.79.camel@lov.localdomain>
	 <1190837311.3359.74.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from charybdis-ext.suse.de ([195.135.221.2]:60268 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751183AbXIZUT3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Sep 2007 16:19:29 -0400
In-Reply-To: <1190837311.3359.74.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>


On Wed, 2007-09-26 at 15:08 -0500, James Bottomley wrote:
> On Wed, 2007-09-26 at 20:32 +0200, Kay Sievers wrote:
> > On Wed, 2007-09-26 at 13:23 -0500, James Bottomley wrote:
> > > On Wed, 2007-09-26 at 19:54 +0200, Kay Sievers wrote:
> > > > Hi James,
> > > > seems we miss the following fix in the current tree.
> > > > 
> > > > From: Kay Sievers <kay.sievers@vrfy.org>
> > > > Subject: [SCSI] fix scsi_is_sdev_device() after switch to default sdev attributes
> > > > 
> > > > Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> > > > ---
> > > > diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> > > > index 0088c4d..8e880ef 100644
> > > > --- a/drivers/scsi/scsi_sysfs.c
> > > > +++ b/drivers/scsi/scsi_sysfs.c
> > > > @@ -995,7 +995,7 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
> > > >  
> > > >  int scsi_is_sdev_device(const struct device *dev)
> > > >  {
> > > > -	return dev->release == scsi_device_dev_release;
> > > > +	return dev->type == &scsi_dev_type;
> > > 
> > > This will make the check different from all the others in the
> > > mid-layer ... is there any reason to change it?
> > 
> > The release function moved to device_type, so the "hack" with checking
> > for the release pointer at the device doesn't work anymore. With Hannes'
> > patches here on the list, the target and host will get device_type too,
> > and the same way of matching.
> 
> So all the other ones are incorrect and need fixing? That's
> 
> hosts.c:int scsi_is_host_device(const struct device *dev)
> scsi_scan.c:int scsi_is_target_device(const struct device *dev)
> scsi_transport_fc.c:int scsi_is_fc_rport(const struct device *dev)
> scsi_transport_fc.c:int scsi_is_fc_vport(const struct device *dev)
> scsi_transport_iscsi.c:static int iscsi_is_session_dev(const struct
> device *dev)
> scsi_transport_iscsi.c:static int iscsi_is_conn_dev(const struct device
> *dev)
> scsi_transport_sas.c:int scsi_is_sas_phy(const struct device *dev)
> scsi_transport_sas.c:int scsi_is_sas_port(const struct device *dev)
> scsi_transport_sas.c:int scsi_is_sas_rphy(const struct device *dev)
> 
> 
> Checking the release function is the way each of these passes the test.

Oh no, they are all correct.

It's just sdev after the conversion from open-coded attribute creation
to "default attributes" created by the core. Sdev uses device_type now,
and device_type has the release function for all devices of that type,
instead of the individually assigned ones.

Hannes' patches convert host and target to device_type so they can join
the scsi-bus in sysfs. They will have the same logic based on device
type instead of the release pointer trick. But that's not in your tree
now.

Kay

