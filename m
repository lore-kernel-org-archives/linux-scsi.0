From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: kernel panics and errors on lsi 1064e
Date: Fri, 20 Mar 2009 15:27:24 +0000
Message-ID: <1237562844.12008.55.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0903201242300.27079@tassadar.physics.auth.gr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53215 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754535AbZCTP1a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Mar 2009 11:27:30 -0400
In-Reply-To: <Pine.LNX.4.64.0903201242300.27079@tassadar.physics.auth.gr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dimitris Zilaskos <dzila@tassadar.physics.auth.gr>
Cc: linux-scsi@vger.kernel.org, "Moore, Eric" <Eric.Moore@lsi.com>

On Fri, 2009-03-20 at 12:44 +0200, Dimitris Zilaskos wrote:
> Hi,
> 
> I was having problems with two nodes rhel4 x86_64 compatible nodes with
> this:
> 
> 08:00.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1064E
> PCI-Express Fusion-MPT SAS (rev 04)
> 
> the nodes would panic after doing some task (download a few gigabytes 
> from net and run a few computations)
> 
> screenshots of two panics
> 
> http://img10.imageshack.us/img10/3184/camxgemspanic.jpg
> http://img10.imageshack.us/img10/174/wn024.jpg
> 
> 
> Prior to the panic the systems would be up for couple of hours to a couple
> of days and log this when say a gzip was running:
> 
> Mar  5 16:19:30 wn023.grid.auth.gr kernel: mptscsi: ioc0: attempting task
> abort! (sc=000001019199d4c0)
> Mar  5 16:19:30 wn023.grid.auth.gr kernel: scsi7 : destination target 11,
> lun 0
> Mar  5 16:19:30 wn023.grid.auth.gr kernel:         command = Write (10) 00
> 01 cd ab d3 00 01 40 00
> Mar  5 16:19:30 wn023.grid.auth.gr kernel: mptbase: ioc0: IOCStatus=8000
> LogInfo=31120403 Originator={PL}, Code={Abort}, SubCode(0x0403)
> Mar  5 16:19:30 wn023.grid.auth.gr kernel: mptbase: ioc0: IOCStatus=8048
> LogInfo=31140000 Originator={PL}, Code={IO Executed}, SubCode(0x0000)
> Mar  5 16:19:30 wn023.grid.auth.gr kernel: mptscsi: ioc0: task abort:
> SUCCESS (sc=000001019199d4c0)
> Mar  5 16:19:30 wn023.grid.auth.gr kernel: mptbase: ioc0: IOCStatus=804b
> LogInfo=31120403 Originator={PL}, Code={Abort}, SubCode(0x0403)
> Mar  5 16:19:30 wn023.grid.auth.gr kernel: mptscsi: ioc0: attempting task
> abort! (sc=0000010024283d00)
> Mar  5 16:19:30 wn023.grid.auth.gr kernel: scsi7 : destination target 11,
> lun 0
> Mar  5 16:19:30 wn023.grid.auth.gr kernel:         command = Write (10) 00
> 01 cd ad 13 00 01 40 00
> Mar  5 16:19:30 wn023.grid.auth.gr kernel: mptscsi: ioc0: attempting task
> abort! (sc=0000010102db4ac0)
> Mar  5 16:19:30 wn023.grid.auth.gr kernel: scsi7 : destination target 11,
> lun 0
> Mar  5 16:19:30 wn023.grid.auth.gr kernel:         command = Write (10) 00
> 01 cd ae 53 00 01 40 00
> Mar  5 16:19:30 wn023.grid.auth.gr kernel: mptscsi: ioc0: attempting task
> abort! (sc=0000010102db4cc0)
> Mar  5 16:19:30 wn023.grid.auth.gr kernel: scsi7 : destination target 11,
> lun 0
> Mar  5 16:19:30 wn023.grid.auth.gr kernel:         command = Write (10) 00
> 01 cd af 93 00 01 40 00
> Mar  5 16:19:30 wn023.grid.auth.gr kernel: mptscsi: ioc0: attempting task
> abort! (sc=0000010102db40c0)

This is some type of internal fusion firmware failure.  It comes back to
the driver needing an abort and there's some type of inability to do
this.

> Memtest for days was running ok.
> 
> I found this: https://bugzilla.redhat.com/show_bug.cgi?id=208033
> 
> and I upgraded my firmware from
> http://downloadcenter.intel.com/filter_results.aspx?strTypes=all&ProductID=2
> 487&OSFullName=OS+Independent&lang=eng&strOSs=38&submit=Go

So that's the right thing to do (or better yet, contact LSI support to
see if they have a newer version).

> After the upgrade the systems don't seem to panic. But they log this
> 
> 
> mptbase: ioc0: IOCStatus=8000 LogInfo=31123000 Originator={PL},
> Code={Abort}, SubCode(0x3000)
> mptbase: ioc0: IOCStatus=804b LogInfo=31123000 Originator={PL},
> Code={Abort}, SubCode(0x3000)
> mptbase: ioc0: IOCStatus=804b LogInfo=31123000 Originator={PL},
> Code={Abort}, SubCode(0x3000)
> mptbase: ioc0: IOCStatus=804b LogInfo=31123000 Originator={PL},
> Code={Abort}, SubCode(0x3000)
> mptbase: ioc0: IOCStatus=804b LogInfo=31123000 Originator={PL},
> Code={Abort}, SubCode(0x3000)

This has become a log information, so the IOC firmware now dealt with
whatever the problem was.


> Is something broken here? I am close to ask for the systems to be replaced.

You imply that with the firmware upgrade, nothing now goes wrong, so
everything sounds to be OK.

James


