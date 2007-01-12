From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: Adaptect 9405w: What is the best solution?
Date: Fri, 12 Jan 2007 15:37:35 -0800
Message-ID: <45A81BBF.7050104@us.ibm.com>
References: <45A6195E.7020103@scanventure.no> <45A6570C.3090308@torque.net> <45A6906D.3040805@us.ibm.com> <45A694A1.6010400@scanventure.no> <45A69937.8030400@us.ibm.com> <45A6C33C.8060900@scanventure.no>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41093 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161174AbXALXhk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Jan 2007 18:37:40 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0CNbcQn027769
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jan 2007 18:37:38 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0CNbc32263096
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jan 2007 18:37:38 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0CNbcvW024358
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jan 2007 18:37:38 -0500
In-Reply-To: <45A6C33C.8060900@scanventure.no>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tarjei Huse <tarjei@nu.no>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org, "Wu, Gilbert" <Gilbert_Wu@adaptec.com>, "Chim, Ed" <ed_chim@adaptec.com>, Alexis Bruemmer <alexisb@us.ibm.com>

Tarjei Huse wrote:

> I did the opposite, I downloaded the git tree and tried to compile it.
> Since I got an error, I added the scsi-rc-fixes patch (the scsi-misc and
> aic94xx didn't apply cleanly so I guessed they were already in the git
> tree), the 39-libsas-fix-thypos,
> ../11-aic94xx-dont-eat-query-task-results_1, 17-aic94xx-fix-fw-leak_1.

The aic94xx-sas git tree is a requirement.  Something along the lines of:

$ cg-clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
$ cd linux-2.6
$ cg-branch-add scsi-misc git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
$ cg-branch-add scsi-rc git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
$ cg-branch-add aic94xx git://git.kernel.org/pub/scm/linux/kernel/git/jejb/aic94xx-sas-2.6.git
$ cg-update scsi-misc
$ cg-update scsi-rc
$ cg-update aic94xx

*Then* apply patches from my patch set.

--D
