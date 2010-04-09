From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15688] mptsas & poor performance
Date: Fri, 9 Apr 2010 11:50:39 GMT
Message-ID: <201004091150.o39BodsR020237@demeter.kernel.org>
References: <bug-15688-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40119 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab0DILuk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Apr 2010 07:50:40 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o39Bod3Z020238
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 9 Apr 2010 11:50:39 GMT
In-Reply-To: <bug-15688-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=15688





--- Comment #4 from kdesai <kashyap.desai@lsi.com>  2010-04-09 11:50:27 ---
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of bugzilla-daemon@bugzilla.kernel.org
> Sent: Thursday, April 08, 2010 9:07 PM
> To: linux-scsi@vger.kernel.org
> Subject: [Bug 15688] mptsas & poor performance
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=15688
> 
> 
> 
> 
> 
> --- Comment #3 from Brian Sullivan <bexamous@gmail.com>  2010-04-08
> 15:36:49 ---
> I think the only changes I made to 4.18.00.00 was to just not use
> mptlan
> (since I have no need and it wouldn't compile on 2.6.34) and make a few
> changes to mptsas.c (only to get it to compile on 2.6.34).
> 
> diff ./mptlinux-4.18.00.00/dkms.conf /usr/src/mptlinux-
> 4.18.00.00/dkms.conf
> 13d12
> < MAKE[6]="make -C ${kernel_source_dir}
> SUBDIRS=${dkms_tree}/${PACKAGE_NAME}/${PACKAGE_VERSION}/build modules"
> 28,29c27,28
> < BUILT_MODULE_NAME[3]="mptlan"
> < DEST_MODULE_NAME[3]="mptlan"
> ---
> > BUILT_MODULE_NAME[3]="mptspi"
> > DEST_MODULE_NAME[3]="mptspi"
> 30a30,31
> > #MODULES_CONF_OBSOLETES[3]="mptbase,mptscsih,mptctl,mptlan"
> > MODULES_CONF_ALIAS_TYPE[3]="scsi_hostadapter"
> 32,33c33,34
> < BUILT_MODULE_NAME[4]="mptspi"
> < DEST_MODULE_NAME[4]="mptspi"
> ---
> > BUILT_MODULE_NAME[4]="mptsas"
> > DEST_MODULE_NAME[4]="mptsas"
> 35d35
> < #MODULES_CONF_OBSOLETES[4]="mptbase,mptscsih,mptctl,mptlan"
> 38,39c38,39
> < BUILT_MODULE_NAME[5]="mptsas"
> < DEST_MODULE_NAME[5]="mptsas"
> ---
> > BUILT_MODULE_NAME[5]="mptfc"
> > DEST_MODULE_NAME[5]="mptfc"
> 41,45d40
> < MODULES_CONF_ALIAS_TYPE[5]="scsi_hostadapter"
> <
> < BUILT_MODULE_NAME[6]="mptfc"
> < DEST_MODULE_NAME[6]="mptfc"
> < DEST_MODULE_LOCATION[6]="/kernel/drivers/message/fusion"
> 47a43
> >
> diff ./mptlinux-4.18.00.00/Makefile /usr/src/mptlinux-
> 4.18.00.00/Makefile
> 2c2
> < # LSI Logic  mpt fusion
> ---
> > # LSI mpt fusion
> 19c19
> < obj-$(CONFIG_FUSION_LAN)    += mptlan.o
> ---
> > #obj-$(CONFIG_FUSION_LAN)    += mptlan.o
> diff ./mptlinux-4.18.00.00/mptsas.c /usr/src/mptlinux-
> 4.18.00.00/mptsas.c
> 2437,2438c2437,2438
> <             ioc->name, __func__, req->bio->bi_vcnt, req->data_len,
> <             rsp->bio->bi_vcnt, rsp->data_len);
> ---
> >             ioc->name, __func__, req->bio->bi_vcnt,
> blk_rq_bytes(req),
> >             rsp->bio->bi_vcnt, blk_rq_bytes(rsp));
> 2455c2455
> <     smpreq->RequestDataLength = cpu_to_le16(req->data_len - 4);
> ---
> >     smpreq->RequestDataLength = cpu_to_le16(blk_rq_bytes(req) - 4);
> 2485c2485
> <     flagsLength |= (req->data_len - 4);
> ---
> >     flagsLength |= (blk_rq_bytes(req) - 4);
> 2488c2488
> <                       req->data_len, PCI_DMA_BIDIRECTIONAL);
> ---
> >                       blk_rq_bytes(req), PCI_DMA_BIDIRECTIONAL);
> 2501c2501
> <     flagsLength |= rsp->data_len + 4;
> ---
> >     flagsLength |= blk_rq_bytes(rsp) + 4;
> 2503c2503
> <                       rsp->data_len, PCI_DMA_BIDIRECTIONAL);
> ---
> >                       blk_rq_bytes(rsp), PCI_DMA_BIDIRECTIONAL);
> 2534,2535c2534,2535
> <         req->data_len = 0;
> <         rsp->data_len -= smprep->ResponseDataLength;
> ---
> >         req->resid_len = 0;
> >         rsp->resid_len -= smprep->ResponseDataLength;
> 2544c2544
> <         pci_unmap_single(ioc->pcidev, dma_addr_out, req->data_len,
> ---
> >         pci_unmap_single(ioc->pcidev, dma_addr_out,
> blk_rq_bytes(req),
> 2547c2547
> <         pci_unmap_single(ioc->pcidev, dma_addr_in, rsp->data_len,
> ---
> >         pci_unmap_single(ioc->pcidev, dma_addr_in, blk_rq_bytes(rsp),
> 

OK. This is fine. All you did is just to make sure compilation is fine.

> 
> BTW This was Bonnie++ output when btrfs was still empty, 388MB/sec
> write
> 526MB/sec read:
> Version  1.96       ------Sequential Output------ --Sequential Input-
> --Random-
> Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--
> --Seeks--
> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP
> /sec
> %CP
> nine            24G   259  95 388802  57 127153  51   221  94 526553
> 66
> 167.9 331
> Latency             30004us    1451ms     378ms   23627us     118ms
> 104ms
> Version  1.96       ------Sequential Create------ --------Random
> Create--------
> nine                -Create-- --Read--- -Delete-- -Create-- --Read---
> -Delete--
>               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
> /sec
> %CP
>                  16  8406  24 +++++ +++ 11176  49 14249  40 +++++ +++
> 11370
> 49
> Latency               498us     441us     926us     601us      43us
> 1628us
> 1.96,1.96,nine,1,1270361591,24G,,259,95,388802,57,127153,51,221,94,5265
> 53,66,167.9,331,16,,,,,8406,24,+++++,+++,11176,49,14249,40,+++++,+++,11
> 370,49,30004us,1451ms,378ms,23627us,118ms,104ms,498us,441us,926us,601us
> ,43us,1628us
> 
> The <200MB/sec and 395MB/sec i was referring to was just using dd to
> write
> zeros.  Later on I ran bonnie and saved this.
> 
> Also system:
> Tyan mobo wiht two E5410 CPUs, 12GB RAM, using onboard LSI 1068E.  The

CPU is bottleneck in my system. I have to go for Two quadcore CPUs to achieve
395 MB/sec throughput.
I will collect similar h/w and redo the same test again. I will post my
findings once I am done with repro.

~Kashyap

> LSI
> connects to a HP SAS Expander.  All drives are connected to the HP SAS
> Expander.  The drives are all 2TB WD GP drives WD20EADS, not the newer
> EARS
> version.
> 
> 
> On Thu, Apr 8, 2010 at 3:31 AM, <bugzilla-daemon@bugzilla.kernel.org>
> wrote:
> 
> > https://bugzilla.kernel.org/show_bug.cgi?id=15688
> >
> >
> >
> >
> >
> > --- Comment #2 from kdesai <kashyap.desai@lsi.com>  2010-04-08
> 10:31:17
> > ---
> > Andrew,
> >
> > Today I tried same steps as mentioned by you. In my case I am able to
> see
> > both
> > the drivers
> > Performance is similar.
> >
> > 3.4.14 is driver version available at kernel.org
> > 4.22.00.00 is driver LSI internally uses. [4.18.00.00 does not have
> support
> > for
> > 2.6.34 kernel]
> > I guess you must have done some changes to make sure 4.18.00.00 works
> with
> > 2.6.34-020634rc1.
> >
> > Both the case I am getting 190~210MB/sec.
> >
> > Can you help me to reproduce ~395MB/sec using 4.18.00.00 ?
> >
> >
> > ~Kashyap
> >
> >
> >
> >
> > > -----Original Message-----
> > > From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> > > owner@vger.kernel.org] On Behalf Of Andrew Morton
> > > Sent: Tuesday, April 06, 2010 2:05 AM
> > > To: linux-scsi@vger.kernel.org; Moore, Eric
> > > Cc: bugzilla-daemon@bugzilla.kernel.org; bugme-
> > > daemon@bugzilla.kernel.org; bexamous@gmail.com
> > > Subject: Re: [Bugme-new] [Bug 15688] New: mptsas & poor performance
> > >
> > >
> > > (switched to email.  Please respond via emailed reply-to-all, not
> via
> > > the
> > > bugzilla web interface).
> > >
> > > scsi_drivers-other reports don't appear to be coming out on the
> > > linux-scsi list.
> > >
> > > On Sat, 3 Apr 2010 21:16:31 GMT
> > > bugzilla-daemon@bugzilla.kernel.org wrote:
> > >
> > > > https://bugzilla.kernel.org/show_bug.cgi?id=15688
> > > >
> > > >            Summary: mptsas & poor performance
> > > >            Product: SCSI Drivers
> > > >            Version: 2.5
> > > >     Kernel Version: 2.6.34-020634rc1
> > > >           Platform: All
> > > >         OS/Version: Linux
> > > >               Tree: Mainline
> > > >             Status: NEW
> > > >           Severity: normal
> > > >           Priority: P1
> > > >          Component: Other
> > > >         AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
> > > >         ReportedBy: bexamous@gmail.com
> > > >         Regression: No
> > > >
> > > >
> > > > The mptsas module from LSI's website, v4.18.00.00, performs much
> > > better than
> > > > the mptsas module included in the kernel, v3.something.
> > > >
> > > > I'm only comparing sequential writes (dd if=/dev/zero of=zeros
> > > bs=1M), but...
> > > >
> > > > 6 drive MD RAID5 with fresh btrfs, writing 10GB of zeros with dd,
> > > > kernel version:  <200MB/sec
> > > > LSI's v4.18.00.00: 395MB/sec
> > > >
> > > > Pretty big difference.  I've gone back and forth a few times,
> > > > enabling/disabling write cache on the drives, enabling/disabling
> ioc,
> > > > enabling/disabling filesystem barriers...  I can make small
> changes
> > > in
> > > > performance but nothing compares to simply updating to
> v4.18.00.00.
> > > >
> > >
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-
> scsi"
> > > in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> > --
> > Configure bugmail:
> https://bugzilla.kernel.org/userprefs.cgi?tab=email
> > ------- You are receiving this mail because: -------
> > You reported the bug.
> >
> 
> --
> Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
> ------- You are receiving this mail because: -------
> You are watching the assignee of the bug.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
