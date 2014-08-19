From: "Handzik, Joe" <joseph.t.handzik@hp.com>
Subject: RE: Bad tag value in scsi-mq.4
Date: Tue, 19 Aug 2014 18:09:25 +0000
Message-ID: <2C438B34CAC8264398F5C7AF7411910A62AEE735@G9W0731.americas.hpqcorp.net>
References: <2C438B34CAC8264398F5C7AF7411910A62ADCC73@G9W0731.americas.hpqcorp.net>
 <20140805192809.GA971@infradead.org>
 <2C438B34CAC8264398F5C7AF7411910A62ADCDC8@G9W0731.americas.hpqcorp.net>
 <20140819180447.GA16742@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:33161 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbaHSSKj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Aug 2014 14:10:39 -0400
In-Reply-To: <20140819180447.GA16742@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>, "Scales, Webb" <webb.scales@hp.com>, "Teel, Scott Stacy" <scott.stacy.teel@hp.com>

I may take a look again, but was able to get this working on my Rhel7 box (with the kernel boot parameter present). So I either consistently used an earlier version of GRUB incorrectly (possible, maybe when I double checked my boot parameters in the earlier version I somehow reset to defaults?) or found some strange bug. I'm not too concerned, since other members of the team haven't had problems and have been using the SCSI mq code more than I have. Sorry for the false alarm!

Joe

-----Original Message-----
From: hch@infradead.org [mailto:hch@infradead.org] 
Sent: Tuesday, August 19, 2014 1:05 PM
To: Handzik, Joe
Cc: hch@infradead.org; linux-scsi@vger.kernel.org; scameron@beardog.cce.hp.com; Scales, Webb; Teel, Scott Stacy
Subject: Re: Bad tag value in scsi-mq.4

On Tue, Aug 05, 2014 at 07:47:12PM +0000, Handzik, Joe wrote:
> Yeah, we thought about that one. We call scsi_activate_tcq if our scsi_device has tagged_supported set within hpsa_change_queue_type (our .change_queue_type entry into the scsi_host_template). Also made sure I was booting with the "scsi_mod.use_blk_mq=Y" option, which makes no difference either way.

Can you add some tracing to catch this?  On the non-mq path requests
start out with ->tag set to -1 and blk_queue_start_tag, which is called
from scsi_request_fn sets it up.  Adding printks in that area should
help you to find the culprit.

