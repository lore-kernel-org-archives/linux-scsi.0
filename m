Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4085EC47080
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 11:41:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F67A613C8
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 11:41:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbhFALnT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 07:43:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41694 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbhFALnS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 07:43:18 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1lo2m7-0008G4-O5; Tue, 01 Jun 2021 11:41:35 +0000
To:     Suganath Prabu S <suganath-prabu.subramani@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
From:   Colin Ian King <colin.king@canonical.com>
Subject: re: scsi: mpt3sas: Handle firmware faults during second half of IOC
 init
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        MPT-FusionLinux.pdl@broadcom.com,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Message-ID: <78ceab25-cc36-ac43-1e5a-5e38c22eab21@canonical.com>
Date:   Tue, 1 Jun 2021 12:41:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

Static analysis with Coverity on linux-next has detected an issue in
drivers/scsi/mpt3sas/mpt3sas_base.c with the following commit:

commit a0815c45c89f544861eae55d85ccee6b1b1451e8
Author: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Date:   Tue May 18 10:46:25 2021 +0530

    scsi: mpt3sas: Handle firmware faults during second half of IOC init

The analysis is as follows:

7208        if (ioc->port_enable_cmds.status & MPT3_CMD_COMPLETE_ASYNC) {
7209                if (ioc_status == MPI2_IOCSTATUS_SUCCESS) {
7210                        mpt3sas_port_enable_complete(ioc);
7211                        return 1;
7212                } else {
7213                        ioc->start_scan_failed = ioc_status;
7214                        ioc->start_scan = 0;
7215                        return 1;
7216                }

Structurally dead code (UNREACHABLE)
unreachable: This code cannot be reached:

7217                ioc->port_enable_cmds.status &=
~MPT3_CMD_COMPLETE_ASYNC;
7218        }

The return 1 statements in either parts of the proceeding if statement
end up with the ioc->port_enable_cmds.status masking assignment never
being reached.

Colin
