From: Rolf Eike Beer <eike@bilbo.math.uni-mannheim.de>
Subject: [PATCH 0/2] clean up scsi documentation
Date: Mon, 11 Nov 2002 16:33:55 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211111633.55526@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

here are my patches to clean up the scsi documentation. It is split in three
parts:

0) Do the work. A small script that does the following things:
-create Documentation/scsi/
-move all the scsi documentation from Documentation/ and drivers/scsi/ to this
location
-kill ChangeLog.serverraid. It's a duplication from ChangeLog.ips but is
missing some bits (got ok from maintainer to do this)
-rename README.drivername to drivername.txt which is more common in
Documentation/*
NOTE: start this script on the top level of the source tree (/usr/src/linux or
whereever you put it).

1) Fix up references. A patch doing the following:
-fix up all the references (hope I got them all)
-introduce Documentation/scsi/00-INDEX

2) Clean up. Just a bit cosmetics:
-kill unneeded trailing new lines
-kill one not-ascii character from FlashPoint.txt
-kill unneeded patch instruction from cpqfc.txt: noone needs this because the
driver is already in the kernel as everybody can see.

Eike

PS: please CC me, I'm not on this list and I'm only reading this via google
sometimes.

---------Here we go: the script----------
#!/bin/bash

mkdir -v Documentation/scsi
mv -v drivers/scsi/README.* Documentation/scsi/
rm -v drivers/scsi/ChangeLog.serverraid
mv -v drivers/scsi/ChangeLog* Documentation/scsi/
mv -v drivers/scsi/LICENSE.FlashPoint Documentation/scsi/
mv -v drivers/scsi/aic7xxx_old/README.aic7xxx Documentation/scsi/aic7xxx_old.txt
mv -v drivers/scsi/sym53c8xx_2/ChangeLog.txt Documentation/scsi/ChangeLog.sym53c8xx_2
mv -v drivers/scsi/sym53c8xx_2/Documentation.txt Documentation/scsi/sym53c8xx_2.txt
mv -v drivers/scsi/cpqfc.Readme Documentation/scsi/cpqfc.txt
mv -v drivers/scsi/scsi_mid_low_api.txt Documentation/scsi/
mv -v Documentation/scsi.txt Documentation/scsi/
mv -v Documentation/scsi-generic.txt Documentation/scsi/
mv -v Documentation/README.nsp_cs.eng Documentation/scsi/NinjaSCSI.txt
cd Documentation/scsi
for i in README.*; do
 mv -v $i `echo $i| sed 's/README\.//'`.txt
done
cd ../..
-----------------------------------------
