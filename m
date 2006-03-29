From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 1/2] scsi: Add scsi_device max_cmd_len
Date: Tue, 28 Mar 2006 22:42:03 -0600
Message-ID: <442A101B.4070209@us.ibm.com>
References: <200603282217.k2SMHJTH032251@d03av04.boulder.ibm.com>	 <1143584967.3353.47.camel@mulgrave.il.steeleye.com>	 <4429BB02.80304@us.ibm.com>	 <1143586146.3353.51.camel@mulgrave.il.steeleye.com>	 <4429CEB4.4050608@us.ibm.com> <1143591144.3353.55.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1143591144.3353.55.camel@mulgrave.il.steeleye.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> Well, no, not scsi transport; I think just a general transport ... see
> the raid_class for an example of one of these (albeit not very related
> to what you want to do, I'm afraid).
> 
> technically, you can have multiple transports per device, even with SCSI
> ones.  It's just convenient to simplify the single attachement case
> since that's the predominant one.
> 
> The key is in the match function.  Given a generic device, you have to
> know how to verify its a device of the type you want.

 From what I understand, it looks like I should be creating a sata_class
transport of sorts, which would attach to scsi_hosts that support SATA
and would contain SATA host related attributes. It would also provide
APIs such as sata_dev_alloc, sata_dev_add, similar to sas_phy_alloc,
and sas_phy_add, which would be called by external users to attach
SATA devices to the upper layers. sata_dev_add would result in
the device getting hooked into libata and getting added to scsi core,
etc. There could then also be per-device hooks/attributes in the
sata_class transport as appropriate.

However, since scsi core is the one that checks max_cmd_len,
scsi core would somehow need to be able to poke into the sata host
transport attribute to decide whether or not to accept the command.
Probably an addition to struct scsi_transport_template?

This is quite a change from the patchset I have been carrying
for the past 5 months or so to add SATA support to ipr. The
current ipr patch to add this support can be found here:

http://marc.theaimsgroup.com/?l=linux-scsi&m=114263741229458&w=2

It requires no change to scsi core other than the patch we are
discussing (which could technically also be done in libata),
and requires minimal libata changes. I'm happy to start coding
up a sata_class, but is there any chance of this being a phase
2 solution, and for the interim we proceed with something closer
to what I have been submitting to the list for the past 5 months?
I'm happy to drop the patch that started this thread if that helps.
Would you be OK with the ipr patch in the URL above as an interim
solution?

Thanks,

Brian

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
