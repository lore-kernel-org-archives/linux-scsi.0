From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 0/2] ZBC_OUT command translation fixes
Date: Tue, 26 Jun 2018 16:18:36 +0900
Message-ID: <20180626071838.15140-1-damien.lemoal@wdc.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, Hannes Reinecke <hare@suse.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Tejun,

These two patches fix problems with the checks of the ZBC_OUT command fields
prior to its translation to ZAC MANAGEMENT OUT.

The first patch fixes an incorrect out-of-range check and changes the returned
asc/ascq to the ZBC defined INVALID FIELD IN CDB instead of (the more natural
but incorrect) LBA OUT OF RANGE.

The second patch disables the ZBC_OUT command block address check if the ALL
bit is set, as defined by the ZBC specifications.

Thank you for considering these patches for inclusion in 4.18 fixes (and CC
stable).

Damien Le Moal (2):
  ata: Fix ZBC_OUT command block check
  ata: Fix ZBC_OUT all bit handling

 drivers/ata/libata-scsi.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

-- 
2.17.1
