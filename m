From: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v7 1/8] mpt3sas: Added new #define variable IOC_OPERATIONAL_WAIT_COUNT
Date: Wed, 31 Oct 2018 18:53:32 +0530
Message-ID: <1540992219-20291-2-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1540992219-20291-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1540992219-20291-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, Suganath Prabu <suganath-prabu.subramani@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Added new #define variable IOC_OPERATIONAL_WAIT_COUNT and
it replaces hard coded value '10' in all the places where driver is
waiting for the IOC to become operational.

Signed-off-by: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c      | 4 ++--
 drivers/scsi/mpt3sas/mpt3sas_base.h      | 3 +++
 drivers/scsi/mpt3sas/mpt3sas_ctl.c       | 2 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 8 ++++----
 4 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 2500377..f6c7afa 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5230,7 +5230,7 @@ mpt3sas_base_sas_iounit_control(struct MPT3SAS_ADAPTER *ioc,
 	wait_state_count = 0;
 	ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
 	while (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
-		if (wait_state_count++ == 10) {
+		if (wait_state_count++ == IOC_OPERATIONAL_WAIT_COUNT) {
 			ioc_err(ioc, "%s: failed due to ioc not operational\n",
 				__func__);
 			rc = -EFAULT;
@@ -5325,7 +5325,7 @@ mpt3sas_base_scsi_enclosure_processor(struct MPT3SAS_ADAPTER *ioc,
 	wait_state_count = 0;
 	ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
 	while (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
-		if (wait_state_count++ == 10) {
+		if (wait_state_count++ == IOC_OPERATIONAL_WAIT_COUNT) {
 			ioc_err(ioc, "%s: failed due to ioc not operational\n",
 				__func__);
 			rc = -EFAULT;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 8f1d6b0..3ce8785 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -139,6 +139,9 @@
 #define DEFAULT_NUM_FWCHAIN_ELEMTS	8
 
 #define FW_IMG_HDR_READ_TIMEOUT	15
+
+#define IOC_OPERATIONAL_WAIT_COUNT	10
+
 /*
  * NVMe defines
  */
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 4afa597..a285e95 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -669,7 +669,7 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 	wait_state_count = 0;
 	ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
 	while (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
-		if (wait_state_count++ == 10) {
+		if (wait_state_count++ == IOC_OPERATIONAL_WAIT_COUNT) {
 			ioc_err(ioc, "%s: failed due to ioc not operational\n",
 				__func__);
 			ret = -EFAULT;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 6a8a3c0..f446c05 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -323,7 +323,7 @@ _transport_expander_report_manufacture(struct MPT3SAS_ADAPTER *ioc,
 	wait_state_count = 0;
 	ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
 	while (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
-		if (wait_state_count++ == 10) {
+		if (wait_state_count++ == IOC_OPERATIONAL_WAIT_COUNT) {
 			ioc_err(ioc, "%s: failed due to ioc not operational\n",
 				__func__);
 			rc = -EFAULT;
@@ -1101,7 +1101,7 @@ _transport_get_expander_phy_error_log(struct MPT3SAS_ADAPTER *ioc,
 	wait_state_count = 0;
 	ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
 	while (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
-		if (wait_state_count++ == 10) {
+		if (wait_state_count++ == IOC_OPERATIONAL_WAIT_COUNT) {
 			ioc_err(ioc, "%s: failed due to ioc not operational\n",
 				__func__);
 			rc = -EFAULT;
@@ -1406,7 +1406,7 @@ _transport_expander_phy_control(struct MPT3SAS_ADAPTER *ioc,
 	wait_state_count = 0;
 	ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
 	while (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
-		if (wait_state_count++ == 10) {
+		if (wait_state_count++ == IOC_OPERATIONAL_WAIT_COUNT) {
 			ioc_err(ioc, "%s: failed due to ioc not operational\n",
 				__func__);
 			rc = -EFAULT;
@@ -1927,7 +1927,7 @@ _transport_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
 	wait_state_count = 0;
 	ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
 	while (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
-		if (wait_state_count++ == 10) {
+		if (wait_state_count++ == IOC_OPERATIONAL_WAIT_COUNT) {
 			ioc_err(ioc, "%s: failed due to ioc not operational\n",
 				__func__);
 			rc = -EFAULT;
-- 
1.8.3.1
