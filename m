From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH] aacraid: Initialize rx/rkt function pointers before calling
 them
Date: Fri, 27 Apr 2007 11:11:04 -0700
Message-ID: <46323CB8.6060903@us.ibm.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF018FD88C@otce2k301.adaptec.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:39898 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756972AbXD0SLR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Apr 2007 14:11:17 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l3RIBCIc008610
	for <linux-scsi@vger.kernel.org>; Fri, 27 Apr 2007 14:11:12 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l3RIBCwZ520590
	for <linux-scsi@vger.kernel.org>; Fri, 27 Apr 2007 14:11:12 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l3RIBBbk019328
	for <linux-scsi@vger.kernel.org>; Fri, 27 Apr 2007 14:11:11 -0400
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF018FD88C@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi@vger.kernel.org, Alexis Bruemmer <alexisb@us.ibm.com>, Vivek Goyal <vgoyal@in.ibm.com>, Judith Lebzelter <judith@linux-foundation.org>

Salyzyn, Mark wrote:

> In my unit tests of aacraid_kexec_5.patch, restart was not called for
> normal operations. If you are just doing a normal boot, what conditions
> are causing restart to be called in your case? Is it a warm restart?
> Some kind of operation that leaves the Adapter in an initialized state,
> or a bug in the driver making sure that interrupts are disabled when
> shut down. Inquiring minds want to know!

This is a normal boot of a "Serveraid 8k-l" on an IBM x3550.  One
wrinkle in the configuration is that the system is booted off the
network, though I don't see how that would affect the aacraid's state.
It looks like the MUnit.OIMR test just after the "Failure to reset here
is an option..." comment is succeeding.  The crash seems to happen
regardless of whether we had just done a warm or cold boot.  The option
ROM had run during POST, if that makes any difference.  No kexec/kdump
have been configured.  For that matter, neither kexec nor kdump have
ever been run in the lifetime of the machine.

Also observed on an IBM x3650.

--D
