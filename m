From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 10/21] uas: zap_pending: data urbs should have completed
 at this time
Date: Wed, 10 Sep 2014 16:17:31 +0200
Message-ID: <54105D7B.1010201@redhat.com>
References: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>	 <1410349611-17573-11-git-send-email-hdegoede@redhat.com> <1410358224.12706.30.camel@linux-fkkt.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936AbaIJORi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2014 10:17:38 -0400
In-Reply-To: <1410358224.12706.30.camel@linux-fkkt.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org

Hi,

On 09/10/2014 04:10 PM, Oliver Neukum wrote:
> On Wed, 2014-09-10 at 13:46 +0200, Hans de Goede wrote:
>>                 uas_log_cmd_state(cmnd, __func__);
>> -               /* all urbs are killed, clear inflight bits */
>> -               cmdinfo->state &= ~(COMMAND_INFLIGHT |
>> -                                   DATA_IN_URB_INFLIGHT |
>> -                                   DATA_OUT_URB_INFLIGHT);
>> +               /* Sense urbs were killed, clear COMMAND_INFLIGHT
>> manually */
>> +               cmdinfo->state &= ~COMMAND_INFLIGHT;
>>                 cmnd->result = result << 16;
>> -               uas_try_complete(cmnd, __func__);
>> +               WARN_ON(uas_try_complete(cmnd, __func__) != 0);
> 
> That looks like very bad style. WARN_ON() shouldn't
> have side effects.

A valid point, I'll respin this patch to store the result and check it
separately.

Regards,

Hans
