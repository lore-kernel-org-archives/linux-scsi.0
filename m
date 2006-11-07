From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH] cleanup after a discovery error
Date: Tue, 07 Nov 2006 12:01:19 -0800
Message-ID: <4550E60F.2000901@us.ibm.com>
References: <20061019031910.GA16855@us.ibm.com> <1161284938.11219.22.camel@mulgrave.il.steeleye.com> <20061030202302.GA22870@us.ibm.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:62898 "EHLO
	e36.co.us.ibm.com") by vger.kernel.org with ESMTP id S1753036AbWKGUBV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Nov 2006 15:01:21 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id kA7K1KOg027574
	for <linux-scsi@vger.kernel.org>; Tue, 7 Nov 2006 15:01:20 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kA7K1Kb9359252
	for <linux-scsi@vger.kernel.org>; Tue, 7 Nov 2006 13:01:20 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kA7K1Km7018952
	for <linux-scsi@vger.kernel.org>; Tue, 7 Nov 2006 13:01:20 -0700
In-Reply-To: <20061030202302.GA22870@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

> James Bottomley [James.Bottomley@SteelEye.com] wrote:
>> This is a bit of a layering violation
>>
>> if the various discover functions are going to return an error, I think
>> it's their job to clean up whatever they did before returning.

Here's a reworked version of Malahal's patch that pushes the sas_rphy
cleanups into the sas_discover_{sas,sata,expander}.* functions.  It also
checks the return value of sas_notify_lldd_dev_found().  This patch
(since it includes discovery error cleanup for SATA) is against
2.6.19-rc4 + scsi-misc + scsi-rc-fixes + aic94xx-sas, though I can
respin it without the SATA bits if desired.

--

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 23461dc..0f790ea 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -564,12 +564,25 @@ int sas_discover_sata(struct domain_devi
 	default:
 		break;
 	}
+	if (res)
+		goto out_err;
 
 	sas_notify_lldd_dev_gone(dev);
-	if (!res) {
-		sas_notify_lldd_dev_found(dev);
-		res = sas_rphy_add(dev->rphy);
-	}
+	res = sas_notify_lldd_dev_found(dev);
+	if (res)
+		goto out_err2;
+
+	res = sas_rphy_add(dev->rphy);
+	if (res)
+		goto out_err;
+
+	return res;
+
+out_err:
+	sas_notify_lldd_dev_gone(dev);
+out_err2:
+	sas_rphy_free(dev->rphy);
+	dev->rphy = NULL;
 	return res;
 }
 
@@ -594,12 +607,20 @@ int sas_discover_end_dev(struct domain_d
 	/* do this to get the end device port attributes which will have
 	 * been scanned in sas_rphy_add */
 	sas_notify_lldd_dev_gone(dev);
-	sas_notify_lldd_dev_found(dev);
+	res = sas_notify_lldd_dev_found(dev);
+	if (res)
+		goto out_err2;
 
 	return 0;
 
 out_err:
 	sas_notify_lldd_dev_gone(dev);
+	sas_rphy_free(dev->rphy);
+	dev->rphy = NULL;
+	return res;
+out_err2:
+	sas_rphy_delete(dev->rphy);
+	dev->rphy = NULL;
 	return res;
 }
 
@@ -689,6 +710,10 @@ static void sas_discover_domain(void *da
 	}
 
 	if (error) {
+		spin_lock(&port->dev_list_lock);
+		list_del_init(&port->port_dev->dev_list_node);
+		spin_unlock(&port->dev_list_lock);
+
 		kfree(port->port_dev); /* not kobject_register-ed yet */
 		port->port_dev = NULL;
 	}
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 4cc7457..a79e89c 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1474,14 +1474,27 @@ int sas_discover_root_expander(struct do
 	int res;
 	struct sas_expander_device *ex = rphy_to_expander_device(dev->rphy);
 
-	sas_rphy_add(dev->rphy);
+	res = sas_rphy_add(dev->rphy);
+	if (res)
+		goto out_err;
 
 	ex->level = dev->port->disc.max_level; /* 0 */
 	res = sas_discover_expander(dev);
-	if (!res)
-		sas_ex_bfs_disc(dev->port);
+	if (res)
+		goto out_err2;
+
+	sas_ex_bfs_disc(dev->port);
 
 	return res;
+
+out_err2:
+	sas_rphy_delete(dev->rphy);
+	dev->rphy = NULL;
+	return res;
+out_err:
+	sas_rphy_free(dev->rphy);
+	dev->rphy = NULL;
+	return res;
 }
 
 /* ---------- Domain revalidation ---------- */
