From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: question about passing physical address to lower level driver
 in scsi
Date: Mon, 31 Oct 2011 13:22:09 +0100
Message-ID: <20111031132209.1d1ee186@stein>
References: <CADUS3okkKEu_Re1FU_AvVk6agFwrmx0mwzbMSmso6pV8HFfWMA@mail.gmail.com>
	<20111030132821.4df33f1e@stein>
	<CADUS3on70KNyS5=NfMRN2eJ_aOGnZbUqo7_P_RsrEuW49xh48A@mail.gmail.com>
	<CAGRGNgWE4JQ15+Q3rpCvHs_EXiGZ0yu_X9_3FfkrBgsOiXvvLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:45209 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932869Ab1JaMWP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Oct 2011 08:22:15 -0400
In-Reply-To: <CAGRGNgWE4JQ15+Q3rpCvHs_EXiGZ0yu_X9_3FfkrBgsOiXvvLQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Julian Calaby <julian.calaby@gmail.com>
Cc: yoma sophian <sophian.yoma@gmail.com>, linux-scsi@vger.kernel.org

On Oct 31 Julian Calaby wrote:
> Hi,
> 
> On Mon, Oct 31, 2011 at 12:53, yoma sophian <sophian.yoma@gmail.com> wrote:
> > hi stefan:
> > Thanks for your reply.
> > 2011/10/30, Stefan Richter <stefanr@s5r6.in-berlin.de>:
> >> The low level driver, not SCSI core, is responsible to obtain a DMA
> >> address.
> >
> > Why I ask this because I found there is no same transformation for
> > scsi usb subsystem.
> > Would anyone can let me know where it is?
> 
> I am not familiar with the code in question, but I would guess that
> this would happen in the USB Controller Interface driver.

I don't know the USB subsystem either.  Anyway, in this case the
"SCSI low-level" (i.e. SCSI transport and interconnect driver)
internally consists of USB high-level (storage), USB core, and USB
low-level (UHCI, EHCI or whatever).  "grep -r dma_map_sg drivers/usb/"
shows occurrences of scatter-gather list DMA mappings in the USB core.  I
haven't checked whether these are indeed the ones that the usb-storage
driver relies on.
-- 
Stefan Richter
-=====-==-== =-=- =====
http://arcgraph.de/sr/
