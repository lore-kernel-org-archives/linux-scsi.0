From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 0/6] tgt: add I_T nexus support
Date: Wed, 11 Jul 2007 15:08:13 +0900
Message-ID: <20070711150813U.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:56151 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760025AbXGKGMK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jul 2007 02:12:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, fujita.tomonori@lab.ntt.co.jp

This patchset adds I_T nexus support by used via transport classes and
convert srp transport class and ibmvstgt driver to use it.

The patchset depends on the srp transport class:

http://marc.info/?l=linux-scsi&m=118294270112897&w=2

This adds I_T nexus support, which enable one scsi_host to handle
multiple initiators. New scsi_tgt_it_nexus_create/destroy functions
are expected be called transport classes. For example, ibmvstgt
creates an initiator remote port, then the srp transport calls
tgt_it_nexus_create. tgt doesn't manages I_T nexus, instead it tells
tgtd, user-space daemon, to create a new I_T nexus.

On the receiving the result from tgtd, tgt calls
shost->transportt->it_nexus_response. Transports should notify a
lld. The srp transport uses it_nexus_response callback in
srp_function_template to do that.

This patchset also includes patches that move tsk_mgmt_response
callback in struct scsi_host_template to struct
scsi_transport_template since struct scsi_transport_template is more
suitable for task management stuff.
