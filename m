From: Jeremy Higdon <jeremy@sgi.com>
Subject: Control Mode page (0xA) QERR bit setting
Date: Mon, 30 Aug 2004 19:45:20 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040831024520.GA2118@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:53941 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S266296AbUHaCpX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Aug 2004 22:45:23 -0400
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [192.26.80.2])
	by omx2.sgi.com (8.12.11/8.12.9/linux-outbound_gateway-1.1) with ESMTP id i7V3pIit024658
	for <linux-scsi@vger.kernel.org>; Mon, 30 Aug 2004 20:51:18 -0700
Received: from classic.engr.sgi.com (classic.engr.sgi.com [163.154.5.111])
	by cthulhu.engr.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id i7V2jLY97002534
	for <linux-scsi@vger.kernel.org>; Mon, 30 Aug 2004 19:45:21 -0700 (PDT)
Received: from classic.engr.sgi.com (localhost [127.0.0.1])
	by classic.engr.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id i7V2jKjn002229
	for <linux-scsi@vger.kernel.org>; Mon, 30 Aug 2004 19:45:20 -0700 (PDT)
Received: (from jeremy@localhost)
	by classic.engr.sgi.com (SGI-8.12.5/8.12.5/Submit) id i7V2jK6P002228
	for linux-scsi@vger.kernel.org; Mon, 30 Aug 2004 19:45:20 -0700 (PDT)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

It looks as though the midlayer assumes that QERR is 0.  Is that correct?

If QERR is 0, then a check condition for one command will not affect other
commands, whereas if QERR is 1, then when one command gets a check condition,
all others for that ITL are silently aborted.

Since I wasn't able to find any code (other than in the ipr driver) that
completed all outstanding commands to a Lun when a check condition is
received, I figure that we depend on QERR=0.

thanks

jeremy
