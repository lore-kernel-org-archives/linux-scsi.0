From: Martin Michlmayr <tbm@cyrius.com>
Subject: atp870u: bad udelay call, build failure on ARM with SCSI_ACARD
Date: Mon, 25 Aug 2008 15:06:51 +0300
Message-ID: <20080825120651.GA13757@deprecation.cyrius.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sorrow.cyrius.com ([65.19.161.204]:3693 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013AbYHYMHI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2008 08:07:08 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

drivers/scsi/atp870u.ko fails to build on ARM with:

ERROR: "__bad_udelay" [drivers/scsi/atp870u.ko] undefined!
make[1]: *** [__modpost] Error 1

__bad_udelay is specifically designed on ARM to fail when udelay is
called in a bad way.  arch/arm/include/asm/delay.h has this to say
about __bad_udelay:

/*
 * This function intentionally does not exist; if you see references to
 * it, it means that you're calling udelay() with an out of range value.
 *
 * With currently imposed limits, this means that we support a max delay
 * of 2000us. Further limits: HZ<=1000 and bogomips<=3355
 */
extern void __bad_udelay(void);

Can you check why your driver is calling udelay() with a value > 2000?

-- 
Martin Michlmayr
http://www.cyrius.com/
