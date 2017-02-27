From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCHv2 4/5] scsi: make scsi_eh_scmd_add() always succeed
Date: Mon, 27 Feb 2017 22:27:44 +0000
Message-ID: <1488234448.2597.9.camel@sandisk.com>
References: <1487779650-1338-1-git-send-email-hare@suse.de>
         <1487779650-1338-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:63346 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751419AbdB0WjN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Feb 2017 17:39:13 -0500
In-Reply-To: <1487779650-1338-5-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <3AE4A398C4CFC746AFE63E74AE1D1C8B@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jth@kernel.org" <jth@kernel.org>

On Wed, 2017-02-22 at 17:07 +0100, Hannes Reinecke wrote:
>  	spin_lock_irqsave(shost->host_lock, flags);
> +	WARN_ON(shost->shost_state !=3D SHOST_RUNNING &&
> +		shost->shost_state !=3D SHOST_CANCEL &&
> +		shost->shost_state !=3D SHOST_RECOVERY &&
> +		shost->shost_state !=3D SHOST_CANCEL_RECOVERY);
>  	if (scsi_host_set_state(shost, SHOST_RECOVERY))
> -		if (scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY))
> -			goto out_unlock;
> +		scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY);

Please issue a warning if the second scsi_host_set_state() fails. And once
that failure triggers a warning, I don't think we need the newly added
WARN_ON() statement anymore. Something else that surprised me is that you
consistently use WARN_ON() instead of WARN_ON_ONCE() in this patch?
 =20
Otherwise this patch looks fine to me.

Bart.=
