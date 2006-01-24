From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: SCSI tape access on 2.6 kernels?
Date: Tue, 24 Jan 2006 22:50:44 +0200 (EET)
Message-ID: <Pine.LNX.4.63.0601242245260.6350@kai.makisara.local>
References: <43D604AD.6050607@ilsb.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep01-0.kolumbus.fi ([193.229.0.41]:4226 "EHLO
	fep01-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S1030300AbWAXUso (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jan 2006 15:48:44 -0500
In-Reply-To: <43D604AD.6050607@ilsb.tuwien.ac.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gerhard Schneider <gs@ilsb.tuwien.ac.at>
Cc: linux-scsi@vger.kernel.org

On Tue, 24 Jan 2006, Gerhard Schneider wrote:

> 
> It's getting me mad..
> 
> It seems that with 2.6 (compared to 2.4) there has something been
> changed in the kernel that I'm not aware of so I'm not able to
> write/read tapes efficiently anymore..
> 
> LSI1030 SCSI controller
> Overland tape library
> Seagate LTO-1 tape drive
> 
> Kernel 2.4.29:
> 
> dd if=linux-2.6.16-rc1.tar.gz of=/dev/nst0 bs=64k
> 776+1 records in
> 776+1 records out
> 50918460 bytes transferred in 4.620612 seconds (11019852 bytes/sec)
> 
> Kernel 2.6.14rc1:
> 
> dd if=linux-2.6.16-rc1.tar.gz of=/dev/nst0 bs=64k
> 776+1 records in
> 776+1 records out
> 50918460 bytes transferred in 20.395567 seconds (2496545 bytes/sec)
> 
> Another machine w/
> LSI1030 SCSI controller
> Megaraid ZCR controller
> Overland tape library
> HP LTO-3 tape drive
> Kernel 2.6.14rc1:
> 
> dd if=linux-2.6.16-rc1.tar.gz of=/dev/nst0 bs=64k
> 776+1 records in
> 776+1 records out
> 50918460 bytes transferred in 45.953133 seconds (1108052 bytes/sec)
> 
> Either there is an initialization problems with tape drives on 2.6.*
> (I don't think so) or there are tunable kernel parameters that
> I don't know..
> 
You should not need to tune anything.

> CPU load on 2.6 is minimal, tape is waiting for data..
> 
> Any idea? (I can provide you with any amount of data etc..)
> 
What are the speeds negotiated between the SCSI HBA and the tape drive in 
these cases?

One thing that can affect your comparisons is that the amount of data is 
quite small compared to the drive speed. The startup delay may be a 
significant factor in the timings (it differs depending on where the tape 
is and what has happened before the test). Even taking this into account, 
the speeds you see with 2.6 are too small.

-- 
Kai
