From: Douglas Gilbert <dgilbert@interlog.com>
Subject: RFC: short reads on block devices
Date: Fri, 17 Dec 2010 11:48:28 -0500
Message-ID: <4D0B945C.2060309@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:56769 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796Ab0LQQsf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Dec 2010 11:48:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, "Penokie, George" <George.Penokie@lsi.com>

Recently while testing with the scsi_debug driver
I was able to trick the block layer into reading
random data which the block layer thought was
valid ***.

Best to start with an example, say LBA ** 4660 has
an unrecoverable error (aka medium error) and
the block layer fires off a SCSI READ for 8
blocks (512 byte variety) at LBA 4656. The response
will be a medium error with the sense buffer info
field indicating LBA 4660. Now are the 4 blocks
that precede it (i.e. LBA 4656 to 4659) possibly
sitting in the data-in buffer and valid??

The block layer thinks they are. This is what my
term "short read" in the title alludes to. So I put
this question to the T10 reflector:
    http://www.t10.org/t10r.htm
titled "sbc: reading blocks prior to a medium error".
And the answers were pretty clear. And the one from
George Penokie of LSI is interesting because Linux's
block layer assumption breaks some of LSI's equipment.

On the other hand, big array vendors and database vendors
want exactly what the block layer is doing at the moment.
So those guys don't want a change. [Please correct me
if that is too sweeping.] Also I'm informed some other
OSes do this as well.

I would like to propose a solution, at least in the SCSI
subsystem context. The 'resid' field was added 11 years
ago and is used by a HBA driver to indicate how many bytes
less than requested were placed in the scatter gather
list (i.e. the data-in buffer). It defaults to zero
(meaning all requested bytes have been read). Usually
for a medium error one would not bother setting resid
(so resid would remain 0). Somewhat surprisingly the
block layer has always ignored resid. I propose in the
case of a short read caused by a MEDIUM ERROR the block
layer checks resid. And if resid equals the requested
number of bytes then that means no data in the scatter
gather list is valid. So the block layer should act on
this information.

To this end I propose to change the scsi_debug driver
to set resid equal to bufflen when it simulates a
medium error.

Changes in the block layer and drivers from vendors who
want the strict "T10" handling of medium errors would
also be required. Maybe the USB mass storage (and UAS)
folks might also check if this impacts them.

Doug Gilbert

**  LBA is Logical Block Address (origin 0)

*** Using 'modprobe scsi_debug opts=2' will set up a
     pseudo device which the example in the second
     paragraph is based on. Write a known pattern into the
     pseudo device (only 8 MB long) and use dd to read
     that device. Due to the 4 KB blocks used by the block
     layer, the read ends at LBA 4655. In my tests LBAs
     4576 through to 4655 are corrupted (i.e. not what is
     actually on the pseudo device).
