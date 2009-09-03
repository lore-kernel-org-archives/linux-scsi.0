From: Michal Schmidt <mschmidt@redhat.com>
Subject: [PATCH] sg: fix oops in the error path in sg_build_indirect()
Date: Thu, 3 Sep 2009 14:27:08 +0200
Message-ID: <20090903142708.0b820ca1@leela>
References: <20090903033945.GA20755@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbZICMYZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Sep 2009 08:24:25 -0400
In-Reply-To: <20090903033945.GA20755@gherkin.frus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bob Tracy <rct@gherkin.frus.com>, linux-kernel@vger.kernel.org, stable@kernel.org

When the allocation fails in sg_build_indirect(), an oops happens in
the error path. It's caused by an obvious typo.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Reported-by: Bob Tracy <rct@gherkin.frus.com>
---

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 9230402..4968c4c 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1811,7 +1811,7 @@ retry:
 	return 0;
 out:
 	for (i = 0; i < k; i++)
-		__free_pages(schp->pages[k], order);
+		__free_pages(schp->pages[i], order);
 
 	if (--order >= 0)
 		goto retry;
