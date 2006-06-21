From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Always seeing 36 LUNs from qla2xxx HBA
Date: Wed, 21 Jun 2006 02:40:34 +0200
Message-ID: <1150850434.3057.3.camel@laptopd505.fenrus.org>
References: <20060620235940.GC10957@wiggle.dreamhost.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:10125 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751423AbWFUAkh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jun 2006 20:40:37 -0400
In-Reply-To: <20060620235940.GC10957@wiggle.dreamhost.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arild Jensen <ml-linux-scsi@counter-attack.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 2006-06-20 at 16:59 -0700, Arild Jensen wrote:
> I have an interesting problem on my Linux box:
> 
> Setup:
> IBM x445 server
> 2 x QLA2340 fiber HBAs
> Brocade Director 12000 switch
> Hitachi HDS 9960 RAID array
> SLES 9 OS, kernel-bigsmp-2.6.5-7.201
> 
> Problem:
> The qla2xxx driver *always* reports 36 SCSI2 LUNs, regardless of what I
> configure on the RAID array. It should report 17 SCSI3 LUNs. 

why should it report 17?

if you have set up 17 luns, showing up as 36 devices is not that
strange; first you have the management lun, so the kernel should see18
if you configure 17 real disk ones, and then you have 2 paths to the
device, so that is times 2 ==> 36. Now the multipathing in the linux
kernel then should bundle those into multipathing devices, after the
kernel sees them. If that's not happening you should configure the dm
multipathing component....

was the machine that is working also using multipathing?


