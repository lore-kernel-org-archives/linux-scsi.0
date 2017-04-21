From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 9/9] sd_zbc: Do not write lock zones for reset
Date: Fri, 21 Apr 2017 17:15:55 +0000
Message-ID: <1492794954.2550.15.camel@sandisk.com>
References: <20170421091649.25287-1-damien.lemoal@wdc.com>
         <20170421091649.25287-10-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:16529 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423485AbdDUSUQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2017 14:20:16 -0400
In-Reply-To: <20170421091649.25287-10-damien.lemoal@wdc.com>
Content-Language: en-US
Content-ID: <8A0EFC347F201D4F98A79B8B8799E334@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "hare@suse.de" <hare@suse.de>

On Fri, 2017-04-21 at 18:16 +0900, damien.lemoal@wdc.com wrote:
> @@ -250,11 +249,6 @@ int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd)
>  		/* Unaligned request */
>  		return BLKPREP_KILL;
> =20
> -	/* Do not allow concurrent reset and writes */
> -	if (sdkp->zones_wlock &&
> -	    test_and_set_bit(zno, sdkp->zones_wlock))
> -		return BLKPREP_DEFER;
> -

Hello Damien,

Since concurrent zone resets and writes are easy to detect and since these
indicate a bug in the application that submits these, should an error messa=
ge
be logged if that happens? Otherwise this patch looks fine to me.

Bart.=
