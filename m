From: Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH 10/21] uas: zap_pending: data urbs should have completed
 at this time
Date: Wed, 10 Sep 2014 16:10:24 +0200
Message-ID: <1410358224.12706.30.camel@linux-fkkt.site>
References: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>
	 <1410349611-17573-11-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42698 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbaIJOK1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2014 10:10:27 -0400
In-Reply-To: <1410349611-17573-11-git-send-email-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org

On Wed, 2014-09-10 at 13:46 +0200, Hans de Goede wrote:
>                 uas_log_cmd_state(cmnd, __func__);
> -               /* all urbs are killed, clear inflight bits */
> -               cmdinfo->state &= ~(COMMAND_INFLIGHT |
> -                                   DATA_IN_URB_INFLIGHT |
> -                                   DATA_OUT_URB_INFLIGHT);
> +               /* Sense urbs were killed, clear COMMAND_INFLIGHT
> manually */
> +               cmdinfo->state &= ~COMMAND_INFLIGHT;
>                 cmnd->result = result << 16;
> -               uas_try_complete(cmnd, __func__);
> +               WARN_ON(uas_try_complete(cmnd, __func__) != 0);

That looks like very bad style. WARN_ON() shouldn't
have side effects.

	Regards
		Oliver


