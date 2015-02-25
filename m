From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] scsi: pmcraid: Remove usage of struct timeval
Date: Wed, 25 Feb 2015 09:41:14 +0100
Message-ID: <14946525.goxAvFt5IB@wuerfel>
References: <20150225021921.GA2890@tinar>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:63202 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbbBYIlc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Feb 2015 03:41:32 -0500
In-Reply-To: <20150225021921.GA2890@tinar>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tina Ruchandani <ruchandani.tina@gmail.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>

On Wednesday 25 February 2015 07:49:21 Tina Ruchandani wrote:
> struct timeval will have its tv_sec field overflow on 32-bit systems
> in year 2038 and beyond. This patch removes the usage of struct timeval
> and instead uses 64-bit ktime_t to get the current milliseconds
> to populate pmcraid_timestamp_data.
> 
> Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
> 

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

I notice that this patch also increases the accuracy of the timestamp
from seconds to milliseconds, where the original code ignores the
sub-second portion of the timeval.

Doing this will make the the function a little slower, but I have
verified that it is only called for probe, reset and config-change,
all of which are not timing critical.

	Arnd
