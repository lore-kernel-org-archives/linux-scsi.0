From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: 2.6.10-rc4 tape slow after switch Fusion MPT to Megaraid
Date: Sun, 27 Feb 2005 22:46:20 +0200 (EET)
Message-ID: <Pine.LNX.4.61.0502272239580.17367@kai.makisara.local>
References: <1109159088.5896.36.camel@ilfb02.ilsb.tuwien.ac.at>
 <Pine.LNX.4.61.0502242246420.9332@kai.makisara.local>
 <1109323141.5896.124.camel@ilfb02.ilsb.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Received: from fep19-0.kolumbus.fi ([193.229.0.45]:40671 "EHLO
	fep19-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S261264AbVB0UpP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Feb 2005 15:45:15 -0500
In-Reply-To: <1109323141.5896.124.camel@ilfb02.ilsb.tuwien.ac.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gerhard Schneider <gs@ilsb.tuwien.ac.at>
Cc: scsi <linux-scsi@vger.kernel.org>

On Fri, 25 Feb 2005, Gerhard Schneider wrote:

> On Thu, 2005-02-24 at 23:00 +0200, Kai Makisara wrote:
> 
> > > 
> > Sounds strange but the following things come into my mind:
> > - Check from the dmesg output and/or system logs what SCSI transfer 
> > settings the tape drive and the SCSI adapter negotiate. The speed should 
> > not change when you add the Megaraid controller. If you don't find the 
> > value before adding it, you can check that the current value is at least 
> > 40 MB/s (probably more).
> Not so easy. The megaraid driver doesn't tell you that
> 
I hope Seokmann can give you some information about this.

...
> > - Enable debugging in the st driver (change DEBUG to 1 in st.c, recompile, 
> > reload the module). In the normal case st should not print many debugging 
> > message (some when the device is opened at some when it is closed).
> 
> Now the full story:
> 
> st: Version 20050213, fixed bufsize 32768, s/g segs 256
> Attached scsi tape st0 at scsi0, channel 0, id 6, lun 0
normal output cut
> st0: Number of r/w requests 127685, dio used in 127685, pages 383055

This shows that your application is not using very large block size (3 
pages, 10 kB?). You might get better throughput with larger block size (32 
kB or 64 kB is usually large enough). If the Megaraid command processing 
speed is not fast enough, this might explain the problem (not probable but 
I can't see any probable problems ;-)

The messages look OK. There is nothing that should not be there.

--
Kai
