From: "Fajun Chen" <fajunchen@gmail.com>
Subject: Re: Data read/write slows down other programs dramatically (2.6.18-rc2)
Date: Fri, 8 Sep 2006 10:13:29 -0600
Message-ID: <8202f4270609080913l23271679s86e185e8c6aeffb2@mail.gmail.com>
References: <8202f4270609071729n84eaff7j5696e5db65090af8@mail.gmail.com>
	 <45011E37.6040005@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:29686 "EHLO
	py-out-1112.google.com") by vger.kernel.org with ESMTP
	id S1750914AbWIHQNa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Sep 2006 12:13:30 -0400
Received: by py-out-1112.google.com with SMTP id n25so881628pyg
        for <linux-scsi@vger.kernel.org>; Fri, 08 Sep 2006 09:13:29 -0700 (PDT)
In-Reply-To: <45011E37.6040005@gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On 9/8/06, Tejun Heo <htejun@gmail.com> wrote:
> Fajun Chen wrote:
> > The following problem was observed occasionally: the test program uses
> > 99% of cpu and other programs slowed down dramatically: telnet session
>
> How much is in user and how much is in kernel?
>
At the time, load average was about 3.  Test program takes around 99%
cpu.  User and kernel time is not shown separately in top program, so
I'm not sure about the percentage of user vs kernel time. ata/? task
was noticed on top of the list sometimes.

> > was very slow to respond,  ip connection was almost time out...  It
> > seems the slowness was related to the dmesg traces below (just an
> > observation which may not be true). Has anyone seen similar problem
> > before? Is there any place or hot spot I should look closely?
> >
> > ---------
> > ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> > ata2.00: configured for UDMA/100
> > ata2: EH complete
> > SCSI device sdb: 1465149168 512-byte hdwr sectors (750156 MB)
> > sdb: Write Protect is off
> > sdb: Mode Sense: 00 3a 00 00
> > SCSI device sdb: drive cache: write back
> > ata1: exception Emask 0x10 SAct 0x0 SErr 0x40d0000 action 0x2 frozen
> > ata1: (irq_stat 0x01100010, PHY RDY changed)
> > ata1: waiting for device to spin up (8 secs)
> > ata2: exception Emask 0x10 SAct 0x0 SErr 0x40d0000 action 0x2 frozen
> > ata2: (irq_stat 0x01100010, PHY RDY changed)
> > ata2: waiting for device to spin up (8 secs)
> > ata1: soft resetting port
> > ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> > ata1.00: configured for UDMA/100
> > ata1: EH complete
>
> PHY RDY changed on both ata1 and 2 meaning SATA connections are broken
> on both channels simultaneously.  Was there anything special going on?
>
> [--snip--]
> > ata2: exception Emask 0x10 SAct 0x0 SErr 0x40d0000 action 0x2 frozen
> > ata2: (irq_stat 0x01100010, PHY RDY changed)
> > ata2: waiting for device to spin up (8 secs)
> > ata2: soft resetting port
> > ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> > ata2.00: configured for UDMA/100
> > ata2: EH complete
>
> Another PHY RDY changed on ata2.  This repeats a number of times.
> What's going on?  How fast are these exceptions happening?  Can you post
> long w/ timestamps?

Only read/write test was going on and we didn't do anything else.  I
don't have kernel log with timestamps at this moment, so I can't tell
how frequent these exceptions happened.

>
> > SCSI device sdb: 1465149168 512-byte hdwr sectors (750156 MB)
> > sdb: Write Protect is off
> > sdb: Mode Sense: 00 3a 00 00
> > SCSI device sdb: drive cache: write back
> > ata2: exception Emask 0x10 SAct 0x0 SErr 0x80000 action 0x2 frozen
> > ata2: (irq_stat 0x01100010, PHY RDY changed)
> > ata2: soft resetting port
> > ata2: SATA link down (SStatus 0 SControl 300)
> > ata2: failed to recover some devices, retrying in 5 secs
> > ata1: exception Emask 0x10 SAct 0x0 SErr 0x80000 action 0x2 frozen
> > ata1: (irq_stat 0x01100010, PHY RDY changed)
> > ata1: soft resetting port
> > ata1: SATA link down (SStatus 0 SControl 300)
> > ata1: failed to recover some devices, retrying in 5 secs
> > ata2: hard resetting port
> > ata2: SATA link down (SStatus 0 SControl 300)
> > ata2: failed to recover some devices, retrying in 5 secs
> > ata1: hard resetting port
> > ata1: SATA link down (SStatus 0 SControl 300)
> > ata1: failed to recover some devices, retrying in 5 secs
> > ata2: hard resetting port
> > ata2: SATA link down (SStatus 0 SControl 300)
> > ata2.00: disabled
> > sd 1:0:0:0: rejecting I/O to offline device
> > ata2: EH complete
> > ata2.00: detaching (SCSI 1:0:0:0)
> > ata1: hard resetting port
> > ata1: SATA link down (SStatus 0 SControl 300)
> > ata1.00: disabled
> > ata1: EH complete
> > ata1.00: detaching (SCSI 0:0:0:0)
>
> Another concurrent PHY RDY changed on ata1 and 2, and both drives
> decided not to respond this time.  I'm really intrigued.  Can you
> explain in deeper detail about the situation?
>

Sorry, I don't have much details to share with you. As I said, these
exceptions happened during the process of heavy IO test and they don't
happen always. I will enable printk time and collect more traces if it
happens again.
