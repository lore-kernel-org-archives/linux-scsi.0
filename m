From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Apple Xserve RAID and qlogic ISP2312 (qla2300)
Date: Mon, 1 Nov 2004 11:48:45 -0800
Message-ID: <20041101194845.GA27913@us.ibm.com>
References: <20041027233321.GA842@astral.ro> <20041028143734.GA16358@beaverton.ibm.com> <20041028153522.GC1915@astral.ro> <20041028164210.GA16905@beaverton.ibm.com> <20041028172143.GA20949@praka.san.rr.com> <20041029085800.GF6671@astral.ro> <20041029180633.GA27267@beaverton.ibm.com> <20041101105611.GJ22603@astral.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:5119 "EHLO e31.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S293154AbUKATs5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Nov 2004 14:48:57 -0500
Received: from westrelay04.boulder.ibm.com (westrelay04.boulder.ibm.com [9.17.193.32])
	by e31.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id iA1JmvLv219972
	for <linux-scsi@vger.kernel.org>; Mon, 1 Nov 2004 14:48:57 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id iA1JmvBb124116
	for <linux-scsi@vger.kernel.org>; Mon, 1 Nov 2004 12:48:57 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id iA1JmsAj010334
	for <linux-scsi@vger.kernel.org>; Mon, 1 Nov 2004 12:48:55 -0700
Content-Disposition: inline
In-Reply-To: <20041101105611.GJ22603@astral.ro>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Catalin Muresan <catalin.muresan@astral.ro>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, bogdan.luca@astral.ro

[ resending ... not sure if this went out at all ]

On Mon, Nov 01, 2004 at 12:56:11PM +0200, Catalin Muresan wrote:
> 
> 	I have the attached patch from Andrew which fixes the qla2300 part
> of the problem (attached) and a patch is still needed for the case where
> there are LUN0,3 to blacklist the device as BLIST_SPARSELUN.

No attachment ...

>  > 2) If LUN 0 gets a DID_NO_CONNECT (and we do return the
>  > SCSI_SCAN_NO_RESPONSE), we won't scan anything, via REPORT LUN or via
>  > a sequential scan.
> 
> 	we need to have something on LUN 0 to be able to send REPORT LUN, in
> this case we don't.

You don't need storage configured on LUN 0 to send it a REPORT LUN, if
there is a target there, you can (well should) be able to send it a REPORT
LUN.

You do need the driver to allow commands to be issued to LUN 0 (that is
what the patch should have fixed).

SCSI spec says:

	A SCSI device shall support a REPORT LUNS command that is
	addressed to logical unit zero. Support of the REPORT LUNS command
	by logical units other than logical unit zero is optional.

> 	Do you need me to test some other stuff or we can "close" this
> issue?	

In order of best to worst solutions:

If device supports REPORT LUNs:

1) configure the array to report as SCSI-3

2) black list as BLIST_REPORTLUN2

If no REPORT LUNs support:

3) black list as BLIST_SPARSELUN

-- Patrick Mansfield
