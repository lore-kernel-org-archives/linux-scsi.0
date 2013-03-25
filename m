From: Mark Lehrer <mark@tpsit.com>
Subject: megaraid_sas (H710), fast SSD's, poor RAID0 performance
Date: Mon, 25 Mar 2013 09:57:40 -0600 (MDT)
Message-ID: <alpine.DEB.1.00.1303250922290.10890@shell>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from knm.org ([173.10.24.5]:47888 "EHLO knm.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932231Ab3CYQ6Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Mar 2013 12:58:24 -0400
Received: from [192.168.20.65] (account mark@knm.org HELO shell)
  by knm.org (CommuniGate Pro SMTP 5.4.8 _community_)
  with ESMTPSA id 9137895 for linux-scsi@vger.kernel.org; Mon, 25 Mar 2013 09:57:40 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hello there, I have a server in our test lab (specs below) that
doesn't appear to be getting nearly the write speeds that I was
expecting (test details below).  In "top" terminology, there is one
CPU core at about 30% SI and each core shows anywhere from 1 to 15 %
SY and about the same for WA.

My main question: what tools do I need to get some visibility as to
what is going on within the megaraid_sas module and on the SAS
controller itself?  I have gone about as far as I can go with
utilities such as top and MegaCli.

For simplicity, I am only focusing on raw write speed straight to the
block device.  I have a few benchmarks I use, mainly Orion and some of
the Phoronix suite, but Currently the easiest test is just:

dd if=/dev/zero of=/dev/sdc ibs=1048576 obs=1048576

The main symptom is that with a single disk I can push > 300MB/sec,
and with a pair in RAID0 I can get over 600MB/sec, but with 5 of these
in RAID0 it never goes above around 700MB/sec.  My next test will be
to use each disk as a separate device and try software raid (or just
writing to each disk simultaneously).


Thanks,
Mark

p.s. system specs:

Dell 720xd, H710 ("mini") controller
5x Micron P300 SATA SLC SSD's


