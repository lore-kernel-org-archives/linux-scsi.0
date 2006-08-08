From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Add Promise SuperTrak EX 'stex' driver
Date: Tue, 08 Aug 2006 18:55:35 -0400
Message-ID: <44D91667.8030000@garzik.org>
References: <20060808120507.GA20032@havoc.gtf.org> <1155053479.26517.20.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020804020708050601030104"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:17295 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S965066AbWHHWzj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2006 18:55:39 -0400
In-Reply-To: <1155053479.26517.20.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, promise_linux@promise.com, akpm@osdl.org

This is a multi-part message in MIME format.
--------------020804020708050601030104
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

James Bottomley wrote:
> On Tue, 2006-08-08 at 08:05 -0400, Jeff Garzik wrote:
>> Adds the 'stex' driver for Promise SuperTrak EX storage controllers.
>> These controllers present themselves as SCSI, though like 3ware,
>> megaraid and others, the underlying storage may or may not be SCSI.
>>
>> As discussed, the block tagging stuff is a post-merge todo item.
> 
> That's not exactly my recollection of the discussion:  I thought we were
> still discussing the chicken and egg issue (which is we have APIs to do
> this per host tagging which stex duplicates on the grounds no-one's
> using the current APIs).  Jens and I seem to be in agreement that stex
> should try the API's and well make any changes that become necessary to
> block or SCSI happen.

Please re-read the end of the thread.  The last word was "ok, let's go 
ahead and get this merged."

It is unreasonable to require use of an API that no-one else uses, for 
initial merge.  That has higher potential to take a working driver to a 
non-working state.

If you use the API _after_ the initial merge, then you can easily debug 
the problem with 'git bisect' should the driver stop working.  With your 
suggested path, it causes needless delay and reduces the useful 
information a tester can give us to "it works" or "it doesn't work." 
With my way, the tester can give us "<this> change broke the driver" 
information.

>> +	switch (cmd->cmnd[0]) {
>> > +	case MODE_SENSE_10:
>> > +	{
>> > +		static char mode_sense10[8] = { 0, 6, 0, 0, 0, 0, 0, 0 };
>> > +
>> > +		stex_direct_copy(cmd, mode_sense10, sizeof(mode_sense10));
>> > +		cmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
>> > +		done(cmd);
>> > +		return 0;
>> > +	}
> 
> This looks like it will trick the sd driver into reading uninitialised
> data for the drive caching parameters ... there are obviously faults on
> both sides, but I think when you ask for a mode page and you get a
> success return, you're entitled to think you got it ...

Agreed.


>> +	case INQUIRY:
>> > +		if (id != ST_MAX_ARRAY_SUPPORTED)
>> > +			break;
>> > +		if (lun == 0 && (cmd->cmnd[1] & INQUIRY_EVPD) == 0) {
>> > +			stex_direct_copy(cmd, console_inq_page,
>> > +				sizeof(console_inq_page));
>> > +			cmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
>> > +		} else
>> > +			cmd->result = DID_ERROR << 16 | COMMAND_COMPLETE << 8;
>> > +		done(cmd);
> 
> The error return isn't correct you should never use DID_ERROR for an
> uncorrectable error because it will cause a retry (which you'll fail
> again).  For an unsupported inquiry the correct return should be Check
> Condition/Illegal Request/Invalid Field in CDB

Fixed.


>> > +	case INQUIRY:
>> > +		if (id != ST_MAX_ARRAY_SUPPORTED)
>> > +			break;
>> > +		if (lun == 0 && (cmd->cmnd[1] & INQUIRY_EVPD) == 0) {
>> > +			stex_direct_copy(cmd, console_inq_page,
>> > +				sizeof(console_inq_page));
>> > +			cmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
>> > +		} else
>> > +			cmd->result = DID_ERROR << 16 | COMMAND_COMPLETE << 8;
>> > +		done(cmd);
> 
> The error return here looks like it shouldn't be DID_ERROR either.  I
> assume the error is a format one and uncorrectable by a retry?

There is only one 'case INQUIRY' in the entire driver, so I assume you 
accidentally responded to the same code segment twice.


>> +	}
>> +
>> +	hba->dma_mem = pci_alloc_consistent(pdev,
>> +		STEX_BUFFER_SIZE, &hba->dma_handle);
>> +	if (!hba->dma_mem) {
>> +		err = -ENOMEM;
>> +		printk(KERN_ERR DRV_NAME "(%s): dma mem alloc failed\n",
>> +			pci_name(pdev));
>> +		goto out_iounmap;
>> +	}
> 
> This should be dma_alloc_coherent, not pci_alloc_consistent.

This is perfectly normal and proper in a PCI-only driver.  pci_xxx is 
not a deprecated API, it is a convenience API.

Using dma_xxx only causes needless work.

For the INQUIRY and irq flags fix, I checked in the attached patch to 
'stex' branch of 
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git

	Jeff



--------------020804020708050601030104
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"


commit 43ebb4ccf4bf705e7963b8b7162812a8ebd64e22
Author: Jeff Garzik <jeff@garzik.org>
Date:   Tue Aug 8 18:41:31 2006 -0400

    [SCSI] stex: minor fixes: irq flag, error return value

    - Don't use deprecated SA_SHIRQ irq flag.
    - Return CHECK CONDITION (invalid field in CDB) where warranted.

43ebb4ccf4bf705e7963b8b7162812a8ebd64e22
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index acf626f..f35833a 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -334,6 +334,25 @@ static struct status_msg *stex_get_statu
 	return status;
 }
 
+static void stex_set_sense(struct scsi_cmnd *cmd, u8 sk, u8 asc, u8 ascq)
+{
+	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
+
+	cmd->sense_buffer[0] = 0x70;    /* fixed format, current */
+	cmd->sense_buffer[2] = sk;
+	cmd->sense_buffer[7] = 18 - 8;  /* additional sense length */
+	cmd->sense_buffer[12] = asc;
+	cmd->sense_buffer[13] = ascq;
+}
+
+static void stex_invalid_field(struct scsi_cmnd *cmd,
+			       void (*done)(struct scsi_cmnd *))
+{
+	/* "Invalid field in cbd" */
+	stex_set_sense(cmd, ILLEGAL_REQUEST, 0x24, 0x0);
+	done(cmd);
+}
+
 static struct req_msg *stex_alloc_req(struct st_hba *hba)
 {
 	struct req_msg *req = ((struct req_msg *)hba->dma_mem) +
@@ -533,9 +552,9 @@ stex_queuecommand(struct scsi_cmnd *cmd,
 			stex_direct_copy(cmd, console_inq_page,
 				sizeof(console_inq_page));
 			cmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
+			done(cmd);
 		} else
-			cmd->result = DID_ERROR << 16 | COMMAND_COMPLETE << 8;
-		done(cmd);
+			stex_invalid_field(cmd, done);
 		return 0;
 	case PASSTHRU_CMD:
 		if (cmd->cmnd[1] == PASSTHRU_GET_DRVVER) {
@@ -1122,7 +1141,7 @@ stex_probe(struct pci_dev *pdev, const s
 	hba->pdev = pdev;
 	init_waitqueue_head(&hba->waitq);
 
-	err = request_irq(pdev->irq, stex_intr, SA_SHIRQ, DRV_NAME, hba);
+	err = request_irq(pdev->irq, stex_intr, IRQF_SHARED, DRV_NAME, hba);
 	if (err) {
 		printk(KERN_ERR DRV_NAME "(%s): request irq failed\n",
 			pci_name(pdev));

--------------020804020708050601030104--
