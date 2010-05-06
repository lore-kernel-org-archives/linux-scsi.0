From: James Smart <james.smart@emulex.com>
Subject: Re: lpfc SAN/SCSI issue
Date: Thu, 6 May 2010 09:39:10 -0400
Message-ID: <4BE2C67E.30509@emulex.com>
References: <20100422164739.GA15813@lsil.com> <4BD1A071.2010202@emulex.com>	 <j2o29ae894c1004230922le8baf635y563e50e3edc53bc3@mail.gmail.com>	 <4BD226F4.6070908@emulex.com> <1272109999.2983.30.camel@localhost>	 <4BD5D258.8030309@emulex.com> <1272318721.16254.7.camel@localhost>	 <1272389874.4245.2.camel@localhost>	 <k2w29ae894c1005030939lc95722dds328a2ee956b06ba1@mail.gmail.com>	 <4BE17A27.5040603@emulex.com> <z2x29ae894c1005060406l24d47eb8p7e97b6c5955bc259@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:28798 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758324Ab0EFNjc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 May 2010 09:39:32 -0400
In-Reply-To: <z2x29ae894c1005060406l24d47eb8p7e97b6c5955bc259@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brem belguebli <brem.belguebli@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


brem belguebli wrote:
> However, we do not have anymore x26 opcode error messages, though I
> wasn't sure this was the root cause of the problem we had during the
> DWDM ring failover,

It most likely wasn't - although error handlers on some arrays, when 
overloaded or going through failovers, sometimes react oddly.

> I increased the logging (0xffff) on the HBA's of
> the nodes (total 4 nodes, 2 that were reporting the x26 opcode error
> say Group A, and the 2 that never did, say Group B).

I did not recommend 0xFFFF as it turns on everything - whether error or not. 
The value I gave should have filtered out non-errors.

> These 4 nodes form a cluster accessing the same LUNS thru the same
> controllers the very same way, and I get errors relative to INQUIRY on
>  Group A:
> 
> lpfc 0000:10:00.1: 1:(0):0730 FCP command x12 failed: x0 SNS x0 x0
> Data: x8 x3c x0 x0 x0
> lpfc 0000:10:00.1: 1:(0):0716 FCP Read Underrun, expected 96, residual
> 60 Data: x3c x12 x0
> lpfc 0000:10:00.1: 1:0336 Rsp Ring 0 error: IOCB Data: xff000018
> xe99fc48 x0 x0 x3c x0 x1d70c8e xa29b16

Yes - this a normal response for SCSI commands where the command allows 
variable length data from the target - INQUIRY is such a case. We report any 
SCSI completion error - such as this underrun (target returned less data than 
the buffer the host gave it).  This is not an error.

> Group B doesn't show no error.

If you're not seeing the underrun error - there isn't i/o being performed. And 
if INQUIRY isn't being seen, the midlayer isn't attempting to scan the device. 
  Most likely is the hba isn't even seeing the target, which should be visible 
from the lpfc log messages on FC discovery.  Please send me the log messages 
for the Group B hosts and I'll help interpret - However! don't spam linux-scsi 
with this huge log (especially if 0xffff, the older log value should have been 
good enough). Send it to me off-list.

-- james s
