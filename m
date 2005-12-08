From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH 1/5] aacraid: simplify non-dasd support
Date: Thu, 8 Dec 2005 14:09:29 -0500
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F01EE9EEE@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:64437 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932257AbVLHTJb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Dec 2005 14:09:31 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

Christoph Hellwig [mailto:hch@infradead.org] writes:
> NACK on the write filter.  If we can agree on it beeing 
> useful (and I must admit I tend to the contrary opinion)
> it should be done in higher layers.

Did a rough look, neither scsi_dispatch_cmd nor scsi_request_fn
have any scsi command sniffing. Can not go any higher because we
have the no_uld_attach flag set. Given that only RAID cards would
consider this protection necessary, it is hard to justify adding
this overhead into scsi.c. The overhead in aacraid is minimal as
we are already sniffin' and spoofin' scsi commands.

I need to understand why you feel protecting array components
is bad. Without that protection we will not be able to justify
making these components visible at least via sg for
administrative reasons (scsi tools, mode pages etc).

-- Mark Salyzyn
