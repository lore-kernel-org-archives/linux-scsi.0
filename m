From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: Fix the reproducible oops in scsi
Date: Thu, 11 Jan 2007 03:29:20 +0900
Message-ID: <87tzyyg2gv.fsf@duaron.myhome.or.jp>
References: <878xgbhpxg.fsf@duaron.myhome.or.jp> <45A4EACA.7020601@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.parknet.jp ([210.171.160.80]:1104 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965003AbXAJS3a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jan 2007 13:29:30 -0500
Received: from ibmpc.myhome.or.jp ([210.171.168.39]:4530)
	by parknet.jp with [XMail 1.21 ESMTP Server]
	id <SE3BD> for <linux-scsi@vger.kernel.org> from <hirofumi@mail.parknet.co.jp>;
	Thu, 11 Jan 2007 03:29:26 +0900
In-Reply-To: <45A4EACA.7020601@emulex.com> (James Smart's message of "Wed\, 10 Jan 2007 08\:31\:54 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

James Smart <James.Smart@Emulex.Com> writes:

> I don't believe this is a valid fix. This is yet another case
> of the reuse-after-free issues on sdevs. The real issue is the
> deleted sdev isn't truly getting deleted due to references, and
> we're deadlocked trying to allocate a new one while the old one
> is outstanding. This fix just jumps over things. You're actually
> using a partially torn down sdev that, if the refcounts ever
> decremented, would be zapped - and you would be in a bunch of trouble.

I see. Can you explain more about reuse-after-free issue on sdevs? Is
there any test case or any info? Or is there any plan to fix it?
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
