From: David Miller <davem@davemloft.net>
Subject: Re: MPT fusion SAS target numbering...
Date: Sat, 02 May 2009 15:53:29 -0700 (PDT)
Message-ID: <20090502.155329.184624068.davem@davemloft.net>
References: <20090502.151510.127219702.davem@davemloft.net>
	<660360F4F2570145BD872F298951B17A80F01F53@cosmail03.lsi.com>
	<20090502.155155.30314776.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37820
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752159AbZEBWxf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 May 2009 18:53:35 -0400
In-Reply-To: <20090502.155155.30314776.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsi.com
Cc: linux-scsi@vger.kernel.org, tayfun.kocaoglu@sun.com, Greg.Onufer@sun.com

From: David Miller <davem@davemloft.net>
Date: Sat, 02 May 2009 15:51:55 -0700 (PDT)

> From: "Moore, Eric" <Eric.Moore@lsi.com>
> Date: Sat, 2 May 2009 16:44:54 -0600
> 
>> the sas transport layer is assigning the target id's
> 
> Can you show me where that happens and how the MPT fusion
> SAS driver exports the SAS topology target IDs to that
> layer?

Just so you have a concrete example of the problem I am
having.  The SAS scan shows:

[   69.492431] mptsas_sas_device_pg0()
[   69.497824] mptsas: ioc0: ---- SAS DEVICE PAGE 0 ---------
[   69.497829] mptsas: ioc0: Handle=0x1
[   69.497832] mptsas: ioc0: Parent Handle=0x0
[   69.497836] mptsas: ioc0: Enclosure Handle=0x1
[   69.497840] mptsas: ioc0: Slot=0x0
[   69.497843] mptsas: ioc0: SAS Address=0x5080020000002999
[   69.497847] mptsas: ioc0: Target ID=0x3
[   69.497851] mptsas: ioc0: Bus=0x0
[   69.497854] mptsas: ioc0: Parent Phy Num=0x0
[   69.497857] mptsas: ioc0: Access Status=0x0
[   69.497861] mptsas: ioc0: Device Info=0x1071
[   69.497865] mptsas: ioc0: Flags=0x1
[   69.497868] mptsas: ioc0: Physical Port=0x0
[   69.497870] 
[   69.497874] mptsas_sas_device_pg0()
[   69.503148] mptsas: ioc0: ---- SAS DEVICE PAGE 0 ---------
[   69.503153] mptsas: ioc0: Handle=0x5
[   69.503156] mptsas: ioc0: Parent Handle=0x1
[   69.503160] mptsas: ioc0: Enclosure Handle=0x1
[   69.503163] mptsas: ioc0: Slot=0x0
[   69.503166] mptsas: ioc0: SAS Address=0x1221000000000000
[   69.503170] mptsas: ioc0: Target ID=0x0
[   69.503174] mptsas: ioc0: Bus=0x0
[   69.503177] mptsas: ioc0: Parent Phy Num=0x0
[   69.503180] mptsas: ioc0: Access Status=0x0
[   69.503184] mptsas: ioc0: Device Info=0x881
[   69.503187] mptsas: ioc0: Flags=0x2F3
[   69.503191] mptsas: ioc0: Physical Port=0x0

Targets 3 and 0, what I expect.

Yet the SCSI layer assigns targets 0 and 1 to these devices:

[   69.528237] mptsas_target_alloc: starget->id == 0
[   69.531525] mptsas_target_alloc: rphy == fffff8127d3bb000 sas_address=0x12210
00000000000
[   69.538112] mptsas_target_alloc: using phy_info id == 0
[   69.543938] scsi 0:0:0:0: Direct-Access     ATA      HITACHI HDS7225S A94A PQ
: 0 ANSI: 5
[   69.552860] sd 0:0:0:0: [sda] 488390625 512-byte hardware sectors: (250 GB/23
2 GiB)
[   69.552950] mptsas_target_alloc: starget->id == 1
[   69.552955] mptsas_target_alloc: rphy == fffff8127d3ab600 sas_address=0x12210
00003000000
[   69.552959] mptsas_target_alloc: using phy_info id == 3
[   69.554458] scsi 0:0:1:0: Direct-Access     ATA      INTEL SSDSA2MH08 8610 PQ
: 0 ANSI: 5

I want to know why this disconnect?  Shouldn't the SAS topology
provided target IDs be used instead?

