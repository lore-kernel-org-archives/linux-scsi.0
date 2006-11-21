From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Spinup of SCSI Disks: allow_restart won't work on 2.6.18
Date: Mon, 20 Nov 2006 19:54:08 -0500
Message-ID: <45624E30.5080605@torque.net>
References: <455DF39A.6090209@fbihome.de> <455E2D44.5030903@gmx.de> <455E4703.3080005@s5r6.in-berlin.de> <456188FD.3020108@fbihome.de> <45619611.5020502@s5r6.in-berlin.de> <45622CF5.507@fbihome.de> <45624009.3040208@s5r6.in-berlin.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:162 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1030622AbWKUAyW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Nov 2006 19:54:22 -0500
In-Reply-To: <45624009.3040208@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Joern Quillman <quillman@fbihome.de>, linux-scsi@vger.kernel.org

Stefan Richter wrote:
> Joern Quillman wrote:
>>>> One problem left. I still can't set or unset the flag with echo even
>>>> on 2.6.19-rc6 (as root).
> ...
>> Permissions of the file are -rw-r--r--. Owner is of course root.
>> As I wrote before I can set/unset the flag without any problems when I
>> connect a dumb USB<->IDE
>> converter with kernel 2.6.18. Same with 2.6.19-rc6.
>>
>> The complete error message (sorry it's in german here) is:
>> "-bash: echo: write error: Das Argument ist ungueltig"
>>
>> Is there a way to do some debug on the internals to see why the
>> attribute isn't actually writeable? Do you need parts of the kernel log?
> 
> The responsible kernel code is drivers/scsi/sd.c::sd_store_allow_restart().
> 
> static ssize_t sd_store_allow_restart(struct class_device *cdev, const
> char *buf,
> 				      size_t count)
> {
> 	struct scsi_disk *sdkp = to_scsi_disk(cdev);
> 	struct scsi_device *sdp = sdkp->device;
> 
> 	if (!capable(CAP_SYS_ADMIN))
> 		return -EACCES;
> 
> 	if (sdp->type != TYPE_DISK)
> 		return -EINVAL;
> 
> 	sdp->allow_restart = simple_strtoul(buf, NULL, 10);
> 
> 	return count;
> }
> 
> 
> I think the solution is easy: Replace if (sdp->type != TYPE_DISK) by
> 
> 	if (sdp->type != TYPE_DISK && sdp->type != TYPE_RBC)

... but why have the condition at all? What other peripheral
device type should the _sd_ driver be handling??

Doug Gilbert
