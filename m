From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 09/15] qedf: Add bus_reset No-op.
Date: Wed, 24 May 2017 16:37:12 +0000
Message-ID: <1495643831.2823.24.camel@sandisk.com>
References: <20170523131931.1777-1-chad.dupuis@cavium.com>
         <20170523131931.1777-10-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:62333 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751722AbdEXQhO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 May 2017 12:37:14 -0400
In-Reply-To: <20170523131931.1777-10-chad.dupuis@cavium.com>
Content-Language: en-US
Content-ID: <EA19FE0F891AD049A2092503059E508C@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "chad.dupuis@cavium.com" <chad.dupuis@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "QLogic-Storage-Upstream@cavium.com" <QLogic-Storage-Upstream@cavium.com>

On Tue, 2017-05-23 at 06:19 -0700, Dupuis, Chad wrote:
> We need to add a bus reset no-op as without it some of the LUNs attached =
to a
> vport may go offline when the error handler escalates to host reset due t=
o not
> having a bus reset handler in the driver. What happens is we escalate to =
host
> reset which does a soft link down/link up to reset the adapter. However w=
ith
> multiple vports attached it's been observed that if the vports do log bac=
k into
> the target within 5 seconds, the SCSI layer offlines the devices most lik=
ely
> due to a TUR timing out to verify that the device is online. Adding a bus
> reset handler will cause the TUR to be sent after the bus reset handler w=
here
> the devices will still be online if the bus reset is initiated by sg_rese=
t
> (which is the case in the test that was failing). The bus reset will succ=
eed
> and not needlessly bring the device offline/online.

Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>=
