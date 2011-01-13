From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC/PATCH] Deferred disk spinup during system resume
Date: Thu, 13 Jan 2011 16:39:20 +0100
Message-ID: <20110113153920.GA14096@htj.dyndns.org>
References: <1294795457-9006-1-git-send-email-maksim.rayskiy@gmail.com>
 <20110112112142.GA9610@mtj.dyndns.org>
 <4D2DF45B.5010101@pobox.com>
 <AANLkTikEusD_CvkOERsr_wr7T70g1kuU=JnBJm5ur5Wg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44682 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757154Ab1AMPj2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jan 2011 10:39:28 -0500
Received: by bwz15 with SMTP id 15so1634202bwz.19
        for <linux-scsi@vger.kernel.org>; Thu, 13 Jan 2011 07:39:24 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <AANLkTikEusD_CvkOERsr_wr7T70g1kuU=JnBJm5ur5Wg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maksim Rayskiy <maksim.rayskiy@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org

Hello,

On Wed, Jan 12, 2011 at 12:01:56PM -0800, Maksim Rayskiy wrote:
> This is why I was asking if using a workqueue instead of EH might be
> a better idea.  EH looks like an overkill here.

We're not in need of execution context here.  libata machinary doesn't
need context to run commands.  The tricky part is the association
between scsi commands and libata qc's.  The reason why it's easy to do
from EH is because it already has access to internal command
execution.  It has nothing to do with the execution context and wq
won't change anything.

Thanks.

-- 
tejun
