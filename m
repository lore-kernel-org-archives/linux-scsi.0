From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] minimal SAS transport class
Date: Wed, 24 Aug 2005 09:59:55 +0100
Message-ID: <20050824085955.GA26216@infradead.org>
References: <91888D455306F94EBD4D168954A9457C03B21627@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:61630 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750776AbVHXJAI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2005 05:00:08 -0400
Content-Disposition: inline
In-Reply-To: <91888D455306F94EBD4D168954A9457C03B21627@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: James.Smart@Emulex.Com, luben_tuikov@adaptec.com, jejb@steeleye.com, ltuikov@yahoo.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

On Mon, Aug 22, 2005 at 05:08:33PM -0600, Moore, Eric Dean wrote:
> On Sunday, August 21, 2005 10:53 AM, Christoph Hellwig wrote:
> > This is just a brindup helper because the Fusion hardware does a SAS
> > remote port to target ID mapping in firmware, in fact the firmware
> > interface only addresses them using this assigned ID, which is a big
> > shortcoming in the Fusion interface.  Once the more basic things are
> > dealt with that will go away, similarly to how Fusion won't be able
> > to use their firmware mapping for FC once they fully support the FC
> > transport class.
> >
> 
> Thats incorrect about the Fusion Firmware Interface.
> 
> The Sas Device Config pages offers three ways to access this config page.
> They are:  (1) GetNextHandle (2) BusTargetID (3) Handle.
> This is set in config page pageAddr field - bits 28-31.  Lets say you want
> to know all the devices out in the sas domain that is discovered by
> this HBA, you do the GetNextHandle method.  Bits 0-27 is the FormSpecific.
> In FormSpecific, you pass 0xFFFF for the first request, then you pass the
> devHandle for the previous config page to get the next.  The 3.02.55 code
> I sent you did this discovery in mptbase.c, in a function called
> mpt_sas_get_info.
> All this info is stored in a link list, that currently is used for CSMI.

That's actually what I'm doing in the patchkit I submitted (please review
it an given James a ACK/NACK, thanks), what I meant with addressing was
the I/O (or internal frame) submission path, which expects to have the
SPI-like target ID set.

