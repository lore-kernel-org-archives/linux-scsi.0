From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 03/14] target/sbc: Add sbc_check_prot + update sbc_parse_cdb for DIF
Date: Fri, 10 Jan 2014 15:30:08 -0500
Message-ID: <yq14n5bshpr.fsf@sermon.lab.mkp.net>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
	<1389212157-14540-4-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1389212157-14540-4-git-send-email-nab@daterainc.com> (Nicholas
	A. Bellinger's message of "Wed, 8 Jan 2014 20:15:46 +0000")
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "nab" == Nicholas A Bellinger <nab@daterainc.com> writes:

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 52ae54e..600ffcb 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -563,6 +563,27 @@ sbc_compare_and_write(struct se_cmd *cmd)
 	return TCM_NO_SENSE;
 }
 
+bool
+sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb)
+{
+	if (!dev->dev_attrib.pi_prot_type)
+		return true;
+
+	if (dev->dev_attrib.pi_prot_type == TARGET_DIF_TYPE2_PROT &&
+	   (cdb[1] & 0xe0))
+		return false;
+
+	if (!(cdb[1] & 0xe0)) {
+		pr_warn("Target: Unprotected READ/WRITE to DIF device\n");
+		return true;
+	}

You may want to remove this warning. I left it in scsi_debug upstream
for the convenience of tinkerers but quiesce it in my own tree.

-- 
Martin K. Petersen	Oracle Linux Engineering
