Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08756C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 21:26:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF0A322D6E
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 21:26:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394607AbhARV0y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 16:26:54 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54900 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389173AbhARKLJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 05:11:09 -0500
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610964605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zi87JU1wtYK7u/9EdBeQmfwuSvWpL6Dl6md8k/4q3TA=;
        b=vmmHzRErECNDY4i8p0Uw2lqTGSxAzYWkTqg8U/HTNsEkGRDsPM6ORRmQBUBt4rbPg0b9ap
        hrKvpr6n9ciCKpwZ/SmSorh76TqxmXnRS3wS/8adasC5vQzs5RgZeQg6IiwyOHKD3Pz8LO
        aREoYZ1hFodaFCqtaGd5nJxOxzeyhf0MbaAAOUDlcX+vQf6jzDU4wwg89S0o7eQ6j9Ft8h
        xkvz8Bt66ymeTys7kkVIceza7e2/HSDKAuZDW5gLEAUSvwh4KkPVvekGEYqi1S8B+wbijB
        bqxBBOMBcSNsdBvHagkrit8fs4L0meLz+w2BqRbzZ/sBHkVLMPeVmMgBr4zMwg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610964605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zi87JU1wtYK7u/9EdBeQmfwuSvWpL6Dl6md8k/4q3TA=;
        b=TqGab2doXTK6ZVTCop+70ObWN/mZW7jLhxlq0+eklJvJ5OUHqE+rRZPJU78FC9ZtHZMOOP
        N/OEVOE5UgcpEgAQ==
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        John Garry <john.garry@huawei.com>,
        Jason Yan <yanaijie@huawei.com>,
        Daniel Wagner <dwagner@suse.de>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Cc:     linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
Subject: [PATCH v3 01/19] Documentation: scsi: libsas: Remove notify_ha_event()
Date:   Mon, 18 Jan 2021 11:09:37 +0100
Message-Id: <20210118100955.1761652-2-a.darwish@linutronix.de>
In-Reply-To: <20210118100955.1761652-1-a.darwish@linutronix.de>
References: <20210118100955.1761652-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The ->notify_ha_event() hook has long been removed from the libsas event
interface.

Remove it from documentation.

Fixes: 042ebd293b86 ("scsi: libsas: kill useless ha_event and do some cleanup")
Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Reviewed-by: John Garry <john.garry@huawei.com>
Cc: stable@vger.kernel.org
---
 Documentation/scsi/libsas.rst | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/scsi/libsas.rst b/Documentation/scsi/libsas.rst
index 7216b5d25800..f9b77c7879db 100644
--- a/Documentation/scsi/libsas.rst
+++ b/Documentation/scsi/libsas.rst
@@ -189,7 +189,6 @@ num_phys
 The event interface::
 
 	/* LLDD calls these to notify the class of an event. */
-	void (*notify_ha_event)(struct sas_ha_struct *, enum ha_event);
 	void (*notify_port_event)(struct sas_phy *, enum port_event);
 	void (*notify_phy_event)(struct sas_phy *, enum phy_event);
 
-- 
2.30.0

