From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] lpfc: Fix race on command completion
Date: Tue, 19 Jan 2016 19:40:40 -0500
Message-ID: <yq1k2n5qe0n.fsf@sermon.lab.mkp.net>
References: <1452851303-89378-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:25891 "EHLO
	aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932776AbcATAly (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jan 2016 19:41:54 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
	by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u0K0fqHd002291
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 20 Jan 2016 00:41:53 GMT
In-Reply-To: <1452851303-89378-1-git-send-email-hare@suse.de> (Hannes
	Reinecke's message of "Fri, 15 Jan 2016 10:48:23 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> Upon command completion the lpfc driver would call ->done() on
Hannes> the scsi command before taking the host lock and releasing the
Hannes> command internally.  This opens up a race window there this
Hannes> command might be re-used after ->done(), leading to a double
Hannes> completion on the same command.

Hannes> This patch takes the host lock before accessing the scsi
Hannes> command, and disconnect the internal command under the same
Hannes> lock.

James/Dick: Please review.

-- 
Martin K. Petersen	Oracle Linux Engineering
