From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] REPORT LUN scan even if no storage is available on LUN 0
Date: Tue, 11 Jan 2005 10:15:00 -0800
Message-ID: <20050111181500.GA9046@us.ibm.com>
References: <20041210123333.GD685@bogon.ms20.nix> <20041213222206.GA18893@us.ibm.com> <20050110164200.GA8655@bogon.ms20.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:8586 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261352AbVAKSeA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jan 2005 13:34:00 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.12.10/8.12.10) with ESMTP id j0BIXsBW019238
	for <linux-scsi@vger.kernel.org>; Tue, 11 Jan 2005 13:33:54 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j0BIXmvh253154
	for <linux-scsi@vger.kernel.org>; Tue, 11 Jan 2005 13:33:48 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j0BIXlAi000322
	for <linux-scsi@vger.kernel.org>; Tue, 11 Jan 2005 13:33:48 -0500
Content-Disposition: inline
In-Reply-To: <20050110164200.GA8655@bogon.ms20.nix>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guido Guenther <agx@sigxcpu.org>
Cc: linux-scsi@vger.kernel.org

On Mon, Jan 10, 2005 at 05:42:00PM +0100, Guido Guenther wrote:
> Sorry it took me so long to test this, first time I'm near this hardware
> again.
> On Mon, Dec 13, 2004 at 02:22:06PM -0800, Patrick Mansfield wrote:
> > Patch looks okay, but we should always be trying the report lun scan, and
> > then failing back to the sequential scan even if there is no storage on
> > LUN 0.
> 
> > Can you test this? I don't have hardware readily available that supports
> > sparse luns and report lun. Patch is against current bk. I built and
> > ran with regular disks (lun 0 only).
> Doesn't work here. I doen't see any devices in /proc/scsi/scsi now.
>  -- Guido

So it worked some without the patch (I think you only saw some of the LUNs
before)?

What is output during the scan?

Can you turn on some scsi logging, and send that?

If you have root on scsi, you should shutdown syslogd (though this should
not generate lots of logging for small amounts of IO it generates some,
and if you screw up you'll be able to disable the logging), and then 
capture the console/serial output.

If root on ide, just leave syslog on and get /var/log/messages output.

Turn on per-command and scan logging (0x2400 | 0x01c0):

	sysctl -w dev.scsi.logging_level=0x25c0

Set back off afterwards with:

	sysctl -w dev.scsi.logging_level=0

-- Patrick Mansfield
