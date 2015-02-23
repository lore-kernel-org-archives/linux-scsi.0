From: "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: RE: [scsi 1/2] scsi_debug: schedule_resp fix input variable check
Date: Mon, 23 Feb 2015 15:14:14 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B34BB31F8@HASMSX106.ger.corp.intel.com>
References: <1424690001-2482-1-git-send-email-tomas.winkler@intel.com>
 <54EB3DED.8080103@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:34113 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbbBWPOS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Feb 2015 10:14:18 -0500
In-Reply-To: <54EB3DED.8080103@interlog.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "dgilbert@interlog.com" <dgilbert@interlog.com>, "James E.J. Bottomley\"" <JBottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> > @@ -3947,11 +3947,18 @@ schedule_resp(struct scsi_cmnd *cmnd, struct
> sdebug_dev_info *devip,
> >   	struct sdebug_queued_cmd *sqcp = NULL;
> >   	struct scsi_device *sdp = cmnd->device;
> 
> This patch seems incorrect because it still dereferences
> cmnd (in the above line) before it checks it for NULL.
>
Opps, haven't sent the lastest version. 

> > -	if (NULL == cmnd || NULL == devip) {
> > -		pr_warn("called with NULL cmnd or devip pointer\n");
> > +	/* this should never happend */
> 
> happen?
Thanks

> 
> The scsi_debug driver was written by Eric Youngdale to test
> the original Linux SCSI subsystem (or a subsequent rewrite
> of same). Remnants of its "trust nobody" style remain and
> may have been of use to more recent tinkerers.	

The check is preserved  with bigger warning,   there is just no single call for this function w/ cmnd == NULL.
> 
> > +	if (WARN_ON(!cmnd))
> > +		return SCSI_MLQUEUE_HOST_BUSY;
> > +



