From: Dheeraj Pandey <dheeraj@Zambeel.com>
Subject: RE: [IP over FC] qla2xipsrc perf (qla2x00ip driver)
Date: Wed, 16 Oct 2002 10:48:06 -0700
Sender: linux-net-owner@vger.kernel.org
Message-ID: <233C89823A37714D95B1A891DE3BCE521423D9@xch-b.win.zambeel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-net-owner@vger.kernel.org>
To: 'Fabien Salvi' <fabien@cri74.org>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, Linux Net list <linux-net@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


 
> > Its important we identify what resource saturates in the 
> IP-over-FC case,
> > which doesn't in the other.
> 
> Yes, you're right.
> 
> I should have give more informations about CPU utilization...
> There is not really a CPU bottleneck I think.
> I didn't use mpstat tool for that, but just top (thanks for your
> information, I must admin I didn't know the mpstat tool...).
> 
> So, here are the results with IP over FC :
> 19:11:39     CPU   %user   %nice %system   %idle    intr/s
> 19:11:40     all    0.00    0.00   12.50   87.50   8033.00
> 19:11:40       0    0.00    0.00    4.00   96.00   8033.00
> 19:11:40       1    0.00    0.00   21.00   79.00   8033.00
> 
> 
> And with Gigabit ethernet :
> 
> 19:14:49     CPU   %user   %nice %system   %idle    intr/s
> 19:14:50     all    0.00    0.00   26.00   74.00  14432.00
> 19:14:50       0    0.00    0.00   40.00   60.00  14432.00
> 19:14:50       1    0.00    0.00   12.00   88.00  14432.00

It already looks like there are 50% fewer interrupts to the CPU. Now that
could be because the FC pkts are larger than the GigE. Were you using Jumbo
frames for GigE? How different are the FC pkts, in terms of size?

By the way, is the FTP a read or a write? That is, is it TX traffic or RX
traffic on the nodes? You might *not* want to ignore the lesser CPU
utilization and fewer interrupts observation. That might hold the key.

Is it also possible to test the network bandwidth independent of any disk
I/O on the servers? This will narrow down the number of variables in the
system.

Dheeraj
