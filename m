From: Douglas Gilbert <dougg@torque.net>
Subject: Re: libata & scsi error handling
Date: Wed, 18 Aug 2004 15:11:39 +1000
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <4122E50B.209@torque.net>
References: <4122771A.4070203@wasp.net.au> <4122BA04.3070705@pobox.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000806030008090604000506"
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4122BA04.3070705@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Brad Campbell <brad@wasp.net.au>, linux-ide@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------000806030008090604000506
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Jeff Garzik wrote:
> Brad Campbell wrote:
> 
>> I think I have this timeout error issue pegged now.
>>
>> I know this is both wrong, ugly and likely to cause internal kernel 
>> damage, but for the purpose of pegging what I think may be the culprit 
>> it works around the error nicely here
>>
>> brad@srv:/usr/src$ diff -u 
>> temp/linux-2.6.8.1/drivers/scsi/libata-scsi.c 
>> linux-2.6.8.1/drivers/scsi/libata-scsi.c
>> --- temp/linux-2.6.8.1/drivers/scsi/libata-scsi.c       2004-08-14 
>> 14:55:19.000000000 +0400
>> +++ linux-2.6.8.1/drivers/scsi/libata-scsi.c    2004-08-18 
>> 01:04:11.000000000 +0400
>> @@ -213,6 +213,7 @@
>>
>>         ap = (struct ata_port *) &host->hostdata[0];
>>         ap->ops->eng_timeout(ap);
>> +       host->host_failed--;
>>
>>         DPRINTK("EXIT\n");
>>         return 0;
>>
>> The issue is that the libata installed eh_strategy_handler does not 
>> complete the error as
>> scsi_unjam_host -> scsi_eh_abort_cmds -> scsi_eh_finish_cmd does.
> 
> 
> 
> Well, well, well.  If I had a libata Honorary Hacker merit badge, I 
> would give it to you.
> 
> It is highly likely that your patch is doing the right thing.  Doug 
> Ledford, 2.4.x SCSI maintainer, pointed out to me recently that my 2.4.x 
> error handling code MUST update a couple variables, otherwise error 
> handling would hang as you see.  The reason is that scsi_unjam_host(), 
> on both 2.4.x and 2.6.x, is the only ->eh_strategy_handler until libata 
> came along.
> 
> So, it is likely that there are a few details the scsi_unjam_host() 
> performs, that needs to do too.
> 
> Thanks much for your excellent detective work, I'll see where to best 
> put this change...

Jeff,
It probably doesn't rate any gold stars but while your patching
libata-scsi.c could you slip this fix in as well.

The patch is against lk 2.6.8.1 . The same patch is needed
(give or take fuzz) in lk 2.4.27 .

Changes:
    - send vendor, product and rev strings back for 36 byte
      INQUIRYs
    - set the additional length field to indicate 96 byte
      response is available

Doug Gilbert

--------------000806030008090604000506
Content-Type: text/x-patch;
 name="libata-scsi2681.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libata-scsi2681.diff"

--- linux/drivers/scsi/libata-scsi.c	2004-08-14 21:12:42.000000000 +1000
+++ linux/drivers/scsi/libata-scsi.c2681dpg	2004-08-17 22:00:59.501464824 +1000
@@ -534,7 +534,7 @@
 		0,
 		0x5,	/* claim SPC-3 version compatibility */
 		2,
-		96 - 4
+		95 - 4
 	};
 
 	/* set scsi removeable (RMB) bit per ata bit */
@@ -545,7 +545,7 @@
 
 	memcpy(rbuf, hdr, sizeof(hdr));
 
-	if (buflen > 36) {
+	if (buflen > 35) {
 		memcpy(&rbuf[8], "ATA     ", 8);
 		ata_dev_id_string(dev, &rbuf[16], ATA_ID_PROD_OFS, 16);
 		ata_dev_id_string(dev, &rbuf[32], ATA_ID_FW_REV_OFS, 4);

--------------000806030008090604000506--
