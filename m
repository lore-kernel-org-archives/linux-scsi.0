From: Andrew Vasquez <praka@san.rr.com>
Subject: Re: [ping] qla2xxx 8.x driver
Date: Fri, 17 Oct 2003 12:02:44 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031017190244.GA11038@praka.local.home>
References: <20031017184147.A2141@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from orngca-mls01.socal.rr.com ([66.75.160.16]:54728 "EHLO
	orngca-mls01.socal.rr.com") by vger.kernel.org with ESMTP
	id S263564AbTJQTHd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Oct 2003 15:07:33 -0400
Received: from praka.san.rr.com (66-75-133-254.san.rr.com [66.75.133.254])
	by orngca-mls01.socal.rr.com (8.11.4/8.11.3) with ESMTP id h9HJ3Td14880
	for <linux-scsi@vger.kernel.org>; Fri, 17 Oct 2003 12:03:30 -0700 (PDT)
Received: from praka.san.rr.com (localhost [127.0.0.1])
	by praka.san.rr.com (8.12.3/8.11.2/SuSE Linux 8.11.1-0.5) with ESMTP id h9HJ2lmK011147
	for <linux-scsi@vger.kernel.org>; Fri, 17 Oct 2003 12:02:47 -0700
Received: (from praka@localhost)
	by praka.san.rr.com (8.12.3/8.12.3/Submit) id h9HJ2jEj011146
	for linux-scsi@vger.kernel.org; Fri, 17 Oct 2003 12:02:45 -0700
Content-Disposition: inline
In-Reply-To: <20031017184147.A2141@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Fri, 17 Oct 2003, Christoph Hellwig wrote:

> Did qlogic give up on the qla driver for 2.6?  Would be sad to see modern
> qlogic HBAs still not supported after you made some nice progress..

No, not give up, just working on getting a solid next release.  Beta 6
adds some additional intelligence to the driver's processing of RSCNs.
Within large SANs the total time required to perform backend fabric
device management can add-up to a significant amount of time (seconds,
sometimes > 20).  These RSCN additions help to minimize fabric management
time by using asynchronous ADISCs and PLOGIs during port-type RSCNs
(translation: least amount of disruption during fabric changes).  IAC,
the driver needs some additional changes to the firmware to support
the processing.  We're expecting a formal firmware drop early next
week, the driver drop will follow after some basic regression tests.

-- 
Andrew Vasquez | praka@san.rr.com |
DSS: 0x508316BB, FP: 79BD 4FAC 7E82 FF70 6C2B  7E8B 168F 5529 5083 16BB
