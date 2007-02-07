From: "Wu, Gilbert" <Gilbert_Wu@adaptec.com>
Subject: RE: [PATCH] scsi: Update Aic94xx SAS/SATA Linux open source devicedriver for new sequence firmware.
Date: Wed, 7 Feb 2007 13:54:40 -0800
Message-ID: <89FD792A883D4B47AD469FEA2E5D1F9B0F59E8@aime2k302.adaptec.com>
References: <45C997C4.1010705@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:41651 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161447AbXBGVyp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Feb 2007 16:54:45 -0500
Content-class: urn:content-classes:message
In-Reply-To: <45C997C4.1010705@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Alexis Bruemmer <alexisb@us.ibm.com>

Hi Darrick,

 We can duplicate the problem here. The aic94xx with V28 passed IO
testing overnight if we apply IO directly to /dev/sd?.  But it fails
very quickly when we create a partition and format it as ext3. The V17
sequencer works fine with both cases. We are looking into it and find
the root cause ASAP.

Thanks!
Gilbert

-----Original Message-----
From: Darrick J. Wong [mailto:djwong@us.ibm.com] 
Sent: Wednesday, February 07, 2007 1:12 AM
To: Wu, Gilbert
Cc: James Bottomley; linux-scsi@vger.kernel.org; Alexis Bruemmer
Subject: Re: [PATCH] scsi: Update Aic94xx SAS/SATA Linux open source
devicedriver for new sequence firmware.

Wu, Gilbert wrote:
> Hi James,
> 
>   We are investigating this issue here. We will update the status when
> we can duplicate the problem here and root cause.

FWIW,

v17 looks good for both SAS/SATA load testing.  The 24-disk x260 seems
to have crapped out after about 800 rounds of load/unload due to the
phys reporting devices, then no devices about 10s later, and then having
the module unloaded before the dead SAS commands finished returning.
Not sure what that's about, though I might also have borked the x260 :(

Though who really is going to reboot the machine 800 times in rapid-fire
succession???

(I'm not trying to slam the v28 sequencer, I'm merely providing a
baseline for comparison between the two.  It may very well be the case
that all the bugs we used to observe with v17 were merely a result of us
poking the sequencer the wrong way....)

--D
