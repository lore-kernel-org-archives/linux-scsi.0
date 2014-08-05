From: "Handzik, Joe" <joseph.t.handzik@hp.com>
Subject: RE: Bad tag value in scsi-mq.4
Date: Tue, 5 Aug 2014 19:47:12 +0000
Message-ID: <2C438B34CAC8264398F5C7AF7411910A62ADCDC8@G9W0731.americas.hpqcorp.net>
References: <2C438B34CAC8264398F5C7AF7411910A62ADCC73@G9W0731.americas.hpqcorp.net>
 <20140805192809.GA971@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:6968 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554AbaHETsF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Aug 2014 15:48:05 -0400
In-Reply-To: <20140805192809.GA971@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>, "Scales, Webb" <webb.scales@hp.com>, "Teel, Scott Stacy" <scott.stacy.teel@hp.com>

Yeah, we thought about that one. We call scsi_activate_tcq if our scsi_device has tagged_supported set within hpsa_change_queue_type (our .change_queue_type entry into the scsi_host_template). Also made sure I was booting with the "scsi_mod.use_blk_mq=Y" option, which makes no difference either way.

-----Original Message-----
From: hch@infradead.org [mailto:hch@infradead.org] 
Sent: Tuesday, August 05, 2014 2:28 PM
To: Handzik, Joe
Cc: hch@infradead.org; linux-scsi@vger.kernel.org; scameron@beardog.cce.hp.com; Scales, Webb; Teel, Scott Stacy
Subject: Re: Bad tag value in scsi-mq.4

On Tue, Aug 05, 2014 at 06:04:07PM +0000, Handzik, Joe wrote:
> Hey Christoph,
> 
> Using the scsi-mq.4 branch from git://git.infradead.org/users/hch/scsi.git, I'm getting a -1 returned from from scsi_cmnd->request->tag...very unsure why that would be. It happens without any drives attached to the controller, not sure if that's relevant in any way.

You're using the non-mq code path, in which tagging needs to be enabled,
does your driver call scsi_activate_tcq?

