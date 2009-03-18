From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 2/3] scsi_dh: Change scsi device handler modules
	to	utilize modalias
Date: Wed, 18 Mar 2009 10:25:58 -0700
Message-ID: <1237397158.14147.3.camel@chandra-ubuntu>
References: <20090318013615.26548.36303.sendpatchset@chandra-ubuntu>
	 <20090318013627.26548.27704.sendpatchset@chandra-ubuntu>
	 <20090318134629.GB19448@mars.virtualiron.com>
	 <49C1168F.6060900@s5r6.in-berlin.de>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:49805 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbZCRRXW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Mar 2009 13:23:22 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n2IHLwHV006976
	for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2009 11:21:58 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2IHMx1o100872
	for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2009 11:22:59 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n2IHMw6f023991
	for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2009 11:22:59 -0600
In-Reply-To: <49C1168F.6060900@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Konrad Rzeszutek <konrad@virtualiron.com>, linux-scsi@vger.kernel.org, pjones@redhat.com, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com


On Wed, 2009-03-18 at 16:43 +0100, Stefan Richter wrote:
> Konrad Rzeszutek wrote:
> > .. snip..
> >> +	{TYPE_ANY, "HP", "HSV300" },
> >> +	{TYPE_ANY, "IBM", "2107900" },
> >> +	{TYPE_ANY, "IBM", "2145" },
> >> +	{TYPE_ANY, "Pillar", "Axiom" },
> >> +	{0, "", ""},
> > 
> > Is there a define for '0' value?
> 
> This is an array terminator.  Almost nobody uses cpp defines for
> terminating values.  (In this case, the actual terminator is "" in the
> 2nd struct member.)
> 
> BTW, Peter,
> 
> >> --- linux-2.6.28.orig/drivers/scsi/device_handler/scsi_dh.c
> >> +++ linux-2.6.28/drivers/scsi/device_handler/scsi_dh.c
> >> @@ -75,7 +75,10 @@ static int scsi_dh_handler_lookup(struct
> >>  {
> >>  	int i, found = 0;
> >>  
> >> -	for(i = 0; scsi_dh->devlist[i].vendor; i++) {
> >> +	for(i = 0; scsi_dh->devlist[i].vendor[0]; i++) {
> >> +		if ((scsi_dh->devlist[i].type != TYPE_ANY) &&
> >> +				(scsi_dh->devlist[i].type != sdev->type))
> >> +			continue;
> >>  		if (!strncmp(sdev->vendor, scsi_dh->devlist[i].vendor,
> >>  			     strlen(scsi_dh->devlist[i].vendor)) &&
> >>  		    !strncmp(sdev->model, scsi_dh->devlist[i].model,
> 
> AFAICS you could have kept the check for .vendor != NULL instead of
> .vendor[0] != '\0' and write the terminator thusly:
> 
> 	{},
> 
> Saves the space for a one byte long string in the object files.  :-)

Tried it after your response. Got a panic :(.

Did I code your suggestion correctly ?

Here is the patch
--------------
Index: linux-2.6.29-rc8/drivers/scsi/device_handler/scsi_dh.c
===================================================================
--- linux-2.6.29-rc8.orig/drivers/scsi/device_handler/scsi_dh.c
+++ linux-2.6.29-rc8/drivers/scsi/device_handler/scsi_dh.c
@@ -75,7 +75,7 @@ static int scsi_dh_handler_lookup(struct
 {
        int i, found = 0;
 
-       for(i = 0; scsi_dh->devlist[i].vendor[0]; i++) {
+       for(i = 0; scsi_dh->devlist[i].vendor; i++) {
                if ((scsi_dh->devlist[i].type != TYPE_ANY) &&
                                (scsi_dh->devlist[i].type !=
sdev->type))
                        continue;
Index: linux-2.6.29-rc8/drivers/scsi/device_handler/scsi_dh_rdac.c
===================================================================
--- linux-2.6.29-rc8.orig/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ linux-2.6.29-rc8/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -604,7 +604,7 @@ static const struct scsi_dh_device_id rd
        {TYPE_ANY, "DELL", "MD3000i"},
        {TYPE_ANY, "LSI", "INF-01-00"},
        {TYPE_ANY, "ENGENIO", "INF-01-00"},
-       {0, "", ""},
+       {},
 };
 
 MODULE_DEVICE_TABLE(scsi_dh, rdac_dev_list);
--------------
Here is the panic
--------------

Faulting instruction address: 0xd0000000017e01c4
cpu 0x0: Vector: 300 (Data Access) at [c0000000e2fbb680]
    pc: d0000000017e01c4: .scsi_dh_handler_lookup+0x24/0xc0 [scsi_dh]
    lr: d0000000017e0200: .scsi_dh_handler_lookup+0x60/0xc0 [scsi_dh]
    sp: c0000000e2fbb900
   msr: 8000000000009032
   dar: d000000002f80017
 dsisr: 40000000
  current = 0xc0000000e7a84200
  paca    = 0xc000000000723400
    pid   = 3516, comm = modprobe
enter ? for help
[c0000000e2fbb900] c0000000e2fbb9e0 (unreliable)
[c0000000e2fbb9a0] d0000000017e0604 .device_handler_match+0x110/0x278
[scsi_dh]
[c0000000e2fbba50] d0000000017e0bd0 .scsi_dh_notifier_add+0x54/0x94
[scsi_dh]
[c0000000e2fbbae0] c0000000002d9d40 .bus_for_each_dev+0x80/0xd8
[c0000000e2fbbb90] d0000000017e0dc0 .scsi_register_device_handler
+0x90/0xcc [scsi_dh]
[c0000000e2fbbc20] d000000002f70ce8 .rdac_init+0x20/0x4d8 [scsi_dh_rdac]
[c0000000e2fbbca0] c0000000000090b0 .do_one_initcall+0x90/0x1a8
[c0000000e2fbbd90] c0000000000a0b28 .SyS_init_module+0xc4/0x214
[c0000000e2fbbe30] c000000000008534 syscall_exit+0x0/0x40
--- Exception: c00 (System Call) at 000000000ff11a6c
SP (ffb6f7e0) is in userspace
0:mon> 


