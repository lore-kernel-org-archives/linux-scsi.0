From: Jason Schoonover <jasons@pioneer-pra.com>
Subject: High load average on disk I/O on 2.6.17-rc3
Date: Fri, 5 May 2006 10:58:13 -0700
Message-ID: <200605051058.13485.jasons@pioneer-pra.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [65.205.244.70] ([65.205.244.70]:22178 "EHLO
	mail2.dmz.sj.pioneer-pra.com") by vger.kernel.org with ESMTP
	id S1751126AbWEER6O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 May 2006 13:58:14 -0400
Received: from thrace (gw.dmz.sj.pioneer-pra.com [192.168.111.1])
	(using SSLv3 with cipher EXP1024-RC4-SHA (56/128 bits))
	(Client did not present a certificate)
	by mail2.dmz.sj.pioneer-pra.com (Postfix) with ESMTP id 91C2D234340
	for <linux-scsi@vger.kernel.org>; Fri,  5 May 2006 10:58:13 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,

I just posted this to the linux-kernel mailing list, but I think that it was 
the wrong list.  I think this is the more appropriate list.

I'm having some problems on the latest 2.6.17-rc3 kernel and SCSI disk I/O.  
Whenever I copy any large file (over 500GB) the load average starts to slowly 
rise and after about a minute it is up to 7.5 and keeps on rising (depending 
on how long the file takes to copy).  When I watch top, the processes at the 
top of the list are cp, pdflush, kjournald and kswapd.

I just recently upgraded the box, it used to run Redhat 9 with kernel 2.4.20 
just fine.  This problem did not show up with 2.4.20.  I just recently 
installed Debian/unstable on it and that's when the problems started showing 
up.

Initially the problem showed up on debian's 2.6.15-1-686-smp kernel pkg, so I 
upgraded to 2.6.16-1-686; same problem, I then downloaded 2.6.16.12 from 
kernel.org and finally ended up downloading and compiling 2.6.17-rc3 and same 
problem occurs.

The hardware is a Dell PowerEdge 2650 Dual Xeon 2.4GHZ/2GB RAM, the hard drive 
controller is (as reported by lspci):

0000:04:08.1 RAID bus controller: Dell PowerEdge Expandable RAID Controller 
3/Di (rev 01)
0000:05:06.0 SCSI storage controller: Adaptec RAID subsystem HBA (rev 01)
0000:05:06.1 SCSI storage controller: Adaptec RAID subsystem HBA (rev 01)

The PERC RAID configuration is four 136GB SCSI drives RAID5'd together.

Can anybody help me out here?  Maybe I'm doing something wrong with the 
configuration.  Any help/suggestions would be great.

Thanks,
Jason Schoonover
