From: Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] scsi: mptfusion: Remove unnecessary parentheses and simplify null checks
Date: Fri, 14 Sep 2018 23:36:45 -0700
Message-ID: <20180915063645.31295-1-natechancellor@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>, Nathan Chancellor <natechancellor@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Clang warns when multiple pairs of parentheses are used for a single
conditional statement.

drivers/message/fusion/mptbase.c:338:11: warning: equality comparison
with extraneous parentheses [-Wparentheses-equality]
        if ((ioc == NULL))
             ~~~~^~~~~~~
drivers/message/fusion/mptbase.c:338:11: note: remove extraneous
parentheses around the comparison to silence this warning
        if ((ioc == NULL))
            ~    ^      ~
drivers/message/fusion/mptbase.c:338:11: note: use '=' to turn this
equality comparison into an assignment
        if ((ioc == NULL))
                 ^~
                 =
drivers/message/fusion/mptbase.c:342:12: warning: equality comparison
with extraneous parentheses [-Wparentheses-equality]
        if ((pdev == NULL))
             ~~~~~^~~~~~~
drivers/message/fusion/mptbase.c:342:12: note: remove extraneous
parentheses around the comparison to silence this warning
        if ((pdev == NULL))
            ~     ^      ~
drivers/message/fusion/mptbase.c:342:12: note: use '=' to turn this
equality comparison into an assignment
        if ((pdev == NULL))
                  ^~
                  =
2 warnings generated.

Remove them and while we're at it, simplify the NULL checks as '!var' is
used more than 'var == NULL'.

Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/message/fusion/mptbase.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index dc1e43a02599..ba551d8dfba4 100644
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
2.18.0
