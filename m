From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] scsi sysfs update 3
Date: Mon, 2 Dec 2002 09:02:28 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021202170228.GA1363@beaverton.ibm.com>
References: <20021127071100.GC1353@beaverton.ibm.com> <200211281917.gASJH9c05479@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200211281917.gASJH9c05479@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, hch@infradead.org, dougg@torque.net

James Bottomley [James.Bottomley@steeleye.com] wrote:
> andmike@us.ibm.com said:
> > I have attached an updated combined patch of my previously posted
> > sysfs changes.  
> 
> I'm getting ready to put this in scsi-misc-2.5
> 
> I have misgivings about the removal of the scsi bus type, but I know looking 
> at scsi host adapters as bridges isn't a universal view point.
> 

James,
	Christoph and Douglas Gilbert detected a compile error in
	ide-scsi with the sysfs update in scsi-misc-2.5. Christoph sent
	a RFC patch to LKML that request feedback on the removal of the
	transform function in ide-scsi. In the short term I am
	forwarding Doug's patch against scsi-misc-2.5 that restores
	previous functionality by using the sysfs driver name.


-andmike
--
Michael Anderson
andmike@us.ibm.com

--- linux/drivers/scsi/ide-scsi.c	2002-11-23 13:01:23.000000000 +1100
+++ linux/drivers/scsi/ide-scsi.c2550mike	2002-12-01 00:44:26.000000000 +1100
@@ -764,7 +764,7 @@
 
 	if (disk) {
 		struct Scsi_Device_Template **p = disk->private_data;
-		if (strcmp((*p)->tag, "sg") == 0)
+		if (strcmp((*p)->scsi_driverfs_driver.name, "sg") == 0)
 			return test_bit(IDESCSI_SG_TRANSFORM, &scsi->transform);
 	}
 	return test_bit(IDESCSI_TRANSFORM, &scsi->transform);
