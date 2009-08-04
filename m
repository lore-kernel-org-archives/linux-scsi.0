From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 06/12] qla2xxx: Fix endian issues on PPC platfrom for
 NPIV.
Date: Tue, 04 Aug 2009 20:41:32 +0000
Message-ID: <1249418492.3939.42.camel@mulgrave.site>
References: <1249078174-1957-1-git-send-email-giridhar.malavali@qlogic.com>
	 <1249078174-1957-7-git-send-email-giridhar.malavali@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47849 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932750AbZHDUlf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2009 16:41:35 -0400
In-Reply-To: <1249078174-1957-7-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: giridhar.malavali@qlogic.com
Cc: andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

On Fri, 2009-07-31 at 15:09 -0700, giridhar.malavali@qlogic.com wrote:
> From: Andrew Vasquez <andrew.vasquez@qlogic.com>
> 
> VP IDX need to be converted to proper endian for NPIV
> to work on PPC platforms.

This description doesn't seem quite right; it implies there's an NPIV
failure on PPC.  whereas the patch

>  		DEBUG15(printk("%s:format 0 : scsi(%ld) number of VPs setup %d,"
>  			" number of VPs acquired %d\n", __func__, vha->host_no,
> -			MSB(rptid_entry->vp_count), LSB(rptid_entry->vp_count)));
> +			MSB(le16_to_cpu(rptid_entry->vp_count)),
> +			LSB(le16_to_cpu(rptid_entry->vp_count))));

Is altering the way a debug print works, which isn't fixing anything.  I
assume NPIV works fine on PPC but prints the wrong debug values?

James


