From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi_debug: add TPRZ support
Date: Tue, 24 Aug 2010 15:22:09 -0400
Message-ID: <yq1fwy3ke8u.fsf@sermon.lab.mkp.net>
References: <4C72CAF7.8020601@redhat.com> <4C731B08.1060100@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:42120 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab0HXTXZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Aug 2010 15:23:25 -0400
In-Reply-To: <4C731B08.1060100@interlog.com> (Douglas Gilbert's message of
	"Mon, 23 Aug 2010 21:06:16 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: Eric Sandeen <sandeen@redhat.com>, linux-scsi@vger.kernel.org

>>>>> "Doug" == Douglas Gilbert <dgilbert@interlog.com> writes:

Doug,

Doug> SCSI WRITE SAME does have one interesting quirk that Martin may
Doug> like to consider. If the "number of logical blocks" field is zero,
Doug> then that implies write to the end of the LU!! Madness when you
Doug> think about it.  libata's SCSI WRITE SAME translation takes the
Doug> zero number of LBs literally and does nothing I guess (when the
Doug> UNMAP bit is given).

Yeah.  Writing the whole device is one of my pet peeves.  Furthermore,
there are a bunch of devices that have an internal cap on the number of
blocks per WRITE SAME command that isn't advertised anywhere.  Said cap
is lower than the 32-bit block range permitted by WRITE SAME(16).  And
said cap sometimes also applies to the end-of-device case.  I.e. a block
count of 0 only works if you're close enough to the end.  Grrr!

Meanwhile elsewhere the proposal to advertise WRITE SAME limits in the
b0 VPD was gunned down in T10.  I ranted about this situation at length
in Boston.  Too bad you couldn't make it...

Anyway.  We're already bending SBC a bit for our internal use between sd
and libata-scsi.  So I don't consider the "mishandling" of the 0 block
length a problem.  sd would never issue a 0-length WS anyway.

-- 
Martin K. Petersen	Oracle Linux Engineering
