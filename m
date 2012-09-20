From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] qla2xxx: Correct loop_id_map allocation-size and usage.
Date: Thu, 20 Sep 2012 09:15:12 +0100
Message-ID: <1348128912.2388.3.camel@dabdike.int.hansenpartnership.com>
References: <1348126774-3844-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54509 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751756Ab2ITIPQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Sep 2012 04:15:16 -0400
In-Reply-To: <1348126774-3844-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

On Thu, 2012-09-20 at 03:39 -0400, Saurav Kashyap wrote:
> From: Andrew Vasquez <andrew.vasquez@qlogic.com>
> 
> Original code incorrectly assigned LOOPID_MAP_SIZE to be the
> allocation size in bytes rather than total bit size.
> Additionally corrected code to check for bit-allocation failure
> in qla2x00_find_new_loop_id().
> 
> Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_def.h  |    2 +-
>  drivers/scsi/qla2xxx/qla_init.c |    4 ++--
>  drivers/scsi/qla2xxx/qla_os.c   |    3 ++-
>  3 files changed, 5 insertions(+), 4 deletions(-)

This is correcting a bug introduced by

commit 07f2a8c179aa81075a161e6d0c522aa1289d994f
Author: Chad Dupuis <chad.dupuis@qlogic.com>
Date:   Wed Aug 22 14:21:00 2012 -0400

    [SCSI] qla2xxx: Use bitmap to store loop_id's for fcports.

Isn't it?  So rather than introducing a bug and later fixing it, we
should just merge the two, since it's not yet upstream, right?

James


