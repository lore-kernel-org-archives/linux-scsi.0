From: christophe varoqui <christophe.varoqui@free.fr>
Subject: [ANNOUNCE] multipath-tools-0.2.9
Date: Sat, 25 Sep 2004 02:24:09 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096071849.4466.31.camel@zezette>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp10.wanadoo.fr ([193.252.22.21]:17130 "EHLO
	mwinf1009.wanadoo.fr") by vger.kernel.org with ESMTP
	id S269147AbUIYAYM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Sep 2004 20:24:12 -0400
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com
Cc: linux-raid@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

Hello,

here goes multipath-tools-0.2.9

The ChangeLog is pretty big this time : changes accumulated while
waiting for scsi_id-0.6 and while background-battling with an IA64
compilation glitch.

In short :

	* compiles on IA64
	* implement the alias OSDL CGL preconisation
	* more work on single path devices and JBOD handling

Regression testing is even lighter than the previous release, because I
temporarily lost access to my favorite SAN.

Full ChangeLog for the release :

        * [multipathd] finally tame the clone compilation glitch on IA64
          move from sys_clone to __clone / __clone2
        * [kpartx] rework from Stephan Bader, IBM :
                * handle s390x arch
                * endianness fixes
                * push the partname string size to handle wwwids
                * quieten implicit cast warnings
        * [multipath] add an 'alias' multipath keyword for friendlier
	  device
          names. This was "asked" by OSDL' CGL board of secret reviewers
        * [multipath] last pass with JBOD and parallel SCSI support :
          hard-code scsi_id as a fallback when disk strings doesn't
	  match any hwtable entry
        * [multipath & multipathd] change the parser to not coalesce
          consecutive spaces (Patrick Mansfield)
        * [multipath] remove the [UN]: output prefix, so that stdout can
	  be easily fed to a tool like dmsetup
        * [multipathd] DEBUG=3 logs more readable/usefull
        * [multipathd] add a multipath_tool config keyword
        * [multipathd] move to execute_program() like multipath already
          did
        * [multipath] don't print the "no path" msg in quiet mode
        * [multipathd] include linux/unistd.h for _syscall2
          definition on RedHat systems. Remove superfluous
          asm/unistd.h include
        * [libsysfs] forked : last version uses mntent, which
          klibc doesn't provide. That, plus the fact we use
          only 1/3 of the lib, pushed me to freeze the version
          and strip all unused stuff.
        * [multipathd] prepare_namespace() cleanup : no more "multipath"
          special casing since we push it to binvec vector, like the
          other callouts detected in the config file.

As usual, doc and download at :
http://christophe.varoqui.free.fr/

regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>

