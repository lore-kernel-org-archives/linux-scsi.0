From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: linux-scsi on a iSCSI target mode PCIe HBA
Date: Fri, 8 Oct 2010 09:56:04 +0800
Message-ID: <DA9003B7AE9B4262AFCD0ED717F882BE@usish.com.cn>
References: <AANLkTin0ssMxhgoYssxK3z0qYhZ0Rhjay9VPz-L9piOm@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:35158 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab0JHBwq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2010 21:52:46 -0400
In-Reply-To: <AANLkTin0ssMxhgoYssxK3z0qYhZ0Rhjay9VPz-L9piOm@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'iscsi learner' <iscsilearner@gmail.com>, linux-scsi@vger.kernel.org

Hi
I have a target mode iSCSI (and linux 2.6.27)   running on a PCIe HBA.
  This target mode HBA  will completely offload  iSCSI
from  storage server to  itself. Storage server will receive only SCSI
CDB (from this PCIe target HBA) and pass it to attached disk backend.

Over the PCIe interface only the  SCSI  command-response/data is  exchanged.

Experts,   please clear my doubt  about the work/design   to make it work-

I think I should  register myself as  SCSI Mid Layer LLD and  then all
the  SCSI command/data  received by target-mode-iSCSI-stack will be
available in  queuecommand interface of  SCSI Mid layer.  Is that the
right assumption and the  best approach?
[Jack] You should register your HBA to SCST (the one I most familiar and
powerful)
as a target driver. And only if you want the HBA can be initiator and target
at the same time you can register the HBA to SCSI ML as a LLD.

In my case the LLD  will then pass that SCSI command/data across the
PCIe to storage server.   To be more clear this LLD will be running
ON a PCIe HBA

The target mode iSCSI stack can be any one of the popular linux iSCSI
target stacks.


Thanks much in advance
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

