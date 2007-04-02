From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: SMP pass through interface via bsg
Date: Mon, 2 Apr 2007 11:49:56 +0900 (JST)
Message-ID: <20070402110125U.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:55053 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbXDBCud (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Apr 2007 22:50:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org, James.Bottomley@SteelEye.com, dougg@torque.net, James.Smart@Emulex.Com, jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org

I started to work on SMP pass through via bsg as a non-SCSI command
experimentation. I asked Doug to try the patch but it seems to take
some time to make Doug's hardware work with the mainline aic94xxx
driver. Meanwhile, I'd like to discuss some issues.

- user/kernel interface

How should a user-space tool (like Doug's smp_utils) send a request
and get the response via bsg?

-- each SAS object (host, device, expander, etc) has the own bsg device

A user-space tool opens a bsg device for a sas object that it wants to
send a request to.

-- one bsg device handles multiple SAS objects

Some options: one bsg device in the whole system; one bsg device per
SAS driver; one bsg device per SAS host; etc.

With this approach, we need to invent a header incluing routing
information.

My hacky patch creates one bsg device per SAS host and invents:

struct smp_passthrough_hdr {
	__u64 sas_address;
	__u8 phy_identifier;
};

a user-space tool sends this header instead of scb via bsg and put a
SMP request at dout_xfer and a buffer response at din_xfer (note that
now I do bidi transfer in a hacky way).


- SAS implementation details

As I said, the patch is too hacky. I just tried to implement a
smp_portal alternative by using bsg.

The patch adds a hook into sas transport class. sas_host_setup calls
bsg_register_queue. Then, the request_fn calls smp_execute_task to
send a smp request and get the response. It doesn't look good to link
the sas transport class with libsas. In addition, the mpt driver
handles smp request/response in a very different way.

Any suggestion to bind SMP pass through via bsg to aic94xx and mpt
cleanly?
