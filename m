From: Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH][SCS] sd: Read Capacity if (16) fails
Date: Wed, 6 Aug 2008 16:34:16 +0100 (BST)
Message-ID: <Pine.LNX.4.64.0808061629220.10184@blonde.site>
References: <Pine.LNX.4.64.0808061500450.1109@blonde.site>
 <yq1d4kmi5hl.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:56378 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759622AbYHFPe7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Aug 2008 11:34:59 -0400
In-Reply-To: <yq1d4kmi5hl.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 6 Aug 2008, Martin K. Petersen wrote:
> >>>>> "Hugh" == Hugh Dickins <hugh@veritas.com> writes:
> 
> Hugh> Commit e0597d70012c82e16ee152270a55d89d8bf66693 (sd: Identify
> Hugh> DIF protection type and application tag ownership) says that if
> Hugh> a disk is formatted with Inquiry bit PROTECT=1, it is required
> Hugh> to support Read Capacity(16).  But my SD cards, accessed by
> Hugh> builtin cardreader and generic USB storage, disagree.
> 
> Argh.  That's really broken.  USB storage has no business setting
> PROTECT.
> 
> Can you send me the sg_inq output so I can see what else they are
> returning?

sg_inq?  I assume that's the same as the inquiry_len bytes at inquiry:

00000000: 00 8d 00 01 1f 01 00 00 47 65 6e 65 72 69 63 2d  ........Generic-
00000010: 4d 75 6c 74 69 2d 43 61 72 64 20 20 20 20 20 20  Multi-Card      
00000020: 31 2e 30 30                                      1.00

Ah, sg_inq is a command which spells that out, here you go:

standard INQUIRY:
  PQual=0  Device_type=0  RMB=1  version=0x00  [no conformance claimed]
  [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=1
  SCCS=0  ACC=0  TGPS=0  3PC=0  Protect=1  BQue=0
  EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
  [RelAdr=0]  WBus16=0  Sync=0  Linked=0  [TranDis=0]  CmdQue=0
    length=36 (0x24)   Peripheral device type: disk
 Vendor identification: Generic-
 Product identification: Multi-Card      
 Product revision level: 1.00

Hugh
