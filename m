From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 190/258] scsi: smartpqi: correct host serial num for ssa
Date: Mon, 28 Jan 2019 10:58:16 -0500
Message-ID: <20190128155924.51521-190-sashal@kernel.org>
References: <20190128155924.51521-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190128155924.51521-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, Don Brace <don.brace@microsemi.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Sasha Levin <sashal@kernel.org>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>

[ Upstream commit b2346b5030cf9458f30a84028d9fe904b8c942a7 ]

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Ajish Koshy <ajish.koshy@microsemi.com>
Reviewed-by: Murthy Bhat <murthy.bhat@microsemi.com>
Reviewed-by: Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>
Reviewed-by: Dave Carroll <david.carroll@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 8c1a232ac6bf..58eb0d31d8d9 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -653,6 +653,7 @@ struct bmic_host_wellness_driver_version {
 	u8	driver_version_tag[2];
 	__le16	driver_version_length;
 	char	driver_version[32];
+	u8	dont_write_tag[2];
 	u8	end_tag[2];
 };
 
@@ -682,6 +683,8 @@ static int pqi_write_driver_version_to_host_wellness(
 	strncpy(buffer->driver_version, "Linux " DRIVER_VERSION,
 		sizeof(buffer->driver_version) - 1);
 	buffer->driver_version[sizeof(buffer->driver_version) - 1] = '\0';
+	buffer->dont_write_tag[0] = 'D';
+	buffer->dont_write_tag[1] = 'W';
 	buffer->end_tag[0] = 'Z';
 	buffer->end_tag[1] = 'Z';
 
-- 
2.19.1
