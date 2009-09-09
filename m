From: Alok Kataria <akataria@vmware.com>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA - V4.
Date: Wed, 09 Sep 2009 14:51:33 -0700
Message-ID: <1252533093.24633.40.camel@ank32.eng.vmware.com>
References: <1252458903.24914.73.camel@ank32.eng.vmware.com>
	 <4AA8177A.2020606@codemonkey.ws>
Reply-To: akataria@vmware.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:59989 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753079AbZIIVva (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Sep 2009 17:51:30 -0400
In-Reply-To: <4AA8177A.2020606@codemonkey.ws>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: James Bottomley <James.Bottomley@suse.de>, Rolf Eike Beer <eike-kernel@sf-tec.de>, Brian King <brking@linux.vnet.ibm.com>, "Chetan.Loke@Emulex.Com" <Chetan.Loke@Emulex.Com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "pv-drivers@vmware.com" <pv-drivers@vmware.com>, virtualization <virtualization@lists.linux-foundation.org>

Hi Anthony,

On Wed, 2009-09-09 at 14:00 -0700, Anthony Liguori wrote:
> Hi Alok,
> 
> Joining this a bit late as this was just brought to my attention.  It 
> would have been nice to CC the virtualization mailing list.  Please do 
> in future submissions.

Sure.

> 
> Alok Kataria wrote:
> > VMware PVSCSI driver - v4.
> > 
> /
> >  
> > diff --git a/drivers/scsi/pvscsi.h b/drivers/scsi/pvscsi.h
> > new file mode 100644
> > index 0000000..96bb655
> > --- /dev/null
> > +++ b/drivers/scsi/pvscsi.h
> > @@ -0,0 +1,395 @@
> > +/*
> > + * VMware PVSCSI header file
> > + *
> > + * Copyright (C) 2008-2009, VMware, Inc. All Rights Reserved.
> > + *
> > + * This program is free software; you can redistribute it and/or modify it
> > + * under the terms of the GNU General Public License as published by the
> > + * Free Software Foundation; version 2 of the License and no later version.
> > + *
> > + * This program is distributed in the hope that it will be useful, but
> > + * WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
> > + * NON INFRINGEMENT.  See the GNU General Public License for more
> > + * details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
> > + *
> > + * Maintained by: Alok N Kataria <akataria@vmware.com>
> > + *
> > + */
> > +
> > +#ifndef _PVSCSI_H_
> > +#define _PVSCSI_H_
> > +
> > +#include <linux/types.h>
> > +
> > +#define PVSCSI_DRIVER_VERSION_STRING   "1.0.0.0"
> > +
> > +#define PVSCSI_MAX_NUM_SG_ENTRIES_PER_SEGMENT 128
> > +
> > +#define MASK(n)        ((1 << (n)) - 1)        /* make an n-bit mask */
> > +
> > +#define PCI_VENDOR_ID_VMWARE		0x15AD
> > +#define PCI_DEVICE_ID_VMWARE_PVSCSI	0x07C0
> > +
> > +/*
> > + * host adapter status/error codes
> > + */
> > +typedef enum {
> > +   BTSTAT_SUCCESS       = 0x00,  /* CCB complete normally with no errors */
> > +   BTSTAT_LINKED_COMMAND_COMPLETED           = 0x0a,
> > +   BTSTAT_LINKED_COMMAND_COMPLETED_WITH_FLAG = 0x0b,
> > +   BTSTAT_DATA_UNDERRUN = 0x0c,
> > +   BTSTAT_SELTIMEO      = 0x11,  /* SCSI selection timeout */
> > +   BTSTAT_DATARUN       = 0x12,  /* data overrun/underrun */
> > +   BTSTAT_BUSFREE       = 0x13,  /* unexpected bus free */
> > +   BTSTAT_INVPHASE      = 0x14,  /* invalid bus phase or sequence requested by target */
> > +   BTSTAT_LUNMISMATCH   = 0x17,  /* linked CCB has different LUN from first CCB */
> > +   BTSTAT_SENSFAILED    = 0x1b,  /* auto request sense failed */
> > +   BTSTAT_TAGREJECT     = 0x1c,  /* SCSI II tagged queueing message rejected by target */
> > +   BTSTAT_BADMSG        = 0x1d,  /* unsupported message received by the host adapter */
> > +   BTSTAT_HAHARDWARE    = 0x20,  /* host adapter hardware failed */
> > +   BTSTAT_NORESPONSE    = 0x21,  /* target did not respond to SCSI ATN, sent a SCSI RST */
> > +   BTSTAT_SENTRST       = 0x22,  /* host adapter asserted a SCSI RST */
> > +   BTSTAT_RECVRST       = 0x23,  /* other SCSI devices asserted a SCSI RST */
> > +   BTSTAT_DISCONNECT    = 0x24,  /* target device reconnected improperly (w/o tag) */
> > +   BTSTAT_BUSRESET      = 0x25,  /* host adapter issued BUS device reset */
> > +   BTSTAT_ABORTQUEUE    = 0x26,  /* abort queue generated */
> > +   BTSTAT_HASOFTWARE    = 0x27,  /* host adapter software error */
> > +   BTSTAT_HATIMEOUT     = 0x30,  /* host adapter hardware timeout error */
> > +   BTSTAT_SCSIPARITY    = 0x34,  /* SCSI parity error detected */
> > +} HostBusAdapterStatus;
> > +
> > +/*
> > + * Register offsets.
> > + *
> > + * These registers are accessible both via i/o space and mm i/o.
> > + */
> > +
> > +enum PVSCSIRegOffset {
> > +	PVSCSI_REG_OFFSET_COMMAND        =    0x0,
> > +	PVSCSI_REG_OFFSET_COMMAND_DATA   =    0x4,
> > +	PVSCSI_REG_OFFSET_COMMAND_STATUS =    0x8,
> > +	PVSCSI_REG_OFFSET_LAST_STS_0     =  0x100,
> > +	PVSCSI_REG_OFFSET_LAST_STS_1     =  0x104,
> > +	PVSCSI_REG_OFFSET_LAST_STS_2     =  0x108,
> > +	PVSCSI_REG_OFFSET_LAST_STS_3     =  0x10c,
> > +	PVSCSI_REG_OFFSET_INTR_STATUS    = 0x100c,
> > +	PVSCSI_REG_OFFSET_INTR_MASK      = 0x2010,
> > +	PVSCSI_REG_OFFSET_KICK_NON_RW_IO = 0x3014,
> > +	PVSCSI_REG_OFFSET_DEBUG          = 0x3018,
> > +	PVSCSI_REG_OFFSET_KICK_RW_IO     = 0x4018,
> > +};
> > +
> > +/*
> > + * Virtual h/w commands.
> > + */
> > +
> > +enum PVSCSICommands {
> > +	PVSCSI_CMD_FIRST             = 0, /* has to be first */
> > +
> > +	PVSCSI_CMD_ADAPTER_RESET     = 1,
> > +	PVSCSI_CMD_ISSUE_SCSI        = 2,
> > +	PVSCSI_CMD_SETUP_RINGS       = 3,
> > +	PVSCSI_CMD_RESET_BUS         = 4,
> > +	PVSCSI_CMD_RESET_DEVICE      = 5,
> > +	PVSCSI_CMD_ABORT_CMD         = 6,
> > +	PVSCSI_CMD_CONFIG            = 7,
> > +	PVSCSI_CMD_SETUP_MSG_RING    = 8,
> > +	PVSCSI_CMD_DEVICE_UNPLUG     = 9,
> > +
> > +	PVSCSI_CMD_LAST              = 10  /* has to be last */
> > +};
> > +
> > +/*
> > + * Command descriptor for PVSCSI_CMD_RESET_DEVICE --
> > + */
> > +
> > +typedef struct PVSCSICmdDescResetDevice {
> > +	u32	target;
> > +	u8	lun[8];
> > +} __packed PVSCSICmdDescResetDevice;
> > +
> > +/*
> > + * Command descriptor for PVSCSI_CMD_ABORT_CMD --
> > + *
> > + * - currently does not support specifying the LUN.
> > + * - _pad should be 0.
> > + */
> > +
> > +typedef struct PVSCSICmdDescAbortCmd {
> > +	u64	context;
> > +	u32	target;
> > +	u32	_pad;
> > +} __packed PVSCSICmdDescAbortCmd;
> > +
> > +/*
> > + * Command descriptor for PVSCSI_CMD_SETUP_RINGS --
> > + *
> > + * Notes:
> > + * - reqRingNumPages and cmpRingNumPages need to be power of two.
> > + * - reqRingNumPages and cmpRingNumPages need to be different from 0,
> > + * - reqRingNumPages and cmpRingNumPages need to be inferior to
> > + *   PVSCSI_SETUP_RINGS_MAX_NUM_PAGES.
> > + */
> > +
> > +#define PVSCSI_SETUP_RINGS_MAX_NUM_PAGES        32
> > +typedef struct PVSCSICmdDescSetupRings {
> > +	u32	reqRingNumPages;
> > +	u32	cmpRingNumPages;
> > +	u64	ringsStatePPN;
> > +	u64	reqRingPPNs[PVSCSI_SETUP_RINGS_MAX_NUM_PAGES];
> > +	u64	cmpRingPPNs[PVSCSI_SETUP_RINGS_MAX_NUM_PAGES];
> > +} __packed PVSCSICmdDescSetupRings;
> > +
> > +/*
> > + * Command descriptor for PVSCSI_CMD_SETUP_MSG_RING --
> > + *
> > + * Notes:
> > + * - this command was not supported in the initial revision of the h/w
> > + *   interface. Before using it, you need to check that it is supported by
> > + *   writing PVSCSI_CMD_SETUP_MSG_RING to the 'command' register, then
> > + *   immediately after read the 'command status' register:
> > + *       * a value of -1 means that the cmd is NOT supported,
> > + *       * a value != -1 means that the cmd IS supported.
> > + *   If it's supported the 'command status' register should return:
> > + *      sizeof(PVSCSICmdDescSetupMsgRing) / sizeof(u32).
> > + * - this command should be issued _after_ the usual SETUP_RINGS so that the
> > + *   RingsState page is already setup. If not, the command is a nop.
> > + * - numPages needs to be a power of two,
> > + * - numPages needs to be different from 0,
> > + * - _pad should be zero.
> > + */
> > +
> > +#define PVSCSI_SETUP_MSG_RING_MAX_NUM_PAGES  16
> > +
> > +typedef struct PVSCSICmdDescSetupMsgRing {
> > +	u32	numPages;
> > +	u32	_pad;
> > +	u64	ringPPNs[PVSCSI_SETUP_MSG_RING_MAX_NUM_PAGES];
> > +} __packed PVSCSICmdDescSetupMsgRing;
> > +
> > +enum PVSCSIMsgType {
> > +	PVSCSI_MSG_DEV_ADDED          = 0,
> > +	PVSCSI_MSG_DEV_REMOVED        = 1,
> > +	PVSCSI_MSG_LAST               = 2,
> > +};
> > +
> > +/*
> > + * Msg descriptor.
> > + *
> > + * sizeof(struct PVSCSIRingMsgDesc) == 128.
> > + *
> > + * - type is of type enum PVSCSIMsgType.
> > + * - the content of args depend on the type of event being delivered.
> > + */
> > +
> > +typedef struct PVSCSIRingMsgDesc {
> > +	u32	type;
> > +	u32	args[31];
> > +} __packed PVSCSIRingMsgDesc;
> > +
> > +typedef struct PVSCSIMsgDescDevStatusChanged {
> > +	u32	type;  /* PVSCSI_MSG_DEV _ADDED / _REMOVED */
> > +	u32	bus;
> > +	u32	target;
> > +	u8	lun[8];
> > +	u32	pad[27];
> > +} __packed PVSCSIMsgDescDevStatusChanged;
> > +
> > +/*
> > + * Rings state.
> > + *
> > + * - the fields:
> > + *    . msgProdIdx,
> > + *    . msgConsIdx,
> > + *    . msgNumEntriesLog2,
> > + *   .. are only used once the SETUP_MSG_RING cmd has been issued.
> > + * - '_pad' helps to ensure that the msg related fields are on their own
> > + *   cache-line.
> > + */
> > +
> > +typedef struct PVSCSIRingsState {
> > +	u32	reqProdIdx;
> > +	u32	reqConsIdx;
> > +	u32	reqNumEntriesLog2;
> > +
> > +	u32	cmpProdIdx;
> > +	u32	cmpConsIdx;
> > +	u32	cmpNumEntriesLog2;
> > +
> > +	u8	_pad[104];
> > +
> > +	u32	msgProdIdx;
> > +	u32	msgConsIdx;
> > +	u32	msgNumEntriesLog2;
> > +} __packed PVSCSIRingsState;
> 
> All of this can be hidden behind a struct virtqueue.  You could then 
> introduce a virtio-vmwring that implemented this ABI.
> 
> You could then separate out the actual scsi logic into a separate 
> virtio-scsi.c driver.
> 
> There are numerous advantages to this layering.  You get to remain ABI 
> compatible with yourself.  You can potentially reuse the ring logic in 
> other drivers.  Other VMMs can use different ring transports without 
> introducing new drivers.  For instance, in KVM, we would use virtio-pci 
> + virtio-scsi instead of using virtio-vmwring + virtio-scsi.

I see your point, but the ring logic or the ABI that we use to
communicate between the hypervisor and guest is not shared between our
storage and network drivers. As a result, I don't see any benefit of
separating out this ring handling mechanism, on the contrary it might
just add some overhead of translating between various layers for our
SCSI driver.

Having said that, I will like to add that yes if in some future
iteration of our paravirtualized drivers, if we decide to share this
ring mechanism for our various device drivers this might be an
interesting proposition. 

Thanks,
Alok

> 
> The virtio infrastructure has been backported to various old kernels too 
> so there really is no reason not to use it.
> 
> We have the interfaces in virtio to do notification suppression and MSI 
> so I don't think there's any real limitation that it would impose on you.
> 
> Regards,
> 
> Anthony Liguori

