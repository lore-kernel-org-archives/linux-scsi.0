From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [patch 6/8] mptfusion: fc transport
Date: 06 Dec 2004 09:18:17 -0600
Message-ID: <1102346303.2020.9.camel@mulgrave>
References: <91888D455306F94EBD4D168954A9457C73423E@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:53470 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261537AbULFPS3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Dec 2004 10:18:29 -0500
In-Reply-To: <91888D455306F94EBD4D168954A9457C73423E@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2004-12-03 at 11:33, Moore, Eric Dean wrote:
> Why does spi_attach_transport or fc_attach_transport have to be
> done from the module_init routines?  Meaning there is an assumption
> that spi and FC are separate drivers.  Why can't the xxx_attach_transport be
> done
> later from the probe routines when we know which pci devices we are
> attaching?

Can we take a step back from this and look at the actual problem you're
trying to solve with the fc class?

At the moment, its only real use is to display certain device
parameters, which is a passive feature (although it now has the capacity
to control cable pull blocking, which will be an active facility).

Your requirement came from SGI, who cares about the parameters.  What
I'm proposing is that you move the mptbase_pci_table out of mptbase.c
and into *two* upper modules (you could even do it into mptscsih.c and a
new mptfc.c, which would depend on mptscsih).  Now you have the FC
devices registered separately, you can put all of the fc transport
display into mptfc.c.  This involves moving no code other than the
actual PCI table.  Linux will automatically only modprobe mptfc if the
user has a FC device PCI ID and everyone will be happy.

Why is this such a hard thing to do?

James


