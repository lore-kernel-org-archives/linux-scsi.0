From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qla2xxx: deadlock by configfs_depend_item
Date: Wed, 19 Dec 2018 21:27:23 -0500
Message-ID: <yq1tvj9exv8.fsf@oracle.com>
References: <1544140125-3060-1-git-send-email-glagolig@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1544140125-3060-1-git-send-email-glagolig@gmail.com> (Anatoliy
        Glagolev's message of "Thu, 6 Dec 2018 16:48:45 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Anatoliy Glagolev <glagolig@gmail.com>
Cc: aglagolev@purestorage.com, adailey@purestorage.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, hch@lst.de, qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Anatoliy,

> The intent of invoking configfs_depend_item in commit 7474f52a82d51
> ("tcm_qla2xxx: Perform configfs depend/undepend for base_tpg") was to
> prevent a physical Fibre Channel port removal when virtual (NPIV)
> ports announced through that physical port are active.  The change
> does not work as expected: it makes enabled physical port dependent on
> target configfs subsystem (the port's parent), something the configfs
> guarantees anyway.
>
> Besides, scheduling work in a worker thread and waiting for the work's
> completion is not really a valid workaround for the requirement not to
> call configfs_depend_item from a configfs callback: the call
> occasionally deadlocks.
>
> Thus, removing configfs_depend_item calls does not break anything and
> fixes the deadlock problem.

Applied to 4.21/scsi-queue, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
