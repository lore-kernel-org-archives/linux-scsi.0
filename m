From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2 4/4] scsi_dh_alua: take sdev reference in
 alua_bus_attach
Date: Fri, 12 May 2017 16:21:52 +0000
Message-ID: <1494606110.14477.1.camel@sandisk.com>
References: <20170512131508.3231-1-mwilck@suse.com>
         <20170512131508.3231-5-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:27126 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932920AbdELQV7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 May 2017 12:21:59 -0400
In-Reply-To: <20170512131508.3231-5-mwilck@suse.com>
Content-Language: en-US
Content-ID: <F2C60A90F9217B438B976F2B646ABC2B@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "mwilck@suse.com" <mwilck@suse.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "mauricfo@linux.vnet.ibm.com" <mauricfo@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2017-05-12 at 15:15 +0200, Martin Wilck wrote:
> Modification of the access_state field in struct scsi_device
> in alua_rtpg() may race with alua_bus_detach(). Avoid
> the scsi_device struct to be freed while it's being processed
> in the alua code by taking a reference.

Hello Martin,

The approach of this patch seems weird to me. I don't think that it is a
good idea to let any ALUA work continue while alua_bus_detach() is in progr=
ess.
Have you considered to stop the ALUA work from inside alua_bus_detach() by
using cancel_work_sync()?

Bart.=
