From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 3/4] aic94xx: cleanup after a discovery error
Date: Fri, 10 Nov 2006 16:45:47 -0800
Message-ID: <45551D3B.7070007@us.ibm.com>
References: <1163102636.6521.19.camel@localhost.localdomain>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:62096 "EHLO
	e36.co.us.ibm.com") by vger.kernel.org with ESMTP id S1424467AbWKKApt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Nov 2006 19:45:49 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id kAB0jnBY026095
	for <linux-scsi@vger.kernel.org>; Fri, 10 Nov 2006 19:45:49 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kAB0jmKG332708
	for <linux-scsi@vger.kernel.org>; Fri, 10 Nov 2006 17:45:48 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kAB0jmOE021859
	for <linux-scsi@vger.kernel.org>; Fri, 10 Nov 2006 17:45:48 -0700
In-Reply-To: <1163102636.6521.19.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Alexis Bruemmer <alexisb@us.ibm.com>

Alexis Bruemmer wrote:

> Domain device is freed but the port dev list is not adjusted on some
> discovery errors. Module unload will Oops if this happens.

It'll still oops; sas_ex_discover_end_dev needs to be updated to know
that it needn't call sas_rphy_free if the device-specific discovery
functions fail.  This patch should fix that case too.

--

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 4cc7457..a38d05b 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -711,7 +711,6 @@ static struct domain_device *sas_ex_disc
 
  out_list_del:
 	list_del(&child->dev_list_node);
-	sas_rphy_free(rphy);
  out_free:
 	sas_port_delete(phy->port);
  out_err:
