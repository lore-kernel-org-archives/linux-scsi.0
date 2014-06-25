From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v2 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Wed, 25 Jun 2014 13:32:39 +0300
Message-ID: <53AAA547.40300@dev.mellanox.co.il>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com> <1402477799-24610-2-git-send-email-sagig@mellanox.com> <53A920B2.9060503@cs.wisc.edu> <yq1mwd2h3ju.fsf@sermon.lab.mkp.net> <28678EBD-1AE9-48F9-B9E2-E6A61B042BB1@cs.wisc.edu> <53A9A702.8050503@dev.mellanox.co.il> <20140624163040.GA11499@infradead.org> <53A9AEB8.4040104@cs.wisc.edu> <53A9B0A0.6000103@cs.wisc.edu> <53AA42E6.3090101@cs.wisc.edu> <53AA8CF7.8050102@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:51644 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711AbaFYKcp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jun 2014 06:32:45 -0400
Received: by mail-wi0-f179.google.com with SMTP id cc10so2280343wib.12
        for <linux-scsi@vger.kernel.org>; Wed, 25 Jun 2014 03:32:44 -0700 (PDT)
In-Reply-To: <53AA8CF7.8050102@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, nab@linux-iscsi.org, roland@kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org

On 6/25/2014 11:48 AM, Sagi Grimberg wrote:

<SNIP>
>
>> I made the patch below which should fix both bidi
>> support in iscsi and also WRITE_SAME (and similar commands) support.
>
> I'm a bit confused, for all commands (bidi or not) the iscsi header 
> data_length
> should describe the scsi_data_buffer length, bidi information will lie 
> in AHS header.
> (in case bidi will ever co-exist with PI, we might need another helper 
> that will look
> in req->special + PI, something like scsi_bidi_transfer_length)
>
> So why not keep scsi_transfer_length to work on sdb length (take 
> scsi_bufflen(scmnd) or
> scsi_out(scmnd)->length as MKP suggested) and that's it - don't touch 
> libiscsi.
>
> Let me test that.
>

So I tested a bidirectional command using:
$ sg_raw --infile=/root/filex --send=1024 --request=1024 
--outfile=/root/filex "/dev/bsg/7:0:0:0" 53 00 00 00 00 00 00 00 02 00

And I see:
kernel: session1: iscsi_prep_scsi_cmd_pdu iscsi prep [bidirectional cid 
0 sc ffff880468ca1e00 cdb 0x53 itt 0x16 len 1024 bidi_len 1024 cmdsn 223 
win 64]

This confirms what I wrote above, so AFAICT no additional fix is 
required for libiscsi wrt bidi commands support.

Mike?

Sagi.
