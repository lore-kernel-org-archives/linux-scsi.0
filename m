From: "Jack Wang" <jack_wang@usish.com>
Subject: pm8001: [PATCH] fix missed changes during trim sas task of slow path change
Date: Wed, 15 Feb 2012 09:35:05 +0800
Message-ID: <E2EC78FE4D924618947E7C7FA03910BA@usish.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0009_01CCEBC5.1E4DC680"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:51862 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622Ab2BOBh2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Feb 2012 20:37:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'James E.J. Bottomley'" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Cc: 'Dan Williams' <dan.j.williams@intel.com>, lindar_liu@usish.com, crystal_yu@usish.com

This is a multi-part message in MIME format.

------=_NextPart_000_0009_01CCEBC5.1E4DC680
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Dan forget to change sas_alloc_task to sas_alloc_slow_task in pm8001, which
will lead to NULL point dereference, fix this.

>From b93ecdd72d6eaf96bd9c1d735dac0b350a3b2bff Mon Sep 17 00:00:00 2001
From: Jack Wang <jack_wang@usish.com>
Date: Tue, 14 Feb 2012 08:27:52 -0500
Subject: [PATCH] fix missed changes during trim sas task of slow path change

Signed-off-by: Jack Wang <jack_wang@usish.com>
---
 drivers/scsi/pm8001/pm8001_sas.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c
b/drivers/scsi/pm8001/pm8001_sas.c
index ad36f1a..ab98c41 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -660,7 +660,7 @@ static int pm8001_exec_internal_tmf_task(struct
domain_device *dev,
 	struct pm8001_hba_info *pm8001_ha = pm8001_find_ha_by_dev(dev);
 
 	for (retry = 0; retry < 3; retry++) {
-		task = sas_alloc_task(GFP_KERNEL);
+		task = sas_alloc_slow_task(GFP_KERNEL);
 		if (!task)
 			return -ENOMEM;
 
@@ -742,7 +742,7 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info
*pm8001_ha,
 	struct sas_task *task = NULL;
 
 	for (retry = 0; retry < 3; retry++) {
-		task = sas_alloc_task(GFP_KERNEL);
+		task = sas_alloc_slow_task(GFP_KERNEL);
 		if (!task)
 			return -ENOMEM;
 
-- 
1.7.4.4


------=_NextPart_000_0009_01CCEBC5.1E4DC680
Content-Type: application/octet-stream;
	name="0001-fix-missed-changes-during-trim-sas-task-of-slow-path.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-fix-missed-changes-during-trim-sas-task-of-slow-path.patch"

>From b93ecdd72d6eaf96bd9c1d735dac0b350a3b2bff Mon Sep 17 00:00:00 2001=0A=
From: Jack Wang <jack_wang@usish.com>=0A=
Date: Tue, 14 Feb 2012 08:27:52 -0500=0A=
Subject: [PATCH] fix missed changes during trim sas task of slow path =
change=0A=
=0A=
Signed-off-by: Jack Wang <jack_wang@usish.com>=0A=
---=0A=
 drivers/scsi/pm8001/pm8001_sas.c |    4 ++--=0A=
 1 files changed, 2 insertions(+), 2 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/pm8001/pm8001_sas.c =
b/drivers/scsi/pm8001/pm8001_sas.c=0A=
index ad36f1a..ab98c41 100644=0A=
--- a/drivers/scsi/pm8001/pm8001_sas.c=0A=
+++ b/drivers/scsi/pm8001/pm8001_sas.c=0A=
@@ -660,7 +660,7 @@ static int pm8001_exec_internal_tmf_task(struct =
domain_device *dev,=0A=
 	struct pm8001_hba_info *pm8001_ha =3D pm8001_find_ha_by_dev(dev);=0A=
 =0A=
 	for (retry =3D 0; retry < 3; retry++) {=0A=
-		task =3D sas_alloc_task(GFP_KERNEL);=0A=
+		task =3D sas_alloc_slow_task(GFP_KERNEL);=0A=
 		if (!task)=0A=
 			return -ENOMEM;=0A=
 =0A=
@@ -742,7 +742,7 @@ pm8001_exec_internal_task_abort(struct =
pm8001_hba_info *pm8001_ha,=0A=
 	struct sas_task *task =3D NULL;=0A=
 =0A=
 	for (retry =3D 0; retry < 3; retry++) {=0A=
-		task =3D sas_alloc_task(GFP_KERNEL);=0A=
+		task =3D sas_alloc_slow_task(GFP_KERNEL);=0A=
 		if (!task)=0A=
 			return -ENOMEM;=0A=
 =0A=
-- =0A=
1.7.4.4=0A=
=0A=

------=_NextPart_000_0009_01CCEBC5.1E4DC680--

