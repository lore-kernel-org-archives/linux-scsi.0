From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH 1/1] kbuild: recursive build of external kernel modules
Date: Thu,  8 Aug 2019 19:21:04 -0500
Message-ID: <20190809002104.18599-2-stancheff@cray.com>
References: <20190809002104.18599-1-stancheff@cray.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190809002104.18599-1-stancheff@cray.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Shaun Tancheff <stancheff@cray.com>, linux-kbuild@vger.kernel.org, Joe Lawrence <joe.lawrence@redhat.com>, "'James E . J . Bottomley'" <jejb@linux.ibm.com>, Jonathan Corbet <corbet@lwn.net>, "'Martin K . Petersen'" <martin.petersen@oracle.com>, Michal Marek <michal.lkml@markovi.net>, Shuah Khan <shuah@kernel.org>, Thomas Renninger <trenn@suse.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When building a tree of external modules stage 2 fails
silently as the root modules.order is empty.

Modify the modules.order location to be fixed to the
root when KBUILD_EXTMOD is specified and write all
module paths to the single modules.order file.

Signed-off-by: Shaun Tancheff <stancheff@cray.com>
---
 Makefile               | 1 +
 scripts/Makefile.build | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 23cdf1f41364..a9964492f47e 100644
--- a/Makefile
+++ b/Makefile
@@ -1622,6 +1622,7 @@ $(module-dirs): prepare $(objtree)/Module.symvers
 
 modules: $(module-dirs)
 	@$(kecho) '  Building modules, stage 2.';
+	$(Q)$rm -f $(KBUILD_EXTMOD)/modules.order
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost
 
 PHONY += modules_install
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 0d434d0afc0b..f9908b3d59e0 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -64,7 +64,13 @@ builtin-target := $(obj)/built-in.a
 endif
 
 ifeq ($(CONFIG_MODULES)$(need-modorder),y1)
+ifneq ($(KBUILD_EXTMOD),)
+modorder-target := $(KBUILD_EXTMOD)/modules.order
+modorder-add := >>
+else
 modorder-target := $(obj)/modules.order
+modorder-add := >
+endif
 endif
 
 mod-targets := $(patsubst %.o, %.mod, $(obj-m))
@@ -423,7 +429,7 @@ endif # builtin-target
 $(modorder-target): $(subdir-ym) FORCE
 	$(Q){ $(foreach m, $(modorder), \
 	$(if $(filter %/modules.order, $m), cat $m, echo $m);) :; } \
-	| $(AWK) '!x[$$0]++' - > $@
+	| $(AWK) '!x[$$0]++' - $(modorder-add) $@
 
 #
 # Rule to compile a set of .o files into one .a file (with symbol table)
-- 
2.20.1
