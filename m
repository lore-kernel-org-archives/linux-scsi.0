From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: kdump detection in SCSI drivers
Date: Tue, 2 Oct 2007 09:10:20 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01E8BB79@otce2k301.adaptec.com>
References: <9738BCBE884FDB42801FAD8A7769C26501B2C44C@NAMAIL1.ad.lsil.com> <20070920104249.GB12157@atrey.karlin.mff.cuni.cz> <9738BCBE884FDB42801FAD8A7769C26501B2C7D8@NAMAIL1.ad.lsil.com> <20071002080000.GA5743@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:48071 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbXJBNKV convert rfc822-to-8bit (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 09:10:21 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20071002080000.GA5743@atrey.karlin.mff.cuni.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>, "Mukker, Atul" <Atul.Mukker@lsi.com>
Cc: Linux-scsi@vger.kernel.org, Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org

Pavel Machek sez:
> > Other suggestion which came about was to parse the kernel
> > command line and look for "elfcorehdr=". Is this ok? Is
> > kernel command line visible to the SCSI drivers?
> Kernel command line probably is visible, but I'd recommend
> against doing that.

Probably just as pregnant of a plan, what about looking for the
reset_devices being none-zero? It was introduced for kdump to address
the problem with devices that maintain state outside of the driver and
the intent is to have it always set in the kdump kernel context.

Personally, I'd code the driver to acquire memory normally, and have a
backup plan to acquire less should the allocation fail in a memory
limited environment ;-/

Sincerely -- Mark Salyzyn
