Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043412;
	b=g8WK2vsPtz/diod/My3cdwryGaH6hgPKOYohd2Np5BA0cq3QlVerLROdR449irMexPoH
	 V3B9lW0NO0Sl9QGAyAzN0rH8kLEN1DTWQ+udSwHi1UHMOgQEw6bEr5rdAxDZT8wBFqwhn
	 ary1Di8QvasNVjAxgIi3omcaiMw/Ofhw0wqGdHJBbkBSdMu8mu1TF6LvJk8bKEVBDiwTz
	 SWX9e3+PXyx7hEnGC4BWfalyP1eX3OGflHXPkk7zpb7jGYuK1b1gPMZyIowvlFF40dFPk
	 3M1m0skQ4smZTPQ4eA/c9H/HvPoT6Qrrhdlg4r632zHmnIZNBsg+ZvCbFs7Iywm2RVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043412;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=ppTM2cBE6L/hfj2tWUqg6481wVTZMTrU/EH3mrDwKiU=;
	b=LltaIUVLkCVAk8JNKoT+eIOAqQwMz0q/EM6T6bEPBHwyJgwZG6Bg02hMe65+P4WDGvb7
	 KMprzHA0LKNFb4JVoRjvJda3kUKDTn5QdyY13vislECS6SSSVxqdj68D+WcVNKHjm8Fyk
	 Et/3PznlYrQEnRPrcReza8KF/W//5M7nqxJ+r8JAmShsdd6OzT6WPxXMyXiKlM8yjXasR
	 h6E55A4ezXlCVC/PPTUgw12EwNnb48xu07AWmZB+oVzg9TPnIG7gKUVgCbh8DXCE7l0db
	 2DYTDue1pss4FjZvFA/Yy0Cdigvj39nnKqh6Pxh0rHSTTwFz63kiZAOSZuon3GDskaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=amhkGTkn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4F460A2615;
	Wed, 18 Nov 2026 23:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=amhkGTkn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421721F000C6;
	Wed, 18 Nov 2026 23:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795043412;
	bh=ppTM2cBE6L/hfj2tWUqg6481wVTZMTrU/EH3mrDwKiU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=amhkGTknIV5Q5cxulV0QwcLyjkd/BL4NBYzAL2rEv3jHk4fbjPxe9NQTlI1wWpBMV
	 XDyqP6H2sVV+BxZTe5DzIs+j8SNHuQwgjow9S10T+u8cmQ87W8doVlrJ4wU52lGmvY
	 4lHRG+TjRMY38qVSdS4kfwfUuBm1t2QvfQw/wlC9gHlQXk/EVr0V6pXP5c+kmVPUAo
	 dtxDiOiz/H8f9p+h2fG4AU2sft9U5KmgNGakWz3kJWXvD1csoiD6pKw2OCqO4IGrxS
	 qANoturmzKP1CxnhybzvGuggiNceVCBPKMoyC9WHl3Fv+ugScV6MBQAggzUerbqBTI
	 YEx7JWlDZ2pNg==
From: Jeff Layton <jlayton@kernel.org>
Date: Wed, 18 Nov 2026 15:10:00 -0800
Subject: [PATCH v3 03/11] scsi: mpt3sas: Requeue topology events only for
 busy devices
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261118-sas-abba-v3-3-5562d690cf61@kernel.org>
References: <20261118-sas-abba-v3-0-5562d690cf61@kernel.org>
In-Reply-To: <20261118-sas-abba-v3-0-5562d690cf61@kernel.org>
To: Sathya Prakash <sathya.prakash@broadcom.com>, 
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, 
 Ranjan Kumar <ranjan.kumar@broadcom.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, 
 James Bottomley <JBottomley@Parallels.com>
Cc: Keith Busch <kbusch@kernel.org>, 
 Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, MPT-FusionLinux.pdl@broadcom.com, 
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=5181; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=39XHL+sPJAfUiUC9woO6eeOpoaJNWnhlsR7agiU54ig=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBq/jBQPHCqrfi819XvfAlNMRvdTmnYUiWPqIWhd
 Efvzy1uRiSJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCav4wUAAKCRAADmhBGVaC
 Few6EACedhOkyRauo4QlaTDAByUqw7bakxOY+Q7OVb6azfAABK2EvzuwIUtblV+nJ1RemyqJUyb
 CN7Sw9HFhiB992FS1IVdExl7TVamTEKzVxTwa2Mc/00v1JQA8/peOHl0M3R7qiA5Y5Rxu9BoLpc
 6RZroD/X6onkfHWHOqjqJhpKoe3neeVqi7ayahmXiRS3PS+f4e2VXH6rpg6zLSODyQdD8YaIkeC
 W3yhm4yF70vil1sLYVXrFl5Q8j6ddBau0CiOp9rJhhe9X/Ekg+/8kEX3Jl8R1Qu88T0juwfe1nJ
 aFwrj60sqIZyEO65P7dmzx0AipWRwdi5cZZFxA3O2FMS1vPUcP1sqCN1Qq0qqnayn+q0J3I6oht
 XQD/pQcfLqB4HV3wydBdNq67YFgeyNZTAJrPZ3N6namT63oZz916LvK3qLvDvoJqih1AM0MHTva
 vVZu81tYjNtCUtFJ7v3x5+hJq79C8JmQaNO5jKSEt3G2hzzdicIyGCQRv0WUj0GTIXDygqKWbaq
 LhhT0KBa4NZzV9Gz5Ll6B3hzWXRpR+ubkW75RucpJq7/yjUAPBChMIofDFNHgE+VNbN+0YRRwiu
 nP0F1A3/rMvKjzmyEC9PPhsUPhQm9FCk42T3sGB4Os0y6DesVfeLbZ7F+bA5Nql3aacjQSVyRtZ
 dFWNlDLkmYFNsDw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

Since commit ad5957193107 ("scsi: mpt3sas: Add firmware event requeue
support for busy devices"), _scsih_sas_topology_change_event() requeues
the event whenever _scsih_add_device() returns non-zero. It retries the
event every second. But _scsih_add_device() returns 1 only for a busy
device. It returns -1 when it cannot add the device at all. This occurs
when:

 - the driver cannot read the SAS Device Page 0 of the device
 - the device is not an end device, or is not present
 - discovery reported an access problem
 - the device is already added

None of these conditions clear with time, and nothing limits the
number of retries. In a stress test, the driver retried the add of a
device that was not present 249 times.

A requeued event keeps the handle and phy number from its original
report. Meanwhile, the handle may go to another device, because a host
reset assigns all handles again. In one stress run, a requeued add
first ran after a host reset. At that time, its handle was not in use.
Thus the read of SAS Device Page 0 failed, and the driver requeued the
event. One second later, at the retry, a device that was returning on
another phy had that handle.

The retry then makes mpt3sas_transport_update_links() record the SAS
address of that device on the phy of the event. The add of the device
then makes _transport_sanity_check() delete the port of the drive on
that phy. Thus the driver removed the drive, although the drive never
disappeared.

When _scsih_add_device() cannot add the device, return 0, as
_scsih_pcie_add_device() does. Then the driver retries only a busy
device. Some failures of the page read do clear with time:

 - -EAGAIN, when no internal command is free or after a reset
 - an IOC status of BUSY or INSUFFICIENT_RESOURCES

Continue to retry these failures, up to command_retry_count times, as
for a busy device. This change also prevents a spin on such a device
in the loops that call _scsih_add_device() after a host reset.

Fixes: ad5957193107 ("scsi: mpt3sas: Add firmware event requeue support for busy devices")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index b455b7e5d8f3..2d98fcb8e135 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -8509,7 +8509,9 @@ _scsih_check_device(struct MPT3SAS_ADAPTER *ioc,
  *
  * Creating end device object, stored in ioc->sas_device_list.
  *
- * Return: 0 for success, non-zero for failure.
+ * Return: 1 if adding the device should be retried: it is busy, or
+ * reading its SAS Device Page 0 failed in a way that can clear with time.
+ * 0 otherwise.
  */
 static int
 _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 retry_count,
@@ -8525,12 +8527,15 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 retry_count,
 	u32 device_info;
 	u8 connector_name[5];
 	u8 port_id;
+	int r;
 
-	if ((mpt3sas_config_get_sas_device_pg0(ioc, &mpi_reply, &sas_device_pg0,
-	    MPI2_SAS_DEVICE_PGAD_FORM_HANDLE, handle))) {
+	r = mpt3sas_config_get_sas_device_pg0(ioc, &mpi_reply, &sas_device_pg0,
+	    MPI2_SAS_DEVICE_PGAD_FORM_HANDLE, handle);
+	if (r) {
 		ioc_err(ioc, "failure at %s:%d/%s()!\n",
 			__FILE__, __LINE__, __func__);
-		return -1;
+		/* e.g. no free internal command, or a reset intervened */
+		return r == -EAGAIN && retry_count < command_retry_count;
 	}
 
 	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
@@ -8538,13 +8543,15 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 retry_count,
 	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
 		ioc_err(ioc, "failure at %s:%d/%s()!\n",
 			__FILE__, __LINE__, __func__);
-		return -1;
+		return (ioc_status == MPI2_IOCSTATUS_BUSY ||
+		    ioc_status == MPI2_IOCSTATUS_INSUFFICIENT_RESOURCES) &&
+		    retry_count < command_retry_count;
 	}
 
 	/* check if this is end device */
 	device_info = le32_to_cpu(sas_device_pg0.DeviceInfo);
 	if (!(_scsih_is_end_device(device_info)))
-		return -1;
+		return 0;
 	set_bit(handle, ioc->pend_os_device_add);
 	sas_address = le64_to_cpu(sas_device_pg0.SASAddress);
 
@@ -8553,13 +8560,13 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 retry_count,
 	    MPI2_SAS_DEVICE0_FLAGS_DEVICE_PRESENT)) {
 		ioc_err(ioc, "device is not present handle(0x04%x)!!!\n",
 			handle);
-		return -1;
+		return 0;
 	}
 
 	/* check if there were any issues with discovery */
 	if (_scsih_check_access_status(ioc, sas_address, handle,
 	    sas_device_pg0.AccessStatus))
-		return -1;
+		return 0;
 
 	port_id = sas_device_pg0.PhysicalPort;
 	sas_device = mpt3sas_get_sdev_by_addr(ioc,
@@ -8567,7 +8574,7 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 retry_count,
 	if (sas_device) {
 		clear_bit(handle, ioc->pend_os_device_add);
 		sas_device_put(sas_device);
-		return -1;
+		return 0;
 	}
 
 	if (sas_device_pg0.EnclosureHandle) {

-- 
2.56.1

