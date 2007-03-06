From: Olaf Hering <olh@suse.de>
Subject: improve sg_luns output for iscsi
Date: Tue, 6 Mar 2007 19:04:28 +0100
Message-ID: <20070306180428.GA16826@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:40228 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965440AbXCFSEh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Mar 2007 13:04:37 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org


Upcoming IBM pSeries firmware can boot from iscsi. To configure the
openfirmware boot-device string, we need to construct a correct
devicepath. This path includes the lun. Its currently not 100% clear
how exactly this lun value has to look like.

sg_luns may be the tool to get the value. But its current output is not
parseable by scripts. It even gives the same output for two different
scsi devices:

girgendwas:~ # lsscsi
[0:0:0:0]    disk    DGC      RAID 5           0219  /dev/sda
[0:0:0:1]    disk    DGC      RAID 5           0219  /dev/sdb
[0:0:0:2]    disk    DGC      RAID 5           0219  /dev/sdc
[0:0:0:3]    disk    DGC      RAID 5           0219  /dev/sdd
girgendwas:~ # sg_luns -V
sg_luns: version: 1.05 20060127
girgendwas:~ # sg_luns /dev/sdd
Lun list length = 32 which imples 4 lun entries
Report luns [select_report=0]:
    0000000000000000
    0001000000000000
    0002000000000000
    0003000000000000
girgendwas:~ # sg_luns /dev/sdc
Lun list length = 32 which imples 4 lun entries
Report luns [select_report=0]:
    0000000000000000
    0001000000000000
    0002000000000000
    0003000000000000

Is it possible to print the lun only for the requested scsi device?
