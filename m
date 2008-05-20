From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: max_hw_sectors
Date: Tue, 20 May 2008 15:29:09 -0700
Message-ID: <1211322549.14731.46.camel@haakon2.linux-iscsi.org>
References: <1211286814.4057.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iscsitarget-devel-bounces@lists.sourceforge.net>
In-Reply-To: <1211286814.4057.8.camel@localhost.localdomain>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/iscsitarget-devel>,
	<mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=iscsitarget-devel>
List-Post: <mailto:iscsitarget-devel@lists.sourceforge.net>
List-Help: <mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/iscsitarget-devel>,
	<mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: iscsitarget-devel-bounces@lists.sourceforge.net
Errors-To: iscsitarget-devel-bounces@lists.sourceforge.net
To: blackmagic02881@gmail.com
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi <linux-scsi@vger.kernel.org>, iet-dev <iscsitarget-devel@lists.sourceforge.net>, Christoph Hellwig <hch@lst.de>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
List-Id: linux-scsi@vger.kernel.org

Greetings Ming!

On Tue, 2008-05-20 at 08:33 -0400, Ming Zhang wrote:
> Hi
> 
> See if you can shed a light on this.
> 
> When use the target for exporting a local scsi device to iscsi
> initiator, there is a issue here. linux has a max_hw_sector for each
> device and iscsi ini side have another number. if ini thought this
> device can handle large request, it will send a large request size, then
> how target deal with it?

The target mode engine really has to handle this IMHO.  This ended up
being a requirement for me personally around LIO-Target v1.8 with
megaraid SATA using max_sectors == 128 * 512 Byte sectors (for handling
smaller HW RAID stripe sizes) and Host OS SCSI subsystems on the iSCSI
Initiator side assuming max_sectors == 256 * 512 Byte sectors as default
(and some OSes not having an easy way to change that..)

The method in which LIO-Target Core achieves this for
ICF_SCSI_DATA_SG_IO_CDB is by the se_mem_t linked list memory allocation
logic (used in iscsi_target_transport.c) and Received Initiator CDB
(single CMD) vs. CDB(s) going into LIO Subsystem API (N number of
TASKs).  This design allows for:

1) Any combination of the received CMD's CDB count, and max_hw_sectors a
+ sector_size (if the latter is not legacy 512 Byte sectors) up to the
allowed CmdSN Window depth for a given Initiator Port <-> Target Port
iSCSI Nexus.

2) That said LIO se_mem_t memory, which has been using se_mem_t->page in
v2.9, (no changes to v3.0 just yet for this to become completely >= k.o
v2.6.24 struct scatterlist->page_link modern :) can be either

	a) Allocated as the engine receives traditional iSCSI 
	   PDUs during traditional socket level I/O.

	b) Allocated during LIO target engine passthrough by caller.

	c) That incoming memory into LIO-Core can be preregistered 
           beforehand and ready direct data placement memory buffers 
           (using HW or SW RNICs drivers) can be mapped with all of the
           above requirements.

This model allows for multiple types of SCSI device types, both physical
and virtual from different storage subsystems, and obviously you still
need to emulate the control bits, which are going to be emulated per
SCSI transport specific, yes..?

--nab

> 
> 	


-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft 
Defy all challenges. Microsoft(R) Visual Studio 2008. 
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
