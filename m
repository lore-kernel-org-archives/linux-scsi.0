From: Andrew Vasquez <praka@users.sourceforge.net>
Subject: Re: pulling failover out of qla2xxx
Date: Sat, 17 Jan 2004 12:52:30 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040117205230.GB8301@praka.local.home>
References: <B179AE41C1147041AA1121F44614F0B0598E34@AVEXCH02.qlogic.org> <40084860.90902@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:5018 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S266129AbUAQVEE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 Jan 2004 16:04:04 -0500
Received: from praka.san.rr.com (66-75-130-8.san.rr.com [66.75.130.8])
	by ms-smtp-01-eri0.socal.rr.com (8.12.10/8.12.7) with ESMTP id i0HL3xqG028679
	for <linux-scsi@vger.kernel.org>; Sat, 17 Jan 2004 13:04:01 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <40084860.90902@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI <linux-scsi@vger.kernel.org>

On Fri, 16 Jan 2004, Jeff Garzik wrote:

> >I'll open up a request-for-response from the rest of the listers in
> >asking if parceling out qlaAB00.ko modules based on firmware types is
> >both practical and sensible from a user standpoint.  Especially
> >considering that many users aren't really concerned with the ISP chip
> >type on their QLAXXXX or OEM-BRANDED ABC host bus adapter.
> 
> 
> Speaking from a generic driver / distro standpoint, module dependencies 
> and PCI tables (i.e. pci_device_id and MODULE_DEVICE_TABLE) all things 
> to magically Just Work :)
> 

I certainly hope this to be the case.  Perhaps I'm still viewing this
with an eye as an external module maintainer.  When a user compiles
the qla2xxx driver she's given the following options:

	...
        [ ] QLogic ISP2100 host adapter family support
        [ ] QLogic ISP2200 host adapter family support
        [ ] QLogic ISP2300 host adapter family support
        [ ] QLogic ISP2322 host adapter family support
        [ ] QLogic ISP6312 host adapter family support
        [ ] QLogic ISP6322 host adapter family support
	...

how will she know which option to select for her QLA2362 HBA?  Will
she know it's based on an ISP2322 chip and properly select the correct
CONFIG option?  How about for a QLA2342 card?  BTW: it's based on the
ISP2312 chip so one must select the ISP2300 CONFIG option.

The CONFIG list will just get longer as new ISP chips come out.

> I heartily encourage the creation of "library modules", which are loaded 

Library modules seems fine, but, as you noted in a later email, the
qla2100/qla2200.ko modules are mostly wrappers for firmware loads.

Regards,
Andrew Vasquez
