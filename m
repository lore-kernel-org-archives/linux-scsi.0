From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] REPORT LUN scan even if no storage is available on LUN 0
Date: Thu, 13 Jan 2005 16:01:15 -0800
Message-ID: <20050114000115.GA13676@us.ibm.com>
References: <20041210123333.GD685@bogon.ms20.nix> <20041213222206.GA18893@us.ibm.com> <20050110164200.GA8655@bogon.ms20.nix> <20050111181500.GA9046@us.ibm.com> <20050113124032.GB5701@bogon.ms20.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36077 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261821AbVANABx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Jan 2005 19:01:53 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.12.10/8.12.10) with ESMTP id j0E01qBW005203
	for <linux-scsi@vger.kernel.org>; Thu, 13 Jan 2005 19:01:52 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j0E01ner286714
	for <linux-scsi@vger.kernel.org>; Thu, 13 Jan 2005 19:01:52 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j0E01mjE019011
	for <linux-scsi@vger.kernel.org>; Thu, 13 Jan 2005 19:01:49 -0500
Content-Disposition: inline
In-Reply-To: <20050113124032.GB5701@bogon.ms20.nix>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guido Guenther <agx@sigxcpu.org>
Cc: linux-scsi@vger.kernel.org

On Thu, Jan 13, 2005 at 01:40:32PM +0100, Guido Guenther wrote:

> > Can you turn on some scsi logging, and send that?
> Sure. I tried scsi_logging_level=... on the kernel command line but it
> didn't show anything, did I miss something obvious?
> /proc/sys/dev/scsi/logging_level was still zero afterwards.

It is a sysctl variable, so you can set it after you are booted, per my
other email (and still below), and man sysctl.

If you are building the qlogic driver into the kernel you can still rescan
the LUNs via:

	echo "- - -" > /sys/class/scsi_host/hostN/scan

> > If you have root on scsi, you should shutdown syslogd (though this should
> > not generate lots of logging for small amounts of IO it generates some,
> > and if you screw up you'll be able to disable the logging), and then 
> > capture the console/serial output.
> > 
> > If root on ide, just leave syslog on and get /var/log/messages output.
> > 
> > Turn on per-command and scan logging (0x2400 | 0x01c0):
> > 
> > 	sysctl -w dev.scsi.logging_level=0x25c0
> > 
> > Set back off afterwards with:
> > 
> > 	sysctl -w dev.scsi.logging_level=0
> > 
> > -- Patrick Mansfield
