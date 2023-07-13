Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCD22C0015E
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Jul 2023 06:46:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234087AbjGMGqC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Jul 2023 02:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234094AbjGMGp7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jul 2023 02:45:59 -0400
Received: from mail.208.org (unknown [183.242.55.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20B7173B
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 23:45:55 -0700 (PDT)
Received: from mail.208.org (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTP id 4R1lVl2svqzBR7bn
        for <linux-scsi@vger.kernel.org>; Thu, 13 Jul 2023 14:45:51 +0800 (CST)
Authentication-Results: mail.208.org (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)" header.d=208.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=208.org; h=
        content-transfer-encoding:content-type:message-id:user-agent
        :references:in-reply-to:subject:to:from:date:mime-version; s=
        dkim; t=1689230751; x=1691822752; bh=4vUhvqonTqUpI5VbubYfWLeGs5u
        ghPwDkkTzJRLbAdQ=; b=E674rs50jBc9lPAr2jyaZcpkrhfgYOJ8W4vXCqr9kS5
        eU1ca6cjWZf0GBCZfy+4ubmoZhWoza6QihtIIEV3YWGzjFvR7EXzR5zbYu6h4gcu
        IySrWI+NRJ3j9zVoqQsHhfhSI1I70IFdU4DJNT1tPtgn23Xr/1aEil8r7tvaWw+M
        rplMpG3VSzuXHaetKC5mDe70CJDHgrXEH6ogBVoF1tv7kzuQWmORJfTCRvS7ru99
        5/jeoWH7n3ZksyNueMfpNeuZRZECadKRxOEStTddYILRt88g/Ko9n/no1ccGdzYQ
        JSXkWGojTEwUaijN6j4CROG/I7pFrzeQCPBJmMn3Klw==
X-Virus-Scanned: amavisd-new at mail.208.org
Received: from mail.208.org ([127.0.0.1])
        by mail.208.org (mail.208.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 2tfBcfRDJOXA for <linux-scsi@vger.kernel.org>;
        Thu, 13 Jul 2023 14:45:51 +0800 (CST)
Received: from localhost (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTPSA id 4R1lVl0WprzBJDhy;
        Thu, 13 Jul 2023 14:45:51 +0800 (CST)
MIME-Version: 1.0
Date:   Thu, 13 Jul 2023 14:45:50 +0800
From:   hanyu001@208suo.com
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Fwd: [PATCH] scsi: isci:  Convert snprintf() to sysfs_emit()
In-Reply-To: <tencent_9AA2345A885AECF32201BDEABACAB9F12707@qq.com>
References: <tencent_9AA2345A885AECF32201BDEABACAB9F12707@qq.com>
User-Agent: Roundcube Webmail
Message-ID: <9983c57b3af01ba23f482c680ad82698@208suo.com>
X-Sender: hanyu001@208suo.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Coccinnelle reports a warning
Warning: Use scnprintf or sprintf

WARNING: use scnprintf or sprintf
Signed-off-by: ztt <1549089851@qq.com>
---
  drivers/scsi/isci/init.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index ac1e04b86d8f..5ce24fc7f940 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -137,7 +137,7 @@ static ssize_t isci_show_id(struct device *dev, 
struct device_attribute *attr, c
      struct sas_ha_struct *sas_ha = SHOST_TO_SAS_HA(shost);
      struct isci_host *ihost = container_of(sas_ha, typeof(*ihost), 
sas_ha);

-    return snprintf(buf, PAGE_SIZE, "%d\n", ihost->id);
+    return scnprintf(buf, PAGE_SIZE, "%d\n", ihost->id);
  }

  static DEVICE_ATTR(isci_id, S_IRUGO, isci_show_id, NULL);
