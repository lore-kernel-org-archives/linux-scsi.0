From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH] mptsas: fix dma alignment
Date: Tue, 8 Sep 2009 10:19:25 -0600
Message-ID: <660360F4F2570145BD872F298951B17AE32BDE1C@cosmail03.lsi.com>
References: <1252419766.3990.47.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og124.obsmtp.com ([64.18.2.26]:33959 "EHLO
	exprod7og124.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbZIHQTo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2009 12:19:44 -0400
In-Reply-To: <1252419766.3990.47.camel@mulgrave.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: Vitaly Bordug <vitb@kernel.crashing.org>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tuesday, September 08, 2009 8:23 AM,  James Bottomley wrote:
> On Tue, 2009-09-08 at 13:49 +0530, Desai, Kashyap wrote:
> > After seeing original commit from James, this patch looks OK to me.
> > Please consider this patch as ACKed by me.
> 
> If you're sure it's a problem.  The reason for the original 
> was that all
> DMA engines (including the old LSI 1010) can transfer on word
> boundaries.  I didn't realise the 1030 had regressed in terms of DMA
> alignment requirements.
> 

James, correct.  The scatter gather elements themselfs have to be on 4 byte boundary.    Thus I don't believe this patch is required.

However the alignment restrictions are for Request Message Frames, chains, and sense buffer can't cross 4GB boundary.  The reason is the driver reports the upper 32bit address in the ioc_init request at driver load time.

Eric
