From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [Bugme-new] [Bug 8426] New: massive slowdown on SCSI
	CD/DVDdrive connected to mptspi driver
Date: Fri, 04 May 2007 17:58:52 -0500
Message-ID: <1178319532.3711.70.camel@mulgrave.il.steeleye.com>
References: <664A4EBB07F29743873A87CF62C26D7070C3C3@NAMAIL4.ad.lsil.com>
	 <1178315801.27774.15.camel@athlon>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:39472 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767749AbXEDW7G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 May 2007 18:59:06 -0400
In-Reply-To: <1178315801.27774.15.camel@athlon>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Chapman <doug.chapman@hp.com>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>

On Fri, 2007-05-04 at 17:56 -0400, Doug Chapman wrote:
> I am applying/removing _only_ your patch and the problem goes away with
> just removing it.

What id and channel is this DVD drive on?  There is a potential bug in
the move:

-mptscsih_writeIOCPage4(MPT_SCSI_HOST *hd, int channel, int id)
+mptspi_writeIOCPage4(MPT_SCSI_HOST *hd, u8 channel , u8 id)

Note int became u8, but later we have:


	pReq->PageAddress = cpu_to_le32(id | (channel << 8 ));

channel << 8 is always zero as a u8 entity (unless something promotes
the arithmetic beyond u8).  So if the DVD is on a non-zero channel, we
might have our cause.

James


