Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF9EFC3F2D1
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:18:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7197E246B4
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583137112;
	bh=j+CiTWabGq3FXlueQMbmSeaj+tQF9Be/P6X1HTLA8n0=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=X9UTFw+BE1vALQdISdpV9B/BmshG1Do4oNPCrUiJmv0muJ9Hdl8Jkn5GkCWEM9jab
	 zzXsEl3SBSHvUzEoHYaqvgHOShEc02yaz0xxK46xMl4hH6zfVyQw/NOrgRzxWjWEvd
	 O6JR60mqs8YQ2uY4+Mc7L7ax5llzCVyRsuMNutas=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbgCBIST (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Mar 2020 03:18:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:56988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727209AbgCBIQV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Mar 2020 03:16:21 -0500
Received: from mail.kernel.org (ip5f5ad4e9.dynamic.kabel-deutschland.de [95.90.212.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 893B0246EB;
        Mon,  2 Mar 2020 08:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583136979;
        bh=j+CiTWabGq3FXlueQMbmSeaj+tQF9Be/P6X1HTLA8n0=;
        h=From:To:Cc:Subject:Date:From;
        b=x5jd/QTE93lIkxJfUM+jb34xeZrMlv/yIiMdt8EhqpuW6Ei6D0jFaJXgsUjqpKRjp
         5+jxbPQ01NnYDKXNH6g7hBQZjQxNa24LhZSDLG5mEnOB1BfyZVi80j3vHcBdMzHZV7
         9Pwx7QA3BzGzBWRqzJVve1WOSw7I6wr+ugQscbEg=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1j8gFM-0003wg-VK; Mon, 02 Mar 2020 09:16:16 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Matthew Wilcox <willy@infradead.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        megaraidlinux.pdl@broadcom.com,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        esc.storagedev@microsemi.com, Doug Gilbert <dgilbert@interlog.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        HighPoint Linux Team <linux@highpoint-tech.com>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Hannes Reinecke <hare@suse.com>, dc395x@twibble.org,
        Oliver Neukum <oliver@neukum.org>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Juergen E. Fischer" <fischer@norbit.de>,
        Khalid Aziz <khalid@gonehiking.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Jamie Lenehan <lenehan@twibble.org>,
        Ali Akcaagac <aliakc@web.de>,
        Don Brace <don.brace@microsemi.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Avri Altman <avri.altman@wdc.com>,
        GOTO Masanori <gotom@debian.or.jp>
Subject: [PATCH 00/42] Manually convert SCSI documentation to ReST format
Date:   Mon,  2 Mar 2020 09:15:33 +0100
Message-Id: <cover.1583136624.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch series manually convert all SCSI documentation files to ReST.

This is part of a bigger series that finaly finishes the migration to ReST.
After that, we can focus on more interesting tasks from the documentation
PoV, like cleaning obsolete stuff and filling the gaps.

If you want to see how this would show at the documentation body,
a sneak peak of this series (together with the other pending
doc patches from me) is available at:

        https://www.infradead.org/~mchehab/kernel_docs/scsi/index.html

This series is available on this devel branch:

        https://git.linuxtv.org/mchehab/experimental.git/log/?h=scsi_docs_20200228

and it is based on next-20200228


Mauro Carvalho Chehab (42):
  Add an empty index file for SCSI documents
  docs: scsi: include SCSI Transport SRP diagram at the doc body
  docs: scsi: convert 53c700.txt to ReST
  docs: scsi: convert aacraid.txt to ReST
  docs: scsi: convert advansys.txt to ReST
  docs: scsi: convert aha152x.txt to ReST
  docs: scsi: convert aic79xx.txt to ReST
  docs: scsi: convert aic7xxx.txt to ReST
  docs: scsi: convert bfa.txt to ReST
  docs: scsi: convert bnx2fc.txt to ReST
  docs: scsi: convert BusLogic.txt to ReST
  docs: scsi: convert cxgb3i.txt to ReST
  docs: scsi: convert dc395x.txt to ReST
  docs: scsi: convert dpti.txt to ReST
  docs: scsi: convert FlashPoint.txt to ReST
  docs: scsi: convert g_NCR5380.txt to ReST
  docs: scsi: convert hpsa.txt to ReST
  docs: scsi: convert hptiop.txt to ReST
  docs: scsi: convert libsas.txt to ReST
  docs: scsi: convert link_power_management_policy.txt to ReST
  docs: scsi: convert lpfc.txt to ReST
  docs: scsi: convert megaraid.txt to ReST
  docs: scsi: convert ncr53c8xx.txt to ReST
  docs: scsi: convert NinjaSCSI.txt to ReST
  docs: scsi: convert ppa.txt to ReST
  docs: scsi: convert qlogicfas.txt to ReST
  docs: scsi: convert scsi-changer.txt to ReST
  docs: scsi: convert scsi_eh.txt to ReST
  docs: scsi: convert scsi_fc_transport.txt to ReST
  docs: scsi: convert scsi-generic.txt to ReST
  docs: scsi: convert scsi_mid_low_api.txt to ReST
  docs: scsi: convert scsi-parameters.txt to ReST
  docs: scsi: convert scsi.txt to ReST
  docs: scsi: convert sd-parameters.txt to ReST
  docs: scsi: convert smartpqi.txt to ReST
  docs: scsi: convert st.txt to ReST
  docs: scsi: convert sym53c500_cs.txt to ReST
  docs: scsi: convert sym53c8xx_2.txt to ReST
  docs: scsi: convert tcm_qla2xxx.txt to ReST
  docs: scsi: convert ufs.txt to ReST
  docs: scsi: convert wd719x.txt to ReST
  docs: scsi: convert arcmsr_spec.txt to ReST

 Documentation/driver-api/libata.rst           |    2 +-
 Documentation/index.rst                       |    1 +
 Documentation/scsi/{53c700.txt => 53c700.rst} |   61 +-
 .../scsi/{BusLogic.txt => BusLogic.rst}       |   89 +-
 .../scsi/{FlashPoint.txt => FlashPoint.rst}   |  225 +-
 .../scsi/{NinjaSCSI.txt => NinjaSCSI.rst}     |  198 +-
 .../scsi/{aacraid.txt => aacraid.rst}         |   59 +-
 .../scsi/{advansys.txt => advansys.rst}       |  129 +-
 .../scsi/{aha152x.txt => aha152x.rst}         |   73 +-
 .../scsi/{aic79xx.txt => aic79xx.rst}         |  586 +++---
 .../scsi/{aic7xxx.txt => aic7xxx.rst}         |  446 ++--
 Documentation/scsi/arcmsr_spec.rst            |  907 ++++++++
 Documentation/scsi/arcmsr_spec.txt            |  574 -----
 Documentation/scsi/{bfa.txt => bfa.rst}       |   28 +-
 Documentation/scsi/{bnx2fc.txt => bnx2fc.rst} |   18 +-
 Documentation/scsi/{cxgb3i.txt => cxgb3i.rst} |   22 +-
 Documentation/scsi/{dc395x.txt => dc395x.rst} |   75 +-
 Documentation/scsi/dpti.rst                   |   92 +
 Documentation/scsi/dpti.txt                   |   83 -
 .../scsi/{g_NCR5380.txt => g_NCR5380.rst}     |   89 +-
 Documentation/scsi/{hpsa.txt => hpsa.rst}     |   79 +-
 Documentation/scsi/{hptiop.txt => hptiop.rst} |   45 +-
 Documentation/scsi/index.rst                  |   51 +
 Documentation/scsi/{libsas.txt => libsas.rst} |  364 ++--
 ...y.txt => link_power_management_policy.rst} |   12 +-
 Documentation/scsi/{lpfc.txt => lpfc.rst}     |   16 +-
 .../scsi/{megaraid.txt => megaraid.rst}       |   47 +-
 .../scsi/{ncr53c8xx.txt => ncr53c8xx.rst}     | 1865 ++++++++++-------
 Documentation/scsi/{ppa.txt => ppa.rst}       |   12 +-
 .../scsi/{qlogicfas.txt => qlogicfas.rst}     |   17 +-
 .../{scsi-changer.txt => scsi-changer.rst}    |   36 +-
 .../{scsi-generic.txt => scsi-generic.rst}    |   75 +-
 ...csi-parameters.txt => scsi-parameters.rst} |   28 +-
 Documentation/scsi/{scsi.txt => scsi.rst}     |   31 +-
 .../scsi/{scsi_eh.txt => scsi_eh.rst}         |  217 +-
 ...fc_transport.txt => scsi_fc_transport.rst} |  236 ++-
 ...i_mid_low_api.txt => scsi_mid_low_api.rst} | 1730 +++++++--------
 .../{Makefile => figures.rst}                 |    9 +-
 .../{sd-parameters.txt => sd-parameters.rst}  |   21 +-
 .../scsi/{smartpqi.txt => smartpqi.rst}       |   52 +-
 Documentation/scsi/{st.txt => st.rst}         |  301 ++-
 .../{sym53c500_cs.txt => sym53c500_cs.rst}    |    8 +-
 .../scsi/{sym53c8xx_2.txt => sym53c8xx_2.rst} | 1109 +++++-----
 .../scsi/{tcm_qla2xxx.txt => tcm_qla2xxx.rst} |   26 +-
 Documentation/scsi/{ufs.txt => ufs.rst}       |   84 +-
 Documentation/scsi/{wd719x.txt => wd719x.rst} |   23 +-
 MAINTAINERS                                   |   28 +-
 drivers/scsi/BusLogic.c                       |    2 +-
 drivers/scsi/Kconfig                          |   42 +-
 drivers/scsi/aha152x.c                        |    4 +-
 drivers/scsi/aic7xxx/Kconfig.aic79xx          |    2 +-
 drivers/scsi/aic7xxx/Kconfig.aic7xxx          |    2 +-
 drivers/scsi/arcmsr/arcmsr_attr.c             |    2 +-
 drivers/scsi/arcmsr/arcmsr_hba.c              |    2 +-
 drivers/scsi/dpt/dpti_ioctl.h                 |    2 +-
 drivers/scsi/dpt_i2o.c                        |    2 +-
 drivers/scsi/dpti.h                           |    2 +-
 drivers/scsi/g_NCR5380.c                      |    2 +-
 drivers/scsi/ncr53c8xx.c                      |    2 +-
 drivers/scsi/pcmcia/Kconfig                   |    2 +-
 drivers/scsi/smartpqi/Kconfig                 |    2 +-
 drivers/scsi/st.c                             |    2 +-
 drivers/scsi/ufs/Kconfig                      |    2 +-
 include/scsi/sg.h                             |    2 +-
 scripts/documentation-file-ref-check          |    2 +-
 65 files changed, 6040 insertions(+), 4317 deletions(-)
 rename Documentation/scsi/{53c700.txt => 53c700.rst} (75%)
 rename Documentation/scsi/{BusLogic.txt => BusLogic.rst} (93%)
 rename Documentation/scsi/{FlashPoint.txt => FlashPoint.rst} (21%)
 rename Documentation/scsi/{NinjaSCSI.txt => NinjaSCSI.rst} (28%)
 rename Documentation/scsi/{aacraid.txt => aacraid.rst} (83%)
 rename Documentation/scsi/{advansys.txt => advansys.rst} (73%)
 rename Documentation/scsi/{aha152x.txt => aha152x.rst} (76%)
 rename Documentation/scsi/{aic79xx.txt => aic79xx.rst} (48%)
 rename Documentation/scsi/{aic7xxx.txt => aic7xxx.rst} (49%)
 create mode 100644 Documentation/scsi/arcmsr_spec.rst
 delete mode 100644 Documentation/scsi/arcmsr_spec.txt
 rename Documentation/scsi/{bfa.txt => bfa.rst} (72%)
 rename Documentation/scsi/{bnx2fc.txt => bnx2fc.rst} (91%)
 rename Documentation/scsi/{cxgb3i.txt => cxgb3i.rst} (86%)
 rename Documentation/scsi/{dc395x.txt => dc395x.rst} (64%)
 create mode 100644 Documentation/scsi/dpti.rst
 delete mode 100644 Documentation/scsi/dpti.txt
 rename Documentation/scsi/{g_NCR5380.txt => g_NCR5380.rst} (41%)
 rename Documentation/scsi/{hpsa.txt => hpsa.rst} (77%)
 rename Documentation/scsi/{hptiop.txt => hptiop.rst} (78%)
 create mode 100644 Documentation/scsi/index.rst
 rename Documentation/scsi/{libsas.txt => libsas.rst} (57%)
 rename Documentation/scsi/{link_power_management_policy.txt => link_power_management_policy.rst} (65%)
 rename Documentation/scsi/{lpfc.txt => lpfc.rst} (93%)
 rename Documentation/scsi/{megaraid.txt => megaraid.rst} (66%)
 rename Documentation/scsi/{ncr53c8xx.txt => ncr53c8xx.rst} (55%)
 rename Documentation/scsi/{ppa.txt => ppa.rst} (32%)
 rename Documentation/scsi/{qlogicfas.txt => qlogicfas.rst} (92%)
 rename Documentation/scsi/{scsi-changer.txt => scsi-changer.rst} (87%)
 rename Documentation/scsi/{scsi-generic.txt => scsi-generic.rst} (70%)
 rename Documentation/scsi/{scsi-parameters.txt => scsi-parameters.rst} (81%)
 rename Documentation/scsi/{scsi.txt => scsi.rst} (82%)
 rename Documentation/scsi/{scsi_eh.txt => scsi_eh.rst} (73%)
 rename Documentation/scsi/{scsi_fc_transport.txt => scsi_fc_transport.rst} (74%)
 rename Documentation/scsi/{scsi_mid_low_api.txt => scsi_mid_low_api.rst} (39%)
 rename Documentation/scsi/scsi_transport_srp/{Makefile => figures.rst} (1%)
 rename Documentation/scsi/{sd-parameters.txt => sd-parameters.rst} (37%)
 rename Documentation/scsi/{smartpqi.txt => smartpqi.rst} (67%)
 rename Documentation/scsi/{st.txt => st.rst} (79%)
 rename Documentation/scsi/{sym53c500_cs.txt => sym53c500_cs.rst} (89%)
 rename Documentation/scsi/{sym53c8xx_2.txt => sym53c8xx_2.rst} (53%)
 rename Documentation/scsi/{tcm_qla2xxx.txt => tcm_qla2xxx.rst} (57%)
 rename Documentation/scsi/{ufs.txt => ufs.rst} (79%)
 rename Documentation/scsi/{wd719x.txt => wd719x.rst} (46%)

-- 
2.21.1


