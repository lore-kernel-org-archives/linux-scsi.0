From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: aic79xx oops
Date: Mon, 12 Sep 2005 09:15:14 -0500
Message-ID: <1126534514.4825.5.camel@mulgrave>
References: <200509091325.45620.bernd.schubert@pci.uni-heidelberg.de>
	 <1126364765.4813.16.camel@mulgrave>
	 <200509121258.26823.bernd.schubert@pci.uni-heidelberg.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:11461 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750973AbVILOPT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Sep 2005 10:15:19 -0400
In-Reply-To: <200509121258.26823.bernd.schubert@pci.uni-heidelberg.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bernd-schubert@gmx.de
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

[linux-scsi re-added to cc list]

On Mon, 2005-09-12 at 12:58 +0200, Bernd Schubert wrote:
> Hello James,
> 
> > > scsi: host 4 channel 0 id 0 lun 0x306727c0706727c0 has a LUN larger than
> > > currently supported.
> >
> > This looks symptomatic of a report luns failure
> 
> Hmm, so far we always believed this is a bug in the firmware of our scsi-ide 
> raid array.

It is ... the array firmware isn't sending the correct response to
report luns, I think.  Try the attached patch; it will blacklist the
array and prevent us from sending REPORT LUNS commands.

> >
> > > EIP is at ahd_send_async+0xde/0x2a0 [aic79xx]
> >
> > This I'm not sure about.  There are some fixes that may correct this in
> > the current kernel tree head (i.e. beyond 2.6.13), if you could give
> > that a go.
> 
> Well, the oopses do not always occur, only sometimes. On Friday the server 
> locked up a second time and we switched to 2.6.13. With three reboots no oops 
> did happen, though this doesn't tell anything as we also could reboot 2.6.11 
> several times without this oops.
> Well, now we a probably experiencing a network bug in 2.6.13 and the chance it 
> pretty high that we have to switch back to 2.6.11, no chance for a kernel 
> beyond 2.6.13.

OK ... it looks like an internal refcounting error in the aic79xx; that
piece of the driver was overhauled for post 2.6.13; however, that
doesn't guarantee that this particular issue was fixed ...

James

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -110,6 +110,7 @@ static struct {
 	{"RELISYS", "Scorpio", NULL, BLIST_NOLUN},	/* responds to all lun */
 	{"SANKYO", "CP525", "6.64", BLIST_NOLUN},	/* causes failed REQ SENSE, extra reset */
 	{"TEXEL", "CD-ROM", "1.06", BLIST_NOLUN},
+	{"transtec", "T5008", "0001", BLIST_NOREPORTLUN },
 	{"YAMAHA", "CDR100", "1.00", BLIST_NOLUN},	/* locks up */
 	{"YAMAHA", "CDR102", "1.00", BLIST_NOLUN},	/* locks up */
 	{"YAMAHA", "CRW8424S", "1.0", BLIST_NOLUN},	/* locks up */


