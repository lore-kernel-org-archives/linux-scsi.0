From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: ufs: add ioctl interface for query request
Date: Thu, 9 Apr 2015 23:17:55 +0300
Message-ID: <20150409201755.GA9651@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35518 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933332AbbDIUSL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Apr 2015 16:18:11 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: draviv@codeaurora.org
Cc: linux-scsi@vger.kernel.org

Hello Dolev Raviv,

The patch 4aca8e8975db: "ufs: add ioctl interface for query request"
from Mar 12, 2015, leads to the following Smatch warning:

	drivers/scsi/ufs/ufshcd.c:4386 ufshcd_query_ioctl()
	warn: maybe return -EFAULT instead of the bytes remaining?

drivers/scsi/ufs/ufshcd.c
  4364          /* copy to user */
  4365          err = copy_to_user(buffer, ioctl_data,
  4366                          sizeof(struct ufs_ioctl_query_data));
  4367          if (err)
  4368                  dev_err(hba->dev, "%s: Failed copying back to user.\n",
  4369                          __func__);

copy_to/from_user() returns the number of bytes not copied and not an
error code.  Printing these error messages in the ioctl means the user
can trigger a DoS by filling up /var/log/messages.  They make the code
uglier.  We should stop here if the copy fails and goto out_release_mem
otherwise we might end up returning success by mistake.

The normal way to do it is:

	if (copy_to_user(buffer, ioctl_data,
			 sizeof(struct ufs_ioctl_query_data))) {
		err = -EFAULT;
		goto out_release_mem;
	}

  4370          err = copy_to_user(buffer + sizeof(struct ufs_ioctl_query_data),
  4371                          data_ptr, ioctl_data->buf_size);
  4372          if (err)
  4373                  dev_err(hba->dev, "%s: err %d copying back to user.\n",
  4374                                  __func__, err);
  4375          goto out_release_mem;
  4376  
  4377  out_einval:
  4378          dev_err(hba->dev,
  4379                  "%s: illegal ufs query ioctl data, opcode 0x%x, idn 0x%x\n",
  4380                  __func__, ioctl_data->opcode, (unsigned int)ioctl_data->idn);
  4381          err = -EINVAL;
  4382  out_release_mem:
  4383          kfree(ioctl_data);
  4384          kfree(desc);
  4385  out:
  4386          return err;
  4387  }

regards,
dan carpenter
