Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E537C00528
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jul 2023 12:13:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234916AbjG1MNI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jul 2023 08:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233512AbjG1MMu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jul 2023 08:12:50 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16160269E;
        Fri, 28 Jul 2023 05:12:49 -0700 (PDT)
Message-ID: <20230728120929.888713412@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1690546367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=+1QBA7VHZ0Y4GyIw3wTYa2EiSrzVOoXvVDOvnVaT6BY=;
        b=fWvBZAtr1+b7OwhEu0kVqpNM13lP2fyyhOFWfJTTI3uFnsBcnEq3eWD6OPi0V/kdIofsBD
        IWlcRLGqiQ/cmiDi0EWkLzMTw7phJe7v9wjk0XrBX6BmAdVHcGsNlg6jQbzGWWexfHKtzF
        1ZmgunT47P0OUI+815tf6BjkrRuo61gkVY/iLx/rwtXMN0raoQQF/OKZaVhT4HDEOEXpPq
        BRVVv+uYxU6BrAdcgmdY1/9zX3XSj0YrSFhHjjb3+oPf3o46Aq8HPQ7lbDb/2a6Nv9ROoe
        HgKdL4a2ald+wdDQ83SGgrWPMDHY7aGmYhZMEV3mbjhbTuF7BNUmQBhO6tVs5A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1690546367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=+1QBA7VHZ0Y4GyIw3wTYa2EiSrzVOoXvVDOvnVaT6BY=;
        b=L4xnuGbjTILMT48eR30EY7wea8T/sKtJtOh08OVrf89pbFR2Vv/khTIC6uOE4LxgEQoM+Y
        Xg2ntVr6c10qiODQ==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <james.smart@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        linux-hwmon@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Huang Rui <ray.huang@amd.com>, Juergen Gross <jgross@suse.com>,
        Steve Wahl <steve.wahl@hpe.com>,
        Mike Travis <mike.travis@hpe.com>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Russ Anderson <russ.anderson@hpe.com>
Subject: [patch v2 04/38] scsi: lpfc: Use topology_core_id()
References: <20230728105650.565799744@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 28 Jul 2023 14:12:47 +0200 (CEST)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the provided topology helper.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>
Cc: James Smart <james.smart@broadcom.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/lpfc/lpfc_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -12442,7 +12442,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba
 		cpup = &phba->sli4_hba.cpu_map[cpu];
 #ifdef CONFIG_X86
 		cpup->phys_id = topology_physical_package_id(cpu);
-		cpup->core_id = cpuinfo->cpu_core_id;
+		cpup->core_id = topology_core_id(cpu);
 		if (lpfc_find_hyper(phba, cpu, cpup->phys_id, cpup->core_id))
 			cpup->flag |= LPFC_CPU_MAP_HYPER;
 #else

