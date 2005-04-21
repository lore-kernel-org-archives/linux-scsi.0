From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Perform uncached reads on SCSI drives?
Date: Thu, 21 Apr 2005 09:14:21 -0700
Message-ID: <20050421161421.GA20143@us.ibm.com>
References: <66F9227F7417874C8DB3CEB0577274170450EE@MILEX0.Miltope.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:31925 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S261503AbVDUQOe
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Apr 2005 12:14:34 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e33.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j3LGEW4I140844
	for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2005 12:14:33 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j3LGEWax050224
	for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2005 12:14:32 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j3LGEWd3027531
	for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2005 11:14:32 -0500
Content-Disposition: inline
In-Reply-To: <66F9227F7417874C8DB3CEB0577274170450EE@MILEX0.Miltope.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Drew Winstel <DWinstel@Miltope.com>
Cc: "Linux-scsi (E-mail)" <linux-scsi@vger.kernel.org>

On Thu, Apr 21, 2005 at 10:44:23AM -0500, Drew Winstel wrote:
> It has been a busy week, I know, but does anyone have any tips?

You could try setting read cache disable, I don't know if that setting
must be honored, or how ATA/SATA handle it. See mode page 8 for SCSI block
commands. 

The sg utilities sg_modes can probably set it.

Better yet, do IO to more locations on the disk, not just the very
beginning and the very end.

> The reads we're calling are getting cached.  If we call 100 reads--50 to the 
> beginning of the drive alternating with 50 to the end--the first read will 
> sometimes appear to have a realistic result, then the rest will all complete 
> in the neighborhood of 10 microseconds.  

-- Patrick Mansfield
