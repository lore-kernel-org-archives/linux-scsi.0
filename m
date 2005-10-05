From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] libata: ATA Information VPD page, lk 2.6.14-rc1+
Date: Wed, 05 Oct 2005 01:40:51 -0400
Message-ID: <43436763.7010607@pobox.com>
References: <432E7C48.8060205@torque.net> <43426A36.8050605@pobox.com> <43436209.1090208@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <43436209.1090208@torque.net>
Sender: linux-ide-owner@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, htejun@gmail.com
List-Id: linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> Jeff Garzik wrote:
> 
>>Douglas Gilbert wrote:
>>
>>
>>>Jeff,
> 
> <snip>
> 
>>>Changelog:
>>>  - add support for the ATA Information VPD page [0x89]
>>>  - add function to redo IDENTIFY (PACKET) DEVICE ATA
>>>    command to update the array dev->id, assumes
>>>    ata_dev_identify() has been called.
>>
>>
>>Basic idea OK, patch rejected due to the following concerns.  Please
>>resend an updated patch.
> 
> 
> Jeff,
> This patch was sent on 19 September 2005.
> Why does a response take so long? [Has Luben's
> "I request inclusion ..." thread been going that
> long :-) ] With the passage of time, it takes me
> longer to rework and retest. Please also consider
> the submitter's time.
> 
> IMO you are quite capable of making the changes
> that you are now requesting me to make ... but
> I'll have another shot ...
> 
> In the last year or so I have suggested around
> twenty libata patches and bug fixes which have
> resulted in large signal_to_noise and ignore_or_reject
> ratios. Progress seems glacial in terms of SCSI
> support. Others have submitted more code than me.
> What happened to the ATA PASS THROUGH SCSI commands?
> [I would like to use them in smartmontools, hdparm
> is coded for them.] My suspicion is that SAT layer in
> libata is being maintained "half-baked" so it can be
> displaced more easily when the "emulation is bad"
> policy is implemented some time in the future.
> Makes it hard to get motivated to (re-)roll another
> SAT libata patch.

SAT is the primary interface to libata from the outside world.  It's not 
half-baked at all.

ATA passthru support has been in Andrew Morton's -mm kernels for months, 
by virtue of being automatically pulled in from the 'passthru' branch I 
actively maintained in 
rsync://rsync.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git

WRT patches, I just don't have time to hand-edit the useful parts out of 
everybody's patches.  I review, and then run a script to merge your 
patch into the git repository.  This is exactly how Linus works as well. 
  He hand-edits maybe one or two patches a month, and only minor edits 
to get the patches to apply.

This is why I am _begging_ you to split up your patches.  When each one 
of your submissions contains <N> changes, that exponentially increases 
the review time of that patch, and as such, increases the likelihood 
that it will need revisions.

If you will split up your changes into very fine-grained pieces, the 
entire process goes a lot faster, and your changes will make it into the 
kernel with a minimum of fuss, and a maximum speed.

Examples of patches (one patch per email) you could create:

* create ata_scsi_set_sense()
* use ata_scsi_set_sense() in existing code
* simplifications found after using ata_scsi_set_sense()
* move MODE SENSE control page defaults into individual variables 
(def_control_mode_page, etc.) for use by future patches

The issue is not patch size.  The issue is splitting up logical changes 
into multiple successive patches.

If you split up your libata patches, I promise I will merge them rapidly.


>>>@@ -1059,6 +1137,79 @@
>>> }
>>> 
>>> /**
>>>+ *    ata_scsiop_inq_89 - Simulate INQUIRY EVPD page 83, ATA information
>>>+ *    @args: device IDENTIFY data / SCSI command of interest.
>>>+ *    @rbuf: Response buffer, to which simulated SCSI cmd output is
>>>sent.
>>>+ *    @buflen: Response buffer length.
>>>+ *
>>>+ *    Yields ATA (and SAT layer) information. Defined per sat-r05
>>>+ *    This function should also be called for S-ATAPI devices.
>>>+ *
>>>+ *    LOCKING:
>>>+ *    spin_lock_irqsave(host_set lock)
>>>+ */
>>>+
>>>+unsigned int ata_scsiop_inq_89(struct ata_scsi_args *args, u8 *rbuf,
>>>+                   unsigned int buflen)
>>>+{
>>>+    struct ata_port *ap;
>>>+    struct ata_device *dev;
>>>+    struct scsi_cmnd *cmd = args->cmd;
>>>+    struct scsi_device *scsidev = cmd->device;
>>>+    u8 *scsicmd = cmd->cmnd;
>>>+    unsigned int out_len;
>>>+    int res;
>>>+    const int spec_page_len = 568;
>>>+    u8 b[60];
>>>+    int is_atapi_dev = 0;
>>>+
>>>+    out_len = (scsicmd[3] << 8) + scsicmd[4];
>>>+    out_len = (buflen < out_len) ? buflen : out_len;
>>>+    memset(b, 0, sizeof(b));
>>>+    ap = (struct ata_port *)&scsidev->host->hostdata[0];
>>>+    if (ap) {
>>>+        dev = ata_scsi_find_dev(ap, scsidev);
>>>+        if (dev && (dev->class != ATA_DEV_ATA)) {
>>
>>
>>test dev->class == ATA_DEV_ATAPI, as we may soon add port multiplier
>>device classes, breaking the assumption you're making here.
> 
> 
> Ok. Perhaps you could add the appropriate code here
> since I'm not familiar with what is planned. I just
> looked at existing ATA code for guidance.

Change the test to be as I described:

replace
	dev->class != ATA_DEV_ATA
with
	dev->class == ATA_DEV_ATAPI



>>>+    strncpy(b + 32, "0001", 4);
>>>+    /* signature stuff goes here, where to fetch it from? */
>>>+    b[36] = 0x34;        /* FIS type */
>>>+    b[36 + 1] = 0x0;    /* interrupt + PM port */
>>>+    b[36 + 4] = 0x1;    /* lba low */
>>>+    b[36 + 5] = is_atapi_dev ? 0x14 : 0x0;    /* lba mid */
>>>+    b[36 + 6] = is_atapi_dev ? 0xeb : 0x0;    /* lba high */
>>>+    b[36 + 12] = 0x1;    /* sector count */
>>
>>
>>this is a sufficient simulation for now.  for the future, when other
>>devices such as enclosure, port multipliers, and such are supported,
>>we'll probably want to cache the signature returned by the device.
> 
> 
> What the draft wanted was a copy of those registers just after the
> most recent device reset. I do not know how to do this (or if that
> information is held) so I filled those in from a table of
> indicative values in the draft.

As I said, that's fine.

In order to do what the draft suggests, we should store a copy of struct 
ata_taskfile in struct ata_device, caching the register values.  That's 
also fine, if you are motivated to create a further patch.


> "Since some fields within the IDENTIFY DEVICE and IDENTIFY PACKET
> DEVICE may change depending on the state of the attached ATA
> device the SATL shall issue the IDENTIFY DEVICE or IDENTIFY
> PACKET DEVICE command to retrieve the updated data whenever the
> ATA Information VPD page is requested." [sat-r06, section 10.3.5
> page 84, describing that field]

Each time the ATA device's state changes, dev->id needs to be updated. 
And it doesn't change randomly, only when initiated by further libata 
actions.

Thus, dev->id is defined as always containing the most current IDENTIFY 
[PACKET] DEVICE page.  If it does not, that problem should be addressed 
in the area of libata that initiated the state change, _not_ papered 
over by SATL.


> Well that seems pretty clear to me. When I write apps like sdparm
> and sg_inq then I would feel confident documenting that the most
> up to date response data will be fetched irrespective of the
> the transport and the topology. As I have pointed out on
> another thread, the presence of multiple initiators in SAS with
> the STP makes caching device state problematic. STP affiliations
> seem only to span a single connection which at best stops
> co-incident ATA commands interfering with one another, however
> they won't help if 2 hosts (initiators) send contradictory SET
> FEATURE commands, one soon after the other.

If ATA device state is not accurately cached, you get data corruption. 
By definition it -must- be accurate at all times, otherwise the hardware 
will be programmed incorrectly.  This is why we must snoop the ATA 
passthru command.

Welcome to ATA :)


> As discussed in relation to the implementation of the MODE
> SELECT SCSI command (to change SATA disk attributes), there
> is a need for a function like ata_dev_redo_identify() anyway.
> If there is another function to do this (and for that matter
> a way for the userspace to resync the dev->id array), perhaps
> you could point it out to me.

Tejun posted a patch that illustrates doing multiple ATA commands from 
within SATL.  Message id <20050830062556.GA13245@htj.dyndns.org>, and 
you were even in the To: header.

	Jeff

