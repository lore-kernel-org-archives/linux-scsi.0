From: Louis-David Mitterrand <vindex+lists-linux-scsi@apartia.org>
Subject: caviar black + mpt2sas horrific performance
Date: Wed, 30 Mar 2011 10:01:18 +0200
Message-ID: <20110330080114.GA5066@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zenon.apartia.fr ([82.66.93.83]:53110 "EHLO zenon.apartia.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925Ab1C3IKG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2011 04:10:06 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I am seeing horrific performance on a Dell T610 with a LSISAS2008 (Dell
H200) card and 8 WD1002FAEX Caviar Black 1TB configured in mdadm raid6.

The LSI card is upgraded to the latest 9.00 firmware:
http://www.lsi.com/storage_home/products_home/host_bus_adapters/sas_hbas/internal/sas9211-8i/index.html
and the 2.6.38.2 kernel uses the newer mpt2sas driver.

On the T610 this command takes 20 minutes:

	tar -I pbzip2 -xvf linux-2.6.37.tar.bz2  22.64s user 3.34s system 2% cpu 20:00.69 total

where on a lower spec'ed Poweredge 2900 III server (LSI Logic MegaRAID
SAS 1078 + 8 x Hitachi Ultrastar 7K1000 in mdadm raid6) it takes 22
_seconds_:

	tar -I pbzip2 -xvf linux-2.6.37.tar.bz2  16.40s user 3.22s system 86% cpu 22.773 total

Besides hardware, the other difference between servers is that the
PE2900's MegaRAID has no JBOD mode so each disk must be configured as a
"raid0" vdisk unit. On the T610 no configuration was necessary for the
disks to "appear" in the OS. Would configuring them as raid0 vdisks
change anything?

Thanks in advance for any suggestion,
