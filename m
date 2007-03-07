From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: qla2xxx BUG: workqueue leaked lock or atomic
Date: Tue, 6 Mar 2007 20:39:52 -0800
Message-ID: <20070306203952.471218df.akpm@linux-foundation.org>
References: <20070226133153.GC4095@skl-net.de>
	<20070226182617.GC9968@andrew-vasquezs-computer.local>
	<20070227101100.GA22572@skl-net.de>
	<20070227185134.GJ20397@andrew-vasquezs-computer.local>
	<20070228151829.GI22572@skl-net.de>
	<20070228153722.GJ22572@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932687AbXCGEne@vger.kernel.org>
In-Reply-To: <20070228153722.GJ22572@skl-net.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, Alasdair G Kergon <agk@redhat.com>, Adrian Bunk <bunk@stusta.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, 28 Feb 2007 16:37:22 +0100 Andre Noll <maan@systemlinux.org> wrote:

> On 16:18, Andre Noll wrote:
> 
> > With 2.6.21-rc2 I am unable to reproduce this BUG message. However,
> > writing to both raid systems at the same time via lvm still locks up
> > the system within minutes.
> 
> Screenshot of the resulting kernel panic:
> 
> 	http://systemlinux.org/~maan/shots/kernel-panic-21-rc2-huangho2.png
> 

It died in CFQ.  Please try a different IO scheduler.  Use something
like

	echo deadline > /sys/block/sda/queue/scheduler

This could still be the old qla2xxx bug, or it could be a new qla2xxx bug,
or it could be a block bug, or it could be an LVM bug.

Adrian, can we please track this as a regression?
