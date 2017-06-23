From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 32/35] zfcp: use scsi device as argument for
 zfcp_task_mgmt_function()
Date: Fri, 23 Jun 2017 16:48:46 +0000
Message-ID: <1498236524.2735.4.camel@wdc.com>
References: <1498222975-71858-1-git-send-email-hare@suse.de>
         <1498222975-71858-33-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:30240 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753786AbdFWQss (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jun 2017 12:48:48 -0400
In-Reply-To: <1498222975-71858-33-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <D98AE8D2EAC1B04DAA82F0AD47E505A2@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>

On Fri, 2017-06-23 at 15:02 +0200, Hannes Reinecke wrote:
> zfcp_task_mgmt_function() is only used for lun and device reset,
> so it should be using the scsi device as an argument, not the
> scsi command.

There are multiple changes in this patch which makes this patch harder to
review than necessary. Please split this patch, e.g. as follows:
* one patch that removes the "tm_flags" argument from zfcp_fc_scsi_to_fcp()
  and inlines the tm_flags !=3D 0 case.
* another patch that adds the struct scsi_device * argument to
  zfcp_fsf_fcp_handler_common().
* a third patch that changes the first argument of zfcp_task_mgmt_function(=
)
  from struct scsi_cmnd * into struct scsi_device *.

Thanks,

Bart.=
