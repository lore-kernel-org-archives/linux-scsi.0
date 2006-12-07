From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Infinite retries reading the partition table
Date: Thu, 07 Dec 2006 15:15:03 -0600
Message-ID: <1165526103.4698.50.camel@mulgrave.il.steeleye.com>
References: <367656.23632.qm@web31810.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:46341 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1163376AbWLGVPM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Dec 2006 16:15:12 -0500
In-Reply-To: <367656.23632.qm@web31810.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Andrew Morton <akpm@osdl.org>, mdr@sgi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 2006-12-07 at 11:14 -0800, Luben Tuikov wrote:
> It is.  If good_bytes=0 then nothing is up to date and uptodate should
> be set to 0.

That's not a correct assumption.  Zero transfer commands, like TEST UNIT
READY are perfectly happy to complete successfully with good_bytes == 0.

> Look at my comment before the function call:
>    /* A number of bytes were successfully read. ...
> 
> I repeat again: it doesn't make sense to call scsi_end_request
> with uptodate=1 and good_bytes=0, since _no bytes are uptodate_.

We can certainly debate that, but it's not appropriate to do it as part
of an unrelated patch.

James


