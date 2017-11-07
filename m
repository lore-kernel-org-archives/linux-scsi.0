From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] scsi: mpt3sas: Added support for nvme encapsulated
 request message.
Date: Tue, 7 Nov 2017 14:33:30 +0300
Message-ID: <20171107113330.airlabvvr3l7oku6@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47373 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753905AbdKGLdj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Nov 2017 06:33:39 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: suganath-prabu.subramani@broadcom.com
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org

Hello Suganath Prabu Subramani,

The patch aff39e61218f: "scsi: mpt3sas: Added support for nvme
encapsulated request message." from Oct 31, 2017, leads to the
following static checker warning:

	drivers/scsi/mpt3sas/mpt3sas_base.c:1459 _base_build_nvme_prp()
	error: buffer overflow 'nvme_encap_request->NVMe_Command' 4 <= 24

drivers/scsi/mpt3sas/mpt3sas_base.c
  1453          /*
  1454           * Set pointers to PRP1 and PRP2, which are in the NVMe command.
  1455           * PRP1 is located at a 24 byte offset from the start of the NVMe
                                        ^^^^^^^
The ->NVMe_Command is declared as a 4 byte array so this makes static
checkers puzzled how there are more than 24 bytes in it.

  1456           * command.  Then set the current PRP entry pointer to PRP1.
  1457           */
  1458          prp1_entry = (__le64 *)(nvme_encap_request->NVMe_Command +
  1459              NVME_CMD_PRP1_OFFSET);
  1460          prp2_entry = (__le64 *)(nvme_encap_request->NVMe_Command +
  1461              NVME_CMD_PRP2_OFFSET);
  1462          prp_entry = prp1_entry;
  1463          /*
  1464           * For the PRP entries, use the specially allocated buffer of
  1465           * contiguous memory.
  1466           */
  1467          prp_page = (__le64 *)mpt3sas_base_get_pcie_sgl(ioc, smid);
  1468          prp_page_phys = (__le64 *)mpt3sas_base_get_pcie_sgl_dma(ioc, smid);
  1469  

regards,
dan carpenter
