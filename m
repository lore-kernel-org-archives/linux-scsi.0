From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] libata: ATA Information VPD page, lk 2.6.14-rc1+
Date: Wed, 05 Oct 2005 11:36:03 -0400
Message-ID: <4343F2E3.9000703@adaptec.com>
References: <432E7C48.8060205@torque.net> <43426A36.8050605@pobox.com> <43436209.1090208@torque.net> <43436763.7010607@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:17282 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S965219AbVJEPgJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Oct 2005 11:36:09 -0400
In-Reply-To: <43436763.7010607@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, htejun@gmail.com

On 10/05/05 01:40, Jeff Garzik wrote:
>>Jeff,
>>This patch was sent on 19 September 2005.
>>Why does a response take so long? [Has Luben's
>>"I request inclusion ..." thread been going that
>>long :-) ] With the passage of time, it takes me
>>longer to rework and retest. Please also consider
>>the submitter's time.

Yes, consider the submitter's name.

> SAT is the primary interface to libata from the outside world.  It's not 
> half-baked at all.

:-^

Related to this patch by Doug:

Jeff, any plans on dropping the SAS code into
the kernel now, so that that big company can start using
it, plus people would start seeing the code, using it
and themselves submitting patches alongside James B,
Christoph and you?

I just think it would be more fare this way to the big
company, and the SCSI community?  I don't mind everyone
submitting patches.

Latest Linus' Git tree + SAS, patches, whatnot:
http://linux.adaptec.com/sas/

Plus there is a lot of relevant information in
the SAS code in reference to _this_ patch by Doug.
(see below)

>>>>+unsigned int ata_scsiop_inq_89(struct ata_scsi_args *args, u8 *rbuf,
>>>>+                   unsigned int buflen)
>>>>+{
>>>>+    struct ata_port *ap;
>>>>+    struct ata_device *dev;
>>>>+    struct scsi_cmnd *cmd = args->cmd;
>>>>+    struct scsi_device *scsidev = cmd->device;
>>>>+    u8 *scsicmd = cmd->cmnd;
>>>>+    unsigned int out_len;
>>>>+    int res;
>>>>+    const int spec_page_len = 568;
>>>>+    u8 b[60];
>>>>+    int is_atapi_dev = 0;
>>>>+
>>>>+    out_len = (scsicmd[3] << 8) + scsicmd[4];
>>>>+    out_len = (buflen < out_len) ? buflen : out_len;
>>>>+    memset(b, 0, sizeof(b));
>>>>+    ap = (struct ata_port *)&scsidev->host->hostdata[0];
>>>>+    if (ap) {
>>>>+        dev = ata_scsi_find_dev(ap, scsidev);
>>>>+        if (dev && (dev->class != ATA_DEV_ATA)) {
>>>
>>>
>>>test dev->class == ATA_DEV_ATAPI, as we may soon add port multiplier
>>>device classes, breaking the assumption you're making here.
>>
>>
>>Ok. Perhaps you could add the appropriate code here
>>since I'm not familiar with what is planned. I just
>>looked at existing ATA code for guidance.
> 
> 
> Change the test to be as I described:
> 
> replace
> 	dev->class != ATA_DEV_ATA
> with
> 	dev->class == ATA_DEV_ATAPI

Doug, Port Multipliers and other exotic ATA devices
are supported in the SAS code.  You can take a look in there
and do similar here.

>>>>+    strncpy(b + 32, "0001", 4);
>>>>+    /* signature stuff goes here, where to fetch it from? */
>>>>+    b[36] = 0x34;        /* FIS type */
>>>>+    b[36 + 1] = 0x0;    /* interrupt + PM port */
>>>>+    b[36 + 4] = 0x1;    /* lba low */
>>>>+    b[36 + 5] = is_atapi_dev ? 0x14 : 0x0;    /* lba mid */
>>>>+    b[36 + 6] = is_atapi_dev ? 0xeb : 0x0;    /* lba high */
>>>>+    b[36 + 12] = 0x1;    /* sector count */
>>>
>>>
>>>this is a sufficient simulation for now.  for the future, when other
>>>devices such as enclosure, port multipliers, and such are supported,
>>>we'll probably want to cache the signature returned by the device.
>>
>>
>>What the draft wanted was a copy of those registers just after the
>>most recent device reset. I do not know how to do this (or if that
>>information is held) so I filled those in from a table of
>>indicative values in the draft.
> 
> 
> As I said, that's fine.
> 
> In order to do what the draft suggests, we should store a copy of struct 
> ata_taskfile in struct ata_device, caching the register values.  That's 
> also fine, if you are motivated to create a further patch.

In the SAS code, upon Domain Discovery, the IDENTIFY (SAS) or
the initial Device-to-host FIS (ATA) is kept in

struct domain_device::frame_rcvd[32]

This is in drivers/include/scsi/sas/sas_discover.h.

struct domain_device describes any device on the domain.

If the ATA device is not directly attached, but behind an
expaner (SAS/SATA bridge), then this info is gotten from
REPORT PHY SATA, in which case struct domain_device::frame_rcvd[32]
keeps the initial d2h FIS (from the RPS), plus the REPORT PHY SATA is
kept in struct domain_device::ata_dev::rps_resp.

Similar functionality can be had in "libata" (ala SATL).

	Luben

