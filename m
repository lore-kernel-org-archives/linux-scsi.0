From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 1/1][RESEND] Staging: hv: storvsc: Move the storage
 driver out of the staging area
Date: Thu, 12 Jan 2012 17:55:45 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481B6EFEF0@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1325622441-15600-1-git-send-email-kys@microsoft.com>
 <20120111103649.GB22652@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:2769 "EHLO
	VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751860Ab2ALR4G convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jan 2012 12:56:06 -0500
In-Reply-To: <20120111103649.GB22652@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "gregkh@suse.de" <gregkh@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>, "ohering@suse.com" <ohering@suse.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Christoph,

Let me begin by first thanking you for your detailed review. I have addressed all the issues you have
identified - the code looks much better now; thank you! I am currently testing this code and I will post
the patches soon - individual patches against the current code in the staging tree as well as a patch to
move the driver out of staging (as I have done in the past). Please find my responses to your comments
in-line.

Regards,

K. Y

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Wednesday, January 11, 2012 5:37 AM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> James.Bottomley@HansenPartnership.com; hch@infradead.org; linux-
> scsi@vger.kernel.org
> Subject: Re: [PATCH 1/1][RESEND] Staging: hv: storvsc: Move the storage driver
> out of the staging area
> 
> 
> I'd also really recommend splitting the actual protocol defintion in
> a header separate from the driver implementation to make it clear what
> is part of the protocol and what's internal to the driver.

I have consolidated all of the protocol defines at the start of the file and
these are properly commented. The decision to not have a separate header file
was based on the comments I got from the community a while ago. Hopefully,
this consolidation will address all the concerns.

> 
> > +static inline struct storvsc_device *get_out_stor_device(
> > +					struct hv_device *device)
> 
> > +static inline struct storvsc_device *get_in_stor_device(
> > +					struct hv_device *device)
> 
> I'm pretty sure you defended this odd reference counting scheme last
> time the discussion came up, but please write up a long comment in
> the code explaning it so that the question doesn't come up again
> all the time.

I don't have any reference counting anymore. I have added a comment
explaining the protocol for managing the life-cycle.
 
> 
> > +	request_size = sizeof(struct storvsc_cmd_request);
> > +
> > +	cmd_request = mempool_alloc(memp->request_mempool,
> > +				       GFP_ATOMIC);
> > +	if (!cmd_request)
> > +		return SCSI_MLQUEUE_DEVICE_BUSY;
> 
> The point of the mempool allocator is that it will never return NULL.

With GFP_ATOMIC flag, the allocation I think can fail. At least that is what
mempool_alloc() comment says.

> 
> > +	/* max # of devices per target */
> > +	host->max_lun = STORVSC_MAX_LUNS_PER_TARGET;
> > +	/* max # of targets per channel */
> > +	host->max_id = STORVSC_MAX_TARGETS;
> > +	/* max # of channels */
> > +	host->max_channel = STORVSC_MAX_CHANNELS - 1;
> > +	/* max cmd length */
> > +	host->max_cmd_len = STORVSC_MAX_CMD_LEN;
> 
> Any reason these aren't set directly in the host template?

This state is not in the scsi_host_template. What am I missing here.


