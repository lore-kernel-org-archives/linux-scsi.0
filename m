From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 0/5] block/scsi/lio support for COMPARE_AND_WRITE
Date: Thu, 16 Oct 2014 20:12:56 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295930E5A3@G4W3296.americas.hpqcorp.net>
References: <1413437835-13778-1-git-send-email-michaelc@cs.wisc.edu>
 <543FA05C.6060200@interlog.com> <54402421.8060808@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <54402421.8060808@interlog.com>
Content-Language: en-US
Sender: target-devel-owner@vger.kernel.org
To: "dgilbert@interlog.com" <dgilbert@interlog.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Douglas Gilbert
> Sent: Thursday, 16 October, 2014 3:02 PM
...
> On 14-10-16 12:39 PM, Douglas Gilbert wrote:
...
> > The COMPARE AND WRITE command may fail for other reasons
> > such as a transport problem or a Unit Attention, so the
> > SCSI eh logic may need to know about it.
> 
> Elaborating ...
> 
> Hannes will enjoy this one: say a COMPARE AND WRITE (CAW) fails
> due to a transport error or timeout. What should the EH do *** ?
> Answer: read that LBA(s) to see whether the command succeeded
> (i.e. wrote the new data)! If it did, do nothing; if it didn't,
> repeat the CAW command. And naturally that second CAW may
> yield a MISCOMPARE.

I don't think that is safe.. detecting the write data is in
place doesn't prove the COMPARE AND WRITE really worked as
a whole.

Example: if two applications do this:
* application 1: COMPARE AND WRITE: change 4 to 6
* application 2: COMPARE AND WRITE: change 5 to 6

and they both run into transport errors, then they'll 
both read back 6 and think their commands worked when
really only one of them worked.

---
Rob Elliott    HP Server Storage
