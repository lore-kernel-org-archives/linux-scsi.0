From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [RFC PATCH 2.6.9-rc2] Add sysfs queue depth override to qla2xxx
Date: Tue, 28 Sep 2004 17:36:11 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040929003611.GK192475@sgi.com>
References: <B179AE41C1147041AA1121F44614F0B0012AD92B@AVEXCH02.qlogic.org> <20040928193614.GB192475@sgi.com> <1096401196.2008.97.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:45459 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S268113AbUI2AgZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 20:36:25 -0400
Content-Disposition: inline
In-Reply-To: <1096401196.2008.97.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

So do we have a consensus on what the driver should limit queue
depth to?  Currently, it's 32 or ql2xmaxqdepth, if that was specified.
>From what I can see, ql2xmaxqdepth is effectively limited to 65535.

We don't want one lun to use host driver or host adapter resources
to the point that it starves other luns.  Ideally, the max would
depend on what else was attached, but I don't think we want to
make this too complicated.  Anyone changing the queue depth should
have a clue about what they're doing.

Andrew, how many command slots are there in the various adapters,
and do the continuation entries each eat a command slot?

jeremy
