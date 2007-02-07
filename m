From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 06/12] sas_ata: Implement SATA PHY control
Date: Tue, 06 Feb 2007 23:54:56 -0800
Message-ID: <45C985D0.7090704@gmail.com>
References: <20070130091814.31530.23152.stgit@elm3a70.beaverton.ibm.com> <20070130091847.31530.6282.stgit@elm3a70.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:36954 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030642AbXBGRzg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Feb 2007 12:55:36 -0500
Received: by ug-out-1314.google.com with SMTP id 44so248871uga
        for <linux-scsi@vger.kernel.org>; Wed, 07 Feb 2007 09:55:36 -0800 (PST)
In-Reply-To: <20070130091847.31530.6282.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, alexisb@us.ibm.com

Darrick J. Wong wrote:
> This patch requires "libsas: Add a sysfs knob to enable/disable a phy"
> to be applied.  It hooks the SControl write function to provide basic
> SATA phy control for phy enable/disable and speed limits.  Power
> management is still broken, though it is unclear that libata actually
> uses those SControl bits anyway.

I don't really think exporting SControl as-is a good idea.  Not all 
devices would act as expected if you change speed limit in SControl on 
the fly.  Also, SATA phy speed is managed by libata core layer and used 
during EH.  Please take a look at sata_down_spd_limit() and its usage.

-- 
tejun

