From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 2/4] Add bio/request flags for using ZBC/ZAC commands
Date: Mon, 6 Jun 2016 23:23:33 +0800
Message-ID: <201606062332.aehMXEu0%fengguang.wu@intel.com>
References: <1465227572-27149-3-git-send-email-shaun@tancheff.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="W/nzBZO5zC0uMSeA"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:33458 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbcFFQcE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jun 2016 12:32:04 -0400
Content-Disposition: inline
In-Reply-To: <1465227572-27149-3-git-send-email-shaun@tancheff.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: kbuild-all@01.org, linux-ide@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Shaun Tancheff <shaun@tancheff.com>, Shaun Tancheff <shaun.tancheff@seagate.com>


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

[auto build test WARNING on scsi/for-next]
[also build test WARNING on v4.7-rc2 next-20160606]
[cannot apply to block/for-next]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Shaun-Tancheff/Block-layer-support-ZAC-ZBC-commands/20160606-234756
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   lib/crc32.c:148: warning: No description found for parameter 'tab)[256]'
   lib/crc32.c:148: warning: Excess function parameter 'tab' description in 'crc32_le_generic'
   lib/crc32.c:293: warning: No description found for parameter 'tab)[256]'
   lib/crc32.c:293: warning: Excess function parameter 'tab' description in 'crc32_be_generic'
   lib/crc32.c:1: warning: no structured comments found
   mm/memory.c:2881: warning: No description found for parameter 'old'
>> block/blk-lib.c:269: warning: No description found for parameter 'opt'

vim +/opt +269 block/blk-lib.c

   253	
   254	/**
   255	 * blkdev_issue_zone_report - queue a report zones operation
   256	 * @bdev:	target blockdev
   257	 * @bi_rw:	extra bio rw flags. If unsure, use 0.
   258	 * @sector:	starting sector (report will include this sector).
   259	 * @page:	one or more contiguous pages.
   260	 * @pgsz:	up to size of page in bytes, size of report.
   261	 * @gfp_mask:	memory allocation flags (for bio_alloc)
   262	 *
   263	 * Description:
   264	 *    Issue a zone report request for the sectors in question.
   265	 */
   266	int blkdev_issue_zone_report(struct block_device *bdev, unsigned int bi_rw,
   267				     sector_t sector, u8 opt, struct page *page,
   268				     size_t pgsz, gfp_t gfp_mask)
 > 269	{
   270		struct bdev_zone_report *conv = page_address(page);
   271		struct bio *bio;
   272		unsigned int nr_iovecs = 1;
   273		int ret = 0;
   274	
   275		if (pgsz < (sizeof(struct bdev_zone_report) +
   276			    sizeof(struct bdev_zone_descriptor)))
   277			return -EINVAL;

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--W/nzBZO5zC0uMSeA
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--W/nzBZO5zC0uMSeA--
