From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [scsi:for-next 200/200] drivers/scsi/scsi_sysfs.c:778: warning:
 comparison is always false due to limited range of data type
Date: Thu, 20 Mar 2014 05:07:12 +0000
Message-ID: <1395292032.2185.81.camel@dabdike.int.hansenpartnership.com>
References: <532a7339.vUDcmz4ftHlpah9V%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:41281 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbaCTFHh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Mar 2014 01:07:37 -0400
In-Reply-To: <532a7339.vUDcmz4ftHlpah9V%fengguang.wu@intel.com>
Content-Language: en-US
Content-ID: <9138E2F8133AB94C8BD6750C3F44AA9C@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "fengguang.wu@intel.com" <fengguang.wu@intel.com>
Cc: "kbuild-all@01.org" <kbuild-all@01.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.de" <hare@suse.de>

[correct cc to linux-scsi added]
On Thu, 2014-03-20 at 12:48 +0800, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
> head:   c6b7d7a684ef39be73f06c14aca4aadad77f42dc
> commit: c6b7d7a684ef39be73f06c14aca4aadad77f42dc [200/200] [SCSI] Invalidate VPD page data
> config: make ARCH=avr32 atstk1002_defconfig
> 
> All warnings:
> 
>    drivers/scsi/scsi_sysfs.c: In function 'show_vpd_pg83':
> >> drivers/scsi/scsi_sysfs.c:778: warning: comparison is always false due to limited range of data type
>    drivers/scsi/scsi_sysfs.c: In function 'show_vpd_pg80':
> >> drivers/scsi/scsi_sysfs.c:779: warning: comparison is always false due to limited range of data type
> 
> vim +778 drivers/scsi/scsi_sysfs.c
> 
> beba1fc0 Hannes Reinecke 2014-03-15  772  static struct bin_attribute dev_attr_vpd_##_page = {		\
> beba1fc0 Hannes Reinecke 2014-03-15  773  	.attr =	{.name = __stringify(vpd_##_page), .mode = S_IRUGO },	\
> beba1fc0 Hannes Reinecke 2014-03-15  774  	.size = 0,							\
> beba1fc0 Hannes Reinecke 2014-03-15  775  	.read = show_vpd_##_page,					\
> beba1fc0 Hannes Reinecke 2014-03-15  776  };
> beba1fc0 Hannes Reinecke 2014-03-15  777  
> beba1fc0 Hannes Reinecke 2014-03-15 @778  sdev_vpd_pg_attr(pg83);
> b6159c63 Hannes Reinecke 2014-03-15 @779  sdev_vpd_pg_attr(pg80);
> beba1fc0 Hannes Reinecke 2014-03-15  780  
> ^1da177e Linus Torvalds  2005-04-16  781  static ssize_t
> beba1fc0 Hannes Reinecke 2014-03-15  782  show_iostat_counterbits(struct device *dev, struct device_attribute *attr,
> 
> :::::: The code at line 778 was first introduced by commit
> :::::: beba1fc005a56a0597d01d3f381e533427856f5d [SCSI] Add EVPD page 0x83 to sysfs
> 
> :::::: TO: Hannes Reinecke <hare@suse.de>
> :::::: CC: James Bottomley <JBottomley@Parallels.com>

Actually, it's not just this that's a problem.  Since the _len variables
are unsigned chars, they're bogus in more ways than having errors put
into them because the lengths of the pages can go over 255 as well.

Bumping them up to int should fix this.  However, the way we go about
getting the vpd pages looks wrong.  You should reset vpd_len back to the
intial value (255) after obtaining each page, shouldn't you, in order to
avoid potentially wasting buffer space (unless we're assuming the pages
always get larger)?

James

