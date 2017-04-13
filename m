From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 4/4] scsi: scsi_dh_alua: do not print target port group
 state if it remains unavailable
Date: Thu, 13 Apr 2017 21:40:44 +0000
Message-ID: <1492119643.24345.28.camel@sandisk.com>
References: <1491873481-23900-1-git-send-email-mauricfo@linux.vnet.ibm.com>
         <1491873481-23900-5-git-send-email-mauricfo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:46180 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751139AbdDMVkq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Apr 2017 17:40:46 -0400
In-Reply-To: <1491873481-23900-5-git-send-email-mauricfo@linux.vnet.ibm.com>
Content-Language: en-US
Content-ID: <9BB7B8F093590849BBC5E9FCDA5F2D6D@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "mauricfo@linux.vnet.ibm.com" <mauricfo@linux.vnet.ibm.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 2017-04-10 at 22:18 -0300, Mauricio Faria de Oliveira wrote:
>  /*
> + * alua_state_remains - Whether a RTPG state remains the same across 2 v=
alues.
> + * @state: the state value to check for.
> + * @old_state: the old state value.
> + * @new_state: the new state value.
> + */
> +static bool alua_state_remains(int state, int old_state, int new_state)
> +{
> +	return ((old_state =3D=3D state) && (new_state =3D=3D state));
> +}

Hello Mauricio,

All parentheses in the return statement are superfluous. Please consider
removing these.

> +/*
> -	alua_rtpg_print(sdev, pg, &valid_states);
> +
> +	/* Print RTPG information (except if state remains 'unavailable'). */
> +	if (likely(!alua_state_remains(SCSI_ACCESS_STATE_UNAVAILABLE,
> +					orig_state, pg->state)))
> +		alua_rtpg_print(sdev, pg, &valid_states);

Using "likely()" may prevent the CPU branch predictor to do it's work so in
kernel code usually likely() is only used in code that is in the hot path.

Thanks,

Bart.=
