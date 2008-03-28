From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 16/17] scsi: add iSCSI iBFT Support
Date: Fri, 28 Mar 2008 17:28:25 -0500
Message-ID: <1206743305.3662.58.camel@localhost.localdomain>
References: <200803282148.m2SLmiGS012261@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52557 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753723AbYC1W2c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Mar 2008 18:28:32 -0400
In-Reply-To: <200803282148.m2SLmiGS012261@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, ketuzsezr@darnok.org, greg@kroah.com, konradr@linux.vnet.ibm.com, michaelc@cs.wisc.edu, pjones@redhat.com

On Fri, 2008-03-28 at 14:48 -0700, akpm@linux-foundation.org wrote:
> From: Konrad Rzeszutek <ketuzsezr@darnok.org>
> 
> Add /sysfs/firmware/ibft/[initiator|targetX|ethernetX] directories along with
> text properties which export the the iSCSI Boot Firmware Table (iBFT)
> structure.
> 
> What is iSCSI Boot Firmware Table?  It is a mechanism for the iSCSI tools to
> extract from the machine NICs the iSCSI connection information so that they
> can automagically mount the iSCSI share/target.  Currently the iSCSI
> information is hard-coded in the initrd.  The /sysfs entries are read-only
> one-name-and-value fields.
> 
> The usual set of data exposed is:
> 
> # for a in `find /sys/firmware/ibft/ -type f -print`; do  echo -n "$a: ";  cat $a; done
> /sys/firmware/ibft/target0/target-name: iqn.2007.com.intel-sbx44:storage-10gb
> /sys/firmware/ibft/target0/nic-assoc: 0
> /sys/firmware/ibft/target0/chap-type: 0
> /sys/firmware/ibft/target0/lun: 00000000
> /sys/firmware/ibft/target0/port: 3260
> /sys/firmware/ibft/target0/ip-addr: 192.168.79.116
> /sys/firmware/ibft/target0/flags: 3
> /sys/firmware/ibft/target0/index: 0
> /sys/firmware/ibft/ethernet0/mac: 00:11:25:9d:8b:01
> /sys/firmware/ibft/ethernet0/vlan: 0
> /sys/firmware/ibft/ethernet0/gateway: 192.168.79.254
> /sys/firmware/ibft/ethernet0/origin: 0
> /sys/firmware/ibft/ethernet0/subnet-mask: 255.255.252.0
> /sys/firmware/ibft/ethernet0/ip-addr: 192.168.77.41
> /sys/firmware/ibft/ethernet0/flags: 7
> /sys/firmware/ibft/ethernet0/index: 0
> /sys/firmware/ibft/initiator/initiator-name: iqn.2007-07.com:konrad.initiator
> /sys/firmware/ibft/initiator/flags: 3
> /sys/firmware/ibft/initiator/index: 0
> 
> For full details of the IBFT structure please take a look at:
> ftp://ftp.software.ibm.com/systems/support/system_x_pdf/ibm_iscsi_boot_firmware_table_v1.02.pdf
> 
> [akpm@linux-foundation.org: fix build]
> Signed-off-by: Konrad Rzeszutek <konradr@linux.vnet.ibm.com>
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> Cc: Peter Jones <pjones@redhat.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Greg KH <greg@kroah.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>


>  Documentation/ABI/testing/sysfs-ibft |   23 
>  arch/x86/kernel/setup_32.c           |    3 
>  arch/x86/kernel/setup_64.c           |    4 
>  drivers/firmware/Kconfig             |   20 
>  drivers/firmware/Makefile            |    2 
>  drivers/firmware/iscsi_ibft.c        |  982 +++++++++++++++++++++++++
>  drivers/firmware/iscsi_ibft_find.c   |   84 ++
>  include/linux/iscsi_ibft.h           |   50 +
>  8 files changed, 1168 insertions(+)

Um, this has no piece in the SCSI tree or any of our allied files ...
it's basically partly in arch/x86 and partly in drivers/firmware.  It's
job is to export parameters from a rom bios.  I think it belongs to
Greg ...

James


