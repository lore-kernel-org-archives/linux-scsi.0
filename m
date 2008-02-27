From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Bug in aic94xx driver in 2.6.25-rc3
Date: Wed, 27 Feb 2008 15:37:28 -0800
Message-ID: <1204155448.3470.40.camel@localhost.localdomain>
References: <1203987834.6909.17.camel@gnattop>
	 <1203992592.26232.79.camel@alexis>  <1204151946.7281.23.camel@gnattop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60037 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756890AbYB0Xhf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Feb 2008 18:37:35 -0500
In-Reply-To: <1204151946.7281.23.camel@gnattop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: pbog@us.ibm.com
Cc: linux-scsi@vger.kernel.org, "Darrick J. Wong" <djwong@us.ibm.com>, "Wu, Gilbert" <Gilbert_Wu@adaptec.com>, Alexis Bruemmer <alexisb@us.ibm.com>, tom_white@adaptec.com

On Wed, 2008-02-27 at 14:39 -0800, peter wrote:
> My original post was user error and not acutally a bug.  I didn't
> realize that there was another patch I need to apply to rc3 to get the
> latest scsi drivers and error handler code.  Alexis clued me in.  Now
> the error handler appears to be working properly.  I included a sample
> at the bottom of this email.  
> 
> I am still seeing the disk go offline if I run i/o performance tests on
> sas disks connected to the aic94xx (sequencer version 32).  It doesn't
> happen right away.  The i/o tests will run for several hours before it
> fails.  Eventually you see the filesystem abort and then be remounted as
> read only.

Yes, I've seen this one too.  in my case it's caused by error handling
tripping a flutter on the disk phy, so the HBA actually sees an
unplug/replug event, but that causes the disk to go offline (even though
it actually reappears almost immediately).  I have that on my list of
things to fix ... probably by stealing the devloss tmo from fc.

James


