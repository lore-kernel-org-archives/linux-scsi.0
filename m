Return-Path: <SRS0=+pba=Z2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ABA4C432C3
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Dec 2019 01:15:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56D5B2084B
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Dec 2019 01:15:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JebIPV0x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfLDBPW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Dec 2019 20:15:22 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:43563 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfLDBPW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Dec 2019 20:15:22 -0500
Received: by mail-ed1-f66.google.com with SMTP id dc19so5033364edb.10;
        Tue, 03 Dec 2019 17:15:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=P+xBtopGdP1dSzHo89gd0Zoc0rvDJiQE61AIzpf0nJY=;
        b=JebIPV0xPPySJ5+jYeEiElhyebM5r2fPErOwLHBM5aDMcdDV6sTyxdotzqeibGW33X
         7HYYz/LMY+fqxktAISZM20qFRKKyRgmyKT4WZl6jM1DH2Smgi3AsMgtJnMZhR9MBg/Rc
         itr0mVjWhEhaPq6AIsojPtuMOALWYlYKii+766fIKogRVa7BYBr/YACMNafDOpE7Esto
         XmuQ6fbRIIW/ioyMkG09KNExnNW7lfeP7rJlo9dQ8HaTi1257UUkKHzI5yEzXQ+7BzN+
         jbbQarYufvZIwW2EIuKPcUlukM1+BJu8KPD22AEGbC6hhtfY4732eWsVCuRW6A7LA8MN
         nqZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=P+xBtopGdP1dSzHo89gd0Zoc0rvDJiQE61AIzpf0nJY=;
        b=kyzP3SCORfJvWtsMAgi6mjLGndYYpQiR3j7aZKZ2/quejtAOxweQnQuR7dJzak4Zkk
         LXhTTdvf9ygMZQty7bZ71AsWfeewsv16jzzugHECg925cgUDoPvuZ4gser/H/yFjdiWR
         UBarWIAPIGz74pnN2ashATbNK79ajGOGGB7XQWKmWFzldJiwncoeA1aLnKhHq/D2Q9Pq
         cwKDFCS7ioJuMSzbYSwwri5GuyoGV+E5M3cPRcRkOg7V6gOHJ2lQVUWYXMpySiIda6iW
         y6zkm1VPDHdpvKdtPL4CeucVYl/AtBrt+dlxFgUAzDUIAIVvfJB8wsecnChxLR2Lqxcv
         ZZEw==
X-Gm-Message-State: APjAAAVqPQxgNFJu7KGmqY/zDPGydtqSV9tUf1TS6aRcoHskfzdL4Ul/
        tzFhm/QlIRfbRxQvqyNAX+4=
X-Google-Smtp-Source: APXvYqzYrrFNybJW26FdDBTT3r5uTzXOs1q4mSmADxSFM4Z/OkIxlV6PNaIs+z0a6G86sEAKcLCpTw==
X-Received: by 2002:a17:906:eb8b:: with SMTP id mh11mr357595ejb.72.1575422120368;
        Tue, 03 Dec 2019 17:15:20 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfdc6.dynamic.kabel-deutschland.de. [95.91.253.198])
        by smtp.gmail.com with ESMTPSA id b20sm46053ejb.22.2019.12.03.17.15.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 17:15:19 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        pedrom.sousa@synopsys.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] scsi: ufs: delete unused structure filed tc
Date:   Wed,  4 Dec 2019 02:15:07 +0100
Message-Id: <20191204011507.4662-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Delete unused structure field tc in structure utp_upiu_req, since no person
uses it for task management.

Fixes: df032bf27a41 ("scsi: ufs: Add a bsg endpoint that supports UPIUs")
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 include/uapi/scsi/scsi_bsg_ufs.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/uapi/scsi/scsi_bsg_ufs.h b/include/uapi/scsi/scsi_bsg_ufs.h
index 9988db6ad244..d55f2176dfd4 100644
--- a/include/uapi/scsi/scsi_bsg_ufs.h
+++ b/include/uapi/scsi/scsi_bsg_ufs.h
@@ -68,14 +68,13 @@ struct utp_upiu_cmd {
  * @header:UPIU header structure DW-0 to DW-2
  * @sc: fields structure for scsi command DW-3 to DW-7
  * @qr: fields structure for query request DW-3 to DW-7
+ * @uc: use utp_upiu_query to host the 4 dwords of uic command
  */
 struct utp_upiu_req {
 	struct utp_upiu_header header;
 	union {
 		struct utp_upiu_cmd		sc;
 		struct utp_upiu_query		qr;
-		struct utp_upiu_query		tr;
-		/* use utp_upiu_query to host the 4 dwords of uic command */
 		struct utp_upiu_query		uc;
 	};
 };
-- 
2.17.1

