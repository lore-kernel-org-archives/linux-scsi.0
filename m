From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 0/9] scsi_data_buffer structure (in preparation for bidi)
Date: Fri, 7 Sep 2007 06:50:08 +0900
Message-ID: <20070906183448I.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:43001 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932422AbXIFVvj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Sep 2007 17:51:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jens.axboe@oracle.com, James.Bottomley@SteelEye.com, bharrosh@panasas.com, fujita.tomonori@lab.ntt.co.jp

This patchset, which I submitted before, adds a new data structure,
scsi_data_buffer, including everything for data transfer:

struct scsi_data_buffer {
	unsigned length;
	int resid;
	short sg_count;
	short __sg_count;
	struct scatterlist *sglist;
};

One scsi_data_buffer structure is embedded in struct scsi_cmnd for
uni-directional transfer. All the members are just moved from
scsi_cmnd structure to scsi_data_buffer structure. So nothing is added
to scsi_cmnd structure.

After applying this patchset, llds must use the scsi data
accessors. This patchset includes some conversation patches (most of
them are patches that Boaz submitted before), however there is still
some code that is needed to be converted.

Boaz, if you still have other conversation patches, please submit
them.

I suspect that nobody cares about some of unconverted llds, which will
be not compilable after this patchset. I'll fix ldds that people
complain about.

It's difficult to test this patchset in -mm via scsi-misc. Jens,
please send this to -mm via the block tree.
