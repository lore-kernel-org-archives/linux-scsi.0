From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] scsi/ibmvscsi: /sys/class/scsi_host/hostX/config
 doesn't show any information
Date: Mon, 30 Jul 2012 11:33:05 +1000
Message-ID: <1343611985.21647.25.camel@pasglop>
References: <1342630157-16468-1-git-send-email-olaf@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:51523 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377Ab2G3BdS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jul 2012 21:33:18 -0400
In-Reply-To: <1342630157-16468-1-git-send-email-olaf@aepfle.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian J King <bjking1@us.ibm.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org, Linda Xie <lxiep@us.ibm.com>, olaf@aepfle.de

n Wed, 2012-07-18 at 18:49 +0200, olaf@aepfle.de wrote:
> From: Linda Xie <lxiep@us.ibm.com>
> 
> Expected result:
> It should show something like this:
> x1521p4:~ # cat /sys/class/scsi_host/host1/config
> PARTITIONNAME='x1521p4'
> NWSDNAME='X1521P4'
> HOSTNAME='X1521P4'
> DOMAINNAME='RCHLAND.IBM.COM'
> NAMESERVERS='9.10.244.100 9.10.244.200'
> 
> Actual result:
> x1521p4:~ # cat /sys/class/scsi_host/host0/config
> x1521p4:~ #
> 
> This patch changes the size of the buffer used for transfering config
> data to 4K. It was tested against 2.6.19-rc2 tree.
> 
> Reported by IBM during SLES11 beta testing:

So this patch just seems to blindly replace all occurrences of PAGE_SIZE
with HOST_PAGE_SIZE which is utterly wrong. Only one of those needs to
be changed, the one passed to ibmvscsi_do_host_config() which is what's
visible to the server, all the rest is just sysfs attributes and should
remain as-is.

Additionally (not even mentioning that there is no explanation as to
what the real problem is anywhere in the changeset) I don't like the
fix. The root of the problem is that the MAD header has a 16-bit length
field, so writing 0x10000 (64K PAGE_SIZE) into it doesn't quite work.

So in addition to a better comment, I would suggest a fix more like
this:

scsi/ibmvscsi: Fix host config length field overflow

The length field in the host config packet is only 16-bit long, so
passing it 0x10000 (64K which is our standard PAGE_SIZE) doesn't
work and result in an empty config from the server.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: <stable@vger.kernel.org>
---

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 3a6c474..337e8b3 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1541,6 +1541,9 @@ static int ibmvscsi_do_host_config(struct ibmvscsi_host_data *hostdata,
 
 	host_config = &evt_struct->iu.mad.host_config;
 
+	/* The transport length field is only 16-bit */
+	length = min(0xffff, length);
+
 	/* Set up a lun reset SRP command */
 	memset(host_config, 0x00, sizeof(*host_config));
 	host_config->common.type = VIOSRP_HOST_CONFIG_TYPE;


