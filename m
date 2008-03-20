From: "Siva Kodiganti" <kodiganti@gmail.com>
Subject: Re: scsi layer interfaces for hypervisors
Date: Thu, 20 Mar 2008 10:38:05 -0700
Message-ID: <b8c77ef10803201038x3032ab0dpf5b0e37f5e6a82e7@mail.gmail.com>
References: <b8c77ef10803192257w5629e931y28eed9ab32ed02a9@mail.gmail.com>
	 <47E27483.3080604@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:26322 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158AbYCTRiU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Mar 2008 13:38:20 -0400
Received: by fg-out-1718.google.com with SMTP id l27so913873fgb.17
        for <linux-scsi@vger.kernel.org>; Thu, 20 Mar 2008 10:38:05 -0700 (PDT)
In-Reply-To: <47E27483.3080604@emulex.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@emulex.com
Cc: linux-scsi@vger.kernel.org, siva@3leafsystems.com

James,

VirtHBA project isn't aimed/positioned against the pvscsi effort.
VirtHBA provides hypervisor independant interfaces at SCSI
mid-layer(by some means- patch for released kernels or upstream if
embraced), which hypervisors register and get notified appropriately.
In addition, it also provides scsi emulation(target) capability at low
layers.

Thanks,
--Siva


On Thu, Mar 20, 2008 at 7:28 AM, James Smart <James.Smart@emulex.com> wrote:
> Siva,
>
>  I'm curious to hear how you position this against the pvscsi effort
>  going on in the Xen world.
>
>  -- james s
>
>
>
>  Siva Kodiganti wrote:
>  > Hello Linux community,
>  >
>  >  A Project page for Virt_HBA is created on source forge.
>  >  https://sourceforge.net/projects/npivhba
>  >
>  >  Project Virt_HBA is targeted for a providing patch for
>  >  Linux kernels to provide set of scsi layer interfaces to
>  >  aid Hypervisors in Linux to export Scsi Hosts to Guest
>  >  VMs.  Using these interfaces  Hypervisors could export
>  >  Scsi_Host of a virtual hba emulated by HBA hardware to
>  >  Guest VMs.  FC, and FCOE (may) have support for Nport
>  >  Virtualization, a FW/HW mechanism to emulate multiple
>  >  hbas(nports) using a single HBA HW.  Qlogic, and
>  >  Emulex have support for FC NPIV.  With this mechanism,
>  >  Hypervisor would be capable of mapping appropriate
>  >  Guest VM's shost queuecommand to underlying NPIV host's
>  >  queue_command, and other hostt relevant entry points(one
>  >  to one mapping).  This could also provide a means of
>  >  security for luns exported through NPIV host to be
>  >  visible for appropriate Guest OS, hiding from HostOS.
>  >
>  >  Scsi Layer interfaces:
>  >
>  >  Hypervisor's registration with scsi layer
>  >
>  >  scsi_register_hypertt(xn_hostt, xsize);
>  >  xsize is size of private structure maintained by
>  >  hypervisor per npiv host.
>  >
>  >  struct scsi_hyper_hostt xn_hostt {
>  >          .hyp_module             = "xn",
>  >          .hyp_psize              = size of( xhost);
>  >          .hyp_alloc_vhost        = xn_alloc_vhost,
>  >          .hyp_add_vhost          = xn_add_vhost,
>  >          .hyp_remove_vhost       = xn_remove_vhost,
>  >          .hyp_trans_func         = xn_trans_vhost,
>  >          .hyp_async_notifier     = xn_async_ntfr,
>  >          .hyp_reboot_notifier    = xn_reboot_ntfr,
>  >  };
>  >
>  >  Scsi_Host {
>  >
>  >          /* flag for FC or FCOE hw or fw hba virtulization */
>  >          unsigned virt_host:1;
>  >
>  >  }
>  >
>  >  scsi_alloc_host(), scsi_add_host(), and scsi_remove_host()
>  >  interfaces notify registered hypervisor about FC/FCOE
>  >  virtual Scsi_Host.  scsi_alloc_host() would allocate private
>  >  data area per scsi_host for registered hypervisors, which
>  >  export to Guest VMs.
>  >
>  >  Hypervisors uses these virtual hosts' lld driver hostt entry
>  >  points to queue,abort,etc scsi commands to HBA driver directly
>  >  bypassing Host BlK, SD layers.
>  >
>  >  Thanks,
>  >  Siva
>  > --
>  > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>  > the body of a message to majordomo@vger.kernel.org
>  > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  >
>
