From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] bug fix: SCSI async scan sysfs -EEXIST problem
Date: Tue, 22 May 2007 10:48:26 -0500
Message-ID: <1179848907.3738.19.camel@mulgrave.il.steeleye.com>
References: <1178564267.302.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:55458 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756880AbXEVPs2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 May 2007 11:48:28 -0400
In-Reply-To: <1178564267.302.15.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Mon, 2007-05-07 at 14:57 -0400, James Smart wrote:
> +       mutex_lock(&shost->scan_mutex);
>         scsi_sysfs_add_devices(shost);
> +       atomic_set(&shost->async_scan, 0);
> +       mutex_unlock(&shost->scan_mutex);

It really seems that the only safety here is expanding the scan mutex to
cover more of the code.  I don't really see any value to using the
atomic types ... it's not a simultaneous variable update problem, it's a
scan race which the mutex can be used to mediate.

James


