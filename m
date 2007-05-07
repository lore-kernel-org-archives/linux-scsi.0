From: Doug Chapman <doug.chapman@hp.com>
Subject: RE: [Bugme-new] [Bug 8426] New: massive slowdown on SCSI
	CD/DVDdrive connected to mptspi driver
Date: Mon, 07 May 2007 14:37:12 -0400
Message-ID: <1178563032.27671.8.camel@deimos.americas.hpqcorp.net>
References: <664A4EBB07F29743873A87CF62C26D7070C3C3@NAMAIL4.ad.lsil.com>
	 <1178315801.27774.15.camel@athlon>
	 <1178319532.3711.70.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlrel7.hp.com ([156.153.255.213]:53829 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754723AbXEGShs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 May 2007 14:37:48 -0400
In-Reply-To: <1178319532.3711.70.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>

On Fri, 2007-05-04 at 17:58 -0500, James Bottomley wrote:
> On Fri, 2007-05-04 at 17:56 -0400, Doug Chapman wrote:
> > I am applying/removing _only_ your patch and the problem goes away with
> > just removing it.
> 
> What id and channel is this DVD drive on?  There is a potential bug in
> the move:
> 
> -mptscsih_writeIOCPage4(MPT_SCSI_HOST *hd, int channel, int id)
> +mptspi_writeIOCPage4(MPT_SCSI_HOST *hd, u8 channel , u8 id)
> 

I manually changed channel and id back to "int" and it does not seem to
have any affect.

It is looking like the issue is related to the order in how things are
called.  That is the only real change in functionality.  Perhaps there
is something that used to get initialized before mpt*_initTarget that is
now called after?  I don't see anything obvious but I am unfamiliar with
the code and have not had the time to study it all that much.

- Doug


