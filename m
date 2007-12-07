From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
Date: Fri, 7 Dec 2007 01:44:55 +0100
Message-ID: <200712070144.56009.rjw@sisk.pl>
References: <20071207001612.39E36DBA2@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:60731 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168AbXLGA0E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Dec 2007 19:26:04 -0500
In-Reply-To: <20071207001612.39E36DBA2@gherkin.frus.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bob Tracy <rct@frus.com>
Cc: Ingo Molnar <mingo@elte.hu>, Michael Cree <mcree@orcon.net.nz>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, rth@twiddle.net, ink@jurassic.park.msu.ru, linux-scsi@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>

On Friday, 7 of December 2007, Bob Tracy wrote:
> OK.  Finally have this thing painted into a corner: git has identified
> 6f37ac793d6ba7b35d338f791974166f67fdd9ba as the first bad commit.
> 
> From "git bisect log", this corresponds to 
> 
> # bad: [6f37ac793d6ba7b35d338f791974166f67fdd9ba] Merge branch 'master' of master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6

Something's gone wrong, as this commit doesn't modify code.

> Here's the full log:
> 
> git-bisect start
> # good: [9aae299f7fd1888ea3a195cfe0edef17bb647415] Linux 2.6.24-rc2
> git-bisect good 9aae299f7fd1888ea3a195cfe0edef17bb647415
> # bad: [f05092637dc0d9a3f2249c9b283b973e6e96b7d2] Linux 2.6.24-rc3
> git-bisect bad f05092637dc0d9a3f2249c9b283b973e6e96b7d2
> # good: [e6a5c27f3b0fef72e528fc35e343af4b2db790ff] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm
> git-bisect good e6a5c27f3b0fef72e528fc35e343af4b2db790ff
> # good: [42614fcde7bfdcbe43a7b17035c167dfebc354dd] vmstat: fix section mismatch warning
> git-bisect good 42614fcde7bfdcbe43a7b17035c167dfebc354dd
> # bad: [a052f4473603765eb6b4c19754689977601dc1d1] Merge git://git.kernel.org/pub/scm/linux/kernel/git/sam/x86
> git-bisect bad a052f4473603765eb6b4c19754689977601dc1d1
> # good: [d8e5219f9f5ca7518eb820db9f3d287a1d46fcf5] CRISv10 improve and bugfix fasttimer
> git-bisect good d8e5219f9f5ca7518eb820db9f3d287a1d46fcf5
> # good: [d90bf5a976793edfa88d3bb2393f0231eb8ce1e5] [NET]: rt_check_expire() can take a long time, add a cond_resched()
> git-bisect good d90bf5a976793edfa88d3bb2393f0231eb8ce1e5
> # good: [2a113281f5cd2febbab21a93c8943f8d3eece4d3] kconfig: use $K64BIT to set 64BIT with all*config targets
> git-bisect good 2a113281f5cd2febbab21a93c8943f8d3eece4d3
> # good: [2e2cd8bad6e03ceea73495ee6d557044213d95de] CRISv10 memset library add lineendings to asm
> git-bisect good 2e2cd8bad6e03ceea73495ee6d557044213d95de
> # bad: [6f37ac793d6ba7b35d338f791974166f67fdd9ba] Merge branch 'master' of master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6
> git-bisect bad 6f37ac793d6ba7b35d338f791974166f67fdd9ba
> # good: [2f1f53bdc6531696934f6ee7bbdfa2ab4f4f62a3] CRISv10 fasttimer: Scrap INLINE and name timeval_cmp better
> git-bisect good 2f1f53bdc6531696934f6ee7bbdfa2ab4f4f62a3
