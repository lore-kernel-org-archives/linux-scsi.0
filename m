From: Robert Abel <rabel@techfak.uni-bielefeld.de>
Subject: Re: 3.14: WARNING: sysfs group ffffffff81c50ca0 not found for kobject
 'target5:0:0'
Date: Tue, 27 May 2014 02:21:44 +0200
Message-ID: <5383DA98.5010300@techfak.uni-bielefeld.de>
References: <20140516171842.GA4610@aepfle.de>
Reply-To: rabel@techfak.uni-bielefeld.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51145 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaE0AVq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 May 2014 20:21:46 -0400
In-Reply-To: <20140516171842.GA4610@aepfle.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Hi Olaf,

On 16.05.2014 19:18, Olaf Hering wrote:
> I did unplug an USB stick by accident with 3.14.4, the result is this
> warning:
>
>
> [94414.233882] usb 1-3: USB disconnect, device number 4
> [94414.245377] scsi 5:0:0:0: rejecting I/O to offline device
> [94414.245383] scsi 5:0:0:0: killing request
> [94414.370354] FAT-fs (sdc1): unable to read boot sector to mark fs as 
> dirty
> [94414.370393] ------------[ cut here ]------------
> [94414.370400] WARNING: CPU: 2 PID: 3619 at fs/sysfs/group.c:216 
> sysfs_remove_group+0xa1/0xb0()
> [94414.370403] sysfs group ffffffff81c50ca0 not found for kobject 
> 'target5:0:0'
This [1] might fix the problem you encountered. I reckon one of your 
drivers exposes a binary attribute file in a named attribute group, 
which it tries to remove when being unloaded. However, the path it looks 
for this attribute file is likely wrong.

     [1] http://comments.gmane.org/gmane.linux.kernel/1684070
