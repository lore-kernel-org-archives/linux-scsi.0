From: Dan Merillat <harik.attar@gmail.com>
Subject: Re: Megaraid lockup on 2.6.[7-8]
Date: Mon, 9 Aug 2004 16:02:48 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <c0c0679004080916027cf2f42a@mail.gmail.com>
References: <0E3FA95632D6D047BA649F95DAB60E57033BC937@exa-atlanta> <c0c0679004080915331801dc0d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.194]:15695 "EHLO mproxy.gmail.com")
	by vger.kernel.org with ESMTP id S267335AbUHIXCs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2004 19:02:48 -0400
Received: by mproxy.gmail.com with SMTP id 73so120302rnk
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2004 16:02:48 -0700 (PDT)
In-Reply-To: <c0c0679004080915331801dc0d@mail.gmail.com>
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <atulm@lsil.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 9 Aug 2004 15:33:23 -0700, Dan Merillat <harik.attar@gmail.com> wrote:

> So far, so good.  When I stress-tested it I had a device-mapper related lockup,
> but no scsi/Megaraid problems.   I'll report back in a few days if I
> get any further errors.

First lockup, but 2.20.2 recovered gracefully:

megaraid: aborting-37816 cmd=2a <c=1 t=0 l=0>
megaraid abort: 37816:53[255:0], fw owner
megaraid: aborting-37817 cmd=2a <c=1 t=0 l=0>
megaraid abort: 37817:34[255:0], fw owner
megaraid: aborting-37818 cmd=2a <c=1 t=0 l=0>
megaraid abort: 37818:26[255:0], fw owner
megaraid: aborting-37821 cmd=2a <c=1 t=0 l=0>
megaraid abort: 37821:18[255:0], fw owner
megaraid: aborting-37824 cmd=2a <c=1 t=0 l=0>
megaraid abort: 37824:7[255:0], fw owner
megaraid: reseting the host...
megaraid: 5 outstanding commands. Max wait 180 sec
megaraid mbox: Wait for 5 commands to complete:180
megaraid mbox: Wait for 5 commands to complete:175
megaraid mbox: Wait for 5 commands to complete:170
megaraid mbox: Wait for 5 commands to complete:165
megaraid mbox: reset sequence completed sucessfully

This time, it appears that we have 3 media errors on one of the drives
(Since this is the first time it's survived a timeout, it's the first
time I can actually get into megamgr without rebooting)

If so, mystery solved: Drive failure and bad error-handling code leads
to an undiagnosed lockup.  I KNEW it was too sudden to be random
software bitrot.
