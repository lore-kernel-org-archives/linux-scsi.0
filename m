From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCHSET 0/5] osd: Revised patches for the 2.6.33 merge window
Date: Mon, 26 Oct 2009 18:51:00 +0200
Message-ID: <4AE5D374.80400@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dip-colo-pa.panasas.com ([67.152.220.67]:62641 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752225AbZJZQu7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2009 12:50:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>

Hi James

I've revisited my last patches, and am submitting a new set. They address
the concern you had that I was searching for devices by /dev/* names where
actually user-mode can change those.

Additionally there is a related bugfix.

These are the patches

[PATCH 1/5] libosd: osd_dev_is_ver1 - Minor API cleanup
[PATCH 2/5] libosd: osd_sense: OSD_CFO_PERMISSIONS
	Same as before, please submit regardless.

[PATCH 3/5] osduld: Ref-counting bug fix
	This is a bug fix. In the long past it used to work, by chance.
	With this fix it does what it's suppose to do.
	(Please submit)

[PATCH 4/5] osduld: Use device->release instead of internal kref
[PATCH 5/5] libosd: osd_dev_info: Unique Identification of an OSD device
	These two patches are new implementation to the API introduced in previous
	patchset. (Plus a related addition needed by multy-device exofs support).

	It will now use the class_find_device() API to iterate through devices looking
	for the requested one. Using class_find_device forced a ref-counting shift.
	(Please review and submit)

I've tested these patches with multy-device exofs installation also exported to
pnfs-objects clients (also in multi-device) and I'm satisfied with the results.
There are no apparent new instabilities.

I would want to submit a substantial patchset to exofs, supporting multiple devices,
mirror operations. The exofs patches are dependent on these patches to osd

[I'm putting these patches and a rebased set of exofs in linux-next. There should be
 no problems merging once they get accepted into scsi-misc. As these patches are
 based on by exofs and pnfs-objects]

Thanks
Boaz
