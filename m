From: christophe.varoqui@free.fr
Subject: Re: [lvm] [christophe.varoqui@free.fr: dm multipath target]
Date: Tue, 19 Aug 2003 15:14:33 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1061298873.3f4222b9872b3@impt1-2.free.fr>
References: <20030819073926.GA423@fib011235813.fsnet.co.uk> <20030819094838.F8428@sistina.com> <1061283871.3f41e81f8226b@impt3-2.free.fr> <20030819115110.I8420@sistina.com> <1061290087.3f4200678f811@impt2-2.free.fr> <20030819143552.K8420@sistina.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus.kernel.org ([204.152.189.113]:53499 "EHLO zeus.kernel.org")
	by vger.kernel.org with ESMTP id S271742AbTHSQNZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Aug 2003 12:13:25 -0400
Received: from postfix3-1.free.fr (postfix3-1.free.fr [213.228.0.44])
	by zeus.kernel.org (8.11.6/8.11.6) with ESMTP id h7JDJZ622107
	for <linux-scsi@vger.kernel.org>; Tue, 19 Aug 2003 06:19:35 -0700
In-Reply-To: <20030819143552.K8420@sistina.com>
List-Id: linux-scsi@vger.kernel.org
To: mauelshagen@sistina.com
Cc: mge@sistina.com, linux-scsi@vger.kernel.org

> 
> Sorry, this sounds like a workaround mess with arbitrary vendor specific
> drivers and their behaviours. As said: we can filter such devices out
> in LVM2.
> 
> I much rather prefer enhanced and correct error reporting.
> 
> And as said above: no need because we can easily filter out device nodes
> which don't allow (IO) access.
> 
Yes, but a ghost might become active when :
* any host that has access to it through LUN masking sends a START_LUN
* a controler restarts or crashs, then active paths on this controler are
migrated to the other, thus activating ghosts.

I understand that you want to rely on kernel error reporting to put the failed
paths out of the multipath, but how will you get back in the freshly activated
paths if you have filtered them ?

If you do not get them in, you can reach a situation where your mp pool gets
empty even if there are valid paths around.

You won't be able to get away with an initial static marking of active /
inactive paths : this marking is dynamic. Only a proper callback on failing a
path and on manual activation can help vendor-specific plugins to keep those
lists in synch.

Do I oversee or misread a capability of your tools ?

regards,
cvaroqui
