From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [BISECTED] Re: [BUG] Linux-2.6.31-rc1 Fails To Recognize Some USB Disks
Date: Mon, 27 Jul 2009 11:19:39 -0400
Message-ID: <yq1fxci6tmc.fsf@sermon.lab.mkp.net>
References: <4A4472DF.1050900@turknet.net.tr>
	<yq1zlbrn2rj.fsf@sermon.lab.mkp.net> <4A4878AC.3050208@turknet.net.tr>
	<yq1fxdji03l.fsf@sermon.lab.mkp.net> <4A69932E.90906@turknet.net.tr>
	<yq1fxcmnpqa.fsf@sermon.lab.mkp.net> <4A69D093.8020108@turknet.net.tr>
	<yq1hbwykj80.fsf@sermon.lab.mkp.net>
	<20090727020611.GC3711@parisc-linux.org>
	<yq18wiakfq4.fsf@sermon.lab.mkp.net> <4A6D64DC.3020001@panasas.com>
	<yq1ocr66vy6.fsf@sermon.lab.mkp.net> <4A6DBEEB.5020302@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:28467 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbZG0PUG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2009 11:20:06 -0400
In-Reply-To: <4A6DBEEB.5020302@panasas.com> (Boaz Harrosh's message of "Mon,
	27 Jul 2009 17:51:23 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <matthew@wil.cx>, Tarkan Erimer <tarkan.erimer@turknet.net.tr>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

>>>>> "Boaz" == Boaz Harrosh <bharrosh@panasas.com> writes:

Boaz> Haa, OK. I thought INQUIRY EVPD=1 page=0 was so old it sure must
Boaz> be supported but you are saying it's only SBC2/SPC3. So I guess
Boaz> there is nothing else we can do.

Yes, EVPD must be supported.  USB-ATA bridge firmware writers are
dyslexic.  Film at 11.

What I'm saying is that *our* reason for sending out extended inquiry
appeared in SBC2 (block limits VPD).  So there is no point in asking
devices older than that.

The fact that this fixes the problem for Tarkan's crappy disk is a
(quasi-intentional) side effect.  My patch simply tries to be
conservative about asking for those pages.


Boaz> What I hate about all this is that in USB the scsi_level is hard
Boaz> coded at the driver, without actually been able to probe the
Boaz> device about it.

Huh, what?

-- 
Martin K. Petersen	Oracle Linux Engineering
