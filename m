From: Brian King <brking@us.ibm.com>
Subject: [PATCH] IBM Power RAID driver - third version
Date: Wed, 25 Feb 2004 15:03:58 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <403D0DBE.4020207@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:30925 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261486AbUBYVEF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Feb 2004 16:04:05 -0500
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

I have uploaded the third version of the ipr device driver to:

http://www-124.ibm.com/storageio/ipr/patch-2.6.3-ipr-2.0.0-6.gz

Major changes:

1. Removed use of bit fields.
2. Removed show_queue_depth since we can use default one.
3. Added FIXME comments to issues still outstanding that
    require midlayer changes
4. Several bug fixes.

Outstanding issues:

1. Driver needs the start_unit patch I submitted in order to function
    properly. This has still not been accepted. A 2.6.3 patch can be
    found at: http://www-124.ibm.com/storageio/ipr/patch-2.6.3-start_unit.gz
2. Driver needs the array_controller patch, which still has not been
    accepted. http://www-124.ibm.com/storageio/ipr/patch-2.6.3-array_controller.gz
3. Still checking allow_cmds flag in queuecommand. ERP ops (e.g. TUR),
    still do not check host_blocked. Patch to force retries to obey
    host_blocked flag has been accepted, will be submitting another
    patch to fix ERP ops. Once this is accepted, I will remove the check.
4. ioa_is_dead flag still exists and is checked in queuecommand. Need to
    add a scsi_set_host_offline interface to change this.
5. res->del_from_ml flag still exists. To remove it requires a
    scsi_set_device_offline interface.
6. Driver is still modifying the command timeout. Once an acceptable
    alternative is agreed upon, this can be cleaned up.

Please apply. I will continue working the outstanding issues and
update the ipr driver along with the rest of the patch.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

