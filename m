From: malahal@us.ibm.com
Subject: Re: [PATCH] qla2xxx: fix RSCN handling on big-endian systems
Date: Thu, 22 Feb 2007 11:08:32 -0800
Message-ID: <20070222190832.GA30677@us.ibm.com>
References: <20070219181832.GA18043@us.ibm.com> <A6970E9A290F3F4682E1EAD0EA14F32BAE5E07@AVEXCH2.qlogic.org> <20070222025349.GA13701@us.ibm.com> <A6970E9A290F3F4682E1EAD0EA14F32BAE5EFC@AVEXCH2.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:41817 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbXBVTJY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Feb 2007 14:09:24 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l1MJ9O9D012636
	for <linux-scsi@vger.kernel.org>; Thu, 22 Feb 2007 14:09:24 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by westrelay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l1MJ9O4P416920
	for <linux-scsi@vger.kernel.org>; Thu, 22 Feb 2007 12:09:24 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l1MJ9NSk024135
	for <linux-scsi@vger.kernel.org>; Thu, 22 Feb 2007 12:09:23 -0700
Content-Disposition: inline
In-Reply-To: <A6970E9A290F3F4682E1EAD0EA14F32BAE5EFC@AVEXCH2.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seokmann Ju <seokmann.ju@qlogic.com>
Cc: linux-scsi@vger.kernel.org, Linux Driver <Linux-Driver@qlogic.com>

Seokmann Ju [seokmann.ju@qlogic.com] wrote:
> On Wednesday, February 21, 2007 6:54 PM, Malahal Naineni wrote:
> > I have JBOD in FL-port and if I unplug the cable or disable 
> > the switch port, the qla2xxx driver doesn't fail the I/O 
> > soon. The remote port status is 'online' all the time. The 
> > I/O's usually timeout after the usual scsi timeout.
> Yes, that is because qla2xxx doesn't want to trigger unnecessary error
> handling mechanism, which is expensive.
> As long as State Change recovered within SCSI timeout period, driver
> won't let mid-layer know about it.

I removed the cable and didn't put it back at all for more than 1 hour.
There is no recovery here.  When I disable an F-port, after few seconds
the remote port state is set to something other than 'online'. Why not
same behaviour for remote ports on FL-port. With my patch, the behaviour
is same whether the remote port is attached to an FL-port or an F-port.

> > Based on 
> > the existing structure, al_pa is at the lowest addressed 
> > byte, so the b24 field's interpretation as an integer is 
> > *incorrect* on big endinan systems. You should be able to print the
> > b24 as an integer and see what you get is incorrect on big 
> > endian systems.
> I agree on your assessment. However, the patch won't fix the problem as
> the problem itself is regardless byte ordering.
> A patch which includes your evaluation will be submitted.
> Thank you for findings.

Well, my patch fixed the problem! qla2x00_device_resync() fails to call
qla2x00_mark_device_lost() for RSCN's affecting area or domain because
the following evaluates to true always due to b24 field being incorrect:

		(fcport->d_id.b24 & mask) != d_id.b24

Thanks, Malahal.
