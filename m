From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Can LSISAS1068E chip be configured as a x8 wide port?
Date: Sat, 27 Jun 2009 14:23:24 -0400
Message-ID: <4A46639C.2070404@interlog.com>
References: <200906271859275463726@gmail.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from firefly.infotech.no ([82.134.31.146]:54872 "EHLO
	elrond.bb.infotech.no" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750821AbZF0SX2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Jun 2009 14:23:28 -0400
In-Reply-To: <200906271859275463726@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "wenshuang.ma" <wenshuang.ma@gmail.com>
Cc: Eric <Eric.Moore@lsil.com>, linux-scsi <linux-scsi@vger.kernel.org>

wenshuang.ma wrote:
> Hi,
> 
> LSISAS1068E is a 2 ports(total 8 PHY) SAS controller with per port can be 
> configured as a 4 PHY SAS wide port,with the usage of arbitrary one
> port LSISAS1068E can control a SAS expander through a MiniSASx4 to 
> SASx4 cable,we get 4 connections simultaneously.Is it possible for 
> LSISAS1068E to control one SAS expander through two MiniSASx4 to SASx4
> cables so we can have 8 connections simultaneously(more bandwidth)
> if not,why? 

During my experiments I tried something like that
and couldn't get a wide port wider than 4 phys.

I think the reason was that each group of 4 phys
has a different initiator port identifier (SAS
address) seen from the expander. You could check
that with smp_discover (in my smp_utils package).
Or perhaps there was another reason (e.g. perhaps
the expander didn't support it). It didn't work
anyway.

Can LSI's SAS-2 chips do 8 (phy) wide ports?


Note: What SCSI/SAS calls a "port" and LSI's usage
of that term is a bit different. For example you
want two "LSI" ports to act as one SCSI port.

Doug Gilbert
