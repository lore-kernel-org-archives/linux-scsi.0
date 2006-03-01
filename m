From: Douglas Gilbert <dougg@torque.net>
Subject: Re: SATA on mptsas performance
Date: Tue, 28 Feb 2006 22:30:16 -0500
Message-ID: <44051548.9090408@torque.net>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F28A5FF@NAMAIL2.ad.lsil.com> <43F2DDA7.7050700@web.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([205.233.218.70]:62919 "EHLO
	canuck.infradead.org") by vger.kernel.org with ESMTP
	id S1750764AbWCADbU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 22:31:20 -0500
In-Reply-To: <43F2DDA7.7050700@web.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mirko Benz <mirko.benz@web.de>
Cc: linux-scsi@vger.kernel.org

Mirko Benz wrote:
> Hello,
> 
> The SAS3442X is connected to the JBOD via a x4 SAS cable.
> The JBOD has an LSI SAS Expander chip - no port multiplier.
> Disks are Seagate ST3300831AS (300 GB, SATA-I, NCQ)
> 
> Does the SAS controller and the SAS expander communicate at 3 Gb when
> accessing SATA disks?

If the SATA disk does 3 Gb/sec then yes but SATA-1 disks
run at 1.5 Gb/sec (and don't have NCQ). When a SAS HBA
using STP connects to a SATA-1 disk via an expander it
rate matches. This means that it substitutes a dummy value
(ALIGN I think) between each data value on that path
(between the HBA and the expander). Hence it essentially
wastes half the available bandwidth for the duration of
the connection. There is talk of multiplexing in SAS-2
when the the physical link rate is 6 Gb/sec and the
connection rate is 3 or 1.5 Gb/sec.

> If not it should give 4 * 150 MB/s r/w throughput for this configuration.

4 * 150 MB/sec r/w throughput (half duplex ?) would be
correct.

BTW since SAS uses "10b8b" encoding (as do IB,
FC, SATA, PCIe, 10 gigabit ethernet on copper, etc) which
encodes 8 data bits into 10 bits on the wire then one
can flip between "<n> MB/sec" and "(<n> * 10) Mb/sec". The
capitalization (or not) of the "B" is obviously significant.
Perhaps somebody from a SAS vendor company could tell us how
much data one can really send down a 3 Gb/sec SAS/STP
connection under optimum conditions.


Doug Gilbert

