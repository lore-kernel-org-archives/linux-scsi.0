From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: vmw_pscsi: Fix use-after-free in pvscsi_queue_lck()
Date: Thu, 20 Jun 2019 16:35:05 -0400
Message-ID: <yq1zhmcq9l2.fsf@oracle.com>
References: <20190619070541.30070-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190619070541.30070-1-jack@suse.cz> (Jan Kara's message of
        "Wed, 19 Jun 2019 09:05:41 +0200")
Sender: stable-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Jim Gill <jgill@vmware.com>, VMware PV-Drivers <pv-drivers@vmware.com>, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Jan,

> Once we unlock adapter->hw_lock in pvscsi_queue_lck() nothing prevents
> just queued scsi_cmnd from completing and freeing the request. Thus
> cmd->cmnd[0] dereference can dereference already freed request leading
> to kernel crashes or other issues (which one of our customers
> observed). Store cmd->cmnd[0] in a local variable before unlocking
> adapter->hw_lock to fix the issue.

Applied to 5.2/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
