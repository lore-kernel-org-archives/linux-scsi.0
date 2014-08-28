From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Debugging scsi abort handling ?
Date: Thu, 28 Aug 2014 16:56:15 +0200
Message-ID: <53FF430F.5060103@redhat.com>
References: <53F8AAA8.8040407@redhat.com> <53FAE3CA.6060603@redhat.com> <53FAF80D.2070209@redhat.com> <53FB0FE3.80603@acm.org> <53FB1ACD.1040208@redhat.com> <53FF1AD8.9020800@suse.de> <53FF1DE9.5040605@redhat.com> <53FF1FE8.9060108@redhat.com> <53FF2199.4030300@redhat.com> <53FF2283.9000502@redhat.com> <53FF39F7.3070004@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbaH1O4V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2014 10:56:21 -0400
In-Reply-To: <53FF39F7.3070004@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Hans de Goede <hdegoede@redhat.com>, Bart Van Assche <bvanassche@acm.org>, SCSI development list <linux-scsi@vger.kernel.org>

Il 28/08/2014 16:17, Hannes Reinecke ha scritto:
>>
> As mentioned earlier, as soon as SCSI EH is invoked control
> is assumed to be transferred back to the SCSI midlayer.
> How the midlayer interprets any return value from the various eh_XX
> callbacks is immaterial to the LLDD.
> 
> So even if the eh_abort returns FAILED control is still with the SCSI
> midlayer, so the earlier statements apply.
> IE the command will be short-circuited by the block layer anyway if
> ->scsi_done() is called.

As I parsed it, the question is not whether the short-circuiting will
happen.  It's whether you will have use-after-free bugs or not if you
call ->scsi_done() after eh_abort returns FAILED.

Paolo
