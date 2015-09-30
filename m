From: Daniel Axtens <dja@axtens.net>
Subject: Re: [PATCH v4 17/32] cxlflash: Remove dual port online dependency
Date: Thu, 01 Oct 2015 09:50:00 +1000
Message-ID: <87si5vsc0n.fsf@gamma.ozlabs.ibm.com>
References: <1443222593-8828-1-git-send-email-mrochs@linux.vnet.ibm.com> <1443223018-9577-1-git-send-email-mrochs@linux.vnet.ibm.com> <87a8s6und0.fsf@gamma.ozlabs.ibm.com> <FD47E8E4-D768-401E-8A4C-31A3E37E359B@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:36340 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509AbbI3XuH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Sep 2015 19:50:07 -0400
Received: by pablk4 with SMTP id lk4so54008337pab.3
        for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2015 16:50:06 -0700 (PDT)
In-Reply-To: <FD47E8E4-D768-401E-8A4C-31A3E37E359B@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>, Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>


(resending to the list this time, apologies!)

>> I'm not sure I fully understand the flow of this function, but it looks
>> like you set rc=0 regardless of how things actually go: is this ever
>> going to print a return value other than zero?
>
> Correct, this function behaves more like a void for the time being. The
> overall goal of this is to allow a card to configure even when the link is
> down. At some later point when the link is transitioned to 'up', a link state
> change interrupt will trigger the port configuration. I left this with a return
> code for right now in case we need to alter the behavior again (based
> upon testing) and actually return a value other than 0.

OK. That makes more sense - it wasn't clear to me how it could be
correct to proceed if the links were down but now I understand how that
works. I think that explanation should go in the commit message.

>>> 	if (!wait_port_online(fc_regs, FC_PORT_STATUS_RETRY_INTERVAL_US,
>>> 			      FC_PORT_STATUS_RETRY_CNT)) {
>>> 		pr_debug("%s: wait on port %d to go online timed out\n",
>>> 			 __func__, port);

As an aside, should this be a bit noisier? It seems like something
a user would probably want to know - especially in the case where
something has actually gone wrong so there's no link state change
interrupt forthcoming regardless of how long you wait.

Regards,
Daniel
