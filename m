From: "Wu, Gilbert" <Gilbert_Wu@adaptec.com>
Subject: RE: [PATCH] scsi: Update Aic94xx SAS/SATA Linux open source devicedriver for new sequence firmware.
Date: Thu, 8 Feb 2007 18:24:58 -0800
Message-ID: <89FD792A883D4B47AD469FEA2E5D1F9B0F59EA@aime2k302.adaptec.com>
References: <45CBB2F2.5030504@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:33070 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946025AbXBICY7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Feb 2007 21:24:59 -0500
Content-class: urn:content-classes:message
In-Reply-To: <45CBB2F2.5030504@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Alexis Bruemmer <alexisb@us.ibm.com>

Yes, we are still looking into it. From the trace, the sequencer stuck
on DMA transferring data. Most likely the V28 sequencer introduces new
problem. Any way, we are going to find out the root cause.

Thanks!
Gilbert

-----Original Message-----
From: Darrick J. Wong [mailto:djwong@us.ibm.com] 
Sent: Thursday, February 08, 2007 3:32 PM
To: Wu, Gilbert
Cc: James Bottomley; linux-scsi@vger.kernel.org; Alexis Bruemmer
Subject: Re: [PATCH] scsi: Update Aic94xx SAS/SATA Linux open source
devicedriver for new sequence firmware.

Wu, Gilbert wrote:
> Hi Darrick,
> 
>  We can duplicate the problem here. The aic94xx with V28 passed IO
> testing overnight if we apply IO directly to /dev/sd?.  But it fails
> very quickly when we create a partition and format it as ext3. The V17
> sequencer works fine with both cases. We are looking into it and find
> the root cause ASAP.

This may be fairly self evident by now, but it looks like the sequencer
for the link (LSEQ, I think?) is somehow locking up, which explains why
the scsi_cmnds start timing out and after that all commands (stp, phy
control, etc) time out as well.  The other drives continue operating
normally, so I don't think the central sequencer isn't borked up.

Then again, you guys at Adaptec have the sequencer source code works and
I don't, so I can't do much more than make vague guesses. Oh well :(

--D
