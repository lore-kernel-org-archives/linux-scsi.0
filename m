From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: 2.6.10-rc4 tape slow after switch Fusion MPT to Megaraid
Date: Wed, 2 Mar 2005 10:49:58 -0500
Message-ID: <200503021550.j22Fo3516250@www.watkins-home.com>
References: <1109759428.3666.77.camel@ilfb02.ilsb.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Received: from rwcrmhc13.comcast.net ([204.127.198.39]:57257 "EHLO
	rwcrmhc13.comcast.net") by vger.kernel.org with ESMTP
	id S262329AbVCBPuK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Mar 2005 10:50:10 -0500
In-Reply-To: <1109759428.3666.77.camel@ilfb02.ilsb.tuwien.ac.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Gerhard Schneider' <gs@ilsb.tuwien.ac.at>, 'Kai Makisara' <Kai.Makisara@kolumbus.fi>
Cc: 'scsi' <linux-scsi@vger.kernel.org>

You did:
dd if=/dev/zero of=/dev/nst0 bs=1M     and different mt setblk

Since tape drives can compress data, /dev/zero is a bad source of data,
since it compresses real good.  /dev/urandom is a better source.

You would like IBM's LTO-2 tape drive.  It does 35M/s!  They claim the LTO-3
does 70M/s!

Guy

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Gerhard Schneider
Sent: Wednesday, March 02, 2005 5:30 AM
To: Kai Makisara
Cc: scsi
Subject: Re: 2.6.10-rc4 tape slow after switch Fusion MPT to Megaraid

On Sun, 2005-02-27 at 22:46 +0200, Kai Makisara wrote:

> 
> This shows that your application is not using very large block size (3 
> pages, 10 kB?). You might get better throughput with larger block size (32

> kB or 64 kB is usually large enough). If the Megaraid command processing 
> speed is not fast enough, this might explain the problem (not probable but

> I can't see any probable problems ;-)
> 

After different tries (I had problems w/ my backup schedule - ever tried
to back up 600 GB with 2.6MB/s? :-)

Tape block sizes between 10k and a few MB don't make any difference

For better understanding I did the tests with

dd if=/dev/zero of=/dev/nst0 bs=1M     and different mt setblk

No chance to go above 2.6 MB/s

                                    Gerhard Schneider

-- 
Gerhard Schneider
Institute of Lightweight Design and          e-Mail:gs@ilsb.tuwien.ac.at
Structural Biomechanics (E317)               Tel.:   +43 1 58801 31716
Vienna University of Technology / Austria    Fax:    +43 1 58801 31799
A-1040 Wien, Gusshausstrasse 27-29    http://www.ilsb.tuwien.ac.at/~gs/


