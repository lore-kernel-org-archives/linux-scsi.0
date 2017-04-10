From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Race to power off harming SATA SSDs
Date: Mon, 10 Apr 2017 16:57:55 -0700
Message-ID: <1491868675.2473.22.camel@HansenPartnership.com>
References: <20170410232118.GA4816@khazad-dum.debian.net>
         <20170410235206.GA28603@wtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57636 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751648AbdDJX56 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Apr 2017 19:57:58 -0400
In-Reply-To: <20170410235206.GA28603@wtj.duckdns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>

On Tue, 2017-04-11 at 08:52 +0900, Tejun Heo wrote:
[...]
> > Any comments?  Any clues on how to make the delay "smarter" to 
> > trigger only once during platform shutdown, but still trigger per
> > -device when doing per-device hotswapping ?
> 
> So, if this is actually an issue, sure, we can try to work around;
> however, can we first confirm that this has any other consequences
> than a SMART counter being bumped up?  I'm not sure how meaningful
> that is in itself.

Seconded; especially as the proposed patch is way too invasive: we run
single threaded on shutdown and making every disk wait 1s is going to
drive enterprises crazy.  I'm with Tejun: If the device replies GOOD to
SYNCHRONIZE CACHE, that means we're entitled to assume all written data
is safely on non-volatile media and any "essential housekeeping" can be
redone if the power goes away.

James
