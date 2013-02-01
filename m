From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: How to online remove an error scsi disk from the system?
Date: Fri, 01 Feb 2013 08:54:06 +0100
Message-ID: <510B749E.8020501@acm.org>
References: <510B5CFC.2040801@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:42167 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687Ab3BAHyL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Feb 2013 02:54:11 -0500
In-Reply-To: <510B5CFC.2040801@tao.ma>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On 02/01/13 07:13, Tao Ma wrote:
> 	In our product system, we have several sata disks attached to one
> machine. So when one of the disk fails, the jbd2(yes, we use ext4) will
> hang forever and we will get something in /var/log/messages like below.
> It seems to me that the io sent to the scsi layer is never returned back
> with -EIO which is a little bit surprised for me(It should be a timeout
> somewhere, right?). We have tried echo "offline" >
> /sys/block/sdl/device/state, but it doesn't work. So is there any way
> for us to let the scsi device returns all the io requests back with EIO
> so that all the end_io can be called accordingly? Am I missing something
> here?

Please note that I'm not familiar with SAS. But I found this in 
drivers/scsi/scsi_proc.c:

  * proc_scsi_write - handle writes to /proc/scsi/scsi
  * @file: not used
  * @buf: buffer to write
  * @length: length of buf, at most PAGE_SIZE
  * @ppos: not used
  *
  * Description: this provides a legacy mechanism to add or remove
  * devices by Host, Channel, ID, and Lun.  To use,
  * "echo 'scsi add-single-device 0 1 2 3' > /proc/scsi/scsi" or
  * "echo 'scsi remove-single-device 0 1 2 3' > /proc/scsi/scsi" with
  * "0 1 2 3" replaced by the Host, Channel, Id, and Lun.

Bart.
