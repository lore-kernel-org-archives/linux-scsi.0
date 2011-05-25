From: scameron@beardog.cce.hp.com
Subject: Question about aborting commands
Date: Wed, 25 May 2011 08:50:35 -0500
Message-ID: <20110525135035.GK26570@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:20655 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756380Ab1EYNug (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 May 2011 09:50:36 -0400
Received: from g5t0029.atlanta.hp.com (g5t0029.atlanta.hp.com [16.228.8.141])
	by g5t0009.atlanta.hp.com (Postfix) with ESMTP id E6DA0302BC
	for <linux-scsi@vger.kernel.org>; Wed, 25 May 2011 13:50:35 +0000 (UTC)
Received: from beardog.cce.hp.com (beardog.cce.hp.com [16.84.84.24])
	by g5t0029.atlanta.hp.com (Postfix) with ESMTP id CA21C20082
	for <linux-scsi@vger.kernel.org>; Wed, 25 May 2011 13:50:35 +0000 (UTC)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: scameron@beardog.cce.hp.com


If a command is aborted by an abort error handler function in
a LLD, and the aborted command comes back from the HBA with a
status that indicates it was aborted, what status (in cmd->result,
and/or sense data?) is the mid layer expecting in such a case?

Just wondering, because in playing around with adding an abort
handler to the hpsa driver for controllers which are able to do
aborts, I can cause commands to be aborted, and I copy the
sense data back to the mid layer, and give it a
cmd->result = DID_ABORT << 16.  

That is, it's hitting this case in hpsa.c: complete_scsi_command()

        case CMD_ABORTED:
                cmd->result = DID_ABORT << 16;
                dev_warn(&h->pdev->dev, "cmd %s was aborted with "
                                "status 0x%x\n", fmtcmd, ei->ScsiStatus);

it does not seem to be hitting this case below, (same function).
That is, it's not getting a target status/check condition/aborted command.)

                        if (sense_key == ABORTED_COMMAND) {
                                /* Aborted command is retryable */
                                dev_warn(&h->pdev->dev, "cmd %s "
                                        "has check condition: aborted command: "
                                        "ASC: 0x%x, ASCQ: 0x%x\n",
                                        fmtcmd, asc, ascq);
                                cmd->result = DID_SOFT_ERROR << 16;
                                break;
                        }

And, I have a dd running which
I think I have aborted one of the commands that was reading data
for that dd, and yet the dd proceeds happily along, oblivious.
This makes me think I'm not doing the right thing to alert the
mid layer that the command got aborted -- or else the midlayer is
retrying the command somehow? I didn't see how this would happen,
but maybe I missed it.

Or, maybe I should be reporting the CMD_ABORTED case back as

	cmd->result = DID_SOFT_ERROR << 16;

-- steve

