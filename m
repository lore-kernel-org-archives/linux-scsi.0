From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [patch 1/1] sd_dif: problem with verify of type 1 protection information (PI)
Date: Wed, 24 Apr 2013 21:50:40 -0400
Message-ID: <yq1d2tjtm33.fsf@sermon.lab.mkp.net>
References: <20130418095523.GA73004@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21668 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261Ab3DYBuW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Apr 2013 21:50:22 -0400
In-Reply-To: <20130418095523.GA73004@sgi.com> (Jeremy Higdon's message of
	"Thu, 18 Apr 2013 02:55:23 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: linux-scsi@vger.kernel.org, mdr@sgi.com

>>>>> "Jeremy" == Jeremy Higdon <jeremy@sgi.com> writes:

Jeremy> It appears to me that there is a problem with handling of type 1
Jeremy> protection information.  It is considering a logical block
Jeremy> reference tag of 0xffffffff to be an error, but it is actually
Jeremy> valid any time ((lba & 0xffffffff) == 0xffffffff) [for example,
Jeremy> 2TiB-1, 4TiB-1, 6TiB-1, etc.].

Yes, that's a bogus check. It's actually one I put in way back to debug
a faulty device and forgot to back out. My DIF test tooling does not
rely on the block layer generate/verify functions so I never noticed.

The same issue was reported recently by Keith Busch.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
