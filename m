From: Mark Lord <lkml@rtr.ca>
Subject: Re: Core scsi layer crashes in 2.6.8.1
Date: Tue, 05 Oct 2004 11:46:34 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <4162C1DA.5000808@rtr.ca>
References: <1096401785.13936.5.camel@localhost.localdomain>	<1096467125.2028.11.camel@m	ulgrave> 	<20041005114951.GD22396@krispykreme.ozlabs.ibm.com>	<1096984590.1765.2.camel@mulgrave>  <4162B345.9000806@rtr.ca> <1096988167.2064.7.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S270063AbUJEPvc@vger.kernel.org>
In-Reply-To: <1096988167.2064.7.camel@mulgrave>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mark Lord <lsml@rtr.ca>, Anton Blanchard <anton@samba.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
>
> This is expected behaviour.  For orderly removal an cache sync command
> must be sent to drives with a writeback cache before they're powered
> down.  For forced ejection, the driver has to error the command.

Yup, that's how it has to be done at present.

Another weirdness I ran into at one point, was that the mid-layer
could be made to segfault if a LLD asked it to remove a drive that
had previously been set "offline" -- it complains about an illegal
state transition during the removal, and then dies.  This sequence
no longer occurs in the QStor driver, but it might resurface soon
as more drivers begin to support hot insertion/removal.

Cheers
-- 
Mark Lord
(hdparm keeper & the original "Linux IDE Guy")
