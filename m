From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: PATCH [2/18]  qla2xxx: Correct residual counts
Date: Tue, 22 Jun 2004 07:17:20 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B0DD027C@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:7254 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S264067AbUFVOTc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jun 2004 10:19:32 -0400
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: arjanv@redhat.com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>


On Tuesday, June 22, 2004 12:07 AM, Arjan van de Ven wrote:
> On Tue, 2004-06-22 at 07:49, Andrew Vasquez wrote:
> 
> > diff -Nru a/drivers/scsi/qla2xxx/qla_iocb.c
> b/drivers/scsi/qla2xxx/qla_iocb.c
> > --- a/drivers/scsi/qla2xxx/qla_iocb.c	2004-06-21 15:36:37 -07:00
> > +++ b/drivers/scsi/qla2xxx/qla_iocb.c	2004-06-21 15:36:37 -07:00 @@
> >  	-43,7 +43,7 @@ else if (cmd->sc_data_direction ==
> >  	DMA_FROM_DEVICE)  		cflags = CF_READ; else {
> > -		switch (cmd->data_cmnd[0]) {
> > +		switch (cmd->cmnd[0]) {
> >  		case WRITE_6:
> >  		case WRITE_10:
> >  		case WRITE_12:
> 
> this sounds wrong.
>

Yes, it is _wrong_!   This code is baggage left behind from earlier
drivers when we were 'asked' to work around certain applications'
inability to properly construct commands.

> Is there any reason qlogic drivers can't use/trust the midlayer
> instead of doing qla2x00_get_cmd_direction() to reverse engineer to
> direction ??

Sure.  Especially considering an earlier thread:

	http://marc.theaimsgroup.com/?t=108727983000002&r=1&w=2

Regards,
Andrew Vasquez

===== drivers/scsi/qla2xxx/qla_iocb.c 1.9 vs edited =====
--- 1.9/drivers/scsi/qla2xxx/qla_iocb.c	2004-06-03 15:44:16 -07:00
+++ edited/drivers/scsi/qla2xxx/qla_iocb.c	2004-06-22 07:11:11 -07:00
@@ -42,28 +42,6 @@
 		cflags = CF_WRITE;
 	else if (cmd->sc_data_direction == DMA_FROM_DEVICE)
 		cflags = CF_READ;
-	else {
-		switch (cmd->cmnd[0]) {
-		case WRITE_6:
-		case WRITE_10:
-		case WRITE_12:
-		case WRITE_BUFFER:
-		case WRITE_LONG:
-		case WRITE_SAME:
-		case WRITE_VERIFY:
-		case WRITE_VERIFY_12:
-		case FORMAT_UNIT:
-		case SEND_VOLUME_TAG:
-		case MODE_SELECT:
-		case SEND_DIAGNOSTIC:
-		case MODE_SELECT_10:
-			cflags = CF_WRITE;
-			break;
-		default:
-			cflags = CF_READ;
-			break;
-		}
-	}
 	return (cflags);
 }
 
