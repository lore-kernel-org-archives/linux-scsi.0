From: Abhishek Rai <abba@cs.sunysb.edu>
Subject: Re: [2.4.25], [aic79xx-2.0.8] problems with aic79xx on 2.4 (fwd)
Date: Thu, 15 Apr 2004 12:42:34 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.53.0404151238220.24238@compserv1>
References: <20040406212126.A30706@www.goron.de> <40732013.2080904@billboard.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sbcs.sunysb.edu ([130.245.1.15]:17559 "EHLO sbcs.cs.sunysb.edu")
	by vger.kernel.org with ESMTP id S264319AbUDOQpc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Apr 2004 12:45:32 -0400
In-Reply-To: <40732013.2080904@billboard.cz>
List-Id: linux-scsi@vger.kernel.org
To: David Haring <david.haring@billboard.cz>
Cc: linux-scsi@vger.kernel.org, Ari <ari@goron.de>, Erez Zadok <ezk@cs.sunysb.edu>



> I would recommend reducing TCQ depth too - I have also had
> troubles with recent Maxtor Atlas disks / Adaptec / aic79xx
> and reducing TCQ depth solved the problem.
>
> Interesting note though - the troubles only showed with Adaptec
> controller. When I have replaced the Adaptec aic79xx SCSI card
> with Tekram Ultra320 one the system worked without problem.
>
> Ari wrote:
> >
> > Hi,
> > I've ran into similar problems with the same controller and same disks
> > (Maxtor Atlas 10K4 73G WLS, mine are revision DFV0 however).
> > After a lot of frustration including changing all related hardware,
> > especially the cabling, resultless googling, etc, I found the solution:
> > Speeding down the disks does not really help. It works better, but under
> > stress load (3 bonnie++ at the same time) they quickly produce lost
> > SCB commands, even at 80Mhz.
> > What fixed it for me was limiting the Tagged Queuing depth to 16 (in
> > kernel config). After my raid5 array worked flawlessly under a 24h
> > 3 simultaneous bonnie++ test.
> > I've found some hints googling that there might be a firmware problem
> > related to this (which should be fixed with the DFV0 version on my
> > drives, but obviously is not).
> > Anyhow, try to reduce tagged queuing to 16, if that fixes it, it will
> > also confirm my findings.
>
> David Haring
>
>
>



Yes it worked ! reducing tcq depth from 32 to 16. In summary: With a
tagged queue depth of 32 and at 320MBps per disk, when I use a
single disk out of the 9 disk scsi array I have, all's well. However when
I try to use all of them (as in a raid), they fail terribly. Reducinig
disk speeds to 160MBps resolves the problem and alls fine again. But of
course I need higher speeds. For that, reducing TCQ to 16 while still
having each disk operate at 320MBps works fine.

thanks
Abhishek
