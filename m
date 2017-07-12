From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH 02/13] mpt3sas: SGL to PRP Translation for I/Os to NVMe
 devices
Date: Tue, 11 Jul 2017 20:04:02 -0400
Message-ID: <20170712000402.GA27718@localhost.localdomain>
References: <1499763313-7214-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1499763313-7214-3-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1499763313-7214-3-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Cc: "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "jejb@kernel.org" <jejb@kernel.org>, "hch@infradead.org" <hch@infradead.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Sathya.Prakash@broadcom.com" <Sathya.Prakash@broadcom.com>, "kashyap.desai@broadcom.com" <kashyap.desai@broadcom.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 11, 2017 at 01:55:02AM -0700, Suganath Prabu S wrote:
> +/**
> + * _base_check_pcie_native_sgl - This function is called for PCIe end devices to
> + * determine if the driver needs to build a native SGL.  If so, that native
> + * SGL is built in the special contiguous buffers allocated especially for
> + * PCIe SGL creation.  If the driver will not build a native SGL, return
> + * TRUE and a normal IEEE SGL will be built.  Currently this routine
> + * supports NVMe.
> + * @ioc: per adapter object
> + * @mpi_request: mf request pointer
> + * @smid: system request message index
> + * @scmd: scsi command
> + * @pcie_device: points to the PCIe device's info
> + *
> + * Returns 0 if native SGL was built, 1 if no SGL was built
> + */
> +static int
> +_base_check_pcie_native_sgl(struct MPT3SAS_ADAPTER *ioc,
> +	Mpi25SCSIIORequest_t *mpi_request, u16 smid, struct scsi_cmnd *scmd,
> +	struct _pcie_device *pcie_device)
> +{

<snip>

> +	/* Return 0, indicating we built a native SGL. */
> +	return 1;
> +}

This function doesn't return 0 ever. Not sure why it's here.

Curious about your device, though, if a nvme native SGL can *not* be
built, does the HBA firmware then buffer it in its local memory before
sending/receiving to/from the host?

And if a native SGL can be built, does the NVMe target DMA directly
to/from host memory, giving a performance boost?
