From: Ashutosh Naik <ashutosh.naik@gmail.com>
Subject: [PATCH 2/2] scsi/pcmcia/nsp_cs.c: Handle scsi_add_host failure
Date: Wed, 11 Jan 2006 15:10:38 +0530
Message-ID: <81083a450601110140h797245edl33620650376605a7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_15348_4083555.1136972438649"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.193]:44250 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1751411AbWAKJkj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jan 2006 04:40:39 -0500
Received: by zproxy.gmail.com with SMTP id 14so117517nzn
        for <linux-scsi@vger.kernel.org>; Wed, 11 Jan 2006 01:40:38 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: yokota@netlab.is.tsukuba.ac.jp, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>, James.Bottomley@steeleye.com

------=_Part_15348_4083555.1136972438649
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Add scsi_add_host() failure handling for the NinjaSCSI-3 /
NinjaSCSI-32Bi PCMCIA SCSI host adapter card driver

Signed-off-by: Ashutosh Naik <ashutosh.naik@gmail.com>

------=_Part_15348_4083555.1136972438649
Content-Type: text/plain; name=nsp_cs.txt; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="nsp_cs.txt"

diff -Naurp linux-2.6.15-git6-vanilla/drivers/scsi/pcmcia/nsp_cs.c linux-2.6.15-git6/drivers/scsi/pcmcia/nsp_cs.c
--- linux-2.6.15-git6-vanilla/drivers/scsi/pcmcia/nsp_cs.c	2006-01-11 12:56:56.000000000 +0530
+++ linux-2.6.15-git6/drivers/scsi/pcmcia/nsp_cs.c	2006-01-11 12:51:34.000000000 +0530
@@ -1678,7 +1678,7 @@ static void nsp_cs_config(dev_link_t *li
 	scsi_info_t	 *info	 = link->priv;
 	tuple_t		  tuple;
 	cisparse_t	  parse;
-	int		  last_ret, last_fn;
+	int		  last_ret, last_fn, retval;
 	unsigned char	  tuple_data[64];
 	config_info_t	  conf;
 	win_req_t         req;
@@ -1854,7 +1854,13 @@ static void nsp_cs_config(dev_link_t *li
 
 
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,74))
-	scsi_add_host (host, NULL);
+	retval = scsi_add_host (host, NULL);
+	if (retval) {
+		printk(KERN_WARNING "nsp_cs: scsi_add_host failed\n");
+		scsi_host_put(host);
+		return retval;
+	}
+
 	scsi_scan_host(host);
 
 	snprintf(info->node.dev_name, sizeof(info->node.dev_name), "scsi%d", host->host_no);

------=_Part_15348_4083555.1136972438649--
