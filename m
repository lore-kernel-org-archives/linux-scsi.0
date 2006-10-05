From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 7/8] qla2xxx: Stall mid-layer error handlers while rport
 is blocked.
Date: Thu, 05 Oct 2006 11:09:00 -0500
Message-ID: <45252E1C.3000403@cs.wisc.edu>
References: <20061002185947.GF16536@andrew-vasquezs-computer.local> <11598156511007-git-send-email-andrew.vasquez@qlogic.com> <452167C8.3010401@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:15500 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932157AbWJEQJQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Oct 2006 12:09:16 -0400
In-Reply-To: <452167C8.3010401@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>

James Smart wrote:
> Given this is the 3rd instance of this (qla2xxxx, lpfc, mpt fusion),
> we should either:
> 
> - Fix the error handler. (but we all know this is a lot of work,
>     of which none of us have the time to do, nor expect it to
>     be complete in time for our next distro delivery).

I understand the bugs in the eh. I have worked around them in iscsi and
tried to fix them in scsi-ml :) (still working on the queuecommand
SCSI_ML_HOST/DEVICE_BUSY fix), but along with the problems in the eh
where we could get the device offlined there could really be times when
the device needs to be offlined and reonlined, right? For iscsi we do
not really worry about either, in our userspace daemon we have code
where if the device was offlined and the daemon has corrected the
problem (or in qla4xxx case has been notified that the problem has been
corrected), then we online the devices. Since FC, has added a netlink
interface could we add something like fc_rport state changed event
support to some daemom. The daemon could online the device when the
rport state is back up if needed.

I was also thinking that the iscsi code has some common features and
maybe iscsi and fc could share something in some sort of blktool daemon.

Or do you think the userspace daemon is more of hack in userspace. I
cannot tell when I am hacking around something in the kernel or doing
something nifty in userspace anymore :)
