From: Andreas Herrmann <aherrman@web.de>
Subject: Re: [PATCH 1/7] zfcp: introduce eh_timed_out handler
Date: Sun, 04 Sep 2005 12:49:03 +0200
Message-ID: <431AD11F.1050903@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp06.web.de ([217.72.192.224]:8936 "EHLO smtp06.web.de")
	by vger.kernel.org with ESMTP id S1750742AbVIDKmQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Sep 2005 06:42:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, aherrman@de.ibm.com

On Sat, Sep 03, 2005 at 14:53:00, Christoph Hellwig wrote:
  > Please don't do this.  We have proper midlayer handling (plus FC
  > transport
  > class wrappers) to handle that case without introducing a big mess in
  > the
  > driver.  Please take a look at fc_remote_port_{block,unblock}

Thanks for that hint.

But does fc_remote_port_unblock set online devices that were
previously offlined?

If not the problem of offlined devises is not solved with
this. If zfcp would block requests if it detects a path error a scsi
request might have already send to the devise which might cause that
the devise if offlined. Now if zfcp detects the path is up again and
calls fc_remote_port_unblock the device can still not be used because
it is offline.

I'll have to check the code if I am back from vacation.


Regards,

Andreas

(PS: sorry for using this alternate email account)
