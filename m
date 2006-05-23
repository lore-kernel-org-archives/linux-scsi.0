From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] scsi: Return -EINVAL when "id == max_id" in
	scsi_scan_host_selected()
Date: Mon, 22 May 2006 19:54:35 -0500
Message-ID: <1148345675.3320.77.camel@mulgrave.il.steeleye.com>
References: <1148080489.23417.18.camel@amitarora.in.ibm.com>
	 <20060520042132.GC2826@parisc-linux.org>
	 <1148108792.13190.36.camel@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:21917 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751215AbWEWAzM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 May 2006 20:55:12 -0400
In-Reply-To: <1148108792.13190.36.camel@amitarora.in.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Amit Arora <aarora@in.ibm.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, patmans@us.ibm.com

On Sat, 2006-05-20 at 12:41 -0700, Amit Arora wrote:
> Thus, I still think applying the patch might be a good idea in the
> immediate future. Moreover, this patch doesn't change the current
> definition of any of these variables and results in a behavior which
> is
> currently expected. So, till the time we figure out what should be
> done
> in the long run to remove any confusion over the definition of these
> variables - why not apply the patch ?

Actually, we've got another cockup here with drivers: some have set this
to 8 or 16 and others to 7 or 15.  If we apply this without auditing
them, for those who set it to 7 or 15, the last target will end up
inaccessible.

James


