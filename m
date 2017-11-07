From: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Subject: RE: [bug report] scsi: mpt3sas: Added support for nvme encapsulated
 request message.
Date: Tue, 7 Nov 2017 10:29:20 -0700
Message-ID: <258eaa60cc970201a449e079c37a2dbb@mail.gmail.com>
References: <20171107113330.airlabvvr3l7oku6@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:57180 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753517AbdKGR3W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Nov 2017 12:29:22 -0500
Received: by mail-qk0-f176.google.com with SMTP id l194so16229486qke.13
        for <linux-scsi@vger.kernel.org>; Tue, 07 Nov 2017 09:29:22 -0800 (PST)
In-Reply-To: <20171107113330.airlabvvr3l7oku6@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org

Dan,
The MPI structures are of variable length and can go up to a maximum of
128 bytes (a MPI frame size) and as MPI standard the variable length MPI
structures are left out with the last element as a single dword array.
Can we ignore the warning?  If not we need to modify the MPI structure to
have the NVMe_Command array to the maximum size of the frame (which is
typically 128 but can change across hardware generations)

Thanks
Sathya

-----Original Message-----
From: mpt-fusionlinux.pdl@broadcom.com
[mailto:mpt-fusionlinux.pdl@broadcom.com] On Behalf Of Dan Carpenter
Sent: Tuesday, November 7, 2017 4:34 AM
To: suganath-prabu.subramani@broadcom.com
Cc: MPT-FusionLinux.pdl@broadcom.com; linux-scsi@vger.kernel.org
Subject: [bug report] scsi: mpt3sas: Added support for nvme encapsulated
request message.

Hello Suganath Prabu Subramani,

The patch aff39e61218f: "scsi: mpt3sas: Added support for nvme
encapsulated request message." from Oct 31, 2017, leads to the following
static checker warning:

	drivers/scsi/mpt3sas/mpt3sas_base.c:1459 _base_build_nvme_prp()
	error: buffer overflow 'nvme_encap_request->NVMe_Command' 4 <= 24

drivers/scsi/mpt3sas/mpt3sas_base.c
  1453          /*
  1454           * Set pointers to PRP1 and PRP2, which are in the NVMe
command.
  1455           * PRP1 is located at a 24 byte offset from the start of
the NVMe
                                        ^^^^^^^ The ->NVMe_Command is
declared as a 4 byte array so this makes static checkers puzzled how there
are more than 24 bytes in it.

  1456           * command.  Then set the current PRP entry pointer to
PRP1.
  1457           */
  1458          prp1_entry = (__le64 *)(nvme_encap_request->NVMe_Command +
  1459              NVME_CMD_PRP1_OFFSET);
  1460          prp2_entry = (__le64 *)(nvme_encap_request->NVMe_Command +
  1461              NVME_CMD_PRP2_OFFSET);
  1462          prp_entry = prp1_entry;
  1463          /*
  1464           * For the PRP entries, use the specially allocated buffer
of
  1465           * contiguous memory.
  1466           */
  1467          prp_page = (__le64 *)mpt3sas_base_get_pcie_sgl(ioc, smid);
  1468          prp_page_phys = (__le64
*)mpt3sas_base_get_pcie_sgl_dma(ioc, smid);
  1469

regards,
dan carpenter
