From: Sam Creasey <sammy@sammy.net>
Subject: Re: [PATCH] kill old EH constants
Date: Thu, 21 Apr 2005 09:41:25 -0400 (EDT)
Message-ID: <Pine.LNX.4.40.0504210938260.972-100000@sun3>
References: <20050421100933.GA19586@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sun3.sammy.net ([68.162.198.6]:62477 "HELO sun3.sammy.net")
	by vger.kernel.org with SMTP id S261377AbVDUNla (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Apr 2005 09:41:30 -0400
In-Reply-To: <20050421100933.GA19586@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, Linux Kernel Development <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Linux/m68k <linux-m68k@vger.kernel.org>



On Thu, 21 Apr 2005, Christoph Hellwig wrote:

> On Thu, Apr 21, 2005 at 11:58:12AM +0200, Geert Uytterhoeven wrote:
> > sun3_NCR5380.c still uses the following:
> >
> >   - SCSI_ABORT_SUCCESS
> >   - SCSI_ABORT_ERROR
> >   - SCSI_ABORT_SNOOZE
> >   - SCSI_ABORT_BUSY
> >   - SCSI_ABORT_NOT_RUNNING
> >   - SCSI_RESET_SUCCESS
> >   - SCSI_RESET_BUS_RESET
> >
> > causing the driver to fail to build in 2.6.12-rc3. What should I replace them
> > by?
>
> You must replace NCR5380_abort and NCR5380_bus_reset with real new-style
> EH routines.  I'd suggest copying them from NCR5380.c or even better
> scrapping sun3_NCR5380.c in favour of that one completely.

Trust me, there's reasons we don't use NCR5380.c.... (primarily, this has
to due with the order of operations necessary to keep the DMA controller
happpy, which required changing the flow of several functions
(admittedly, I haven't looked into this again since the "new-style"
driver change)).

That being said, it seems the first option needs done.  I suppose I'll
add fixing those two routines to my long list of backlogged sun3 stuff
which needs doing.

-- Sam


