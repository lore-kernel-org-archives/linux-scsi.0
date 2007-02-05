From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] sd: implement stop_on_shutdown
Date: Mon, 05 Feb 2007 18:43:33 +0900
Message-ID: <45C6FC45.4050603@gmail.com>
References: <20070119170122.GS10987@htj.dyndns.org>	 <45B1574D.1090502@us.ibm.com>  <45B18AE2.3010503@gmail.com> <1169303969.2842.10.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.232]:8109 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbXBEJnk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Feb 2007 04:43:40 -0500
Received: by wx-out-0506.google.com with SMTP id h31so1551404wxd
        for <linux-scsi@vger.kernel.org>; Mon, 05 Feb 2007 01:43:39 -0800 (PST)
In-Reply-To: <1169303969.2842.10.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, Jeff Garzik <jgarzik@pobox.com>, hmh@hmh.eng.br, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

James Bottomley wrote:
> There are practical problems to handling this in sd, namely that the
> power handling commands and state model are part of the ATA command set,
> not part of the SCSI command set.  SAT really only covers the basics of
> mapping the different power management models.

I see.  I think what's currently described in SAT-r09 is enough for most
cases this is necessary - ATA and USB disks.

> However, I suppose if we're going to allow stop on shutdown, it does
> make sense to use it on suspend as well.

Yeah, it does.  Issuing STOP on suspend and START (possibly with
IMMED=1) on resume should do the trick.  libata currently does this
using sht->resume/suspend callbacks but it fits much better in sd in
that it's also useful for other SCSI disks.

James, do you think such change to sd is acceptable?  As the original
patch, the default behavior won't be changed, so unless specifically
configured (probably during boot by dist) there won't be any behavior
change.

Thanks.

-- 
tejun
