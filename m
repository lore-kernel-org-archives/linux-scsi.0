From: Andrew Morton <akpm@digeo.com>
Subject: Re: scsi command slab allocation under memory pressure
Date: Mon, 3 Feb 2003 14:59:30 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030203145930.34e079dc.akpm@digeo.com>
References: <20030129104731.A2811@beaverton.ibm.com>
	<3E382E2C.4030201@splentec.com>
	<20030129121117.A3389@beaverton.ibm.com>
	<20030130225738.1874c2e0.akpm@digeo.com>
	<1044020591.2002.16.camel@mulgrave>
	<20030131124412.086f2d1c.akpm@digeo.com>
	<20030203225550.GJ29516@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from digeo-nav01.digeo.com (digeo-nav01.digeo.com [192.168.1.233])
	by packet.digeo.com (8.9.3+Sun/8.9.3) with SMTP id PAA21140
	for <linux-scsi@vger.kernel.org>; Mon, 3 Feb 2003 15:04:47 -0800 (PST)
In-Reply-To: <20030203225550.GJ29516@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: James.Bottomley@steeleye.com, patmans@us.ibm.com, luben@splentec.com, linux-scsi@vger.kernel.org

Doug Ledford <dledford@redhat.com> wrote:
>
> Of course, that's just my 5 minute analysis, someone feel free to prove me 
> wrong.

I'd agree with that.

Plus there's the PF_MEMALLOC thing which gives swapper-outers an extra
megabyte or two.  If _any_ of these allocations are happening in process
context then they will benefit from this.

If all the allocations are happening at interrupt/softirq time then some
changes might be needed.

But I haven't been able to break it, using aix7xxx, with quite harsh
testing.
