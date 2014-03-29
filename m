From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 50/55] scsi: Mark function and macro definition as static in
 be2iscsi/be_main.c
Date: Sun, 30 Mar 2014 00:16:25 +0530
Message-ID: <c4a13888f1c3462834fd2d015b627230d996bfa3.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, josh@joshtriplett.org
List-Id: linux-scsi@vger.kernel.org

Mark functions as static in be2iscsi/be_main.c because they are not use=
d
outside this file. Also, add static keyword to the macro definition to
ensure prototype of functions as defined.

This eliminates the following warning in be2iscsi/be_main.c:
drivers/scsi/be2iscsi/be_main.c:153:1: warning: no previous prototype f=
or =E2=80=98beiscsi_log_enable_disp=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/be2iscsi/be_main.c:153:1: warning: no previous prototype f=
or =E2=80=98beiscsi_log_enable_change=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/be2iscsi/be_main.c:153:1: warning: no previous prototype f=
or =E2=80=98beiscsi_log_enable_store=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/be2iscsi/be_main.c:153:1: warning: no previous prototype f=
or =E2=80=98beiscsi_log_enable_init=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/be2iscsi/be_main.c:4843:5: warning: no previous prototype =
for =E2=80=98beiscsi_iotask_v2=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/be2iscsi/be_main.c:5181:6: warning: no previous prototype =
for =E2=80=98beiscsi_hba_attrs_init=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/be2iscsi/be_main.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be=
_main.c
index 1f37505..d9d0087 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -61,7 +61,7 @@ MODULE_PARM_DESC(be_max_phys_size,
 		"memory that can be allocated. Range is 16 - 128");
=20
 #define beiscsi_disp_param(_name)\
-ssize_t	\
+static ssize_t	\
 beiscsi_##_name##_disp(struct device *dev,\
 			struct device_attribute *attrib, char *buf)	\
 {	\
@@ -74,7 +74,7 @@ beiscsi_##_name##_disp(struct device *dev,\
 }
=20
 #define beiscsi_change_param(_name, _minval, _maxval, _defaval)\
-int \
+static int \
 beiscsi_##_name##_change(struct beiscsi_hba *phba, uint32_t val)\
 {\
 	if (val >=3D _minval && val <=3D _maxval) {\
@@ -93,7 +93,7 @@ beiscsi_##_name##_change(struct beiscsi_hba *phba, ui=
nt32_t val)\
 }
=20
 #define beiscsi_store_param(_name)  \
-ssize_t \
+static ssize_t \
 beiscsi_##_name##_store(struct device *dev,\
 			 struct device_attribute *attr, const char *buf,\
 			 size_t count) \
@@ -112,7 +112,7 @@ beiscsi_##_name##_store(struct device *dev,\
 }
=20
 #define beiscsi_init_param(_name, _minval, _maxval, _defval) \
-int \
+static int \
 beiscsi_##_name##_init(struct beiscsi_hba *phba, uint32_t val) \
 { \
 	if (val >=3D _minval && val <=3D _maxval) {\
@@ -4840,9 +4840,9 @@ free_hndls:
 	io_task->cmd_bhs =3D NULL;
 	return -ENOMEM;
 }
-int beiscsi_iotask_v2(struct iscsi_task *task, struct scatterlist *sg,
-		       unsigned int num_sg, unsigned int xferlen,
-		       unsigned int writedir)
+static int beiscsi_iotask_v2(struct iscsi_task *task, struct scatterli=
st *sg,
+			     unsigned int num_sg, unsigned int xferlen,
+			     unsigned int writedir)
 {
=20
 	struct beiscsi_io_task *io_task =3D task->dd_data;
@@ -5178,7 +5178,7 @@ static int beiscsi_bsg_request(struct bsg_job *jo=
b)
 	return rc;
 }
=20
-void beiscsi_hba_attrs_init(struct beiscsi_hba *phba)
+static void beiscsi_hba_attrs_init(struct beiscsi_hba *phba)
 {
 	/* Set the logging parameter */
 	beiscsi_log_enable_init(phba, beiscsi_log_enable);
--=20
1.7.9.5
