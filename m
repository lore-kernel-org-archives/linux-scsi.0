From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 03/37] ncr5380: Fix compiler warnings and __setup options
Date: Wed, 12 Nov 2014 16:11:49 +1100
Message-ID: <20141112051147.245471886@telegraphics.com.au>
References: <20141112051146.525489687@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-fix-compiler-warnings-and-setup
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Some __setup() options mentioned in Documentation/scsi don't work because
a few lines of code went missing sometime since Linux 2.4. Fix the options
and thus fix some compiler warnings for both the non-modular case,

    CC      drivers/scsi/dtc.o
drivers/scsi/dtc.c:176:20: warning: 'dtc_setup' defined but not used [-Wunused-function]

and the modular case,

    CC [M]  drivers/scsi/pas16.o
drivers/scsi/pas16.c:335:20: warning: 'pas16_setup' defined but not used [-Wunused-function]
    CC [M]  drivers/scsi/t128.o
drivers/scsi/t128.c:147:20: warning: 't128_setup' defined but not used [-Wunused-function]

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.de>

---
 drivers/scsi/dtc.c   |    8 +++++++-
 drivers/scsi/pas16.c |   10 +++++++++-
 drivers/scsi/t128.c  |   11 ++++++++++-
 3 files changed, 26 insertions(+), 3 deletions(-)

Index: linux/drivers/scsi/dtc.c
===================================================================
--- linux.orig/drivers/scsi/dtc.c	2014-11-12 16:10:43.000000000 +1100
+++ linux/drivers/scsi/dtc.c	2014-11-12 16:10:48.000000000 +1100
@@ -173,10 +173,13 @@ static const struct signature {
  *
  */
 
-static void __init dtc_setup(char *str, int *ints)
+static int __init dtc_setup(char *str)
 {
 	static int commandline_current = 0;
 	int i;
+	int ints[10];
+
+	get_options(str, ARRAY_SIZE(ints), ints);
 	if (ints[0] != 2)
 		printk("dtc_setup: usage dtc=address,irq\n");
 	else if (commandline_current < NO_OVERRIDES) {
@@ -189,7 +192,10 @@ static void __init dtc_setup(char *str,
 			}
 		++commandline_current;
 	}
+	return 1;
 }
+
+__setup("dtc=", dtc_setup);
 #endif
 
 /* 
Index: linux/drivers/scsi/pas16.c
===================================================================
--- linux.orig/drivers/scsi/pas16.c	2014-11-12 16:10:43.000000000 +1100
+++ linux/drivers/scsi/pas16.c	2014-11-12 16:10:48.000000000 +1100
@@ -337,6 +337,7 @@ static int __init
 }
 
 
+#ifndef MODULE
 /*
  * Function : pas16_setup(char *str, int *ints)
  *
@@ -347,10 +348,13 @@ static int __init
  *
  */
 
-void __init pas16_setup(char *str, int *ints)
+static int __init pas16_setup(char *str)
 {
     static int commandline_current = 0;
     int i;
+    int ints[10];
+
+    get_options(str, ARRAY_SIZE(ints), ints);
     if (ints[0] != 2) 
 	printk("pas16_setup : usage pas16=io_port,irq\n");
     else 
@@ -364,8 +368,12 @@ void __init pas16_setup(char *str, int *
 		}
 	    ++commandline_current;
 	}
+    return 1;
 }
 
+__setup("pas16=", pas16_setup);
+#endif
+
 /* 
  * Function : int pas16_detect(struct scsi_host_template * tpnt)
  *
Index: linux/drivers/scsi/t128.c
===================================================================
--- linux.orig/drivers/scsi/t128.c	2014-11-12 16:10:43.000000000 +1100
+++ linux/drivers/scsi/t128.c	2014-11-12 16:10:48.000000000 +1100
@@ -148,6 +148,7 @@ static struct signature {
 
 #define NO_SIGNATURES ARRAY_SIZE(signatures)
 
+#ifndef MODULE
 /*
  * Function : t128_setup(char *str, int *ints)
  *
@@ -158,9 +159,13 @@ static struct signature {
  *
  */
 
-void __init t128_setup(char *str, int *ints){
+static int __init t128_setup(char *str)
+{
     static int commandline_current = 0;
     int i;
+    int ints[10];
+
+    get_options(str, ARRAY_SIZE(ints), ints);
     if (ints[0] != 2) 
 	printk("t128_setup : usage t128=address,irq\n");
     else 
@@ -174,8 +179,12 @@ void __init t128_setup(char *str, int *i
 		}
 	    ++commandline_current;
 	}
+    return 1;
 }
 
+__setup("t128=", t128_setup);
+#endif
+
 /* 
  * Function : int t128_detect(struct scsi_host_template * tpnt)
  *
