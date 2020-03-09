Return-Path: <SRS0=qdS7=42=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30AE2C10F29
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Mar 2020 16:11:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F105224671
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Mar 2020 16:11:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gfBo7b1F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbgCIQLQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Mar 2020 12:11:16 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36629 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbgCIQLQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Mar 2020 12:11:16 -0400
Received: by mail-wm1-f65.google.com with SMTP id g62so1675wme.1;
        Mon, 09 Mar 2020 09:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=uWD6OmCc/Giz/7rKVyMfrzR5IhxZKcEZvTGrG7yLYLs=;
        b=gfBo7b1Ffo9O4U5qquVVpcT52aKU2dNihOMsEcGR/9alUJ+yXukzI49SQExLztLQOx
         ooo5hobvn2aVB9mvCknptB+IECv0XR18G3TKMF2cFnZH6+foWGfQZ6MsbnNawdEM7YtF
         MXAZdKvDstdVslGORA27sEf1UFYFryx9X48S2WqzpfPO4poQzLVTpVT3FbhVxw97NOv0
         YhgA0hkX1HbIgPBnpjD7AmCVIRFUp5pOzRI4WQTXltzJ9t5wjNHpUDirjWj14YXnCoGn
         tB4Kv3ovJbVuySgHeHEQaNgRoFyb7aeoBkxEn1ugLS1ya37rFlX//EdHGOzwEBh7FO/G
         uPPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=uWD6OmCc/Giz/7rKVyMfrzR5IhxZKcEZvTGrG7yLYLs=;
        b=WhPk5U+c3N44dwoTf+47cAEu3qvSuV3NUywf7lPTFkq0WJCsxe8Cn48ylCphLe+U9O
         v0wn3yoWGYCBeeX/0hChM3Q9aBozlNcir+0GjctfPFeyXPQblXNZSvupDgJmrOdVcy2K
         +uzbL5Vc0qylXvJI3siphk00xjuxHn/6BoCOTmRArdKJrm+34NxxQVXppe5w8pD8czZQ
         5smp7BmQj9Y2OPD+2FJOX4wRo5cQKmUG0zsTTUW3XnOoKkA2u5l8rj2rV56LIEEgVZ2H
         B5NXPD7dssPU0aIiOdmd4XO4QdEklO1hFa9SaI4E7p93ijRPFb/qPFLFVl4w4FQcUheW
         OUmg==
X-Gm-Message-State: ANhLgQ1FZ6QvfOguZ5p6UYWybbCNYC7jCSB6egGOaEvlD1KcttNGiJfV
        cZMdxJLQjGsxU7p4ppMJqGc=
X-Google-Smtp-Source: ADFU+vuw1Gn/gxv91C8ZwB+oVwi9gMsS2phal1+uxIjUXty+KwUa7GLLvqosl4RNPBebPvsCgW33Ug==
X-Received: by 2002:a7b:c944:: with SMTP id i4mr29675wml.77.1583770273978;
        Mon, 09 Mar 2020 09:11:13 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bee49.dynamic.kabel-deutschland.de. [95.91.238.73])
        by smtp.gmail.com with ESMTPSA id s14sm50104932wrv.44.2020.03.09.09.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 09:11:12 -0700 (PDT)
From:   huobean@gmail.com
X-Google-Original-From: beanhuo@micron.com
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/1] scsi: ufs: fix LRB pointer incorrect initialization issue
Date:   Mon,  9 Mar 2020 17:10:56 +0100
Message-Id: <20200309161057.9897-1-beanhuo@micron.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Hi, Martin and Bart

Based on the Bart's suggestion, delete ufshcd_init_lrb(), and update the patch
to v3. This version patch passed stress test.
Thanks,

//Bean

Bean Huo (1):
  scsi: ufs: fix LRB pointer incorrect initialization issue

 drivers/scsi/ufs/ufshcd.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

-- 
2.17.1

