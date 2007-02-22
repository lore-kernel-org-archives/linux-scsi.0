From: Douglas Gilbert <dougg@torque.net>
Subject: Re: program inquiry is using a deprecated scsi_ioctl , please	convert
 it to SG_IO
Date: Thu, 22 Feb 2007 18:59:37 -0500
Message-ID: <45DE2E69.70201@torque.net>
References: <8862659.post@talk.nabble.com>	 <1170946255.3766.18.camel@mulgrave.il.steeleye.com>	 <868c9d9d0702202233pa206222jb9beb85d60089003@mail.gmail.com>	 <1172078268.3335.29.camel@mulgrave.il.steeleye.com>	 <868c9d9d0702212229p2e1a39ek9b73813899f18645@mail.gmail.com> <1172182531.3378.41.camel@mulgrave.il.steeleye.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:40076 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbXBVX7m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Feb 2007 18:59:42 -0500
In-Reply-To: <1172182531.3378.41.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: MASTHAN DUDEKULA <d.mastan@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Thu, 2007-02-22 at 11:59 +0530, MASTHAN DUDEKULA wrote:
>> Hi JAMES,
>>  
>>  
>> The following code is SG_IO equivalent of scsi ioctls
>> SCSI_TEST_UNIT_READY
>>  
>>    unsigned char sense_b[32];
>>     unsigned char turCmbBlk[] = {0x00, 0, 0, 0, 0, 0};
>>     struct sg_io_hdr io_hdr; 
>>
>>     memset(&io_hdr, 0, sizeof(struct sg_io_hdr));
>>     io_hdr.interface_id = 'S';
>>     io_hdr.cmd_len = sizeof(turCmbBlk);
>>     io_hdr.mx_sb_len = sizeof(sense_b);
>>     io_hdr.dxfer_direction = SG_DXFER_NONE;
>>     io_hdr.cmdp = turCmbBlk;
>>     io_hdr.sbp = sense_b;
>>     io_hdr.timeout = DEF_TIMEOUT;
>>
>>     if (ioctl(fd, SG_IO, &io_hdr) < 0) {
>>  
>> Like this What is the SG_IO equivalent for SCSI_IOCTL_SCSI_COMMAND ?

Judging from the above you have found some sg3_utils
code. In a recent version, if you go to the "examples"
subdirectory, you will find the scsi_inquiry.c and
sg_simple1.c files.
The former shows the usage of the older, deprecated
SCSI_IOCTL_SCSI_COMMAND ioctl while the latter does something
very similar but uses the SG_IO ioctl interface.

The equivalence is that they both programs send a SCSI
INQUIRY cdb to a device and print out the response.

Doug Gilbert

> I don't understand your question ... SCSI_IOCTL_SEND_COMMAND sends a
> SCSI command to the device.  Your example of test unit ready above does
> just that ... it sends a Test Unit Ready command to the device using
> SG_IO ... exactly what do you not understand about using SG_IO to send
> commands to the device?
> 
> James

