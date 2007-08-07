From: "Nicholas A. Bellinger" <nab@kernel.org>
Subject: Re: [Cbe-oss-dev] Playstation 3 BD-ROM access and
	LV1_DENIED_BY_POLICY
Date: Tue, 07 Aug 2007 01:45:42 -0700
Message-ID: <1186476342.3188.105.camel@haakon2.linux-iscsi.org>
References: <46B1F92C.8030206@am.sony.com>
	 <1186072148.13194.46.camel@haakon2.linux-iscsi.org>
	 <20070803110537.A84C.MOKUNO@sm.sony.co.jp>
	 <1186133997.3198.19.camel@haakon2.linux-iscsi.org>
	 <46B3770E.4070805@am.sony.com>
	 <Pine.LNX.4.62.0708061533230.31116@pademelon.sonytel.be>
	 <1186409379.3436.3.camel@localhost.localdomain>
	 <Pine.LNX.4.62.0708061617190.31116@pademelon.sonytel.be>
Reply-To: nab@kernel.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp115.sbc.mail.re3.yahoo.com ([66.196.96.88]:24168 "HELO
	smtp115.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753436AbXHGIzH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Aug 2007 04:55:07 -0400
In-Reply-To: <Pine.LNX.4.62.0708061617190.31116@pademelon.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Geoff Levand <geoffrey.levand@am.sony.com>, Masakazu Mokuno <mokuno@sm.sony.co.jp>, Cell Broadband Engine OSS Development <cbe-oss-dev@ozlabs.org>, linux-scsi@vger.kernel.org, Bernard Li <bernard@vanhpc.org>, Patrick Mansfield <patmans@us.ibm.com>, Mike Mazarick <mazarick@bellsouth.net>

On Mon, 2007-08-06 at 16:19 +0200, Geert Uytterhoeven wrote:
> On Mon, 6 Aug 2007, James Bottomley wrote:
> > On Mon, 2007-08-06 at 15:38 +0200, Geert Uytterhoeven wrote:
> > > On Fri, 3 Aug 2007, Geoff Levand wrote:
> > > > Nicholas A. Bellinger wrote:
> > > > > Thank you for this information.  I since been able to resolve my issue
> > > > > on 2.6.16 (which ended up being my fault), and was able to determine
> > > > > that the issue on 2.6.23-rc1 is due to
> > > > > drivers/scsi/scsi_lib.c:scsi_execute_async() rejecting READ_10 and
> > > > > TEST_UNIT_READY commands in certain cases (perhaps a race in
> > > > > drivers/scsi/ps3rom.c..?) using this API that was causing the win32 side
> > > > > to throw exceptions.
> > > > 
> > > > If you get more info on what was happening here, please report it to Geert
> > > > so he can investigate.  He should return next week.
> > > 
> > > Indeed.
> > > 
> > > Perhaps because ps3rom cannot queue more than 1 command?
> > > I'm CCing the SCSI guys, just in case this rings a bell.
> > 
> > Without details, it's really hard to speculate.  The problem description
> > is manifestly strange for two reasons
> > 

My apologies for the delay as things have been busy on late..

On the kernel side, the setup is:

Sector Size:

2048 bytes for TYPE_ROM

Max Sectors:

32 from struct scsi_host->max_sectors.  The iSCSI/HD client software is
requesting single sector READ_10s at various LBAs of the media.

iSCSI TCQ:

Setting ExpCmdSn/MaxCmdSn Window == 1 has had no effect.

ATAPI Transport Level TCQ:

A single TCQ slot is detected from struct scsi_host & struct scsi_device
and the lowest of either is set and enforced.  Both scsi_execute_async()
and legacy scsi-request APIs are working elsewhere (outside of PS3
BD-ROM) with single ATAPI Transport level TCQ for SATA + USB and single
or many iSCSI TCQs value settings.

PS3-Linux BD-ROM support:

Also of interest is that both implementations of
drivers/block/ps3pf_storage.c and drivers/scsi/ps3rom.c using
scsi_execute_async() are able to trigger the exception scenario in
question.

PS3 System Software Revision.

There is no affect on PS3 System Software Revision. 

> >      1. READ_10 should never be issued via scsi_execute_async.  There's
> >         no ULD in the current kernel that does this.  The READ_X/WRITE_X
> >         commands are issued through the filesystem path.

Gotcha.  The filesystem path with scsi_excute_async() for SG_IO Cdbs is
where I will move towards supporting ps3-linux git latest.   Also, as
you mention, TUR expections is what eventually causes the software
player stop.  Only the READ_10s appear to be affected by the scenario in
question.

Thanks for this pointer, I will take another look at the wireshark logs
to verify this is indeed the case.

> Nicholas is using the PS3 as an iSCSI target for watching BD-ROM content on
> other machines. That's probably where the weird command submission comes from.
> 
> He will hopefully fill in the rest...
> 

On my side, the goal has been successful export of Linux-iSCSI Targets
with both formats of commerical HD with win32 iSCSI Initiator(s) and
commerical software decoding the many HD discs I have purchased.  These
iSCSI targets include a Linux/ppc64 with PS3 BD-ROM and a Xbox 360
HD-DVD USB, and Linux/x86 and Linux/Alpha export of Philips SPD7000P BD
Writer over GB/sec Ethernet and IPv4/IPv6.  I have been very pleased the
progress so far, and will be posting more info for an HOWTO in the
upcoming weeks.

> With kind regards,
>  
> Geert Uytterhoeven
> Software Architect
> 

Many thanks for your most valuable of time.

--nab


