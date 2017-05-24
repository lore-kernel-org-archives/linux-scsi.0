From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 01/15] qedf: Enable basic FDMI information.
Date: Wed, 24 May 2017 16:16:18 +0000
Message-ID: <1495642577.2823.13.camel@sandisk.com>
References: <20170523131931.1777-1-chad.dupuis@cavium.com>
         <20170523131931.1777-2-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:9109 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966912AbdEXQQV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 May 2017 12:16:21 -0400
In-Reply-To: <20170523131931.1777-2-chad.dupuis@cavium.com>
Content-Language: en-US
Content-ID: <CBB621AA3DD1AA41A06E14233A044280@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "chad.dupuis@cavium.com" <chad.dupuis@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "QLogic-Storage-Upstream@cavium.com" <QLogic-Storage-Upstream@cavium.com>

On Tue, 2017-05-23 at 06:19 -0700, Dupuis, Chad wrote:
> +		snprintf(fc_host_serial_number(lport->host),
> +		    FC_SERIAL_NUMBER_SIZE,
> +		    "%02X%02X%02X%02X%02X%02X%02X%02X",
> +		    buf[7], buf[6], buf[5], buf[4],
> +		    buf[3], buf[2], buf[1], buf[0]);
> +	} else
> +		snprintf(fc_host_serial_number(lport->host),
> +		    FC_SERIAL_NUMBER_SIZE, "Unknown");
> +
> +	snprintf(fc_host_manufacturer(lport->host),
> +	    FC_SERIAL_NUMBER_SIZE, "%s", "Cavium Inc.");

Hello Chad,

I think this code would be a lot easier to read and to verify if it would b=
e
modified as follows:
* Instead of using the fc_host_<field>() macros, assign shost_to_fc_host(lp=
ort->host)
  to a variable and change fc_host_<field>() into ...-><field>.
* Instead of using the FC_*_SIZE macros, use sizeof(...-><field>).

Thanks,

Bart.=
