From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: MPT Fusion Crash
Date: Thu, 7 Sep 2006 10:37:08 -0600
Message-ID: <200609071037.09259.bjorn.helgaas@hp.com>
References: <664A4EBB07F29743873A87CF62C26D702E363A@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlrel8.hp.com ([156.153.255.206]:62940 "EHLO atlrel8.hp.com")
	by vger.kernel.org with ESMTP id S1161022AbWIGQhO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Sep 2006 12:37:14 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D702E363A@NAMAIL4.ad.lsil.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: "Chen, Justin" <justin.chen@hp.com>, linux-scsi@vger.kernel.org, "Patterson, Andrew D (Linux R&D)" <andrew.patterson@hp.com>

On Wednesday 06 September 2006 15:54, Moore, Eric wrote:
> > bsp=e0000700835190a8
> >  [<a0000001001e77e0>] swiotlb_unmap_sg+0xa0/0x1e0
> >                                 sp=e00007008351fd90 
> > bsp=e000070083519048
> >  [<a00000010047b970>] mptscsih_search_running_cmds+0x210/0x340
> >                                 sp=e00007008351fd90 
> 
> Looks like it panic'd when pci_unmap_sg() is called.   In older kernels
> we had a similar panic, and we added a scsi_device_online call because
> midlayer was nulling some of the pointers in the scsi_cmd after itself
> offlined a device before the lld slave_destroy was called..  
> This panic occured because there were still outstanding io in fusion.
> Since I thought that was fix'd, it was recommended by hch and company
> that we kill the scsi_device_online call.

I suppose this is the scsi_device_online() removal you're talking
about (item 5 in the changelog):
  http://kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=0d0c79747e362ff54adc6418d2990d49cad9395d

I don't know enough about SCSI to know how the midlayer is supposed
to know that all the outstanding fusion I/O has completed before it
calls slave_destroy.

I also have a naive question about the ScsiLookup[] table, which is
used in mptscsih_qcmd(), mptscsih_io_done(), mptscsih_flush_running_cmds(),
mptscsih_search_running_cmds(), mptscsih_remove(), and a few other
places.  What is the locking strategy for this?

It seems like the slave_destroy (which uses ScsiLookup[] via
mptscsih_search_running_cmds()) might happen asynchronously with
respect to I/O completions, and might need to be protected against
updates by mptscsih_io_done().

Bjorn
