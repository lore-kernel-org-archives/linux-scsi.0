From: Willem Riede <wrlk@riede.org>
Subject: Re: sense buffer not cleaned when retrying failed command by the eh
Date: Mon, 12 Jan 2004 19:26:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040113002656.GW4339@linnie.riede.org>
References: <40028A1A.2030609@il.marvell.com>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc11.comcast.net ([204.127.198.35]:49365 "EHLO
	rwcrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S262687AbUAMA1B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jan 2004 19:27:01 -0500
Received: from linnie.riede.org (localhost.localdomain [127.0.0.1])
	by linnie.riede.org (8.12.10/8.12.10) with ESMTP id i0D0QuEM014209
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2004 19:26:59 -0500
Content-Disposition: inline
In-Reply-To: <40028A1A.2030609@il.marvell.com> (from Saeed.Bishara@il.marvell.com on Mon, Jan 12, 2004 at 06:50:50 -0500)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 2004.01.12 06:50, Saeed Bishara wrote:
> Hello,
>     when the scsi error handler(eh) retries failed command after 
> resetting the bus and sending test unit ready, it doesn't clean the 
> sense buffer. in my case the test unit ready completed successfully but 
> with check condition (reporting bus reset and parameters changed), after 
> then, the eh retried the failed command, and it was completed 
> successfully without check condition, but since the sense buffer was not 
> cleaned, the eh thinks that the sense data for the retried command was 
> valid!
>     the failed command I'm talking about it the INQUIRY that sent by 
> scsi scan, so due the problem described above, the scsi scan decided to 
> but the device offline!
>     I've fixed the problem in my LLD by cleaning the sense buffer when 
> there is no sense data to report, but I do think this should be done by 
> the mid layer.
> 
> I'm using kernel 2.4.20

What about in the 2.6 kernel:

--- drivers/scsi/scsi_lib.c.orig	2004-01-12 18:40:28.000000000 -0500
+++ drivers/scsi/scsi_lib.c	2004-01-12 18:50:22.000000000 -0500
@@ -302,6 +302,7 @@
 void scsi_setup_cmd_retry(struct scsi_cmnd *cmd)
 {
 	memcpy(cmd->cmnd, cmd->data_cmnd, sizeof(cmd->data_cmnd));
+	memset(cmd->sense_buffer, 0, sizeof(cmd->sense_buffer));
 	cmd->request_buffer = cmd->buffer;
 	cmd->request_bufflen = cmd->bufflen;
 	cmd->use_sg = cmd->old_use_sg;


and in the 2.4 kernel:

--- drivers/scsi/scsi_lib.c.orig	2003-12-01 08:27:56.000000000 -0500
+++ drivers/scsi/scsi_lib.c	2004-01-12 18:49:55.000000000 -0500
@@ -223,6 +223,7 @@
 {
 	memcpy((void *) SCpnt->cmnd, (void *) SCpnt->data_cmnd,
 	       sizeof(SCpnt->data_cmnd));
+	memset(SCpnt->sense_buffer, 0, sizeof(SCpnt->sense_buffer));
 	SCpnt->request_buffer = SCpnt->buffer;
 	SCpnt->request_bufflen = SCpnt->bufflen;
 	SCpnt->use_sg = SCpnt->old_use_sg;


Regards, Willem Riede.
