From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [GIT PULL] target fixes for v3.10-rc2
Date: Wed, 15 May 2013 21:53:49 -0700
Message-ID: <1368680029.15002.32.camel@haakon3.risingtidesystems.com>
References: <1368654607.6899.16.camel@haakon3.risingtidesystems.com>
	 <CAJZOPZK7_VPzcJnc1s9oZVshvGMbm-LDVO-ZoKu63tD1bqcvDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:49033 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab3EPEut (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 May 2013 00:50:49 -0400
In-Reply-To: <CAJZOPZK7_VPzcJnc1s9oZVshvGMbm-LDVO-ZoKu63tD1bqcvDg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Or Gerlitz <or.gerlitz@gmail.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, shlomop@mellanox.com

On Wed, 2013-05-15 at 23:40 -0400, Or Gerlitz wrote:
> On Wed, May 15, 2013 at 5:50 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > A handful of fixes + minor changes this time around, along with one
> > important >= v3.9 regression fix for IBLOCK backends.  The highlights include:
> 
> Hi Nic,
> 
> Are you pushing also a patch which would allow to actually test NULL
> based RAM target (e.g target backend that does no actual IO)
> 

Yes, that's the patch included in the PULL request here:

http://git.kernel.org/cgit/linux/kernel/git/nab/target-pending.git/commit/?h=queue&id=52c07423a819091b0fe9abbf26977098b996f85b

Btw, It still needs to be enabled in userspace, but appending a
rd_nullio=1 to the /control parameters with the following lio-utils
patch should work for your testing purposes atm..

--nab

diff --git a/tcm-py/tcm_ramdisk.py b/tcm-py/tcm_ramdisk.py
index 2f66aeb..3340705 100755
--- a/tcm-py/tcm_ramdisk.py
+++ b/tcm-py/tcm_ramdisk.py
@@ -14,7 +14,7 @@ def createvirtdev(path, params):
 #      print "Calling ramdisk createvirtdev: params " + str(params)
        rd_pages = params[0]
 
-       rd_params = "rd_pages=" + rd_pages
+       rd_params = "rd_pages=" + rd_pages + ",rd_nullio=1"
 #      print "rd_params: " + rd_params
 
        control_opt = "echo -n " + rd_params.rstrip() + " > " + cfs_path + "/control"


> Or.
> 
> 
> > Nicholas Bellinger (5):
> >   iscsi-target: Fix NULL pointer dereference in iscsit_send_reject
> >   target/rd: Add ramdisk bit for NULLIO operation
> >   iscsi-target: Fix typos in RDMAEXTENSIONS macro usage
> >   MAINTAINERS: Update target git tree URL
> >   target/iblock: Fix WCE=1 + DPOFUA=1 backend WRITE regression
> >
> > Shlomo Pongratz (1):
> >   iscsi-target: Fix processing of OOO commands
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


