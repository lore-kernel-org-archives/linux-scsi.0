From: Jason White <jason@jasonjgw.net>
Subject: SCSI queue warnings under 2.6.31 with LSI SAS1064E controller
Date: Fri, 9 Oct 2009 03:07:16 +0000 (UTC)
Message-ID: <ham9d4$ihu$1@ger.gmane.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:58464 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760208AbZJIDUl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Oct 2009 23:20:41 -0400
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1Mw61U-0007xb-OI
	for linux-scsi@vger.kernel.org; Fri, 09 Oct 2009 05:20:04 +0200
Received: from ppp118-208-189-60.lns10.mel4.internode.on.net ([118.208.189.60])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Fri, 09 Oct 2009 05:20:04 +0200
Received: from jason by ppp118-208-189-60.lns10.mel4.internode.on.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Fri, 09 Oct 2009 05:20:04 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

With apologies in advance if this is the wrong mailing list for this, after
upgrading from 2.6.30 to 2.6.31 I get the following warnings in syslog
frequently

Oct  9 12:19:21 jdc kernel: [ 1785.096275] sd 6:1:0:0: strange observation,
the queue depth is (64) meanwhile fw queue depth (65)
Oct  9 12:19:51 jdc kernel: [ 1815.312019] sd 6:1:0:0: Queue depth not changed yet

The Debian bug report is here
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=550190

Following a suggestion by Debian developers, I tried patching 2.6.31.3 with
this commit, but with no effect.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9d2e9d66a3f032667934144cd61c396ba49f090d

However, this also shows the problem can be reproduced under 2.6.31.3.

I would prefer to avoid running git bisect on this machine if I can, but I'll
gladly test a patch if it is unlikely to corrupt the file system.

HP XW6400 workstation, two SAS drives configured for striping, x86-64
architecture.

I haven't noticed any file corruption so far - I'm not sure how serious this
problem is.


