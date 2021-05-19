Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58412C43460
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 14:20:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 359FB6139A
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 14:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347203AbhESOWH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 May 2021 10:22:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38642 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241909AbhESOWG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 May 2021 10:22:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14JEFO1d101869;
        Wed, 19 May 2021 14:20:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2020-01-29; bh=NWXJTdpag0NA3Z5nBPPluFxqdVryRh9BEHtOH6qDsdw=;
 b=MZHROyt0Bb1+DBlsr2p1DXCUw8+PO3qHUFz5V9FIy2hSTU8BealhEaWVSdXQydQivnC7
 vtHvV8mqwP6M3mcvuIPoLEZ8Q/L1pfBQmOGkU8DyFhtWXhqzANRXLybIrHBSdfMmv101
 HERBOJdB7NgY8YOCwfSpHndzxMEyF1Tdf7f70WpAat5/xW097tQtZthD7OeHj+JoNxRp
 /+OiczBQShqrMUWi70if2HwnzFnLTJtFeahif20bUIAxrb54yLy+IYaVAQBLh71YmR6x
 Kdpp5xV/tS9OiwCRtgmuzaKZohKHiEcV1RxDaGUbqYCx9NuEdaDAzUSp0G0ZSpNRczN8 Kw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 38j6xnhp6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 14:20:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14JEEYMm026477;
        Wed, 19 May 2021 14:20:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 38n490r567-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 14:20:38 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 14JEKbKF038131;
        Wed, 19 May 2021 14:20:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 38n490r55y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 14:20:37 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 14JEKaX2006668;
        Wed, 19 May 2021 14:20:36 GMT
Received: from mwanda (/41.212.42.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 May 2021 14:20:35 +0000
Date:   Wed, 19 May 2021 17:20:27 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Jacek Danecki <jacek.danecki@intel.com>,
        James Bottomley <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: libsas: use _safe() loop in sas_resume_port()
Message-ID: <YKUeq6gwfGcvvhty@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210518082855.GB32682@kadam>
X-Mailer: git-send-email haha only kidding
X-Proofpoint-GUID: eiWzx_JHoZsIUKMcKgdqTGrepn9ltPPr
X-Proofpoint-ORIG-GUID: eiWzx_JHoZsIUKMcKgdqTGrepn9ltPPr
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9988 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 priorityscore=1501
 phishscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1011
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105190089
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If sas_notify_lldd_dev_found() fails then this code calls:

	sas_unregister_dev(port, dev);

which removes "dev", our list iterator, from the list.  This could
lead to an endless loop.  We need to use list_for_each_entry_safe().

Fixes: 303694eeee5e ("[SCSI] libsas: suspend / resume support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/libsas/sas_port.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index 19cf418928fa..e3d03d744713 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -25,7 +25,7 @@ static bool phy_is_wideport_member(struct asd_sas_port *port, struct asd_sas_phy
 
 static void sas_resume_port(struct asd_sas_phy *phy)
 {
-	struct domain_device *dev;
+	struct domain_device *dev, *n;
 	struct asd_sas_port *port = phy->port;
 	struct sas_ha_struct *sas_ha = phy->ha;
 	struct sas_internal *si = to_sas_internal(sas_ha->core.shost->transportt);
@@ -44,7 +44,7 @@ static void sas_resume_port(struct asd_sas_phy *phy)
 	 * 1/ presume every device came back
 	 * 2/ force the next revalidation to check all expander phys
 	 */
-	list_for_each_entry(dev, &port->dev_list, dev_list_node) {
+	list_for_each_entry_safe(dev, n, &port->dev_list, dev_list_node) {
 		int i, rc;
 
 		rc = sas_notify_lldd_dev_found(dev);
-- 
2.30.2

