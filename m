From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 0/2] fix the lifetime of sas bsg objects
Date: Sat, 19 Apr 2008 00:43:13 +0900
Message-ID: <1208533395-31610-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:52922 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757176AbYDRPoN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Apr 2008 11:44:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This patchset is a replacement for:

http://marc.info/?l=linux-scsi&m=120753407109400&w=2

The problem is that we call blk_cleanup_queue too early for bsg queues
for SAS. We need to call blk_cleanup_queue in the release function as
we do with scsi devices.

A sas_host device doesn't have the release function so the previous
patch adds struct device to struct sas_host_attrs.

On IRC, James tolds me that kref would make things simpler.

This patchset adds release callback support to bsg, which is called
when a bsg device goes away. bsg_register_queue() takes a pointer to a
callback function. Objects like sas_host that can't use the release
callback in struct device can use this feature.

bsg internally uses kref for refcounts on bsg devices instead of
get/put_device in fops->open/release. bsg calls put_device and the
caller's release callback (if it was registered) in kref_put's
release.

This patchset against scsi-post-merge since there are some changes to
scsi_transport_sas in scsi-post-merge. This patchset also depends on
the bsg fixes for scsi devices:

http://marc.info/?l=linux-scsi&m=120692552424155&w=2

The bsg fixes for scsi devices needs to be applied to scsi-misc first,
scsi-post-merge needs to be rebased, then this patch can be applied.

James, let me know if you want me send all the floating bsg patches
against scsi-post-merge.


