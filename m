From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] REPORT LUN scan even if no storage is available on LUN 0
Date: Fri, 14 Jan 2005 08:51:42 -0800
Message-ID: <20050114165142.GA32650@us.ibm.com>
References: <20041210123333.GD685@bogon.ms20.nix> <20041213222206.GA18893@us.ibm.com> <20050110164200.GA8655@bogon.ms20.nix> <20050111181500.GA9046@us.ibm.com> <20050113124032.GB5701@bogon.ms20.nix> <20050114002134.GA14102@us.ibm.com> <20050114132623.GA7837@bogon.ms20.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:5805 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261932AbVANQwW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Jan 2005 11:52:22 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.12.10/8.12.10) with ESMTP id j0EGqMJX010534
	for <linux-scsi@vger.kernel.org>; Fri, 14 Jan 2005 11:52:22 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j0EGqM8u251210
	for <linux-scsi@vger.kernel.org>; Fri, 14 Jan 2005 11:52:22 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j0EGqLrU000301
	for <linux-scsi@vger.kernel.org>; Fri, 14 Jan 2005 11:52:22 -0500
Content-Disposition: inline
In-Reply-To: <20050114132623.GA7837@bogon.ms20.nix>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guido Guenther <agx@sigxcpu.org>
Cc: linux-scsi@vger.kernel.org

On Fri, Jan 14, 2005 at 02:26:23PM +0100, Guido Guenther wrote:
> On Thu, Jan 13, 2005 at 04:21:34PM -0800, Patrick Mansfield wrote:

> This is the target that has all the devices:
> # echo "0 0 -" > /sys/class/scsi_host/host0/scan
> scsi_scan_host_selected: <0:0:0:4294967295>
> scsi scan: INQUIRY to host 0 channel 0 id 0 lun 0
> scsi <0:0:0:0> send                  scsi0 : destination target 0, lun 0
>         command = Inquiry 00 00 00 24 00
> scsi <0:0:0:0> done SUCCESS        0 scsi0 : destination target 0, lun 0
>         command = Inquiry 00 00 00 24 00
> scsi scan: 1st INQUIRY successful with code 0x0
> scsi <0:0:0:0> send                  scsi0 : destination target 0, lun 0
>         command = Inquiry 00 00 00 95 00
> scsi <0:0:0:0> done SUCCESS        0 scsi0 : destination target 0, lun 0
>         command = Inquiry 00 00 00 95 00
> scsi scan: 2nd INQUIRY successful with code 0x0
> scsi scan: peripheral qualifier of 3, no device added
> scsi scan: Sequential scan of host 0 channel 0 id 0
> 
> While this is an empty one:
> # echo "0 1 -" > /sys/class/scsi_host/host0/scan
> scsi_scan_host_selected: <0:0:1:4294967295>
> scsi scan: INQUIRY to host 0 channel 0 id 1 lun 0
> scsi <0:0:1:0> send                  scsi0 : destination target 1, lun 0
>         command = Inquiry 00 00 00 24 00
> scsi <0:0:1:0> done SUCCESS    10000 scsi0 : destination target 1, lun 0
>         command = Inquiry 00 00 00 24 00
> scsi scan: 1st INQUIRY failed with code 0x10000

Your device must be reporting as SCSI-2, that makes sense, since you
needed other bflags set. The logging should really dump the scsi_level.
You need to add an entry to the devinfo list to force a REPORT LUNs scan.

I don't know why it is not already in scsi_devinfo.c, AFAIR REPORT LUNs
has always worked with EMC, and should be in its devinfo flag (and
probably the only devinfo flag, since sparse, largelun and forcelun are
meaningless for a REPORT LUN scan).

module params can be used, but /proc/scsi/device_info is easiest. Make
sure I have the correct vendor:model, this should work:

	echo "EMC:SYMMETRIX:0x20000" > /proc/scsi/device_info

BLIST_REPORTLUN2 is 0x20000.

-- Patrick Mansfield
