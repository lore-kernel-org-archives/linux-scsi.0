From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] sd: implement stop_on_shutdown
Date: Sat, 20 Jan 2007 04:50:11 -0500
Message-ID: <45B1E5D3.90101@pobox.com>
References: <20070119170122.GS10987@htj.dyndns.org> <45B1574D.1090502@us.ibm.com> <45B18AE2.3010503@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:56072 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965242AbXATJuV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Jan 2007 04:50:21 -0500
In-Reply-To: <45B18AE2.3010503@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, James.Bottomley@SteelEye.com, hmh@hmh.eng.br, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Tejun Heo wrote:
> Darrick J. Wong wrote:
>> Tejun Heo wrote:
>>> sd doesn't stop (unload head) on shutdown.  This behavior is necessary
>>> for multi initiator cases.  Unloading head by powering off stresses
>>> the drive and sometimes produces distinct clunking noise which
>>> apparently disturbs users considering multiple reports on different
>>> distributions.  halt(8) usually puts the drives to sleep prior to
>>> shutdown but the implementation is fragile and it doesn't work with
>>> sleep-to-disk.
>> I wonder if this sort of thing (cache flush + spin down) is the sort of
>> thing that ought to be done to near-line storage at suspend time too,
>> though one would want allow_restart = 1 before doing such a thing.
> 
> For ATA, it's currently being done inside libata proper (a bit ugly).
> It would be nice to have those implemented at sd layer but I wonder how
> useful it's going to be for actual SCSI devices.  Do people actually
> suspend using SCSI?  If it's useful at the SCSI layer, I can implement
> and test it with SATA devices here.

There is always the open question for multi-initiator SCSI devices, as 
to who "owns" the SCSI device.  Some devices should be suspended/stopped 
when the machine is suspended/stopped, others not.

	Jeff



