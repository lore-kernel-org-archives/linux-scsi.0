Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99566C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 14:57:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83A6920829
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 14:57:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgG2O45 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 10:56:57 -0400
Received: from netrider.rowland.org ([192.131.102.5]:42093 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726385AbgG2O45 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 10:56:57 -0400
Received: (qmail 1574449 invoked by uid 1000); 29 Jul 2020 10:56:56 -0400
Date:   Wed, 29 Jul 2020 10:56:56 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Martin Kepplinger <martin.kepplinger@puri.sm>,
        Bart Van Assche <bvanassche@acm.org>, jejb@linux.ibm.com,
        Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@puri.sm
Subject: Re: [PATCH] scsi: sd: add runtime pm to open / release
Message-ID: <20200729145656.GA1574246@rowland.harvard.edu>
References: <20200706164135.GE704149@rowland.harvard.edu>
 <d0ed766b-88b0-5ad5-9c10-a4c3b2f994e3@puri.sm>
 <20200728200243.GA1511887@rowland.harvard.edu>
 <f3958758-afce-8add-1692-2a3bbcc49f73@puri.sm>
 <20200729143213.GC1530967@rowland.harvard.edu>
 <yq15za68k17.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq15za68k17.fsf@ca-mkp.ca.oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 29, 2020 at 10:44:26AM -0400, Martin K. Petersen wrote:
> 
> Alan,
> 
> >> [   77.474632] sd 0:0:0:0: [sda] tag#0 UNKNOWN(0x2003) Result:
> >> hostbyte=0x00 driverbyte=0x08 cmd_age=0s
> >> [   77.474647] sd 0:0:0:0: [sda] tag#0 Sense Key : 0x6 [current]
> >> [   77.474655] sd 0:0:0:0: [sda] tag#0 ASC=0x28 ASCQ=0x0
> >> [   77.474667] sd 0:0:0:0: [sda] tag#0 CDB: opcode=0x28 28 00 00 00 60
> >> 40 00 00 01 00
> >
> > This error report comes from the SCSI layer, not the block layer.
> 
> This the device telling us that the media (SD card?) has changed.

Ah yes, thank you.  I knew that SK=6 ASC=0x28 meant "Not Ready to Ready 
Transition", but I had forgotten the "(Media May Have Changed)" part.

This makes sense and is a reasonable thing to see, since many SD card 
readers lose track of whether or not the card has been changed when they 
go into suspend.

Alan Stern
