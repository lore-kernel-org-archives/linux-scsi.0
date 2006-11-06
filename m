From: Jaco van der Schyff <jvds@netgroup.co.za>
Subject: Re: Automatic LUN detectioning not working
Date: Mon, 6 Nov 2006 12:08:06 +0200
Message-ID: <20061106100806.GA9343@npjaco.netgroup.co.za>
References: <20061106090702.GA8071@npjaco.netgroup.co.za> <1162807123.3160.182.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.netgroup.co.za ([196.25.213.80]:38813 "EHLO
	mail.netgroup.co.za") by vger.kernel.org with ESMTP
	id S1423697AbWKFKIG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Nov 2006 05:08:06 -0500
Content-Disposition: inline
In-Reply-To: <1162807123.3160.182.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Mon, Nov 06, 2006 at 10:58:43AM +0100, Arjan van de Ven wrote:
> On Mon, 2006-11-06 at 11:07 +0200, Jaco van der Schyff wrote:
> > Hi,
> > 
> > I wonder if you guys might be able to help.  Automatic LUN detection
> > does not seem to be functioning on my kernel despite all my efforts to
> > persuade it otherwise. (Kernel 2.6.17.6, although I tried newer versions
> > aswell...)
> > 
> > CONFIG_SCSI_MULTI_LUN=y is set in my kernel config, and I am passing
> > max_luns=12 as kernel parameter.  The scsi system is _not_ compiled as a
> > module, and my HBA is in Adaptec 3930A-R, (aic79xx)
> > 
> > Once the system has booted, I can force it to detect all luns with:
> > 
> > echo "0 0 1" > /sys/class/scsi_host/host[x]/scan
> > echo "0 0 2" > /sys/class/scsi_host/host[x]/scan
> > echo "0 0 3" > /sys/class/scsi_host/host[x]/scan
> > 
> > I have a hardware RAID array connected to the HBA which maps 4 x 1TB
> > slices to LUNS[0-3].
> > 
> > Like I said the kernel is only interested in LUN0 for some reason...
> > 
> > Any way I can ask my kernel to detect all LUNs at startup?
> 
> Hi,
> 
> what probably is needed is to teach the kernel about your array and to
> make the kernel either scan all luns or ask the device which luns it
> has.
> Can you post the /proc/scsi/scsi entry for your array ? (only for the
> LUN0 is enough); that information is going to be needed to make a
> special entry for your array with either of the two behaviors..
>

Contents of /proc/scsi/scsi:

Attached devices:
Host: scsi0 Channel: 00 Id: 06 Lun: 00
Vendor: PE/PV    Model: 1x6 SCSI BP      Rev: 1.0 
Type:   Processor                        ANSI SCSI revision: 02
Host: scsi0 Channel: 02 Id: 00 Lun: 00
Vendor: MegaRAID Model: LD 0 RAID1  139G Rev: 521X
Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 00 Lun: 00
Vendor: SA-6640S Model:                  Rev: R0.0
Type:   Direct-Access                    ANSI SCSI revision: 03

The device is question is the SA-6640S on scsi1:0:0:0

http://www.maxtronic.com/raid_systems/janusraid_series/janusraid_sa-6640s/

Kind regards,

- Jaco
