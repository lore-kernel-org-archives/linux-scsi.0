From: Mike Christie <michaelc@cs.wisc.edu>
Subject: question about sd_sync_cache and shutdown
Date: Tue, 11 Jul 2006 19:57:45 -0500
Message-ID: <44B44909.1000703@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37251 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932322AbWGLA5l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jul 2006 20:57:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

Currently, if we remove a host, target, transport object like session or
rport or scsi_device sd_shutdown will get called but
scsi_disk_get_from_dev will return NULL and we hit this return statement

static void sd_shutdown(struct device *dev)
{
        struct scsi_device *sdp = to_scsi_device(dev);
        struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);

        if (!sdkp)
                return;         /* this can happen */

The reason is that __scsi_remove_device calls scsi_device_set_state and
sets the state to SDEV_CANCEL then it calls device_del. then when
scsi_disk_get_from_dev is called in sd.c it eventually calls
scsi_device_get which checks if the state is SDEV_CANCEL and it so
returns NULL.

My question is if this a bug or expected behavior? It seems like a bug
because for a orderly removal of some object, like someone shutting down
a iscsi session, we are going to hit that path, but the command will not
get sent. However, for unorderly removal, like ripping out a usb device
or FC rport or iSCSI session being removed due to dev_loss_tmp expiring
then we do not want the command sent. So it seems like it may be
intended behavior.

