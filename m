Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DBFFC04A6A
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Jul 2023 17:44:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbjGXRod (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jul 2023 13:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbjGXRoC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jul 2023 13:44:02 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 914331990;
        Mon, 24 Jul 2023 10:43:58 -0700 (PDT)
Message-ID: <20230724172843.929899881@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1690220637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=+1QBA7VHZ0Y4GyIw3wTYa2EiSrzVOoXvVDOvnVaT6BY=;
        b=iVWRNyxlnjAR303LEMHHDOgaHF4+ObmcuZ/a6UL0hy2h4n6KHlalaO8zjpVCH2NO7d94ts
        KYqxhdN+TvXh/W9ibkQ1cfEyiQT0ix9TYvF4FxnD5nFFLH8Vn5J3L05VRqakZZ7hK91gib
        PRAAp7DPRgBtG3jsdjvkMKWnwV9MpDnkps7XJgrxpJ9T7NGVcWN+CIAMip0wP23lSG+7QO
        Fv+1QS/70IOP1Y4mt0HEhYlwad0lo39QYj4TeiR4Ntig1pN2s2IsdThp6fnw0J3CUL/V8y
        5ikSnqAWaL6exrKPPnAVymLavDDYjBaYuSwZmHc8ZQOYmukcPNrjW4Ezk8Q0hg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1690220637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=+1QBA7VHZ0Y4GyIw3wTYa2EiSrzVOoXvVDOvnVaT6BY=;
        b=rHYO7lmH2GRC0sEVqEQUPW/FVny31iqHq2c8qWgTdQaK3+q4AicqpJDmYkOECOz9x6vsFx
        /me2tsRA6HVf2FCQ==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <james.smart@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-hwmon@vger.kernel.org,
        Jean Delvare <jdelvare@suse.com>,
        Huang Rui <ray.huang@amd.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Steve Wahl <steve.wahl@hpe.com>,
        Mike Travis <mike.travis@hpe.com>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Russ Anderson <russ.anderson@hpe.com>
Subject: [patch 04/29] scsi: lpfc: Use topology_core_id()
References: <20230724155329.474037902@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 24 Jul 2023 19:43:56 +0200 (CEST)
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

