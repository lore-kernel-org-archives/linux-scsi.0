From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/5] [SCSI] scsi_dh_alua: fixes and new dev support
Date: Wed, 05 Jan 2011 16:37:19 -0800
Message-ID: <1294274239.14650.182.camel@haakon2.linux-iscsi.org>
References: <1294261224-12599-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:32777 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464Ab1AFAnS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jan 2011 19:43:18 -0500
In-Reply-To: <1294261224-12599-1-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>

On Wed, 2011-01-05 at 16:00 -0500, Mike Snitzer wrote:
> James,
> 
> I'm sheparding these fixes and new dev support on behalf of Intel,
> Promise and NetApp.  Please review and queue for 2.6.39 if you're OK
> with the changes.
> 
> Thanks,
> Mike
> 
> Ilgu Hong (1):
>   scsi_dh_alua: Add Promise VTrak to dev list
> 
> Joseph Gruher (3):
>   scsi_dh_alua: fix submit_stpg return
>   scsi_dh_alua: fix deadlock in stpg_endio
>   scsi_dh_alua: fix stpg_endio group state reporting
> 
> Mike Snitzer (1):
>   scsi_dh_alua: add scalable ONTAP lun to dev list
> 
>  drivers/scsi/device_handler/scsi_dh_alua.c |   16 ++++++++++------
>  1 files changed, 10 insertions(+), 6 deletions(-)
> 

Hi Mike and James,

Would you mind including the following patch to add support for the
target virtual backends drivers that natively support explict/implict
ALUA to save the extra explict multipath configuration..?

Thanks,

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 6b72932..dbf6c1a 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -731,6 +731,10 @@ static const struct scsi_dh_devlist alua_dev_list[] = {
        {"Intel", "Multi-Flex"},
        {"NETAPP", "LUN"},
        {"AIX", "NVDISK"},
+       {"LIO-ORG", "IBLOCK"},
+       {"LIO-ORG", "FILEIO"},
+       {"LIO-ORG", "RAMDISK-MCP"},
+       {"LIO-ORG", "RAMDISK-DR"},
        {NULL, NULL}
 };
 


