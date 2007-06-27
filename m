From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 0/3] srp transport class
Date: Wed, 27 Jun 2007 16:32:28 +0900
Message-ID: <20070627163228S.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:55789 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbXF0LLW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jun 2007 07:11:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@steeleye.com, santil@us.ibm.com, rdreier@cisco.com

This patchset adds srp transport class and converts ib_srp and
ibmvscsi drivers to use it.

ib_srp driver already uses ib's sysfs and ibmvscsi uses vio's sysfs so
there aren't many things to do for srp transport class unless I'm
allowed to break the existing applications.

It creates only /sys/class/{srp_host,srp_remote_ports} and
srp_remote_ports has only "port_id" attribute.

viola:/sys/class/srp_remote_ports/port-0:1# ls
device  port_id  subsystem  uevent
viola:/sys/class/srp_remote_ports/port-0:1# cat port_id
4c:49:4e:55:58:20:56:49:4f:00:00:00:00:00:00:00


Currently, this is useful only for initiator mode, but I plan to add
stuff for target mode to enable ibmvstgt to handle transport-dependent
stuff.

The patchset were made against scsi-misc.
