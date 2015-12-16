From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: kernel BUG at block/bio.c:1787! while initializing scsi_debug on ppc64 host
Date: Tue, 15 Dec 2015 20:37:14 -0500
Message-ID: <yq1si33uqb9.fsf@sermon.lab.mkp.net>
References: <20151211115340.GB19209@eguan.usersys.redhat.com>
	<20151215112057.GC19209@eguan.usersys.redhat.com>
	<CACVXFVOPgONuXjGhBnFVxuRVr+=LFe36QR-VTGVvTkEK+V0JLw@mail.gmail.com>
	<20151215130631.GD19209@eguan.usersys.redhat.com>
	<yq1egenwons.fsf@sermon.lab.mkp.net>
	<CACVXFVPEK4TM9XtY-WGs=9--3NvxpsO8au+L2ex5xKKpHpdM-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48974 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486AbbLPBhS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2015 20:37:18 -0500
In-Reply-To: <CACVXFVPEK4TM9XtY-WGs=9--3NvxpsO8au+L2ex5xKKpHpdM-g@mail.gmail.com>
	(Ming Lei's message of "Wed, 16 Dec 2015 09:17:43 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Eryu Guan <guaneryu@gmail.com>, Linux SCSI List <linux-scsi@vger.kernel.org>

>>>>> "Ming" == Ming Lei <tom.leiming@gmail.com> writes:

Ming,

Ming> No, it can't.

Well, it fixes a problem on one of my test systems where max_ws_blocks,
by virtue of being 64 bits, clobbers opt_xfer_blocks causing rw_len and
thus max_sectors to be set incorrectly.

We haven't run into that issue on real hardware. Probably because
scsi_debug is the only driver reporting $LUDICROUS_NUMBER as the max hw
transfer.

Ming> As the debug log shows, it is because you use 'OPTIMAL TRANSFER
Ming> LENGTH' to set queue's max_sectors.

But that is intentional.

I agree that the value chosen by scsi_debug in this case is very low and
we should fix that.

-- 
Martin K. Petersen	Oracle Linux Engineering
