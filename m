From: Jan-Frode Myklebust <janfrode@parallab.uib.no>
Subject: qla2300 failed to initialize adapter on 2.6.7-rc3
Date: Tue, 8 Jun 2004 18:53:23 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040608165323.GA4739@ii.uib.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eik.ii.uib.no ([129.177.16.3]:62687 "EHLO eik.ii.uib.no")
	by vger.kernel.org with ESMTP id S265252AbUFHQx2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2004 12:53:28 -0400
Received: from lapprose.ii.uib.no ([129.177.20.37]:55059)
	by eik.ii.uib.no with esmtp (TLSv1:AES256-SHA:256)
	(Exim 4.30)
	id 1BXjqm-0006v7-2z
	for linux-scsi@vger.kernel.org; Tue, 08 Jun 2004 18:53:24 +0200
Received: (from jfm@localhost)
	by lapprose.ii.uib.no (8.12.8/8.12.8/Submit) id i58GrNaT004948
	for linux-scsi@vger.kernel.org; Tue, 8 Jun 2004 18:53:23 +0200
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I only tried once since it's on our NFS-server and I wanted to avoid
downtime, but ... when booting 2.6.7-rc3 it failed to initialize my
qla2300 fibre channel adapter:

'dmesg' logged:

QLogic Fibre Channel HBA Driver (c030edd0)
qla2300 0000:01:05.0: Found an ISP2300, irq 145, iobase 0xf8834000
qla2300 0000:01:05.0: Configuring PCI space...
qla2300 0000:01:05.0: Configure NVRAM parameters...
qla2300 0000:01:05.0: Verifying loaded RISC code...
qla2300 0000:01:05.0: Waiting for LIP to complete...
qla2300 0000:01:05.0: LOOP UP detected (2 Gbps).
qla2300 0000:01:05.0: Topology - (N_Port-to-N_Port), Host Loop address 0x1
qla2300 0000:01:05.0: Failed SNS login: loop_id=80 mb[0]=4005 mb[1]=5 mb[2]=0 mb[6]=423 mb[7]=922e
qla2300 0000:01:05.0: Failed to initialize adapter
Trying to free free IRQ145
qla2300: probe of 0000:01:05.0 failed with error -1

On 2.6.6 it works fine, and logs:

QLogic Fibre Channel HBA Driver (c030b2e0)
qla2300 0000:01:05.0: Found an ISP2300, irq 145, iobase 0xf8834000
qla2300 0000:01:05.0: Configuring PCI space...
qla2300 0000:01:05.0: Configure NVRAM parameters...
qla2300 0000:01:05.0: Verifying loaded RISC code...
qla2300 0000:01:05.0: Waiting for LIP to complete...
qla2300 0000:01:05.0: LOOP UP detected (2 Gbps).
qla2300 0000:01:05.0: Topology - (N_Port-to-N_Port), Host Loop address 0x1
qla2300 0000:01:05.0: Failed SNS login: loop_id=80 mb[0]=4005 mb[1]=5 mb[2]=0 mb[6]=423 mb[7]=922e
scsi1 : qla2xxx
qla2300 0000:01:05.0:
 QLogic Fibre Channel HBA Driver: 8.00.00b11-k
  QLogic QLA2300 -
  ISP2300: PCI (33 MHz) @ 0000:01:05.0 hdma-, host#=1, fw=3.02.26 IPX
  Vendor: IFT       Model: A16F-G1A2         Rev: 334A
  Type:   Direct-Access                      ANSI SCSI revision: 03
qla2300 0000:01:05.0: scsi(1:0:0:0): Enabled tagged queuing, queue depth 32.
  Vendor: IFT       Model: A16F-G1A2         Rev: 334A
  Type:   Direct-Access                      ANSI SCSI revision: 03
qla2300 0000:01:05.0: scsi(1:0:0:1): Enabled tagged queuing, queue depth 32.
  Vendor: IFT       Model: A16F-G1A2         Rev: 334A
  Type:   Direct-Access                      ANSI SCSI revision: 03
qla2300 0000:01:05.0: scsi(1:0:0:2): Enabled tagged queuing, queue depth 32.
  Vendor: IFT       Model: A16F-G1A2         Rev: 334A
  Type:   Direct-Access                      ANSI SCSI revision: 03
qla2300 0000:01:05.0: scsi(1:0:0:3): Enabled tagged queuing, queue depth 32.


  -jf
