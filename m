Return-Path: <SRS0=ULGd=EP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65809C388F7
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 13:21:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 211B8208FE
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 13:21:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388139AbgKINVz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Nov 2020 08:21:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52287 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388128AbgKINVy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2020 08:21:54 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kc77H-0007n2-ML; Mon, 09 Nov 2020 13:21:51 +0000
To:     Can Guo <cang@codeaurora.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>
From:   Colin Ian King <colin.king@canonical.com>
Subject: re: scsi: ufs: Try to save power mode change and UIC cmd completion
 timeout
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Message-ID: <fa7ed8c9-8b5d-c499-a498-245364b18f63@canonical.com>
Date:   Mon, 9 Nov 2020 13:21:51 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi

Static analysis with Coverity on linux-next has detected a potential
null pointer deference issue with commit:

commit 0f52fcb99ea2738a0a0f28e12cf4dd427069dd2a
Author: Can Guo <cang@codeaurora.org>
Date:   Mon Nov 2 22:24:40 2020 -0800

    scsi: ufs: Try to save power mode change and UIC cmd completion timeout


The analysis is as follows:

4925 static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32
intr_status)
4926 {
4927        irqreturn_t retval = IRQ_NONE;
4928

    1. Condition intr_status & 1024, taking true branch.
    2. Condition hba->active_uic_cmd, taking false branch.
    3. var_compare_op: Comparing hba->active_uic_cmd to null implies
that hba->active_uic_cmd might be null.

4929        if ((intr_status & UIC_COMMAND_COMPL) && hba->active_uic_cmd) {
4930                hba->active_uic_cmd->argument2 |=
4931                        ufshcd_get_uic_cmd_result(hba);
4932                hba->active_uic_cmd->argument3 =
4933                        ufshcd_get_dme_attr_val(hba);
4934                if (!hba->uic_async_done)
4935                        hba->active_uic_cmd->cmd_active = 0;
4936                complete(&hba->active_uic_cmd->done);
4937                retval = IRQ_HANDLED;
4938        }
4939

    4. Condition intr_status & (112U /* (0x40 | 0x20) | 0x10 */), taking
true branch.
    5. Condition hba->uic_async_done, taking true branch.

4940        if ((intr_status & UFSHCD_UIC_PWR_MASK) &&
hba->uic_async_done) {

Dereference after null check (FORWARD_NULL)
    6. var_deref_op: Dereferencing null pointer hba->active_uic_cmd.

4941                hba->active_uic_cmd->cmd_active = 0;
4942                complete(hba->uic_async_done);
4943                retval = IRQ_HANDLED;
4944        }
4945

Line 4929 checks to see if hba->active_uic_cmd is null, so there is a
potential it may be null.  However, on line 4941 hba->active_uic_cmd is
being dereferenced without a null check, so Coverity has flagged this is
a potential null pointer dereference issue.

If it is null, then cmd_active shouldn't be assigned, but I'm unsure if
this is a false positive warning and/or what the ramifications of not
seeting cmd_active to zero is if hba->active_uic_cmd is null.

Colin
