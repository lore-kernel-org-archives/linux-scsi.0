From: peter <pbog@us.ibm.com>
Subject: Re: [RFC 0/11] mpt2sas v00.100.11.11: 3rd revision
Date: Fri, 06 Mar 2009 11:11:00 -0800
Message-ID: <1236366660.10988.6.camel@gnattop>
Reply-To: pbog@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:47458 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755717AbZCFTLD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Mar 2009 14:11:03 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e7.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n26J2NCR018487
	for <linux-scsi@vger.kernel.org>; Fri, 6 Mar 2009 14:02:23 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n26JB14M193038
	for <linux-scsi@vger.kernel.org>; Fri, 6 Mar 2009 14:11:01 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n26JB04f018965
	for <linux-scsi@vger.kernel.org>; Fri, 6 Mar 2009 14:11:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Moore, Eric" <Eric.Moore@lsi.com>


I tried to apply and compile this set of patches with the scsi-rc-fixes
git tree and ran into a few problems.

The first issue I think is just an oversight. The Makefile in
drivers/scsi doesn't get patched so even if the CONFIG_SCSI_MPT2SAS is
define in the .config file the driver doesn't get built. I needed to add
this line to the Makefile in drivers/scsi

obj-$(CONFIG_SCSI_MPT2SAS)      += mpt2sas/

The second issue is that the driver doesn't build unless
CONFIG_SCSI_MPT2SAS_LOGGING is defined. The problem seems to be that
_debug_dump_mf, from line 163 of mpt2sas_debug.h, is called from a
number of places that don't rely on CONFIG_SCSI_MPT2SAS_LOGGING. With
logging enabled the driver builds without any errors or warnings.

Peter Bogdanovic
IBM System x enablement




