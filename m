From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCHv6 8/8] scsi: inline command aborts
Date: Tue, 11 Apr 2017 00:19:17 +0000
Message-ID: <1491869956.4199.35.camel@sandisk.com>
References: <1491485796-44411-1-git-send-email-hare@suse.de>
         <1491485796-44411-9-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:61983 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751983AbdDKAT1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Apr 2017 20:19:27 -0400
In-Reply-To: <1491485796-44411-9-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <5A4CC50A7E830E4AB6B45F188CE83258@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>

On Thu, 2017-04-06 at 15:36 +0200, Hannes Reinecke wrote:
> The block layer always calls the timeout function from a workqueue
> context, so there is no need to have yet another workqueue for
> running command aborts.
>=20
> [ ... ]
> @@ -271,10 +266,14 @@ enum blk_eh_timer_return scsi_times_out(struct requ=
est *req)
>  		rtn =3D host->hostt->eh_timed_out(scmd);
> =20
>  	if (rtn =3D=3D BLK_EH_NOT_HANDLED) {
> -		if (scsi_abort_command(scmd) !=3D SUCCESS) {
> +		int ret;
> +
> +		ret =3D scsi_abort_command(scmd);
> +		if (ret =3D=3D FAILED) {
>  			set_host_byte(scmd, DID_TIME_OUT);
>  			scsi_eh_scmd_add(scmd);
> -		}
> +		} else if (ret =3D=3D FAST_IO_FAIL)
> +			rtn =3D BLK_EH_RESET_TIMER;
>  	}

Has this patch been tested with the traditional block layer? For the
traditional block layer scsi_times_out() is called with the queue lock
held. Does this patch cause .eh_abort_handler(), a function that may
sleep, to be called with the queue lock held?

Bart.=
