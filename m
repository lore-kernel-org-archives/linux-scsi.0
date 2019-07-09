From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH 00/11] kbuild: create *.mod with directory path and remove MODVERDIR
Date: Tue,  9 Jul 2019 13:24:04 +0900
Message-ID: <20190709042416.27554-1-yamada.masahiro@socionext.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kbuild@vger.kernel.org
Cc: Nicolas Pitre <nico@fluxnic.net>, Sam Ravnborg <sam@ravnborg.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Michal Marek <michal.lkml@markovi.net>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>
List-Id: linux-scsi@vger.kernel.org


This series kills the long standing MODVERDIR.

Since MODVERDIR has a flat structure, it cannot avoid a race
condition when somebody introduces a module name conflict.

Kbuild now reads modules.order to get the list of all modules.

The post-processing/installation stages will be more robust
and simpler.



Masahiro Yamada (11):
  kbuild: do not create empty modules.order in the prepare stage
  kbuild: get rid of kernel/ prefix from in-tree modules.{order,builtin}
  kbuild: remove duplication from modules.order in sub-directories
  scsi: remove pointless $(MODVERDIR)/$(obj)/53c700.ver
  kbuild: modinst: read modules.order instead of $(MODVERDIR)/*.mod
  kbuild: modsign: read modules.order instead of $(MODVERDIR)/*.mod
  kbuild: modpost: read modules.order instead of $(MODVERDIR)/*.mod
  kbuild: create *.mod with full directory path and remove MODVERDIR
  kbuild: remove the first line of *.mod files
  kbuild: remove 'prepare1' target
  kbuild: split out *.mod out of {single,multi}-used-m rules

 .gitignore                  |  1 +
 Documentation/dontdiff      |  1 +
 Makefile                    | 33 +++++++++------------------------
 drivers/scsi/Makefile       |  2 +-
 scripts/Makefile.build      | 33 ++++++++++++++++-----------------
 scripts/Makefile.modbuiltin |  2 +-
 scripts/Makefile.modinst    |  5 +----
 scripts/Makefile.modpost    | 17 +++++++++--------
 scripts/Makefile.modsign    |  3 +--
 scripts/adjust_autoksyms.sh | 11 ++++-------
 scripts/mod/sumversion.c    | 23 ++++-------------------
 scripts/modules-check.sh    |  2 +-
 scripts/package/mkspec      |  2 +-
 13 files changed, 50 insertions(+), 85 deletions(-)

-- 
2.17.1
