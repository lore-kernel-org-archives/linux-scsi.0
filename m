From: Boaz Harrosh <openosd@gmail.com>
Subject: Re: [PATCH v2 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Sun, 27 Jul 2014 12:11:11 +0300
Message-ID: <53D4C22F.8050904@gmail.com>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com> <1402477799-24610-2-git-send-email-sagig@mellanox.com> <53A920B2.9060503@cs.wisc.edu> <yq1mwd2h3ju.fsf@sermon.lab.mkp.net> <28678EBD-1AE9-48F9-B9E2-E6A61B042BB1@cs.wisc.edu> <53A9A702.8050503@dev.mellanox.co.il> <20140624163040.GA11499@infradead.org> <53A9AEB8.4040104@cs.wisc.edu> <53A9B0A0.6000103@cs.wisc.edu> <53AA42E6.3090101@cs.wisc.edu> <53AA8CF7.8050102@dev.mellanox.co.il> <53AAA547.40300@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <53AAA547.40300@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, nab@linux-iscsi.org, roland@kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/25/2014 01:32 PM, Sagi Grimberg wrote:
> On 6/25/2014 11:48 AM, Sagi Grimberg wrote:
> 
> <SNIP>
>>
>>> I made the patch below which should fix both bidi
>>> support in iscsi and also WRITE_SAME (and similar commands) support.
>>
>> I'm a bit confused, for all commands (bidi or not) the iscsi header 
>> data_length
>> should describe the scsi_data_buffer length, bidi information will lie 
>> in AHS header.
>> (in case bidi will ever co-exist with PI, we might need another helper 
>> that will look
>> in req->special + PI, something like scsi_bidi_transfer_length)
>>
>> So why not keep scsi_transfer_length to work on sdb length (take 
>> scsi_bufflen(scmnd) or
>> scsi_out(scmnd)->length as MKP suggested) and that's it - don't touch 
>> libiscsi.
>>
>> Let me test that.
>>
> 
> So I tested a bidirectional command using:
> $ sg_raw --infile=/root/filex --send=1024 --request=1024 
> --outfile=/root/filex "/dev/bsg/7:0:0:0" 53 00 00 00 00 00 00 00 02 00
> 
> And I see:
> kernel: session1: iscsi_prep_scsi_cmd_pdu iscsi prep [bidirectional cid 
> 0 sc ffff880468ca1e00 cdb 0x53 itt 0x16 len 1024 bidi_len 1024 cmdsn 223 
> win 64]
> 

This is a very bad example and tested nothing, since len && bidi_len
are the same. So even if you had a bug and took length from the
wrong side it would come out the same.

You must test with a bidi command that has two different lengths for
each side

If you have a tree that you want me to test I will be glad too.
>From this thread I'm confused as to what patches you want me to
test? please point me to a tree you need testing. You can bug me
any time, any tree. I will be happy to test.

Cheers
Boaz

> This confirms what I wrote above, so AFAICT no additional fix is 
> required for libiscsi wrt bidi commands support.
> 
> Mike?
> 
> Sagi.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
