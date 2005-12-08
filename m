From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH] OOPS due to clearing eh_action prior to aborting eh	command
Date: Wed, 07 Dec 2005 21:46:27 -0600
Message-ID: <4397AC93.7050500@sgi.com>
References: <43975A8C.2030208@sgi.com> <1133993204.3303.46.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020101060306020108000707"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:63970 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S1030421AbVLHDqt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2005 22:46:49 -0500
In-Reply-To: <1133993204.3303.46.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, James.Smart@Emulex.Com, Jeremy Higdon <jeremy@sgi.com>

This is a multi-part message in MIME format.
--------------020101060306020108000707
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit



James Bottomley wrote:
> On Wed, 2005-12-07 at 15:56 -0600, Michael Reed wrote:
>> During my testing of fc transport attributes for the mpt fusion
>> driver, I came upon this OOPS.  (Actually, I've come upon it
>> too many times.  :(  )
>>
>> Attached is a patch which addresses the issue.  Please give it a look.
> 
> Isn't a better patch simply to copy the eh_action and check it for null
> before completing it?  That will close the done after timeout race.
> 
> James
> 
> 

OK.  Try this.  (I did!)

Mike

--------------020101060306020108000707
Content-Type: text/x-patch;
 name="scsi_error.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_error.patch"

--- a/drivers/scsi/scsi_error.c	2005-12-07 19:14:44.000000000 -0800
+++ b/drivers/scsi/scsi_error.c	2005-12-07 19:13:24.734716721 -0800
@@ -422,10 +422,15 @@
  **/
 static void scsi_eh_done(struct scsi_cmnd *scmd)
 {
+	struct completion     *eh_action;
+
 	SCSI_LOG_ERROR_RECOVERY(3,
 		printk("%s scmd: %p result: %x\n",
 			__FUNCTION__, scmd, scmd->result));
-	complete(scmd->device->host->eh_action);
+
+	eh_action = scmd->device->host->eh_action;
+	if (eh_action)
+		complete(eh_action);
 }
 
 /**

--------------020101060306020108000707--
