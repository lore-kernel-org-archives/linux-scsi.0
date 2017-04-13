From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 2/4] scsi: scsi_dh_alua: create alua_rtpg_print() for
 alua_rtpg() sdev_printk
Date: Thu, 13 Apr 2017 21:18:47 +0000
Message-ID: <1492118326.24345.22.camel@sandisk.com>
References: <1491873481-23900-1-git-send-email-mauricfo@linux.vnet.ibm.com>
         <1491873481-23900-3-git-send-email-mauricfo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:61784 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750735AbdDMVSt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Apr 2017 17:18:49 -0400
In-Reply-To: <1491873481-23900-3-git-send-email-mauricfo@linux.vnet.ibm.com>
Content-Language: en-US
Content-ID: <BBF70E92435FBA4F9C2461791EF4BB6B@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "mauricfo@linux.vnet.ibm.com" <mauricfo@linux.vnet.ibm.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 2017-04-10 at 22:17 -0300, Mauricio Faria de Oliveira wrote:
>  /*
> + * alua_rtpg_print - Print REPORT TARGET GROUP STATES information
> + * @sdev: the device evaluated (or associated with this port group).
> + * @pg: the port group the information is associated with.
> + * @valid_states: pointer to valid_states value.
> + *                (optional; e.g., obtained via another port group)
> + *
> + * Must be called with pg->lock held.
> + */

Please use lockdep_assert_held() instead of documenting locking conventions=
 as
comments. lockdep_assert_held() is verified at runtime=A0with CONFIG_PROVE_=
LOCKING=3Dy
but comments not.

> +static void alua_rtpg_print(struct scsi_device *sdev, struct alua_port_g=
roup *pg,
> +			    int *valid_states)
> +{
> +	if (valid_states)
> +		sdev_printk(KERN_INFO, sdev,
> +		    "%s: port group %02x state %c %s supports %c%c%c%c%c%c%c\n",
> +		    ALUA_DH_NAME, pg->group_id, print_alua_state(pg->state),
> +		    pg->pref ? "preferred" : "non-preferred",
> +		    (*valid_states) & TPGS_SUPPORT_TRANSITION ? 'T' : 't',
> +		    (*valid_states) & TPGS_SUPPORT_OFFLINE ? 'O' : 'o',
> +		    (*valid_states) & TPGS_SUPPORT_LBA_DEPENDENT ? 'L' : 'l',
> +		    (*valid_states) & TPGS_SUPPORT_UNAVAILABLE ? 'U' : 'u',
> +		    (*valid_states) & TPGS_SUPPORT_STANDBY ? 'S' : 's',
> +		    (*valid_states) & TPGS_SUPPORT_NONOPTIMIZED ? 'N' : 'n',
> +		    (*valid_states) & TPGS_SUPPORT_OPTIMIZED  ?  'A' : 'a');
> +	else
> +		sdev_printk(KERN_INFO, sdev,
> +		    "%s: port group %02x state %c %s\n",
> +		    ALUA_DH_NAME, pg->group_id, print_alua_state(pg->state),
> +		    pg->pref ? "preferred" : "non-preferred");
> +}

Please define two functions - one for valid_states !=3D NULL and one for va=
lid_states
=3D=3D NULL such that valid_states can be passed by value instead of by ref=
erence.

Thanks,

Bart.=
