From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Fw: [Bugme-new] [Bug 8141] New: Adaptec 39320D and long boot
Date: Sun, 11 Mar 2007 13:03:44 -0500
Message-ID: <1173636225.3420.13.camel@mulgrave.il.steeleye.com>
References: <20070307123335.d7e97db3.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:54934 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933920AbXCKSDu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Mar 2007 14:03:50 -0400
In-Reply-To: <20070307123335.d7e97db3.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org

On Wed, 2007-03-07 at 12:33 -0800, Andrew Morton wrote:
> 41-second delay when mounting root fs.

This sounds like a user configuration error.  The adaptec has a bus
settle time in its initialisation path.  Originally it was 20s, hence
for a D card (twin channel) it would take about 50s to come online
(extra 5s to scan per channel).  There was a lot of argument about this,
and the value was finally made configurable as

CONFIG_AIC79XX_RESET_DELAY_MS

I suspect you have this set to around 15000.  You can make the boot
sequence shorter by reducing this value.  I believe Red Hat configures
it down to the default 5000.

James


