From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 12/20] lpfc: Limit amount of work processed in IRQ
Date: Mon, 7 Aug 2017 10:43:54 +0200
Message-ID: <20170807084354.GO3978@linux-x5ow.site>
References: <20170805004731.1335-1-jsmart2021@gmail.com>
 <20170805004731.1335-13-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42464 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752528AbdHGIn4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Aug 2017 04:43:56 -0400
Content-Disposition: inline
In-Reply-To: <20170805004731.1335-13-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: linux-scsi@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On Fri, Aug 04, 2017 at 05:47:23PM -0700, James Smart wrote:
> From: Dick Kennedy <dick.kennedy@broadcom.com>
> 
> Various oops being seen on being in the ISR too long and cpu
> lockups, when under heavy load.
> 
> The amount of work being posted off of completion queues kept
> the ISR running almost all the time
> 
> Correct the issue by limiting the amount of work per itteration.

Have you considered using the IRQ poll mechanism for this? It deferres the
heavy lifing into the Soft-IRQ layer and this could help you a lot here. IIRC
I've sent James the "Slides" from my LSF/MM session which have the function
protoypes on 'em. See 'lib/irq_poll.c' or the be2iscsi driver for further
details.

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
