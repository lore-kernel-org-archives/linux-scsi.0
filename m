From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 1/2] libahci: Add support to handle HOST_IRQ_STAT as
 edge trigger latch.
Date: Mon, 4 May 2015 14:26:18 -0400
Message-ID: <20150504182618.GG1971@htj.duckdns.org>
References: <1430667220-23477-1-git-send-email-stripathi@apm.com>
 <1430667220-23477-2-git-send-email-stripathi@apm.com>
 <20150504154726.GA1971@htj.duckdns.org>
 <CAOHikRCZimsE+_-6dqTiCT6qRTFLp9VGt6=WHWA_Z86GBn+WRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOHikRCZimsE+_-6dqTiCT6qRTFLp9VGt6=WHWA_Z86GBn+WRg@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Mark Langsdorf <mlangsdo@redhat.com>, Jon Masters <jcm@redhat.com>, patches <patches@apm.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

On Mon, May 04, 2015 at 10:13:11PM +0530, Suman Tripathi wrote:
> AFAIK clearing host_irq_stat means we have handled port interrupts .
> Now for our case we still have interrupts left because it didn't get
> detected on
> first ahci_port_intr.  So you  mean to handle that residual irq in the
> next cycle (i mean next call intr handler ) ??

Heh, I think we're talking past each other.  For level triggered IRQs,
the latched IRQ bits should be cleared after handling the events;
otherwise, the latched bits are gonna get set immediately as the
events are still pending.  Also, this doesn't lose any events as
they're level triggered latches - if any event is pending, the IRQ is
gonna be raised again.

Edge triggered latches are the other way around.  You should clear the
latches before actually handling and clearing the events.  The pending
events won't trigger the latches again as it's edge-triggered and the
events which happens after this irq handling starts won't get lost as
they'll be latched for the next round.

Thanks.

-- 
tejun
