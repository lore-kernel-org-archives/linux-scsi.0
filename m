From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/2] scsi: Add scsi_device max_cmd_len (resend)
Date: Fri, 28 Apr 2006 13:30:06 -0500
Message-ID: <1146249006.5251.64.camel@mulgrave.il.steeleye.com>
References: <200604172240.k3HMes2V010154@d01av01.pok.ibm.com>
	 <44522672.5010607@us.ibm.com>
	 <1146237433.5251.7.camel@mulgrave.il.steeleye.com>
	 <44525CBE.1030409@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:54969 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751434AbWD1SaI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Apr 2006 14:30:08 -0400
In-Reply-To: <44525CBE.1030409@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: linux-scsi@vger.kernel.org, jgarzik@pobox.com, linux-ide@vger.kernel.org

On Fri, 2006-04-28 at 13:19 -0500, Brian King wrote:
> That is what is done today, which works fine if you only have one
> device per host, but when you have multiple devices per host, there is
> no *good* value to put in the host max_cmd_len, hence the patch. This
> could also be completely contained in libata as my previous post suggests,
> if Jeff is OK with that.

The value should be the minimum of the currently supported lengths.  I
presume we have 10, 12 and 16 for SATA?  In which case the only problem
is not doing 16 and then only if you want to go beyond 2TB ... 

Perhaps you could tell me what the actual failure case is?  my
recollection is that sd does either 6, 10 or 16, but that it only ever
tries 16 if it has to access a sector beyond 2TB, so as a matter of
practice, you should be safe even for a 10 only device on a host that
supports 16.

James


