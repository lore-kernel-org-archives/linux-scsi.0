From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sd: always scan VPD pages if thin provisioning is enabled
Date: Wed, 25 Jan 2017 21:45:17 -0500
Message-ID: <yq1ziiea69u.fsf@oracle.com>
References: <1485329165-64825-1-git-send-email-hare@suse.de>
        <20170125102329.GA17657@lst.de>
        <022cd098-4156-6e17-a308-adff544bf99f@suse.de>
        <1485354425.5280.76.camel@localhost.localdomain>
        <02181dcf-0177-d2f3-545e-264d87bc489b@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45310 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752453AbdAZCpl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jan 2017 21:45:41 -0500
In-Reply-To: <02181dcf-0177-d2f3-545e-264d87bc489b@suse.de> (Hannes Reinecke's
        message of "Wed, 25 Jan 2017 15:38:35 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: emilne@redhat.com, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes,

Hannes> Thing is, setting 'WS16' here is arguably wrong, as LPBME just
Hannes> means 'logical block provisioning management enabled', not
Hannes> 'WRITE SAME 16 with UNMAP' supported.

Things are the way they are because many devices predate the final SBC
spec. They report LBPME=1 but do not have the VPD page indicating their
preferred deprovisioning command. The VPD was added very late in the
spec and there are a ton of devices that don't have it. As a result, we
default to WS16 unless the device reports the UNMAP parameters in the
Block Limits VPD.

That has been a very solid heuristic for a long time so please don't
mess with that.

-- 
Martin K. Petersen	Oracle Linux Engineering
