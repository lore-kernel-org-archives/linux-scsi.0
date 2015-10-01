From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 17/32] cxlflash: Remove dual port online dependency
Date: Thu, 1 Oct 2015 10:00:19 -0500
Message-ID: <30417754-C518-4C29-B44E-260C29455732@linux.vnet.ibm.com>
References: <1443222593-8828-1-git-send-email-mrochs@linux.vnet.ibm.com> <1443223018-9577-1-git-send-email-mrochs@linux.vnet.ibm.com> <87a8s6und0.fsf@gamma.ozlabs.ibm.com> <FD47E8E4-D768-401E-8A4C-31A3E37E359B@linux.vnet.ibm.com> <87si5vsc0n.fsf@gamma.ozlabs.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:49953 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129AbbJAPAe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2015 11:00:34 -0400
Received: from localhost
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Thu, 1 Oct 2015 11:00:33 -0400
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 8163638C8052
	for <linux-scsi@vger.kernel.org>; Thu,  1 Oct 2015 11:00:27 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t91F0Rga41484540
	for <linux-scsi@vger.kernel.org>; Thu, 1 Oct 2015 15:00:27 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t91F0Lkf023522
	for <linux-scsi@vger.kernel.org>; Thu, 1 Oct 2015 11:00:27 -0400
In-Reply-To: <87si5vsc0n.fsf@gamma.ozlabs.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Axtens <dja@axtens.net>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>, Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

> On Sep 30, 2015, at 6:50 PM, Daniel Axtens <dja@axtens.net> wrote:
> (resending to the list this time, apologies!)
> 
>>> I'm not sure I fully understand the flow of this function, but it looks
>>> like you set rc=0 regardless of how things actually go: is this ever
>>> going to print a return value other than zero?
>> 
>> Correct, this function behaves more like a void for the time being. The
>> overall goal of this is to allow a card to configure even when the link is
>> down. At some later point when the link is transitioned to 'up', a link state
>> change interrupt will trigger the port configuration. I left this with a return
>> code for right now in case we need to alter the behavior again (based
>> upon testing) and actually return a value other than 0.
> 
> OK. That makes more sense - it wasn't clear to me how it could be
> correct to proceed if the links were down but now I understand how that
> works. I think that explanation should go in the commit message.
> 
>>>> 	if (!wait_port_online(fc_regs, FC_PORT_STATUS_RETRY_INTERVAL_US,
>>>> 			      FC_PORT_STATUS_RETRY_CNT)) {
>>>> 		pr_debug("%s: wait on port %d to go online timed out\n",
>>>> 			 __func__, port);
> 
> As an aside, should this be a bit noisier? It seems like something
> a user would probably want to know - especially in the case where
> something has actually gone wrong so there's no link state change
> interrupt forthcoming regardless of how long you wait.

You bring up a good point. There is another place where we are noisier
with respect to the link being down, so we'll do the same here. I'll include
this in v5 along with an updated commit message as requested.

