From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] 2.5.65, cciss_scsi, scsi error handling
Date: Wed, 19 Mar 2003 12:32:09 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030319203209.GA3241@beaverton.ibm.com>
References: <45B36A38D959B44CB032DA427A6E106404513385@cceexc18.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <45B36A38D959B44CB032DA427A6E106404513385@cceexc18.americas.cpqcorp.net>
List-Id: linux-scsi@vger.kernel.org
To: "Cameron, Steve" <Steve.Cameron@hp.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Cameron, Steve [Steve.Cameron@hp.com] wrote:
> Anyway, I talked this (doing aborts and device resets) 
> over with the firmware guys here, they seemed be of the 
> opinion (off the top of their heads) that aborting commands and 
> so on in the face of timeouts generally tends to make things worse, 
> not better, but said it wouldn't really hurt.  (especially I was 
> worried about i/o the array controller was doing  to disks on the 
> same bus as the tape drive, disks of which linux knows nothing.)
> 

The key thing the SCSI mid needs is the command canceled to ensure that
the LLDD will not reference the scsi_cmnd anymore. Secondary it would be
nice if the BDR got the device sane again, but the probability is low
in response to a timeout that this would be the case.

> Hmm.  If the tape drive were set off line, I wonder could I hot
> plug it to get it back?
> 
> e.g. 
> echo scsi revmove-single-device 0 0 0 0 > /proc/scsi/scsi
> (physically hot unplug tape drive)
> echo rescan > /proc/scsi/cciss1/1
> (physically hot re-plug tape drive)
> echo rescan > /proc/scsi/cciss1/1
> echo scsi add-single-device 0 0 0 0 > /proc/scsi/scsi

If the device is ok and all you want is to set the online flag you
can:

echo 1 > /sys/bus/scsi/devices/0:1:15:0/online

YMMV :-).

-andmike
--
Michael Anderson
andmike@us.ibm.com

