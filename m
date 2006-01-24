From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: SCSI tape access on 2.6 kernels?
Date: Tue, 24 Jan 2006 22:56:47 +0200 (EET)
Message-ID: <Pine.LNX.4.63.0601242251190.6350@kai.makisara.local>
References: <43D604AD.6050607@ilsb.tuwien.ac.at>
 <Pine.LNX.4.64.0601241251460.23364@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep01-0.kolumbus.fi ([193.229.0.41]:43656 "EHLO
	fep01-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S1750789AbWAXUyr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jan 2006 15:54:47 -0500
In-Reply-To: <Pine.LNX.4.64.0601241251460.23364@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chip Coldwell <coldwell@frank.harvard.edu>
Cc: Gerhard Schneider <gs@ilsb.tuwien.ac.at>, linux-scsi@vger.kernel.org

On Tue, 24 Jan 2006, Chip Coldwell wrote:

> On Tue, 24 Jan 2006, Gerhard Schneider wrote:
> 
> >
> > It's getting me mad..
> >
> > It seems that with 2.6 (compared to 2.4) there has something been
> > changed in the kernel that I'm not aware of so I'm not able to
> > write/read tapes efficiently anymore..
> 
> Put
> 
> options st try_direct_io=0
> 
> in /etc/modprobe.conf.  Direct I/O defeats read-ahead, and
> significantly (factor of >5) degrates read performance.  I don't know
> about writes.
> 
The only thing that could be seen in Gerhard's tests with try_direct_io=0 
should be higher CPU load. It probably won't have any effect on the speed 
in these tests.

Disabling direct i/o helps in fixed block mode if the application's read() 
and write() byte counts are small, e.g., 10 kB. With 64 kB it should not 
have any effect. Additionally, Gerhard is probably using variable block 
mode and there is no read-ahead. There is write-behind which is disabled 
when doing direct i/o but this should have no effect since if the HBA is 
able to sustain the speed the drive requires.

-- 
Kai
