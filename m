From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/2] [Target_Core_Mod/Persistent_Reservations]: Updates
	from PR client testing
Date: Tue, 17 Mar 2009 18:50:44 -0700
Message-ID: <1237341044.4214.52.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:43553 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755499AbZCRBvJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Mar 2009 21:51:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>

Greetings all,

Here is a couple of bugfixes that have made while myself and the LIO
team have been testing RHEL/Centos v5 Cluster Storage (using SCSI
fencing) and MSFT Windows 2008 Cluster server using SPC-3 PR aware iSCSI
storage from Target_Core_Mod + LIO-Target v3.0.

The first was a bug where a held reservation was not being implictly
released when the initiator's registration as being freed (this is
obvious BUG wrt to SPC-4 language).

The second was allowing non WRITE cdbs from unregistered initiators
while a registration is held of any Write Exclusive PR Type.  I was
unable to find any explict language in spc4r17 saying this was allowed,
but since both of the client side cluster setups listed above seem to
need these CDBs allowed to function, I have gone ahead and allowed these
non WRITE CDBs to pass in core_scsi3_pr_seq_non_holder().

These patches are made against lio-core-2.6.git/master and tested on
v2.6.29-rc8 x86 32-bit HVM.  The lio-core-2.6.git tree can be found at: 

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

[PATCH 1/2] [Target_Core_Mod/Persistent_Reservations]: Release reservation when freeing registration
[PATCH 2/2] [Target_Core_Mod/Persistent_Reservations]: Allow non WRITE CDBs from unregistered initiators

 drivers/lio-core/target_core_pr.c |   60 ++++++++++++++++++++++++++++++++-----
 1 files changed, 52 insertions(+), 8 deletions(-)

Thanks to everyone who has been contributing their time and efforts to make
SPC-3 compliant target mode emulation on Linux a reality!

--nab


