From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC] [PATCH] qla4xxx driver resubmission
Date: Thu, 21 Sep 2006 13:25:31 -0500
Message-ID: <4512D91B.1020507@cs.wisc.edu>
References: <1158710887.4358.17.camel@dcslnxpc.site> <451297C7.4000007@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54667 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751330AbWIUSZs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Sep 2006 14:25:48 -0400
In-Reply-To: <451297C7.4000007@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: David C Somayajulu <david.somayajulu@qlogic.com>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, Doug Maxey <dwm@enoyolf.org>, David Wagner <david.wagner@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Duane Grigsby <duane.grigsby@qlogic.com>

James Smart wrote:
> Why does your LLD need to reach up into the block layer to find an i/o ?
> 
> Even if you are using tags as an index into something... I would think that
> having to go up to the blk layer to retrieve a something that should have
> already been known lower in the driver leaves room for race conditions.
> 

This is how the blk and scsi tag api work for queue based tagging. We
have the scsi_find_tag() function which takes a scsi device and than
calls blk_queue_find_tag to get the request. It then does all the magic
sdev to request_queue and request to scsi command work and pass the LLD
the scsi command for the tag. So we can either add a driver array and do
some tag to scsi command or driver stucture mapping or we can use the
array already created in the scsi host block queue tag. And as you see
Dave's patch did the latter in the spirit of not duplicating what
scsi-ml or the block layer already do.

I think there are some basic races though. For example, scsi_request_fn
calls blk_queue_start_tag with only the queue lock held and so if the
request_fn was called for two devices on the same host at the same time
they both could call find_first_zero_bit on the shared bqt->tag_map and
end up getting the same tag.
