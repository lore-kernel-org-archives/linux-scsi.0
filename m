From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 3/4] scsi_dh_alua: do not call BUG_ON when updating
 port group
Date: Mon, 15 May 2017 10:16:29 +0200
Message-ID: <1494836189.4728.2.camel@suse.com>
References: <20170512131508.3231-1-mwilck@suse.com>
         <20170512131508.3231-4-mwilck@suse.com>
         <1494606261.14477.3.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:40388 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933174AbdEOPjd (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Mon, 15 May 2017 11:39:33 -0400
In-Reply-To: <1494606261.14477.3.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "mauricfo@linux.vnet.ibm.com" <mauricfo@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


On Fri, 2017-05-12 at 16:24 +0000, Bart Van Assche wrote:
> 
> Hello Martin,
> 
> Allowing races like the one this patch tries to address to exist
> makes
> the ALUA code harder to maintain than necessary. Have you considered
> to
> make alua_bus_detach() wait until ALUA work has finished by using
> e.g.
> cancel_work_sync() or rcu_synchronize()?
> 
> Bart.

Hello Bart,

to be honest, no, I didn't consider this yet. The current kernel
crashes with BUG() if an ALUA device is detached at an inopportune
point in time (not just theoretically, we actually observed this). The
goal of my patch was to fix this with minimum risk to introduce other
problems. The addition in patch 4/4 was an attempt to address the
concern you had expressed in your review of the v1 patch.

I'm not opposed to try to find a better solution, but could we maybe
get the fix for the BUG() (i.e. patch 3/4) applied in the first place?
AFAICS it would not conflict with a solution like the one you
suggested.

Best regards and thanks for the review,
Martin

-- 
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
