From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [ANNOUNCE]: Generic SCSI Target Mid-level For Linux (SCST),
	target drivers for iSCSI and QLogic Fibre Channel cards released
Date: Tue, 08 Jul 2008 14:09:14 -0700
Message-ID: <1215551354.3977.6.camel@haakon2.linux-iscsi.org>
References: <4873BCA5.10103@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752699AbYGHVJe@vger.kernel.org>
In-Reply-To: <4873BCA5.10103@vlnb.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, nab@kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Vlad,

On Tue, 2008-07-08 at 23:14 +0400, Vladislav Bolkhovitin wrote:
> I'm glad to announce that version 1.0.0 of Generic SCSI Target Middle 
> Level for Linux (SCST) was released and available for download from 
> http://scst.sourceforge.net/downloads.html
> 

Congratulations on reaching your v1.0.0 release!

> SCST is a subsystem of the Linux kernel that provides a standard 
> framework for SCSI target drivers development. It is designed to provide 
> unified, consistent interface between SCSI target drivers and Linux 
> kernel and simplify target drivers development as much as possible. It 
> has the following main features:
> 
>      *  Simple, easy to use interface with target drivers. Particularly, 
> SCST core performs required pre- and post- processing of incoming 
> requests as well as necessary error recovery.
> 
>      * Undertakes most problems, related to execution contexts, thus 
> practically eliminating one of the most complicated problem in the 
> kernel drivers development. For example, a target driver for QLogic 
> 22xx/23xx cards, which has all necessary features, is only about 2000 
> lines of code long.
> 
>      * Very low overhead, fine-grained locks and simplest commands 
> processing path, which allow to reach maximum possible performance and 
> scalability. Particularly, incoming requests can be processed in the 
> caller's context or in one of the internal SCST core's tasklets, 
> therefore no extra context switches required.
> 
>      * Device handlers, i.e. plugins, architecture provides extra 
> flexibility by allowing various I/O modes in backstorage handling. For 
> example, pass-through device handlers allow to use real SCSI hardware 
> and vdisk device handler allows to use files as virtual disks.
> 
>      * Provides advanced per-initiator devices visibility management 
> (LUN masking), which allows different initiators to see different set of 
> devices with different access permissions. For instance, initiator A 
> could see exported from target T devices X and Y read-writable, and 
> initiator B from the same target T could see devices Y read-only and Z 
> read-writable.
> 
>      * Emulates necessary functionality of SCSI host adapter, because 
> from remote initiators point of view SCST acts as a SCSI host with its 
> own devices.
> 
> The following I/O modes are supported by SCST:
> 
> 	* Pass-through mode with one to many relationship, i.e. when multiple 
> initiators can connect to the exported pass-through devices, for 
> virtually all SCSI devices types: disks (type 0), tapes (type 1), 
> processors (type 3), CDROMs (type 5), MO disks (type 7), medium changers 
> (type 8) and RAID controllers (type 0xC)
> 
> 	* FILEIO mode, which allows to use files on file systems or block 
> devices as virtual remotely available SCSI disks or CDROMs with benefits 
> of the Linux page cache
> 
> 	* BLOCKIO mode, which performs direct block I/O with a block device, 
> bypassing page-cache for all operations. This mode works ideally with 
> high-end storage HBAs and for applications that either do not need 
> caching between application and disk or need the large block throughput.
> 
> 	* User space mode using scst_user device handler, which allows to 
> implement in the user space virtual SCSI devices in the SCST environment.
> 
> Detail description of SCST, its drivers and utilities you can find on 
> SCST home page http://scst.sourceforge.net.
> 
> Comparison with the mainstream target middle level STGT you can find on 
> the SCST vs STGT page http://scst.sourceforge.net/scstvsstgt.html. In 
> short, SCST has the following main advantages over STGT:
> 

I noticed that you included a reference to my presentation at LSF 08' on
your SCST vs. STGT page liked above, and took my description of your
work (you are more than welcome to come and present your own case at LSF
'09) very much out of context.

If you wish to reference my presentation, please at least make the
comparision between LIO-Core+LIO-Target vs. SCST vs. STGT, and NOT JUST
SCST vs. STGT so that the community are large can understand the
differences and technical challenges.  The more in fighting between the
leaders in our community, the less the community benefits.

Many thanks for your most valuable of time,

--nab

>   - Better performance (in many cases tens of %% and more) with 
> potential for further improvement, for example, by implementing 
> zero-copy cache I/O.
> 
>   - Monolithic in-kernel architecture, which follows standard Linux 
> kernel paradigm to eliminate distributed processing. It is simpler, 
> hence more reliable and maintainable.
> 
> SCST is being prepared in form of patch for review and inclusion to the 
> kernel.
> 
> Vlad
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
