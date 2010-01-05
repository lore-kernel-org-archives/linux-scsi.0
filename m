From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH] scsi_dh_rdac: Changing the memory allocation flag from
 GFP_KERNEL to GFP_NOIO
Date: Tue, 5 Jan 2010 10:20:07 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4877BC7E8@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:58842 "HELO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755004Ab0AERVZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Jan 2010 12:21:25 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, Rob Evers <revers@redhat.com>, Chandra Seetharaman <chandra.seetharaman@us.ibm.com>

This patch changes the memory allocation flag from GFP_KERNEL to GFP_NOIO which is more appropriate.

This was noticed by Mike Christie and Rob Evers.. 
Mike Christie wrote:
> Rob Evers wrote:
>> +
>> +static int queue_mode_select(struct scsi_device *sdev,
>> +                activate_complete fn, void *data)
>> +{
>> +    struct rdac_queue_data *qdata;
>> +    struct rdac_controller *ctlr;
>> +
>> +    qdata = kzalloc(sizeof(*qdata), GFP_KERNEL);
>> +    if (!qdata)
>> +        return SCSI_DH_RETRY;
>> +
>
> It looks like this is called in the main IO path. A failed IO could cause, the path to go down,
> then we would call this to active a new path. If the system needed to write out pages to the same
> disk that just had the failed path so it can allocate memory then GFP_KERNEL would be bad to use here.
> You would use a mempool and still use something like GFP_NOIO. If a mempool is not possible for some 
> reason, then you would want to still use GFP_NOIO.

Using mempool would become bit more complex here because I cannot assume about the number of elements
during the allocation. I would use GFP_NOIO.

CC: Mike Christie <michaelc@cs.wisc.edu>
CC: Rob Evers <revers@redhat.com>
CC: Chandra Seetharaman <chandra.seetharaman@us.ibm.com>
Signed-off-by: Babu Moger <babu.moger@lsi.com>

---
--- linux-2.6.33-rc2/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2010-01-05 11:49:22.000000000 -0400
+++ linux-2.6.33-rc2/drivers/scsi/device_handler/scsi_dh_rdac.c	2010-01-05 11:53:13.000000000 -0400
@@ -624,7 +624,7 @@ static int queue_mode_select(struct scsi
 	struct rdac_queue_data *qdata;
 	struct rdac_controller *ctlr;
 
-	qdata = kzalloc(sizeof(*qdata), GFP_KERNEL);
+	qdata = kzalloc(sizeof(*qdata), GFP_NOIO);
 	if (!qdata)
 		return SCSI_DH_RETRY;
 


