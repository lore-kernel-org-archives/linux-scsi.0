From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH / RFC] scsi_error handler update. (1/4)
Date: 17 Feb 2003 12:58:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1045504719.1749.77.camel@mulgrave>
References: <3E495862.3050709@splentec.com>	<20030211212048.GC1114@beaverton.ibm.com>
	<3E49698D.3030402@splentec.com>	<20030211224119.A23149@infradead.org>
	<3E4AAA3F.8040002@splentec.com>	<20030212204634.A17425@infradead.org>
	<3E4AC0B5.9030208@splentec.com>	<20030213154748.A1965@infradead.org>
	<3E4BEA13.50402@splentec.com>	<20030213192440.A6660@redhat.com>
	<20030214165827.GA1165@beaverton.ibm.com>	 <3E4D44EB.1090402@splentec.com>
	<1045257640.1726.23.camel@mulgrave>  <3E5119EC.7080907@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id JAA07805
	for <linux-scsi@vger.kernel.org>; Mon, 17 Feb 2003 09:58:42 -0800
In-Reply-To: <3E5119EC.7080907@splentec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2003-02-17 at 12:20, Luben Tuikov wrote:
> There is no ``locking hierarchy'' -- i.e. a lock *only* locks its list
> manipulation. So, you don't have to have a string of locks to change
> a scsi_command, for example.

If I want to loop over all outstanding commands on a device (say because
the FC has just got a LIP removal), how do I do it?  Your design implies
I have to loop over all portals, targets and luns.  To do this loop, I'd
have to stabilise all the lists by acquiring the three locks that
protect them, wouldn't I?

> When was the last time a SPI HBA set channel/bus to anything different
> than 0?

Channel is a special abstraction for the dual channel chips.  It's
really an extension of host number for drivers that need a channel
decode.  The mid-layer only uses it for the host reset function, since
resetting the host 

> My Adaptec AIC-7899P dual channel, presents two hosts, not two channels.
> And this is the right behaviour.

The adaptec driver certainly uses the multiple channel feature, but only
if the AHC_TWIN flag is set in the host.

> > 3. I don't see where the mid-layer has a use for the data.  By and
> 
> Well, how can I contend *that* statement?...  This basically means
> that the whole thing I proposed is cr*p.

This is the key issue.  Complexity should only be introduced in a design
when it serves a justifiable purpose.  How do the 4 layers you propose
simplify the design/improve the throughput or in any other way add
benefit over the two layers (host and device) that we already have?

Because the standards say so isn't enough.  The Mid-layer's job is to
make efficient use of devices which follow the standards as simply and
elegantly as possible, not mirror the SCSI architecture model.

James



