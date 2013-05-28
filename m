From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 0/6] scsi_debug: bug fixes and cleanups for data integrity support
Date: Tue, 28 May 2013 15:40:17 -0400
Message-ID: <yq1k3mi3nby.fsf@sermon.lab.mkp.net>
References: <1369555282-17864-1-git-send-email-akinobu.mita@gmail.com>
	<51A5057F.9030703@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41801 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341Ab3E1TkC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 May 2013 15:40:02 -0400
In-Reply-To: <51A5057F.9030703@interlog.com> (Douglas Gilbert's message of
	"Tue, 28 May 2013 15:29:03 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Doug" == Douglas Gilbert <dgilbert@interlog.com> writes:

Doug> No PI, why not? This was tested on lk 3.9.4 with your patches
Doug> applied.

I've been communicating with Akinobu offline about this.

The reason is that I really only implemented DIX support in
scsi_debug. The dif module parameter is only there to select the
reported protection type.

The main problem with scsi_debug is that it's both initiator and target
in one. And there isn't any notion of a data transfer between the
initiator and the target. We just fill out the scatterlists with stuff
from the in-memory buffer.

To support DIX/DIF correctly we'd have to have the notion of a handoff
between the front and back of scsi_debug. And we'd have to support all
combinations of DIX and DIF with the relevant slicing and dicing of data
and PI buffers.

I have some patches pending as part of my next DIF/DIX update that makes
some of these things more palatable at the block/SCSI level. Akinobu
voiced interest in finishing the scsi_debug work on top of my code.

-- 
Martin K. Petersen	Oracle Linux Engineering
