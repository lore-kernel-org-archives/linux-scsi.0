From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: Re: 2.6.0-test1 and qlogic 8.00.00b4 driver
Date: Tue, 29 Jul 2003 10:04:51 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B060EC96@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [198.70.193.2] ([198.70.193.2]:16811 "EHLO AVEXCH01.qlogic.org")
	by vger.kernel.org with ESMTP id S271883AbTG2REn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jul 2003 13:04:43 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Andy,

> > It should be fine with plain -test1, with newer trees you need to
> > add a call to scsi_scan_host just after scsi_add_host.
> >
> I added scsi_scan_host after scsi_add_host and it did not change the
> situation, the driver still does not see any devices.  Either the
> driver or the kernel changed since it still works fine in 2.5.69
> w/qlogic 8.00.00b3 drivers. 
> 

So there are no entries in the /proc instance file for any
targets/luns?  For example:

	SCSI Device Information:
	scsi-qla0-adapter-node=200000e08b08f73f;
	scsi-qla0-adapter-port=210000e08b08f73f;
	scsi-qla0-target-0=210000203715973d;
	scsi-qla0-target-1=2100002037170202;
	scsi-qla0-target-2=2100002037c37fe6;

	SCSI LUN Information:
	(Id:Lun)  * - indicates lun is not registered with the OS.
	( 0: 0): Total reqs 9, Pending reqs 0, flags 0x0, 0:0:81,
	( 1: 0): Total reqs 7, Pending reqs 0, flags 0x0, 0:0:82,
	( 2: 0): Total reqs 9, Pending reqs 0, flags 0x0, 0:0:83,

Could you forward along the information I had previously request
(output of /proc/scsi/qla2300/<inst#>).  Depending on the info, you
may need to enable debugging output (qla_settings.h -- enable
DEBUG_QLA2100 and/or qla_os.h -- enable QL_DEBUG_LEVEL_2).

Regards,
Andrew Vasquez
