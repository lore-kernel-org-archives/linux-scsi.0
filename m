From: Fabien Salvi <fabien@cri74.org>
Subject: Re: [IP over FC] qla2xipsrc perf (qla2x00ip driver)
Date: Thu, 17 Oct 2002 10:49:47 +0200
Sender: linux-net-owner@vger.kernel.org
Message-ID: <3DAE79AB.50DA3055@cri74.org>
References: <233C89823A37714D95B1A891DE3BCE521423D9@xch-b.win.zambeel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-net-owner@vger.kernel.org>
To: Dheeraj Pandey <dheeraj@Zambeel.com>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, Linux Net list <linux-net@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Dheeraj Pandey wrote:
> 

> > So, here are the results with IP over FC :
> > 19:11:39     CPU   %user   %nice %system   %idle    intr/s
> > 19:11:40     all    0.00    0.00   12.50   87.50   8033.00
> > 19:11:40       0    0.00    0.00    4.00   96.00   8033.00
> > 19:11:40       1    0.00    0.00   21.00   79.00   8033.00
> >
> >
> > And with Gigabit ethernet :
> >
> > 19:14:49     CPU   %user   %nice %system   %idle    intr/s
> > 19:14:50     all    0.00    0.00   26.00   74.00  14432.00
> > 19:14:50       0    0.00    0.00   40.00   60.00  14432.00
> > 19:14:50       1    0.00    0.00   12.00   88.00  14432.00
> 
> It already looks like there are 50% fewer interrupts to the CPU. Now that
> could be because the FC pkts are larger than the GigE. Were you using Jumbo
> frames for GigE? How different are the FC pkts, in terms of size?

yes, MTU for GigE is 1500 and for FC 4096
I've tried to decrease MTU on FC to 2000 or to increase to 8192, but
each time, the transfer was a half of the maximum (10 MB/s).

> By the way, is the FTP a read or a write? That is, is it TX traffic or RX
> traffic on the nodes? You might *not* want to ignore the lesser CPU
> utilization and fewer interrupts observation. That might hold the key.
> 
> Is it also possible to test the network bandwidth independent of any disk
> I/O on the servers? This will narrow down the number of variables in the
> system.

Yes you're right.
I'm going to do some tests with ramdisks to prevent perturbation of I/O
traffic...

-- 
Fabien SALVI      Centre de Ressources Informatiques
                  Archamps, France -- http://www.cri74.org
                  PingOO GNU/linux distribution : http://www.pingoo.org
