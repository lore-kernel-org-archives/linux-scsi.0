From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: sg utils sg_io -i 0x24 -y "12 00:00:00 24 00"
Date: 02 Dec 2003 17:17:56 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1070410676.2347.8.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:10999 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264400AbTLCASu
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Dec 2003 19:18:50 -0500
Received: from royntex01.iomegacorp.com (unknown [147.178.90.120])
	by email.iomega.com (Postfix) with ESMTP id 6FA7B1F47
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2003 17:18:49 -0700 (MST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

> > - O_RDWR
> > + O_RDONLY|O_NONBLOCK
> ...
> I dreamed up this patch only by guessing from
> hints found on the web, not from reading a
> document anywhere.

Possibly we recommend open O_NONBLOCK for SG_IO.

Evidence in favour of that conjecture includes the following, not close
to block/scsi_ioctl.c in the kernel source, but yes close in author
space:

---

From: linux-2.6.0-test11/Documentation/cdrom/cdrom-standard.tex
...
1997/12/28 ...
...
We therefore propose to use the flag $O_NONBLOCK$ to indicate
that the device is opened just for issuing $ioctl$
commands. Strictly, the meaning of $O_NONBLOCK$ is that opening and
subsequent calls to the device don't cause the calling process to
wait. We could interpret this as ``don't wait until someone has
inserted some valid data-\cdrom.'' Thus, our proposal of the
implementation for the $open()$ call for \cdrom s is:
...
\begin{itemize}
...
\item If no other flags are set than $O_RDONLY$, the device is opened
for data transfer, and the return value will be 0 only upon successful
initialization of the transfer. The call may even induce some actions
on the \cdrom, such as closing the tray.
...
\item If the option flag $O_NONBLOCK$ is set, opening will always be
successful, unless the whole device doesn't exist. The drive will take
no actions whatsoever.
...
\end{itemize}

---

Pat LaVarre


