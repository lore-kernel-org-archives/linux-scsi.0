From: Hannes Reinecke <hare@suse.de>
Subject: Current plans for SDEV_EVT_* and friends
Date: Tue, 01 Feb 2011 15:55:14 +0100
Message-ID: <4D481ED2.1060109@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:42240 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253Ab1BAOr3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Feb 2011 09:47:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: James Bottomley <jbottomley@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Richard Sharpe <realrichardsharpe@gmail.com>

Hi Tejun,

seeing that you are moving the old SCSI / libata AEN handling over
to the new block-based workqueue, I was wondering what your plans
are with the remaining SDEV_EVT_* things.

Thing is I'm currently working on implementing proper Unit Attention
handling in the SCSI stack. For this I would need to have some field
off the scsi_device structure into which I can store information
about which events / event types are supported and which are activated.
So the existing bitmap approach with 'supported_events' would quite
a good starting point here, and it will even be useful to add
another one, eg 'enabled_events'.
And, of course, plan is to route appropriate events over to the
block workqueue by calling disk_check_events().

Unless you have other ideas/plans here ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
