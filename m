From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/3] scsi: 3ware: use 64-bit times for FW time sync
Date: Fri, 10 Nov 2017 16:58:26 +0100
Message-ID: <20171110155840.1941250-2-arnd@arndb.de>
References: <20171110155840.1941250-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171110155840.1941250-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Adam Radford <aradford@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The calculation of the number of seconds since Sunday 00:00:00 overflows
in 2106, meaning that we instead will return the seconds since Wednesday
06:28:16 afterwards.

Using 64-bit time stamps avoids this slight inconsistency, and the
deprecated do_gettimeofday(), replacing it with the simpler
ktime_get_real_seconds().

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/3w-9xxx.c |  8 +++-----
 drivers/scsi/3w-sas.c  | 10 ++++------
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index cb9af3f7b653..b1c9bd9c1bfd 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -472,11 +472,10 @@ static char *twa_aen_severity_lookup(unsigned char severity_code)
 static void twa_aen_sync_time(TW_Device_Extension *tw_dev, int request_id)
 {
 	u32 schedulertime;
-	struct timeval utc;
 	TW_Command_Full *full_command_packet;
 	TW_Command *command_packet;
 	TW_Param_Apache *param;
-	u32 local_time;
+	time64_t local_time;
 
 	/* Fill out the command packet */
 	full_command_packet = tw_dev->command_packet_virt[request_id];
@@ -498,9 +497,8 @@ static void twa_aen_sync_time(TW_Device_Extension *tw_dev, int request_id)
 
 	/* Convert system time in UTC to local time seconds since last 
            Sunday 12:00AM */
-	do_gettimeofday(&utc);
-	local_time = (u32)(utc.tv_sec - (sys_tz.tz_minuteswest * 60));
-	schedulertime = local_time - (3 * 86400);
+	local_time = (ktime_get_real_seconds() - (sys_tz.tz_minuteswest * 60));
+	div_u64_rem(local_time - (3 * 86400), 604800, &schedulertime);
 	schedulertime = cpu_to_le32(schedulertime % 604800);
 
 	memcpy(param->data, &schedulertime, sizeof(u32));
diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index c283fdb3cb24..cf9f2a09b47d 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -407,11 +407,10 @@ static int twl_aen_read_queue(TW_Device_Extension *tw_dev, int request_id)
 static void twl_aen_sync_time(TW_Device_Extension *tw_dev, int request_id)
 {
 	u32 schedulertime;
-	struct timeval utc;
 	TW_Command_Full *full_command_packet;
 	TW_Command *command_packet;
 	TW_Param_Apache *param;
-	u32 local_time;
+	time64_t local_time;
 
 	/* Fill out the command packet */
 	full_command_packet = tw_dev->command_packet_virt[request_id];
@@ -433,10 +432,9 @@ static void twl_aen_sync_time(TW_Device_Extension *tw_dev, int request_id)
 
 	/* Convert system time in UTC to local time seconds since last 
            Sunday 12:00AM */
-	do_gettimeofday(&utc);
-	local_time = (u32)(utc.tv_sec - (sys_tz.tz_minuteswest * 60));
-	schedulertime = local_time - (3 * 86400);
-	schedulertime = cpu_to_le32(schedulertime % 604800);
+	local_time = (ktime_get_real_seconds() - (sys_tz.tz_minuteswest * 60));
+	div_u64_rem(local_time - (3 * 86400), 604800, &schedulertime);
+	schedulertime = cpu_to_le32(schedulertime);
 
 	memcpy(param->data, &schedulertime, sizeof(u32));
 
-- 
2.9.0
