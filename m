From: Andrew Vasquez <praka@users.sourceforge.net>
Subject: Re: What's the "right" qla2100 driver?
Date: Wed, 21 Jan 2004 21:22:19 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040122052218.GA2405@praka.local.home>
References: <F888C30C3021D411B9DA00B0D0209BE8038F9BD1@cvo-exchange.cvo.roguewave.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:20208 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S264368AbUAVFeh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2004 00:34:37 -0500
Received: from praka.san.rr.com (66-75-130-8.san.rr.com [66.75.130.8])
	by ms-smtp-01-eri0.socal.rr.com (8.12.10/8.12.7) with ESMTP id i0M5YaqG017130
	for <linux-scsi@vger.kernel.org>; Wed, 21 Jan 2004 21:34:36 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <F888C30C3021D411B9DA00B0D0209BE8038F9BD1@cvo-exchange.cvo.roguewave.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Wed, 21 Jan 2004, Poul Petersen wrote:

> I've got a Qlogic qla2100 card connected via copper to an array of
> 28 ~18GB disks. I'm trying to create two raid level 5 md devices
> with 13disk+1spare each. What I'm experiencing is a lot of hangs and
> strange disk failures that appear to be related to the drivers for
> the 2100. As there seems to be many different drivers to choose from
> for the qla2100, I've tried them all and collected my (all bad)
> experiences, a summary of which I have attached below. 
> 
> What I am wondering is if anyone else is using this card with Linux
> and if so what driver are they using? More importantly, which driver
> is actively being worked on (if any) so that I might contribute some
> failure information? 
> 

For 2.4, you could try another driver -- 6.06.10 (available at the
QLogic website).  This driver has support for the 2100 (though it's
not actually documented).  The makefile will not build the driver
though, try something similiar to the following:

	# make qla2100.o

For 2.6, why don't we start out with the default qla2xxx driver in
2.6.2-rc1.  

> It's possible that I am experiencing a hardware problem, since these
> disks and controller are a few years old now, but I doubt it since
> most of the errors seem inconsistent with bad hardware (all disks
> failing, etc). If nothing else, if I get feedback saying that
> someone else is successfully using a certain driver, then I can
> start playing with hardware using the same driver and maybe get to
> the bottom of this...
> 

>From there let's see how far you get with the drivers.  We may need to
enable some extra debugging for additional information.

> ---
> Test #5
> 2.6.1 with sourceforge qlogic driver 8.00.00.b8 (
> http://sourceforge.net/projects/linux-qla2xxx/ )
> ---
> 
> # modprobe qla2xxx
> # mkraid /dev/md0
> # mkraid /dev/md1
> # mkfs.ext3 /dev/md0
> 
>  	After awhile, the mkfs hung and when I tried to reboot the machine,
> I got a bunch of errors like the following for all 28 disks:
> 
> qla2xxx_eh_abort scsi(1:0:12:0) cmd_timeout_in_sec=0x1e.
> qla2xxx_eh_abort Exiting: status=Failed
> 

Interesting...

Regards,
Andrew Vasquez
