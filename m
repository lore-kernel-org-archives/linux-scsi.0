From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] mvsas: ATAPI LUN issue
Date: Thu, 27 Mar 2008 15:07:55 -0700
Message-ID: <1206655675.3662.14.camel@localhost.localdomain>
References: <47E87F67.4080501@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60429 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752104AbYC0XUn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Mar 2008 19:20:43 -0400
In-Reply-To: <47E87F67.4080501@marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kewei@marvell.com
Cc: linux-scsi@vger.kernel.org, jeff@garzik.org

On Tue, 2008-03-25 at 12:28 +0800, Ke Wei wrote:
> I found that sending REPORT_LUNS command to some DVD device will 
> cause fis error and controller error record. As a result, scsi mid layer 
> get some wrong LUNs. Also I can get some queer messages.
> 
> scsi: host 12 channel 0 id 2 lun 0x30302e302f686f73 has a LUN larger 
> than currently supported.
> scsi: host 12 channel 0 id 2 lun 0x7431322f706f7274 has a LUN larger 
> than currently supported.
> scsi: host 12 channel 0 id 2 lun 0x2d31323a322f656e has a LUN larger 
> than currently supported.
> ...
> 
>     The patch forced to clear the sg buffer of SATA response if FIS is 
> error. But I suggest these codes should remove to the libsas module.

My first observation is that this isn't the correct approach:  Most of
the CD/DVD simply respond with an error or the correct information.  The
odd media changer will actually respond with real LUNs.  Doing a blanket
erase of the REPORT LUN information will cause problems for media
changers.

I think the correct way to fix your problem is to blacklist the
particular CD.  We have a BLIST_NOREPORTLUN for devices which behave
like this ... what are the INQUIRY strings?

James


