From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 09/33] scsi: core: reset host byte in DID_NEXUS_FAILURE case
Date: Wed, 13 Mar 2019 15:14:42 -0400
Message-ID: <20190313191506.159677-9-sashal@kernel.org>
References: <20190313191506.159677-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190313191506.159677-1-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Martin Wilck <mwilck@suse.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

[ Upstream commit 4a067cf823d9d8e50d41cfb618011c0d4a969c72 ]

Up to 4.12, __scsi_error_from_host_byte() would reset the host byte to
DID_OK for various cases including DID_NEXUS_FAILURE.  Commit
2a842acab109 ("block: introduce new block status code type") replaced this
function with scsi_result_to_blk_status() and removed the host-byte
resetting code for the DID_NEXUS_FAILURE case.  As the line
set_host_byte(cmd, DID_OK) was preserved for the other cases, I suppose
this was an editing mistake.

The fact that the host byte remains set after 4.13 is causing problems with
the sg_persist tool, which now returns success rather then exit status 24
when a RESERVATION CONFLICT error is encountered.

Fixes: 2a842acab109 "block: introduce new block status code type"
Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_lib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7f505c027ce7..37d366696d21 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -734,6 +734,7 @@ static blk_status_t __scsi_error_from_host_byte(struct scsi_cmnd *cmd,
 		set_host_byte(cmd, DID_OK);
 		return BLK_STS_TARGET;
 	case DID_NEXUS_FAILURE:
+		set_host_byte(cmd, DID_OK);
 		return BLK_STS_NEXUS;
 	case DID_ALLOC_FAILURE:
 		set_host_byte(cmd, DID_OK);
-- 
2.19.1
