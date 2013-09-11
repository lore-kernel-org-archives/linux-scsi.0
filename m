From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH 1/3] scsi: Fix erratic device offline during EH
Date: Wed, 11 Sep 2013 09:36:01 -0500
Message-ID: <52307FD1.70903@tributary.com>
References: <1378123118-111972-1-git-send-email-hare@suse.de> <1378123118-111972-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.51]:20491 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab3IKOgI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Sep 2013 10:36:08 -0400
In-Reply-To: <1378123118-111972-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Bart Van Assche <bvanassche@acm.org>, Roland Dreier <roland@purestorage.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 9/2/2013 6:58 AM, Hannes Reinecke wrote:

> +static int scsi_eh_action(struct scsi_cmnd *scmd, int rtn) +{ +	static
> unsigned char tur_command[6] = {TEST_UNIT_READY, 0, 0, 0, 0, 0}; + +	if
> (scmd->request->cmd_type != REQ_TYPE_BLOCK_PC) { +		struct scsi_driver
> *sdrv = scsi_cmd_to_driver(scmd); +		if (sdrv->eh_action) +			rtn =
> sdrv->eh_action(scmd, tur_command, 6, rtn); +	} +	return rtn; +} +

	Is there are reason for using TUR here instead of STD inquiry? STD inquiry has
the advantage that it can act like a "ping" but doesn't return unit
attentions.

	Per my previous comments, trapping unit attentions in the error handler has
caused UA's like luns changed, or power loss to get lost without being
processed. For tape devices loosing UA's like this often means that the higher
level driver won't be notified that the tape is rewound, resulting in serious
issues.
