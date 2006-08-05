From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] set proc_name in aic94xx
Date: Sat, 05 Aug 2006 14:48:54 -0700
Message-ID: <44D51246.10602@us.ibm.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:30164 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S932458AbWHEVs4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 Aug 2006 17:48:56 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k75LmuJA013393
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Sat, 5 Aug 2006 17:48:56 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k75LmtjY210888
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sat, 5 Aug 2006 15:48:56 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k75LmtEA017122
	for <linux-scsi@vger.kernel.org>; Sat, 5 Aug 2006 15:48:55 -0600
Received: from [9.49.128.162] (sig-9-49-128-162.mts.ibm.com [9.49.128.162])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k75LmtDK017119
	for <linux-scsi@vger.kernel.org>; Sat, 5 Aug 2006 15:48:55 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Hi,

Here's a patch to set proc_name in the aic94xx driver so that
/sys/class/scsi_host/*/proc_name displays something more
useful than "(NULL)".

--D

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 3ec2e46..3cd8553 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -63,6 +63,7 @@ static struct scsi_host_template aic94xx
        .module                 = THIS_MODULE,
        /* .name is initialized */
        .name                   = "aic94xx",
+       .proc_name              = "aic94xx",
        .queuecommand           = sas_queuecommand,
        .target_alloc           = sas_target_alloc,
        .slave_configure        = sas_slave_configure,

