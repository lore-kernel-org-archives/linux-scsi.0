From: Douglas Gilbert <dougg@torque.net>
Subject: Re: status as in SAM2
Date: Sat, 25 May 2002 18:54:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CF01627.3C6866C@torque.net>
References: <3CEE5837.CECADF71@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Luben Tuikov wrote:
> 
> Hello there.
> 
> Given SCpnt->result and that queuecommand() has
> returned with error or done() was called,
> how can I find out the status byte as per SAM2,
> given SCpnt->result?
> 
> Is it just ``status_byte(SCpnt->result)''?
> (macro defined in scsi.h)

Luben,
The actual scsi status (bits as defined in SAM-2 and
elsewhere) is given by the expression:
   (0xff & SCpnt->result)

Traditionally linux has used a one bit shifted and masked
version of this called internally the "status_byte" which
is the macro you referred to:
   #define status_byte(result) (((result) >> 1) & 0x1f)

It masks "vendor" bits (in SCSI 2) which were bits 0, 6 
and 7. This is dangerous since SAM-2 now uses bit 6:
   0x40  ----> Task Aborted
and states all bit patterns other than those in Table 22
(Status codes) [SAM-2 draft T10/1157-D revision 23] are
reserved. I guess that stops vendors using bits 0 and
7. Has anyone every seen those bits used?


Perhaps it is time (in lk 2.5) to get rid of the current
status_byte macro "cleverness", change it to:
   #define status_byte(result) ((result) & 0xff) 
and change the "offset" defines for CHECK_CONDITION and
friends in include/scsi/scsi.h to their SAM-2 values.
Alternatively new defines could be introduced prefixed
with "SCSI_" for the standard values. The sg driver is
the only scsi interface that I'm aware of that exposes
the result of the status_byte() macro to the user space
and it could be set up not to surprise existing applications.


Doug Gilbert
