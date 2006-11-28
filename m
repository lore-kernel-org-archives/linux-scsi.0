From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: aic94xx panic on module load
Date: Tue, 28 Nov 2006 10:01:10 -0800
Message-ID: <456C7966.7080602@us.ibm.com>
References: <1164734233.21827.8.camel@markh3.pdx.osdl.net>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53900 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S935997AbWK1SBM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Nov 2006 13:01:12 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id kASI1B2w021995
	for <linux-scsi@vger.kernel.org>; Tue, 28 Nov 2006 13:01:11 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kASI1B9f155050
	for <linux-scsi@vger.kernel.org>; Tue, 28 Nov 2006 13:01:11 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kASI1BhM032588
	for <linux-scsi@vger.kernel.org>; Tue, 28 Nov 2006 13:01:11 -0500
In-Reply-To: <1164734233.21827.8.camel@markh3.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Mark Haverkamp wrote:
> I got this panic when loading the aic94xx module.  The adapter is
> connected to an HP MSA50 SAS enclosure with 3 72GB SAS disks.
> 
> Kernel 2.6.19-rc6-scsi-misc on an x86_64
<snip>
> sas: task finished with resp:0x0, stat:0x89
> sas: sas_discover_sata() for device 500508b300a27a2c at 500508b300a27a2f:0xc returned 0xffffff06
> kobject_add failed for port-2:0:12 with -EEXIST, don't try to register things with the same name in the same directory.

Your expander is reporting your SAS disks to aic94xx as SATA disks,
which is why the sas_discover_sata fails.  I don't know why it would do
that... flaky hardware?  I'm not really sure what to do when we're given
bad information.

> Kernel BUG at drivers/scsi/libsas/sas_expander.c:603

I believe this BUG is fixed by a few patches in aic94xx-sas.  For sure
you'll want the patch named "libsas: better error handling in
sas_ex_discover_end_dev()" patch; see commit
82f6bc0849b6fce9a965dde11dd6f685adc7285e.

There are some dependencies:
e384a0bdd9d3abb5ba2f6eac9ac4d0ac61e1c6a1 ->
1f8787b198c4ba058a0bfc06c2ca7f301168a5dd ->
82f6bc0849b6fce9a965dde11dd6f685adc7285e.

--D
