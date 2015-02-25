From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] [SCSI] mvumi: 64bit value for seconds_since1970
Date: Wed, 25 Feb 2015 11:48:33 +0100
Message-ID: <5652033.yqM2roEabN@wuerfel>
References: <20150225021354.GA2794@tinar>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:53391 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbbBYKso (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Feb 2015 05:48:44 -0500
In-Reply-To: <20150225021354.GA2794@tinar>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tina Ruchandani <ruchandani.tina@gmail.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>

On Wednesday 25 February 2015 07:43:54 Tina Ruchandani wrote:
> struct mvumi_hs_page2 stores a "seconds_since1970" field which is of
> type u64. It is however, written to, using 'struct timeval' which has
> a 32-bit seconds field and whose value will overflow in year 2038.
> This patch uses ktime_get_real_seconds() instead since it provides a
> 64-bit seconds value, which is 2038 safe.
> 
> Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

I note that in this case, the bug exists and is fixed by your patch
on both 32-bit and 64-bit kernels.

I am unsure whether it is correct that this driver along with 3w-9xxx.c
and 3w-sas.c, but unlike all others, uses local time instead of UTC,
but your patch does not change that.
