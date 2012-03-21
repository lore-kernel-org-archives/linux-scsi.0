From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [SCSI] pm8001: Add error handler in
 pm8001_init_sas_add() if kzalloc fails.
Date: Wed, 21 Mar 2012 08:49:45 +0000
Message-ID: <1332319785.2909.11.camel@dabdike.int.hansenpartnership.com>
References: <1332319094-11864-1-git-send-email-santoshprasadnayak@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54740 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754131Ab2CUItt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Mar 2012 04:49:49 -0400
In-Reply-To: <1332319094-11864-1-git-send-email-santoshprasadnayak@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: santosh nayak <santoshprasadnayak@gmail.com>
Cc: jack_wang@usish.com, mark_salyzyn@xyratex.com, lindar_liu@usish.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On Wed, 2012-03-21 at 14:08 +0530, santosh nayak wrote:
> From: Santosh Nayak <santoshprasadnayak@gmail.com>
> 
> We need to add error handler if kzalloc fails to allocate and initialize.
> Otherwise it may lead to Null derefernce error in 
> 'pm8001_chip_get_nvmd_req()'.

It's a GFP_KERNEL allocation.  They sleep until memory is available
(__GFP_WAIT).  It's GFP_ATOMIC that can return NULL.

James


