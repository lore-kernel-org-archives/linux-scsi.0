From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] clean up some more tmscsim scan logic
Date: Tue, 17 Aug 2004 22:17:14 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0408172136340.5224@poirot.grange>
References: <20040817163323.GA16799@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.gmx.net ([213.165.64.20]:35799 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S268404AbUHQURY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Aug 2004 16:17:24 -0400
In-Reply-To: <20040817163323.GA16799@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

On Tue, 17 Aug 2004, Christoph Hellwig wrote:

> - cleanup checks in ->queuecommand, we only get here either for
>   inquiry or a found device now
> - DCBmap in the acb is gone, was only used for debug prints after
>   the prevous changes
> - kill some more debugging keyed of by ->scan_devices

Thanks for the patch!

Christoph, when I have a couple of free minutes, I am trying to look at 
the driver to see what else could one through away there:-), or what to 
improve / break... I've got a couple of points, I am trying to implement, 
but I am not sure if at all I am moving in the right direction, besides, 
maybe you also have them on your todo. So, to avoid effort duplication, 
maybe you could help me with my doubts, or tell me if you've already 
implemented it:

Currently SCSI drivers (tmscsim included) implement multiplecommand 
queues. Which, in part, makes sense, but the generic code changed, and not 
all drivers nave been converted to fully use it promptly. So, as a 
maximum, I saw (maybe you could add a couple:-)):

1) Queue in the block-layer
2) Incoming queue in a scsi LLD (recently removed in tmscsim)
3) Issue queue in LLD (Waiting in tmscsim)
4) Submitted tagged command queue or untagged 1 current command in LLD 
with a timer (Going in tmscsim)
5) tcq in SCSI mid-layer / block.

So, I can't figure out, nor find a sample implementation or a document 
about which queues should really be implemented in LLDs and how they 
should inter-operate with the mid- / block-layer. Say, a document, 
describing the (SCSI-)command flow would be very useful, like

...
n)   scsi.c: LLD->queuecommand()
n+1) LLD:    send out on the bus, insert on tcq / return
      SCSI_MLQUEUE_DEVICE_BUSY
n+2) LLD:    on command-completion, if successful, report (scsi_done()),
      if not - auto request sense, put the request-sense command on
      internal "going" queue
...

Where n+2 is, actually, the second question - I've seen a comment 
somewhere, that LLDs should (not?) auto request-sense, rather than failing 
and letting the mid-layer issue one...

Is there a "perfect" LLD, I could look at for an example? I looked at 
53c700.c, as it was until recently the only one using tcq, but it also has 
a few of those internal queues...

Thanks
Guennadi
---
Guennadi Liakhovetski

