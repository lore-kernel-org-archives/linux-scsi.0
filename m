From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: Bad tag value in scsi-mq.4
Date: Tue, 19 Aug 2014 11:04:47 -0700
Message-ID: <20140819180447.GA16742@infradead.org>
References: <2C438B34CAC8264398F5C7AF7411910A62ADCC73@G9W0731.americas.hpqcorp.net>
 <20140805192809.GA971@infradead.org>
 <2C438B34CAC8264398F5C7AF7411910A62ADCDC8@G9W0731.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41025 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbaHSSEs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Aug 2014 14:04:48 -0400
Content-Disposition: inline
In-Reply-To: <2C438B34CAC8264398F5C7AF7411910A62ADCDC8@G9W0731.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Handzik, Joe" <joseph.t.handzik@hp.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>, "Scales, Webb" <webb.scales@hp.com>, "Teel, Scott Stacy" <scott.stacy.teel@hp.com>

On Tue, Aug 05, 2014 at 07:47:12PM +0000, Handzik, Joe wrote:
> Yeah, we thought about that one. We call scsi_activate_tcq if our scsi_device has tagged_supported set within hpsa_change_queue_type (our .change_queue_type entry into the scsi_host_template). Also made sure I was booting with the "scsi_mod.use_blk_mq=Y" option, which makes no difference either way.

Can you add some tracing to catch this?  On the non-mq path requests
start out with ->tag set to -1 and blk_queue_start_tag, which is called
from scsi_request_fn sets it up.  Adding printks in that area should
help you to find the culprit.

