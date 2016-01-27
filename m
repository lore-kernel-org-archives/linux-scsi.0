From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [LSF/MM TOPIC] Improving DISCARD support
Date: Wed, 27 Jan 2016 09:48:47 -0800
Message-ID: <56A902FF.8050102@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0071.outbound.protection.outlook.com ([65.55.169.71]:30479
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932953AbcA0Rsy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jan 2016 12:48:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lsf-pc@lists.linux-foundation.org
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>

Increasing the discard granularity of an SSD helps with reducing the 
production cost of an SSD. This makes it likely that in the future even 
more SSDs will have a discard granularity that is larger than the block 
size than today. Kernel drivers like DRBD and OCFS2 need a way to 
efficiently erase a data range. This is why the function 
blkdev_issue_zeroout() has been introduced in the block layer. This 
function uses the DISCARD operation for those devices for which 
discarded ranges read back as zero (discard_zeroes_data == 1). However, 
support in the block layer for devices with a discard granularity that 
is larger than the block size is suboptimal. Callers of 
blkdev_issue_zeroout() namely have to ensure that the start and end of 
the range that has to be zeroed are aligned with discard boundaries. 
This forces driver writers to write wrapper functions that work around 
this limitation. An example can be found in [1]. My proposal is to 
provide such functionality in the block layer instead of forcing every 
driver author to reimplement this functionality. A candidate 
implementation is available in [2].

[1] Lars Ellenberg, drbd: when receiving P_TRIM, zero-out partial 
unaligned chunks, October 2015 
(http://git.drbd.org/drbd-8.4.git/commitdiff/5204727f9dfa695fc57915c4edeb2a9f186e5fba).
[2] Bart Van Assche, Make blkdev_issue_discard() submit aligned discard 
requests, December 2015 
(http://thread.gmane.org/gmane.linux.kernel.device-mapper.devel/23801).
