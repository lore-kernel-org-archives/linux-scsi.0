From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH v2 1/2] message: fusion: Remove extra parentheses
Date: Thu,  7 Jun 2018 09:18:05 +0530
Message-ID: <431da1b7c0fa06aea38acc22fed41963b6d44421.1528342739.git.rvarsha016@gmail.com>
References: <cover.1528342739.git.rvarsha016@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1528342739.git.rvarsha016@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>, Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
List-Id: linux-scsi@vger.kernel.org

To fix clang warning of extraneous parentheses and check patch issue,
remove extra parentheses and replace x == NULL with !x.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
Following coccinele script is used to fix the warnings.

@disable is_null,paren@
expression e;
statement s;
@@
if (
- (e==NULL)
+!e
 )
s

Changes in v2:
 - Removed coccinelle script from commit message.

 drivers/message/fusion/mptbase.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index a746ccdd630a..5b98b7fca0f2 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -335,11 +335,11 @@ static int mpt_remove_dead_ioc_func(void *arg)
 	MPT_ADAPTER *ioc = (MPT_ADAPTER *)arg;
 	struct pci_dev *pdev;
 
-	if ((ioc == NULL))
+	if (!ioc)
 		return -1;
 
 	pdev = ioc->pcidev;
-	if ((pdev == NULL))
+	if (!pdev)
 		return -1;
 
 	pci_stop_and_remove_bus_device_locked(pdev);
-- 
2.17.0
