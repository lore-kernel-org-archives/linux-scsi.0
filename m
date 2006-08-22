From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [Patch] cleanup: GFP_ATOMIC to GFP_KERNEL in scsi_scan.c
Date: Tue, 22 Aug 2006 11:43:19 +0200
Message-ID: <44EAD1B7.1010505@s5r6.in-berlin.de>
References: <1156187273.2924.12.camel@dyn-9-152-230-71.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:16783 "EHLO
	hp3.statik.tu-cottbus.de") by vger.kernel.org with ESMTP
	id S1751389AbWHVJrN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Aug 2006 05:47:13 -0400
In-Reply-To: <1156187273.2924.12.camel@dyn-9-152-230-71.boeblingen.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke <mp3@de.ibm.com>
Cc: linux-scsi@vger.kernel.org

Martin Peschke wrote:
> It seems to be safe to replace all 4 occurrences of GFP_ATOMIC in
> scsi_scan.c by GFP_KERNEL. I found that calling code always held a mutex
> (indicating process context) while not acquiring a spin_lock or such
> inside the mutex sections and when using GFP_ATOMIC (see details below).

Please use diff's -p option for postings like this.

Did you check Documentation/scsi/scsi_mid_low_api.txt with respect to
the detailed description of all exported functions which you modify? All
of them should contain a remark like "Might block: yes" or something
else in the way of "do not call in atomic context". Although I suppose
that all or most of them do so already.

If scsi_mid_low_api.txt does not fully reflect what your patch imposes,
please modify scsi_mid_low_api.txt in the same patch.

> http://marc.theaimsgroup.com/?l=linux-scsi&m=115522223917634&w=2
> indicates that these occurrences of GFP_ATOMIC are just there for
> historical reasons.
> 
> Patch ist against 2.6.18-rc4-mm2. Please consider applying this cleanup.
> It didn't break my test machine with 3 SCSI disks attached.
[...]

You need to make sure that it does not break _any_ caller. (SCSI is more
than the bundle of interconnect drivers for SPI hardware.) Also take
precautions for future callers or future changes to current callers.
-- 
Stefan Richter
-=====-=-==- =--- =-==-
http://arcgraph.de/sr/
