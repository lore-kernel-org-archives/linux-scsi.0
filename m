From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 5/6] aha152x.c - Fix check_condition code-path
Date: Thu, 02 Aug 2007 14:26:47 +0300
Message-ID: <46B1BF77.6060804@panasas.com>
References: <46ACE62F.4070108@panasas.com>	<46ACEA0A.5040101@panasas.com>	<20070730171331.5237bb94.rdunlap@xenotime.net>	<46AEEBF7.3060808@panasas.com>	<20070731114021.488735ec.rdunlap@xenotime.net>	<1185976274.3468.70.camel@localhost.localdomain> <20070801093422.f986597d.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:3422 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753968AbXHBL1O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Aug 2007 07:27:14 -0400
In-Reply-To: <20070801093422.f986597d.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, =?ISO-8859-1?Q?=22J=FC?= =?ISO-8859-1?Q?rgen_E=2E_Fischer=22?= <fischer@norbit.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, "David A. Hinds" <dahinds@users.sourceforge.net>

Randy Dunlap wrote:
> On Wed, 01 Aug 2007 08:51:14 -0500 James Bottomley wrote:
> 
>> On Tue, 2007-07-31 at 11:40 -0700, Randy Dunlap wrote:
>>> On Tue, 31 Jul 2007 10:59:51 +0300 Boaz Harrosh wrote:
>>>
>>>> Randy Dunlap wrote:
>>>>> Since you grok all of that (above), maybe you can help here:
>>>>>
>>>>> With these 6 patches applied, I do the following:
>>>>>
>>>>> 1.  insert PCMCIA aha152x card with SCSI drive attached (/dev/sdb4)
>>>>> 2.  mount -t vfat /dev/sdb4 /mnt/disk
>>>>> 3.  play with /mnt/disk
>>>>> 4.  umount /mnt/disk
>>>>>
>>>>> Now I would like to rmmod the aha152x_cs module, but its use count
>>>>> is 2.  Even if I eject the card, its use count stays at 2.
>>>>> Maybe the reset or check_condition patch doesn't clean up correctly,
>>>>> or one of them isn't releasing a used resource ?
>>>>>
>>>>> (this is 2.6.23-rc1 + your 6 patches + 1 acpi seq-file throttling fix.)
>>>>>
>>>> I had an hard look and a very careful line-by-line compare
>>>> and I can't find anything obvious. Could you do a bisect.
>>>> maybe it will give me a clue as to where to look. Also please
>>>> Enable debug prints. Maybe the driver is stuck at some state 
>>>> and does not exit.
>>> The good news is that this problem has nothing to do with this
>>> patch series.  The bad news is that this problem is there anyway.
I was afraid of that. I will try and see what other PCMCIA drivers
are doing in this situation. It looks like the driver should bailout
much earlier in the event that the card is not present. But it lets
the request in anyway. The original driver was not written for hotplug
PCMCIA maybe that's why.

Please correct me if I'm wrong
1. pccard senses an eject coming and is doing device_unregister()
2. sd.c in sd_shutdown() is doing a Synchronize Cache.
3. The command is queued but since card is not there anymore an interrupt never
   comes and the command is just stuck.

4. After one second an abort comes in an is returned with success (line 1113)
[   88.869051] (scsi-1:-1:-1) (aha152x_internal_queue:1055) unlocked
[   89.884469] (scsi-1:-1:-1) (aha152x_abort:1113) locking

5. Now a Test Unit Ready comes in. Already a good second and more after
   the eject. The card is clearly not powered by now.
   aha152x_internal_queue should check it's own presence. and return 
   appropriate value.
   Two questions:
   a. What should be the return value from a queuecommand handler
      when the card is no longer present?
   b. What should we check to know we no longer have a card?

6. One more second passes and 2nd abort comes in.
7. Than a reset comes in. Here too Should driver check for hardware
   presence.

since ds.c is doing: p_dev->_removed=1;
before the shutdown. Maybe a solution is to have aha152x_stub.c,
which is the only one that knows of PCMCIA, Override queuecommand
and just check for p_dev->_removed==1. Something like:

-------------------------------------------------------------------------------------------------------------
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index d30a307..5fe55d0 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -1062,7 +1063,7 @@ static int aha152x_internal_queue(Scsi_Cmnd *SCpnt, struct completion *complete,
  *  queue a command
  *
  */
-static int aha152x_queue(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
+int aha152x_queue(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
 {
 #if 0
 	if(*SCpnt->cmnd == REQUEST_SENSE) {
diff --git a/drivers/scsi/aha152x.h b/drivers/scsi/aha152x.h
index ac4bfa4..065612f 100644
--- a/drivers/scsi/aha152x.h
+++ b/drivers/scsi/aha152x.h
@@ -333,5 +333,6 @@ struct aha152x_setup {
 struct Scsi_Host *aha152x_probe_one(struct aha152x_setup *);
 void aha152x_release(struct Scsi_Host *);
 int aha152x_host_reset_host(struct Scsi_Host *);
+int aha152x_queue(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *));
 
 #endif /* _AHA152X_H */
diff --git a/drivers/scsi/pcmcia/aha152x_stub.c b/drivers/scsi/pcmcia/aha152x_stub.c
index 370802d..e2f5ea5 100644
--- a/drivers/scsi/pcmcia/aha152x_stub.c
+++ b/drivers/scsi/pcmcia/aha152x_stub.c
@@ -137,6 +137,19 @@ static void aha152x_detach(struct pcmcia_device *link)
 } /* aha152x_detach */
 
 /*====================================================================*/
+static int aha152x_queue_cs(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
+{
+struct pcmcia_device *p_dev;
+struct device *dev = &SCpnt->device->sdev_gendev;
+
+	p_dev = to_pcmcia_dev(dev);
+	if (p_dev->_removed==1)
+		return ENODEV;
+	
+	return aha152x_queue(SCpnt, done);
+}
+
+/*====================================================================*/
 
 #define CS_CHECK(fn, ret) \
 do { last_fn = (fn); if ((last_ret = (ret)) != 0) goto cs_failed; } while (0)
@@ -201,6 +214,7 @@ static int aha152x_config_cs(struct pcmcia_device *link)
 	goto cs_failed;
     }
 
+    host->hostt->queuecommand = aha152x_queue_cs;
     sprintf(info->node.dev_name, "scsi%d", host->host_no);
     link->dev_node = &info->node;
     info->host = host;
-------------------------------------------------------------------------------------------------------------


But you will have to totally check me out on that: to_pcmcia_dev() 
thing above.
And maybe it is plain lobotomy. I wish sd.c could Just signal the
SCSI device that it is on the shutdown path.

Or maybe my original Question. How can a card identify it's un-presence?

>> So on a functionality basis you're prepared to ack this patch set on the
>> basis of empirical testing on the grounds that the bug predates them?
> 
> Yes.  Acked-and-tested-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Thanks.
Thank you Randy.
Boaz

> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***

