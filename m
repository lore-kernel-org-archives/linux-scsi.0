From: "Stewart, Sean" <Sean.Stewart@netapp.com>
Subject: Re: [PATCH 16/16] scsi_dh_alua: Use workqueue for RTPG
Date: Tue, 29 Apr 2014 21:47:36 +0000
Message-ID: <1398808055.29991.15.camel@ict-vth-stewarts01.ict.englab.netapp.com>
References: <1391160600-19652-1-git-send-email-hare@suse.de>
	 <1391160600-19652-17-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx11.netapp.com ([216.240.18.76]:38762 "EHLO mx11.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754127AbaD2Vrt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Apr 2014 17:47:49 -0400
In-Reply-To: <1391160600-19652-17-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <368F1A0EAE7561469D0D3FC48B930D38@hq.netapp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, "George, Martin" <Martin.George@netapp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2014-01-31 at 10:30 +0100, Hannes Reinecke wrote:
> @@ -797,37 +838,40 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>  		off = 8 + (ucp[7] * 4);
>  	}
>  
> -	sdev_printk(KERN_INFO, sdev,
> -		    "%s: port group %02x state %c %s supports %c%c%c%c%c%c%c\n",
> -		    ALUA_DH_NAME, pg->group_id, print_alua_state(pg->state),
> -		    pg->pref ? "preferred" : "non-preferred",
> -		    valid_states&TPGS_SUPPORT_TRANSITION?'T':'t',
> -		    valid_states&TPGS_SUPPORT_OFFLINE?'O':'o',
> -		    valid_states&TPGS_SUPPORT_LBA_DEPENDENT?'L':'l',
> -		    valid_states&TPGS_SUPPORT_UNAVAILABLE?'U':'u',
> -		    valid_states&TPGS_SUPPORT_STANDBY?'S':'s',
> -		    valid_states&TPGS_SUPPORT_NONOPTIMIZED?'N':'n',
> -		    valid_states&TPGS_SUPPORT_OPTIMIZED?'A':'a');
Hannes,

I was wondering why this was changed from an sdev_printk to a printk? I
can see the AAS of a TPG on a target, but with it this way I do not know
with respect to what logical unit it is.

> +	printk(KERN_INFO "%s: target %s port group %02x state %c %s "
> +	       "supports %c%c%c%c%c%c%c\n", ALUA_DH_NAME, pg->target_id_str,
> +	       pg->group_id, print_alua_state(pg->state),
> +	       pg->pref ? "preferred" : "non-preferred",
> +	       valid_states&TPGS_SUPPORT_TRANSITION?'T':'t',
> +	       valid_states&TPGS_SUPPORT_OFFLINE?'O':'o',
> +	       valid_states&TPGS_SUPPORT_LBA_DEPENDENT?'L':'l',
> +	       valid_states&TPGS_SUPPORT_UNAVAILABLE?'U':'u',
> +	       valid_states&TPGS_SUPPORT_STANDBY?'S':'s',
> +	       valid_states&TPGS_SUPPORT_NONOPTIMIZED?'N':'n',
> +	       valid_states&TPGS_SUPPORT_OPTIMIZED?'A':'a');
>  
>  

Thanks,
Sean
