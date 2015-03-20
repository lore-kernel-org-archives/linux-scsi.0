From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: noise in target_core_register_fabric
Date: Fri, 20 Mar 2015 11:40:02 -0700
Message-ID: <1426876802.16687.4.camel@haakon3.risingtidesystems.com>
References: <20150304154620.GA32023@aepfle.de>
	 <20150318074947.GA21195@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150318074947.GA21195@aepfle.de>
Sender: target-devel-owner@vger.kernel.org
To: Olaf Hering <olaf@aepfle.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-03-18 at 08:49 +0100, Olaf Hering wrote:
> On Wed, Mar 04, Olaf Hering wrote:
> 
> > Is there a need to fill dmesg with noise like shown below whenever
> > targetcli-3.0 runs a command? I think the pr_err calls in those functions
> > should be converted to pr_debug.
> 
> Any update on this?
> 
> > [ 1240.045518] target_core_register_fabric() trying autoload for fc
> > [ 1240.045520] target_core_get_fabric() failed for fc
> 

Hi Olaf,

Applying the following patch to target-pending/for-next.

Thank you,

--nab

>From 62554910a94a62f7b9b79cee3ca6bac95abe3c29 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 20 Mar 2015 11:36:50 -0700
Subject: [PATCH] target: Convert fabric module autoload failures to pr_debug

This patch converts the fabric module autoload failures from
pr_err to pr_debug in target_core_register_fabric() code, to
reduce the amount of noise during normal operation.

Reported-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 75d89ad..69baf1c 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -142,8 +142,8 @@ static struct config_group *target_core_register_fabric(
 
 	tf = target_core_get_fabric(name);
 	if (!tf) {
-		pr_err("target_core_register_fabric() trying autoload for %s\n",
-			name);
+		pr_debug("target_core_register_fabric() trying autoload for %s\n",
+			 name);
 
 		/*
 		 * Below are some hardcoded request_module() calls to automatically
@@ -165,8 +165,8 @@ static struct config_group *target_core_register_fabric(
 			 */
 			ret = request_module("iscsi_target_mod");
 			if (ret < 0) {
-				pr_err("request_module() failed for"
-				       " iscsi_target_mod.ko: %d\n", ret);
+				pr_debug("request_module() failed for"
+				         " iscsi_target_mod.ko: %d\n", ret);
 				return ERR_PTR(-EINVAL);
 			}
 		} else if (!strncmp(name, "loopback", 8)) {
@@ -178,8 +178,8 @@ static struct config_group *target_core_register_fabric(
 			 */
 			ret = request_module("tcm_loop");
 			if (ret < 0) {
-				pr_err("request_module() failed for"
-				       " tcm_loop.ko: %d\n", ret);
+				pr_debug("request_module() failed for"
+				         " tcm_loop.ko: %d\n", ret);
 				return ERR_PTR(-EINVAL);
 			}
 		}
@@ -188,8 +188,8 @@ static struct config_group *target_core_register_fabric(
 	}
 
 	if (!tf) {
-		pr_err("target_core_get_fabric() failed for %s\n",
-		       name);
+		pr_debug("target_core_get_fabric() failed for %s\n",
+		         name);
 		return ERR_PTR(-EINVAL);
 	}
 	pr_debug("Target_Core_ConfigFS: REGISTER -> Located fabric:"
