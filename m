From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [Iscsitarget-devel] Re: Re[2]: ata over ethernet question
Date: Wed, 11 May 2005 14:42:34 +0900
Message-ID: <20050511144234U.fujita.tomonori@lab.ntt.co.jp>
References: <20050507150538.GA800@favonius>
	<Pine.LNX.4.60.0505102352430.9008@poirot.grange>
	<1115766875.25161.101.camel@beastie>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:41875 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP id S261898AbVEKFuu
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 May 2005 01:50:50 -0400
In-Reply-To: <1115766875.25161.101.camel@beastie>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: iscsitarget-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
Cc: dmitry_yus@yahoo.com, g.liakhovetski@gmx.de, sander@humilis.net, dhollis@davehollis.com, solt2@dns.toxicfilms.tv

From: Dmitry Yusupov <dmitry_yus@yahoo.com>
Subject: [Iscsitarget-devel] Re: Re[2]: ata over ethernet question
Date: Tue, 10 May 2005 16:14:35 -0700

> I'll redirect this question to iSCSI Target folks, so they will lead
> some light on current IET limitations and advantages comparing to NBD.

I'm not familiar with NBD, so I'll talk about only iSCSI and the
current IET implementation.


> > A follow up question - I recently used nbd to access a CD-ROM. It worked 
> > nice, but, I had to read in 7 CDs, so, each time I had to replace a CD, I 
> > had to stop the client, the server, then replace the CD, re-start the 
> > server, re-start the client... I thought about extending NBD to (better) 
> > support removable media, but then you start thinking about all those 
> > features that your local block device has that don't get exported over 
> > NBD...
> > 
> > Now, my understanding (sorry, without looking at any docs - yet) is, that 
> > iSCSI is (or at least should be) free from these limitations. So, does it 
> > make any sense at all extending NBD or just switch to iSCSI? Should NBD be 
> > just kept simple as it is or would it be completely superseeded by iSCSI, 
> > or is there still something that NBD does that iSCSI wouldn't (easily) do?

The iSCSI protocol simply encapsulates the SCSI protocol into the
TCP/IP protocol, and carries packets over IP networks. You can handle
remote devices in the exact same way as local devices (which are
directly connected to your machine through SCSI cables). So iSCSI
enables you to access a remote SCSI CD-ROM withough the above trouble.

The current IET implementation can offer disk drives to
initiators. You can use files, that is, regular files, block devices,
LVM, or RAID.

The patch for SCSI tape and CD-ROM drive support is available. It
enables you to offer SCSI tape and CD-ROM drives connected the target
box to initiators. It works in most cases, however, it is not
finished. So it is not merged.

We've not started to work on virtual tape and CD-ROM support yet.
