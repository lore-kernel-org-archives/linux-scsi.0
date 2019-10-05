Return-Path: <SRS0=qHo0=X6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48E4DC3E8AB
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Oct 2019 07:44:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 163362133F
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Oct 2019 07:44:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rwi8lQdZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbfJEHof (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Oct 2019 03:44:35 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42174 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbfJEHof (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Oct 2019 03:44:35 -0400
Received: by mail-pf1-f194.google.com with SMTP id q12so5283649pff.9
        for <linux-scsi@vger.kernel.org>; Sat, 05 Oct 2019 00:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=sN9f19VIE1OPsvOKEMTP4zPFWWu7rjTp/bqAcExE/h0=;
        b=rwi8lQdZF/QvulqGtkGrbEtYAlzI+cLdTocOsd0S4AFdEAXbXvuhAl0/WxgWQBgE90
         Fs/xLFsDXbbEeYEoofFho2BrjE6s/8yd0M9EfpWnwafVo4NaP4Q/U5XFmRkiutY+AMVY
         6tuLcPitWs3iNfW9IJl2R1rw3TRKMBTGJ3xrzboX3PJT5MmOFLYkeRTX04BTuJoRdgfo
         Wpaq5Vidn1n65IEQ4dlfolx++RBClD9Vs3o8SiO/R0hXaURw73D5dcy/otFAaWOwyYui
         fLv3IQ1l+VUyF5IvRC+ff/6sgoeio3GEiJY4v9jX7WP+u81YcXHekXKuMk5BIrkBofY+
         QQdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=sN9f19VIE1OPsvOKEMTP4zPFWWu7rjTp/bqAcExE/h0=;
        b=VWeTFd8tnCley6HfVqxYMOXA5lpY68fJxIttFBQOzdvn8kIDwFJHcuswUeVIbQbw8q
         JuEBT5ThK9kjLs3utDDHH0ppz2g6NewiLAsET2F12ZrySOVIZ3udIT79srYG+JCYot24
         2cDX0/d2KpdzRWGtSDv86ggDtvKdL8AvtOPoPAg3WLvIT98XaCBveJlRJJ8WQqA+1+VE
         ZhLQqFNeezSEoysZOVl+UtLj1yEKexfB9FZOBhURYD024DvFtFwWi4bCne7tP+fAX0KR
         lxldAmKPp8l6jrT/gJhHKi6gt9qjlniuGp2KpfjYzdpk1reViS4/O2wQqmy8QAwL5eUx
         YPPg==
X-Gm-Message-State: APjAAAWgJLKScwWzrdXTeR0831W0/sZauCKfqRSz3swfRa1hO1hla7Xr
        JnfZeFEkSyjtlohih3sgbp4=
X-Google-Smtp-Source: APXvYqw6sZ5hH+W2lr2/QTClsn5/EgQ192xcnd5b/YQF1T+4f2xc9eq9jydZdLLpA6dBV4dG+6ULYw==
X-Received: by 2002:a63:e512:: with SMTP id r18mr19413837pgh.117.1570261474087;
        Sat, 05 Oct 2019 00:44:34 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1950:559a:117f:4889:e0ff:3af])
        by smtp.gmail.com with ESMTPSA id 127sm9184783pfw.6.2019.10.05.00.44.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Oct 2019 00:44:33 -0700 (PDT)
From:   aliasgar.surti500@gmail.com
To:     anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     Aliasgar Surti <aliasgar.surti500@gmail.com>
Subject: [PATCH] drivers:scsi:bfa: removed unnecessary semicolon
Date:   Sat,  5 Oct 2019 13:14:18 +0530
Message-Id: <20191005074418.17320-1-aliasgar.surti500@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Aliasgar Surti <aliasgar.surti500@gmail.com>

There is use of unneeded semicolon on multiple places in
single file. Removed the same.

Signed-off-by: Aliasgar Surti <aliasgar.surti500@gmail.com>
---
 drivers/scsi/bfa/bfa_fcs_rport.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_rport.c b/drivers/scsi/bfa/bfa_fcs_rport.c
index 82801b366500..fc294e1950a6 100644
--- a/drivers/scsi/bfa/bfa_fcs_rport.c
+++ b/drivers/scsi/bfa/bfa_fcs_rport.c
@@ -1575,7 +1575,7 @@ bfa_fcs_rport_sm_nsdisc_sent(struct bfa_fcs_rport_s *rport,
 			bfa_timer_start(rport->fcs->bfa, &rport->timer,
 					bfa_fcs_rport_timeout, rport,
 					bfa_fcs_rport_del_timeout);
-		};
+		}
 		break;
 
 	case RPSM_EVENT_DELETE:
@@ -2449,7 +2449,7 @@ bfa_fcs_rport_hal_online_action(struct bfa_fcs_rport_s *rport)
 		bfa_fcs_itnim_brp_online(rport->itnim);
 		if (!BFA_FCS_PID_IS_WKA(rport->pid))
 			bfa_fcs_rpf_rport_online(rport);
-	};
+	}
 
 	wwn2str(lpwwn_buf, bfa_fcs_lport_get_pwwn(port));
 	wwn2str(rpwwn_buf, rport->pwwn);
-- 
2.17.1

