From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: HELP:  Is writeq an atomic operation??
Date: Fri, 2 May 2008 16:19:49 -0600
Message-ID: <0631C836DBF79F42B5A60C8C8D4E822901047B1D@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:53252 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755846AbYEBWTv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 18:19:51 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id m42MGFKc026800
	for <linux-scsi@vger.kernel.org>; Fri, 2 May 2008 15:16:15 -0700 (PDT)
Received: from namail.ad.lsil.com (namail.co.lsil.com [172.21.36.18])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id m42MJp54017458
	for <linux-scsi@vger.kernel.org>; Fri, 2 May 2008 15:19:51 -0700
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Is a 64bit write to MMIO registers an atomic operation when using the
writeq API?  

My concern is when I send 64bit data via writeq, will it be sent out as
two 32 bit writes?  If so, is it possible that another CPU be sending
the data at the same time.  Meaning can I write the 1st 32bit data from
CPU-A, meanwhile CPU-B is writing his 32bit data at the same time, and
CPU-A didn't complete the full 64bit in one shot.  If this could occur,
is there an API that I can use to make sure the entire data sent in one
atomic operation?


Here is a trace from pci express analyzer.   I'm sending
0x0800010000000000 to the adress DD1400C0 using writeq.   Notice that in
the TLP header it sent a 32bit Memory write with data length of two.

Trace follows:

Link Tra(597) Downstream 2.5(x1) TLP(1992) Mem MWr(32)(10:00000) TC(0)
TD(0) 
_______| EP(0) Attributes(01) Length(2) RequesterID(000:02:0) Tag(8) 
_______| Address(DD1400C0) 1st BE(1111) Last BE(1111) Data(08000100
00000000) 
_______| VC ID(0) Explicit ACK(Packet #1195) Metrics # Packets(2) 
_______| Time Stamp(0003 . 120 181 840 s) 
