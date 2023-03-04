Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55CD7C61DA3
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:32:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbjCDAcx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:32:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjCDAci (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:32:38 -0500
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE4F6513D
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:32:36 -0800 (PST)
Received: by mail-pj1-f51.google.com with SMTP id qa18-20020a17090b4fd200b0023750b675f5so7855928pjb.3
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:32:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889956;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c47+d0pz7DNihHgR0GI5I+QfVkFleIpC/pj+/6FjG7w=;
        b=7nV9MBYxFnN4vK8SaQayEo65NN+oGREPsCQ1mMEi0PNyVt/VLScSmSBcqUvdE3YlEj
         6J4nTwMt9PIrJT0WunqbeM53N0LgPqRy3yTM82fquk1vr+CTdSB7VzqBtwhZaNlyHr0R
         zDzE5vAoPpJiWgGmdsA7/mNXA0Vznaja88BvE5oa8UNNemXoicFVsGxs8Ad3zvHpyQmb
         +zmOLmji5PQrcCvl5ji5N8gqjpn1EUHt6U0po7VNrDZqv6fOnFgf6jR1dcPHI00daEWH
         nUBw2IkWOqx+CO+ZXSe7T+MDPfOyxcIxrmDaVttfidjlNZc6kSNKXtKu90qQKS6sdSHL
         8EEQ==
X-Gm-Message-State: AO0yUKXfXHXZbIhhslx2l1FqmksKalrHvftD6HzQlniimkT0KRJ4defY
        Vy0xwKwXu5nrtgfn2ZRbIWU=
X-Google-Smtp-Source: AK7set+Ds0k+T/J71TynPssUX1fj8wdKzMQBhXv3FsMjEca96lIDBLsQ+t9vEGuEGbZj0zB3d6Bt2w==
X-Received: by 2002:a17:902:d4cf:b0:19c:eb9a:7712 with SMTP id o15-20020a170902d4cf00b0019ceb9a7712mr5044556plg.1.1677889955862;
        Fri, 03 Mar 2023 16:32:35 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.32.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:32:34 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Finn Thain <fthain@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 25/81] scsi: cumana: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:07 -0800
Message-Id: <20230304003103.2572793-26-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230304003103.2572793-1-bvanassche@acm.org>
References: <20230304003103.2572793-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/arm/cumana_1.c | 2 +-
 drivers/scsi/arm/cumana_2.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/arm/cumana_1.c b/drivers/scsi/arm/cumana_1.c
index 5d4f67ba74c0..d1a2a22ffe8c 100644
--- a/drivers/scsi/arm/cumana_1.c
+++ b/drivers/scsi/arm/cumana_1.c
@@ -211,7 +211,7 @@ static void cumanascsi_write(struct NCR5380_hostdata *hostdata,
 
 #include "../NCR5380.c"
 
-static struct scsi_host_template cumanascsi_template = {
+static const struct scsi_host_template cumanascsi_template = {
 	.module			= THIS_MODULE,
 	.name			= "Cumana 16-bit SCSI",
 	.info			= cumanascsi_info,
diff --git a/drivers/scsi/arm/cumana_2.c b/drivers/scsi/arm/cumana_2.c
index d15053f02472..c5d8f4313b31 100644
--- a/drivers/scsi/arm/cumana_2.c
+++ b/drivers/scsi/arm/cumana_2.c
@@ -356,7 +356,7 @@ static int cumanascsi_2_show_info(struct seq_file *m, struct Scsi_Host *host)
 	return 0;
 }
 
-static struct scsi_host_template cumanascsi2_template = {
+static const struct scsi_host_template cumanascsi2_template = {
 	.module				= THIS_MODULE,
 	.show_info			= cumanascsi_2_show_info,
 	.write_info			= cumanascsi_2_set_proc_info,
