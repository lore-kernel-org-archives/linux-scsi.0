From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi_dh_alua: Fix a reference counting bug
Date: Tue, 01 Nov 2016 13:32:10 -0400
Message-ID: <yq1ziljyulh.fsf@sermon.lab.mkp.net>
References: <bf51a27f-d99f-4a43-867b-0b683ec1784d@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22284 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752872AbcKARc1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2016 13:32:27 -0400
In-Reply-To: <bf51a27f-d99f-4a43-867b-0b683ec1784d@sandisk.com> (Bart Van
        Assche's message of "Tue, 1 Nov 2016 08:19:57 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.de>, tang.junhui@zte.com.cn, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>>>>> "Bart" == Bart Van Assche <bart.vanassche@sandisk.com> writes:

Bart> The code at the end of alua_rtpg_work() is as follows:
Bart> 	scsi_device_put(sdev);
Bart> 	kref_put(&pg->kref, release_port_group);

Bart> In other words, alua_rtpg_queue() must hold an sdev reference and
Bart> a pg reference before queueing rtpg work. If no rtpg work is
Bart> queued no additional references should be held when
Bart> alua_rtpg_queue() returns. If no rtpg work is queued, ensure that
Bart> alua_rtpg_queue() only gives up the sdev reference if that
Bart> reference was obtained by the same alua_rtpg_queue() call.

Applied to 4.9/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
