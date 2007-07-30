From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 3/3] mptsas: add SMP passthrough support via bsg
Date: Mon, 30 Jul 2007 11:10:07 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D708B3ED9@NAMAIL4.ad.lsil.com>
References: <20070729163656J.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:64110 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967078AbXG3RKd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jul 2007 13:10:33 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070729163656J.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: tomof@acm.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, dougg@torque.net, jens.axboe@oracle.com

On Sunday, July 29, 2007 1:37 AM, FUJITA Tomonori wrote:
> > Eric, can I get your ACK on this patch?
> 
> One comment on the the patch:
> 
> +	if (!(ioc->sas_mgmt.status & MPT_IOCTL_STATUS_COMMAND_GOOD)) {
> +		printk(KERN_ERR "%s: smp response invalid!\n", 
> __FUNCTION__);
> +		ret = -ENXIO;
> +	}
> 
> We don't need this part since user-space can get mpt's reply, I think.
>

Correct, this should be removed. The processing of the mpt reply has
been pushed to user-space.    On another note, according to the mpi
specification, its says there should always be a reply message frame
returned for every smp passthru.  So I thinking this would be the best
way to close out the end of this function.  What do you think?


+	if (ioc->sas_mgmt.status & MPT_IOCTL_STATUS_RF_VALID) {
+		SmpPassthroughReply_t *smprep;
+
+		smprep = (SmpPassthroughReply_t *)ioc->sas_mgmt.reply;
+		memcpy(req->sense, smprep, sizeof(*smprep));
+		req->sense_len = sizeof(*smprep);
+	} else
+		printk(KERN_ERR "%s: smp passthru reply failed to be
returned\n", __FUNCTION__);
+		ret = -ENXIO;
+	}

