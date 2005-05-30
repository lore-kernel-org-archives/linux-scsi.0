From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: What breaks aic7xxx in post 2.6.12-rc2 ?
Date: Mon, 30 May 2005 09:38:58 -0500
Message-ID: <1117463938.4913.3.camel@mulgrave>
References: <20050517192636.GB9121@gmail.com>
	 <1116359432.4989.48.camel@mulgrave> <20050517195650.GC9121@gmail.com>
	 <1116363971.4989.51.camel@mulgrave> <20050521232220.GD28654@gmail.com>
	 <1116770040.5002.13.camel@mulgrave> <20050524153930.GA10911@gmail.com>
	 <1117113563.4967.17.camel@mulgrave> <20050526143516.GA9593@gmail.com>
	 <1117118766.4967.22.camel@mulgrave>  <20050526173518.GA9132@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:58330 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261611AbVE3OjX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 May 2005 10:39:23 -0400
In-Reply-To: <20050526173518.GA9132@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?Gr=E9goire?= Favre <gregoire.favre@gmail.com>
Cc: dino@in.ibm.com, Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2005-05-26 at 19:35 +0200, Gr=E9goire Favre wrote:
> That's with vanilla 2.6.12-rc5 if I have to patch, just tell me :-)

OK, I have two things for you to try.

The first is the attached, which, I think, enforces the limits this
device is expecting.  It's really just a sanity check to see if the
problem is what I think it is (device negotiates a transfer setting it
can't actually support).

James

diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/=
aic7xxx_osm.c
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -735,6 +735,7 @@ ahc_linux_slave_configure(struct scsi_de
=20
 	/* Initial Domain Validation */
 	if (!spi_initial_dv(device->sdev_target))
+		spi_min_period(device->sdev_target) =3D 100;
 		spi_dv_device(device);
=20
 	return 0;


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
