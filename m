From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] ses: use scsi_is_sas_rphy instead of is_sas_attached
Date: Mon, 15 Aug 2016 07:25:53 -0700
Message-ID: <1471271153.2428.5.camel@linux.vnet.ibm.com>
References: <201608152258.TcR75AwO%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201608152258.TcR75AwO%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kbuild test robot <lkp@intel.com>, Johannes Thumshirn <jthumshirn@suse.de>
Cc: kbuild-all@01.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, stable@vger.kernel.org, #@suse.de, v4.5+@suse.de
List-Id: linux-scsi@vger.kernel.org

On Mon, 2016-08-15 at 22:11 +0800, kbuild test robot wrote:
> Hi Johannes,
> 
> [auto build test ERROR on scsi/for-next]
> [also build test ERROR on v4.8-rc2 next-20160815]
> [if your patch is applied to the wrong git tree, please drop us a 
> note to help improve the system]

This is happening because scsi_is_sas_rphy wasn't designed to be used
outside the SAS transport class, so it's failing when the ATTRs aren't
defined.

This is the way you fix it (needs to be a precursor patch to 1/2):

James

---

diff --git a/include/scsi/scsi_transport_sas.h b/include/scsi/scsi_transport_sas.h
index 13c0b2b..0e1c50e 100644
--- a/include/scsi/scsi_transport_sas.h
+++ b/include/scsi/scsi_transport_sas.h
@@ -15,8 +15,13 @@ static inline int is_sas_attached(struct scsi_device *sdev)
 {
 	return 0;
 }
+static inline int scsi_is_sas_rphy(const struct device *)
+{
+	return 0;
+}
 #else
 extern int is_sas_attached(struct scsi_device *sdev);
+extern int scsi_is_sas_rphy(const struct device *);
 #endif
 
 static inline int sas_protocol_ata(enum sas_protocol proto)
@@ -202,7 +207,6 @@ extern int sas_rphy_add(struct sas_rphy *);
 extern void sas_rphy_remove(struct sas_rphy *);
 extern void sas_rphy_delete(struct sas_rphy *);
 extern void sas_rphy_unlink(struct sas_rphy *);
-extern int scsi_is_sas_rphy(const struct device *);
 
 struct sas_port *sas_port_alloc(struct device *, int);
 struct sas_port *sas_port_alloc_num(struct device *);
