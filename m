From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH] scsi: Update Aic94xx SAS/SATA Linux open source devicedriver
 for new sequence firmware.
Date: Thu, 08 Feb 2007 15:32:02 -0800
Message-ID: <45CBB2F2.5030504@us.ibm.com>
References: <89FD792A883D4B47AD469FEA2E5D1F9B0F59E8@aime2k302.adaptec.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:49602 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965596AbXBHXcG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Feb 2007 18:32:06 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l18NVhsG012852
	for <linux-scsi@vger.kernel.org>; Thu, 8 Feb 2007 18:31:43 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by westrelay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l18NW552503488
	for <linux-scsi@vger.kernel.org>; Thu, 8 Feb 2007 16:32:05 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l18NW4F2025019
	for <linux-scsi@vger.kernel.org>; Thu, 8 Feb 2007 16:32:05 -0700
In-Reply-To: <89FD792A883D4B47AD469FEA2E5D1F9B0F59E8@aime2k302.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Wu, Gilbert" <Gilbert_Wu@adaptec.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Alexis Bruemmer <alexisb@us.ibm.com>

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
