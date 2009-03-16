From: "Ying Chu" <jasonchu@marvell.com>
Subject: [RFC]Redisign Marvell Linux HBA driver Layout.
Date: Mon, 16 Mar 2009 03:26:03 -0700
Message-ID: <FE3F06125A99254E8D92161AA4569C6F0687C01C@sc-exch02.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:61534 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752765AbZCPK0I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Mar 2009 06:26:08 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, jeff@garzik.org, Tejun Heo <tj@kernel.org>
Cc: linux-scsi@vger.kernel.org, Michael Wang <qswang@marvell.com>, Jacky Feng <jfeng@marvell.com>, Andy Yan <ayan@marvell.com>, Ke Wei <kewei@marvell.com>


Hi, James/Jeff,

 We Marvell Linux Team redesign Marvell SAS/SATA Linux driver
architecture which focuses on the following issue:
1. Layout Change
	In order to support additional series ASIC, flexible source
style is mandatory. We redesign the source code layout to facilitate
more chips involved. With splitting the old mvsas.c into several files
according to its features, if any new ASIC with similar features added,
it's no necessary to give any huge changes to the original source code.
Taking 88SE94xx series chips for example, we only need add a new file
named mv_94xx.c in the corresponding folder and implement the
appropriate handler.

 	Following with source codes layout:
      XXX1 --|---------mv_init.c       /* PCI driver interface */
             |---------mv_sas.c        /* libsas-glue */
             |---------mv_sas.h        /* ditto */
             |---------mv_spi.c        /* R/W SPI for relative
configuration */
             |---------mv_spi.h        /* ditto */
             |---------mv_64xx.c       /* mv64xx */
             |---------mv_64xx.h       /* ditto */
             |---------mv_94xx.c       /* mv94xx */
             |---------mv_94xx.h       /* ditto */

This architecture is designed for those ASIC which has no embedded SOC
supported. Still in order to support Universal Message Interface ASIC
such as 88SE8180, we can place additional sub-folders to contain those
files. Like-wise, other folder can be propagated to support other
different ASIC design. So we define MTSL folder as the default, and any
sub-folders are used for different design. The ultimate layout will be: 

      MTSL----|--------------XXX1 (SAS/SATA Host controller)
              |--------------XXX2 (Universal Message Interface)
              |--------------...  (If any, others)
      
2. New Features and Bug-fixes
  - SSP TMF supported and related Error Handing enhanced.
  - Support flash feature with delay 2*HZ when PHY changed.
  - Support Marvell 94xx series ASIC for 6G SAS/SATA, which has 2
88SE64xx chips but any different register description.
  - Support SPI flash for HBA-related configuration info.
  - Other patch enhanced from kernel side such as increasing PHY type
detection wait time. (http://lkml.org/lkml/2009/1/15/502)

 Any comments will be appreciated.

--
Regards,
Ying Chu
