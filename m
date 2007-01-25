From: Aboo Valappil <aboo@aboo.org>
Subject: Re: Linux Virtual SCSI HBAs and Virtual disks
Date: Fri, 26 Jan 2007 08:41:49 +1100
Message-ID: <45B9241D.5040807@aboo.org>
References: <1e157f74d8578f24c762571c1016aab3@aboo.org> <b43c8fc9882e65d397a6465e6cb7c998@aboo.org> <45B4EAAC.5000008@s5r6.in-berlin.de> <45B60993.9070508@aboo.org> <45B6D18A.8000607@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ppp245-155.static.internode.on.net ([59.167.245.155]:43175 "EHLO
	goobu.aboo.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030601AbXAYVmR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Jan 2007 16:42:17 -0500
In-Reply-To: <45B6D18A.8000607@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org

Hi Doug Gilbert,

I am not sure if my previous email was received or not.
> # ./start_target.sh id=3 -files ../../zz_lun0 -v
> # lsscsi
> [0:0:0:0]    disk    Linux    scsi_debug       0004  /dev/sda
> [1:0:0:0]    disk    VirtualH VHD              0     /dev/sdb
>
> So "id=3" doesn't look the target identifier. If not, what
> is it?
>
>   

Actually it is not the target number, it can have only one target. This 
is just an identification for the scsi_host created inside the kernel. 
If you re-run the same command again with same id, the new process would 
attach to the same scsi_host. This can be seen as two user process 
serving the same virtual host bus adapter.  If use a different id with 
the same lun file, It will create a new scsi_host and it would appear as 
the same LUN on a different host bus adapter.

> Perhaps you could examine the way scsi_debug (or most
> other LLDs) does autosense. This modern technique (used
> for about the last 12 years) relieves the scsi midlevel
> of having to send a follow up REQUEST SENSE.
>   
What would i do if the SCSI target does not return any sense code? I 
make some thing up or just return no-sense? In the new version, I made 
up  SK="Illegal request", ASC="Invalid Opcode" if I do not receive any 
sense from target. But I think I should return  no sense, ie SK=0, 
ASC=0, ASCQ=0. Any thoughts?
> It would be easier to read those SCSI commands in the
> debug output if they were trimmed to their actual lengths
> (e.g. the INQUIRY is 12 00 00 00 24 00).
>   
I will fix this.


Aboo

