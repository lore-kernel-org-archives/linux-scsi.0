From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH 1/2] Block I/O while SG reset operation in progress - midlayer portion
Date: Fri, 24 Feb 2006 12:11:51 -0800
Message-ID: <20060224201151.GA30144@us.ibm.com>
References: <43FF39C0.7080509@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:63383 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932464AbWBXUTr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Feb 2006 15:19:47 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id k1OKJkNF013255
	for <linux-scsi@vger.kernel.org>; Fri, 24 Feb 2006 15:19:46 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k1OKJkAf228784
	for <linux-scsi@vger.kernel.org>; Fri, 24 Feb 2006 15:19:46 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k1OKJfHq024539
	for <linux-scsi@vger.kernel.org>; Fri, 24 Feb 2006 15:19:41 -0500
Content-Disposition: inline
In-Reply-To: <43FF39C0.7080509@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

James Smart <James.Smart@Emulex.Com> wrote:
> This is the midlayer portion of the patch
> 
> This patch ensures that i/o is stopped while an eh handler is being
> processed. It adds a new flag, set by the async reset callers, which
> augments the host-in-reset checks and stops i/o.  The async reset
> callers are already synchronized to hold off until the error thread is
> no longer running.

Why the new flag instead of calling scsi_host_set_state(shost,
SHOST_RECOVERY) or a new state if you want different behavior?

Not using the state model but still doing recovery actions may run into
issues if these happen while someone tries to remove a host.

-andmike
--
Michael Anderson
andmike@us.ibm.com
