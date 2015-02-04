From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] [SCSI] bfa: Remove use of struct timeval
Date: Wed, 04 Feb 2015 16:07:53 +0100
Message-ID: <2559983.ap4ZrMWJg3@wuerfel>
References: <20150204031203.GA3762@tinar>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:62195 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932877AbbBDPID (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Feb 2015 10:08:03 -0500
In-Reply-To: <20150204031203.GA3762@tinar>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tina Ruchandani <ruchandani.tina@gmail.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>

On Wednesday 04 February 2015 08:42:03 Tina Ruchandani wrote:
> struct timeval will have its tv_sec field overflow on 32-bit systems
> in year 2038 and beyond. This patch removes the usage of struct timeval
> and instead uses ktime_get_real_seconds() which returns 64-bit wall-clock
> seconds.
> 
> Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
> 

The patch is correct, but you can do it better by removing the
bfa_get_log_time() function completely and changing the
four callers to call ktime_get_real_seconds() directly.

The subject line could be improved too: you don't remember all uses
of timeval in this patch, but only one of them. When you do the
first change, a good subject line would be:

[SCSI] bfa: replace bfa_get_log_time with ktime_get_real_seconds

	Arnd
