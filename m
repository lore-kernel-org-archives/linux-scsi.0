From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH v3 00/12] kbuild: create *.mod with directory path and remove MODVERDIR
Date: Wed, 17 Jul 2019 15:17:48 +0900
Message-ID: <20190717061800.10018-1-yamada.masahiro@socionext.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kbuild@vger.kernel.org
Cc: Joe Lawrence <joe.lawrence@redhat.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Jonathan Corbet <corbet@lwn.net>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michal Marek <michal.lkml@markovi.net>, Shuah Khan <shuah@kernel.org>, Thomas Renninger <trenn@suse.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


This series kills the long standing MODVERDIR.

Since MODVERDIR has a flat structure, it cannot avoid a race
condition when somebody introduces a module name conflict.

Kbuild now reads modules.order to get the list of all modules.

The post-processing/installation stages will be more robust
and simpler.



Masahiro Yamada (12):
  kbuild: do not create empty modules.order in the prepare stage
  kbuild: get rid of kernel/ prefix from in-tree modules.{order,builtin}
  kbuild: remove duplication from modules.order in sub-directories
  scsi: remove pointless $(MODVERDIR)/$(obj)/53c700.ver
  kbuild: modinst: read modules.order instead of $(MODVERDIR)/*.mod
  kbuild: modsign: read modules.order instead of $(MODVERDIR)/*.mod
  kbuild: modpost: read modules.order instead of $(MODVERDIR)/*.mod
  kbuild: export_report: read modules.order instead of
    .tmp_versions/*.mod
  kbuild: create *.mod with full directory path and remove MODVERDIR
  kbuild: remove the first line of *.mod files
  kbuild: remove 'prepare1' target
  kbuild: split out *.mod out of {single,multi}-used-m rules

 .gitignore                                 |  1 +
 Documentation/dontdiff                     |  1 +
 Makefile                                   | 36 ++++++-------------
 drivers/scsi/Makefile                      |  2 +-
 lib/Kconfig.debug                          | 12 +------
 scripts/Makefile.build                     | 40 +++++++++-------------
 scripts/Makefile.modbuiltin                |  2 +-
 scripts/Makefile.modinst                   |  5 +--
 scripts/Makefile.modpost                   | 19 +++++-----
 scripts/Makefile.modsign                   |  3 +-
 scripts/adjust_autoksyms.sh                | 14 +++-----
 scripts/export_report.pl                   | 11 +++---
 scripts/mod/sumversion.c                   | 23 +++----------
 scripts/modules-check.sh                   |  2 +-
 scripts/package/mkspec                     |  2 +-
 tools/power/cpupower/debug/kernel/Makefile |  4 +--
 16 files changed, 62 insertions(+), 115 deletions(-)

-- 
2.17.1
