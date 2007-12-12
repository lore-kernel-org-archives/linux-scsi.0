From: Bernd Schubert <bs@q-leap.de>
Subject: Re: [PATCH] scsi device recovery
Date: Wed, 12 Dec 2007 15:36:10 +0100
Message-ID: <200712121536.10665.bs@q-leap.de>
References: <200712121354.14474.bs@q-leap.de> <20071212133927.GI26334@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:35661 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbXLLOgM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Dec 2007 09:36:12 -0500
In-Reply-To: <20071212133927.GI26334@parisc-linux.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Wednesday 12 December 2007 14:39:27 Matthew Wilcox wrote:
> On Wed, Dec 12, 2007 at 01:54:14PM +0100, Bernd Schubert wrote:
> > below is a patch introducing device recovery, trying to prevent i/o
> > errors when a DID_NO_CONNECT or SOFT_ERROR does happen.
>
> Why doesn't the regular scsi_eh do what you need?

First of all, it is presently simply not called when the two errors above do 
happen. This could be changed, of course.

Secondly, I think scsi_eh is in most cases doing too much. We are fighting 
with flaky Infortrend boxes here, and scsi_eh sometimes manages to crash 
their scsi channels. In most cases it is sufficient to stall any io to the 
device and then to resume.
For most scsi devices one probably doesn't need a suspend time or it can be 
very small, this still needs to become configurable via sysfs.

Thirdly, scsi_eh doesn't give up, in most cases, when the scsi channel of a 
Infortrend box crashed, it tried forever to recover.
To improve this is still on my todo list.


Thanks,
Bernd

-- 
Bernd Schubert
Q-Leap Networks GmbH
