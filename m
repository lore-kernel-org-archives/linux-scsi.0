From: Benny Halevy <bhalevy.lists@gmail.com>
Subject: Re: [PATCH 3/3] iscsi_tcp: Enable large commands
Date: Tue, 15 Apr 2008 16:57:20 +0300
Message-ID: <4804B440.20109@gmail.com>
References: <20080414010112W.tomof@acm.org> <1208170266-1676-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <48049E8A.7030700@panasas.com> <4804A16D.7000002@panasas.com> <4804A8C7.504@emulex.com> <4804AFBA.1070105@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:56918 "EHLO
	bh-buildlin1.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782AbYDON7Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Apr 2008 09:59:24 -0400
In-Reply-To: <4804AFBA.1070105@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James.Smart@Emulex.Com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Alasdair G Kergon <agk@redhat.com>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

On Apr. 15, 2008, 16:38 +0300, Boaz Harrosh <bharrosh@panasas.com> wrote:
> On Tue, Apr 15 2008 at 16:08 +0300, James Smart <James.Smart@Emulex.Com> wrote:
>> Boaz Harrosh wrote:
>>> Let through up to the largest command of 260 defined by the scsi standard.
>>> iscsi core supports this already. Now that the scsi-ml supports it we can
>>> start using large commands.
>> Just to double-check:
>> if we use sg_io to pass through requests from user-land, which are addressed to
>> drivers or transports, and which may not be a SCSI command but rather just something
>> utilizing the sg_io infrastructure for management or pass-thru, are we limited to
>> 260 bytes for request/cmd payload ?
>>
>> -- james s
> 
> I think that only bsg, after the pending patches get accepted, will let you
> pass larger then 16 bytes commands from user-land. sg_io is I think limited 
> to 16. However this could be fixed. (With sg_io, did you mean commands going
> through the sg.c driver?)
> 
> The block layer imposes no limits, and so is scsi-ml. The only limits are from
> ULDs, and LLDs, like here, iscsi protocol does not support more then 
> SCSI_MAX_VARLEN_CDB_SIZE (260).

Actually the 260 byte limit comes from SCSI variable length CDB maximum length.
iSCSI allows to send larger CDBs with the Extended CDB AHS that has a 16 bit
length field. Within the protocol constraints, the longest CDB would be
16 (in BHS) + 65532 (in AHS) = 65548 bytes long :)

Benny

> 
> If you need support in any other ULD, I will be happy to help.
> 
> Boaz
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

