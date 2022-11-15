Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C11A1C43219
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Nov 2022 12:54:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237921AbiKOMy1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Nov 2022 07:54:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237857AbiKOMyK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2022 07:54:10 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E557F2C7;
        Tue, 15 Nov 2022 04:54:08 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id d9so19387627wrm.13;
        Tue, 15 Nov 2022 04:54:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LaKOqDhptLjaCqNuPU9LAcUmnWCUnenBrjS8YZMexSk=;
        b=NpXsKZ8mo+A+jcgbZQFf3yGUFVDQvoSPwX6Io2f09OX9oPL4LYzfbWN5dAhQ2yUkbS
         0r30nqaVFLu4j9BleBxtON0dsjlMTz8v8dRBra1s8woLlkyDnrHS76nMdGTfjDhbDJ3k
         yHCOenwbegupBQOuAwxUuvEWJD0U7wzupmGMwUxEX4q4Wlni2kd0MBZASfMGlXkZeZSK
         gxNsJ/OmWK3Egrhi+BaNb3teUJpCKEGcy0MctdZsA2QI+cH8GhhNRsM5t11S/hFmeLl/
         tgVvJFCwIZ8HVeTvnpEb72QVvT1ZLfdzzr0J0wM/JgYaxjNnwkwlQBaG8QfYIjszfVPK
         euSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LaKOqDhptLjaCqNuPU9LAcUmnWCUnenBrjS8YZMexSk=;
        b=nStACnICb9sAEQdJ8otGnwCJ7mWqhzuo5sNF3Xry5aUz8u6w9E4BeblP+o304G4x6n
         2N2Fu6xLcGDZoRc+jvjfzIXGF6n1fTSH3mOciFWf/dgc4+uY3NByNKfXE3J6h60vYNlj
         PI66eJ+KQsjDy2xJ+uK/ncY5hQsjkN9nt8sV+NqZWlHBNFEBILGUYbnkSuVtP+Q48Zcs
         wgVSEtR5TfoePRyv0bVGuryCit43KhahEOrUHhqn0kP0AZ74TrxCAY88mqvYUxwG8Aqp
         Q3BCcEnP0/3+OdsgGZ9fcYbDnU3UmuUQ0+UKIv0n/Npvxxf+IxtZxEG0MEXzWheheqRO
         kPNA==
X-Gm-Message-State: ANoB5pkL98qffI2ZwS9TbVGZ4eZqLmjn8JNVVBC+0NKgkRJjqdibBABn
        gne8cyHMXGvq9hp/CZRtfAW9XwCMylM=
X-Google-Smtp-Source: AA0mqf5537IgOeGKbjxC0iEvUS1kmsFjXJOBmW9YKz1cQ6CmNW6ctjhMp9EuWQPXKZkUvX2P+PTTiA==
X-Received: by 2002:adf:e68e:0:b0:236:c820:97d1 with SMTP id r14-20020adfe68e000000b00236c82097d1mr10297715wrm.201.1668516847424;
        Tue, 15 Nov 2022 04:54:07 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id bh9-20020a05600005c900b0022e36c1113fsm12630427wrb.13.2022.11.15.04.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 04:54:07 -0800 (PST)
Date:   Tue, 15 Nov 2022 15:54:03 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     jsmart2021@gmail.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [bug report] scsi: elx: libefc: SLI and FC PORT state machine
 interfaces
Message-ID: <Y3OL64Iacel/wmW9@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello James Smart,

The patch fcd427303eb9: "scsi: elx: libefc: SLI and FC PORT state
machine interfaces" from Jun 1, 2021, leads to the following Smatch
static checker warning:

	drivers/scsi/elx/libefc/efc_nport.c:710 efc_nport_vport_del()
	warn: 'nport' was already freed.

drivers/scsi/elx/libefc/efc_nport.c
    680 int
    681 efc_nport_vport_del(struct efc *efc, struct efc_domain *domain,
    682                     u64 wwpn, uint64_t wwnn)
    683 {
    684         struct efc_nport *nport;
    685         struct efc_vport *vport;
    686         struct efc_vport *next;
    687         unsigned long flags = 0;
    688 
    689         spin_lock_irqsave(&efc->vport_lock, flags);
    690         /* walk the efc_vport_list and remove from there */
    691         list_for_each_entry_safe(vport, next, &efc->vport_list, list_entry) {
    692                 if (vport->wwpn == wwpn && vport->wwnn == wwnn) {
    693                         list_del(&vport->list_entry);
    694                         kfree(vport);
    695                         break;
    696                 }
    697         }
    698         spin_unlock_irqrestore(&efc->vport_lock, flags);
    699 
    700         if (!domain) {
    701                 /* No domain means no nport to look for */
    702                 return 0;
    703         }
    704 
    705         spin_lock_irqsave(&efc->lock, flags);
    706         list_for_each_entry(nport, &domain->nport_list, list_entry) {
    707                 if (nport->wwpn == wwpn && nport->wwnn == wwnn) {
    708                         kref_put(&nport->ref, nport->release);
                                                      ^^^^^^^^^^^^^^
The release function can free "nport".

    709                         /* Shutdown this NPORT */
--> 710                         efc_sm_post_event(&nport->sm, EFC_EVT_SHUTDOWN, NULL);
                                                  ^^^^^^^^^^
Use after free.

    711                         break;
    712                 }
    713         }
    714 
    715         spin_unlock_irqrestore(&efc->lock, flags);
    716         return 0;
    717 }

regards,
dan carpenter
