From: Boaz Harrosh <openosd@gmail.com>
Subject: Re: [PATCH v2 2/3] libiscsi, iser: Adjust data_length to include
 protection information
Date: Wed, 06 Aug 2014 16:25:58 +0300
Message-ID: <53E22CE6.9070202@gmail.com>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com> <1402477799-24610-3-git-send-email-sagig@mellanox.com> <53D4CFAB.3040804@gmail.com> <53E22300.3090907@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <53E22300.3090907@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, Sagi Grimberg <sagig@mellanox.com>, michaelc@cs.wisc.edu, martin.petersen@oracle.com, nab@linux-iscsi.org, roland@kernel.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/06/2014 03:43 PM, Sagi Grimberg wrote:
> Hi Boaz,
> 
<>
>>
>> I hate that you introduced this new transfer_length variable. It does
>> not exist. In BIDI supporting driver there is out_len and in_len just
>> as original code.
> 
> Effectively, out_len and in_len are the same except for the bidi case.
> Moreover, the hdr->data_length is exactly the command scsi data buffer
> length, the bidi length is taken from scsi_in when we build the AHS for
> bidi (rlen_ahdr->read_length).
> 
> So to me it is correct and makes sense. But I'm don't feel so strong
> about it...
> 
> Mike what's your take on this?
> 

I have a patch to clean all that, will send tomorrow. 

What I mean is that this is on the out-path only the in path is different.
See the code this variable is only used in the if (== DMA_TO_DEVICE) case and
should be local to that scope. This is my clean up

<>
>> this particular driver puts them together in the same payload. There can be
>> other DIFF supporting drivers that put the DIFF payload on another stream / another
>> SG list, like the sata one, right?
> 
> I think that DIF specification says that on the wire the data and
> protection are interleaved i.e. Block1, DIF1, Block2, DIF2...
> 

No it does not. This is a per transport, and actually per device host
driver. Yes in iSCSI_tcp they are inline in HW cards they might come as
two different SGs (Like the Linux model). Even with iscsi-offload they might
want to be two SG-lists.

> So I do think that the transfer length should always include
> data_length + protection_length.
> 

This is at the iscsi level. But the scsi_transfer_length() is on the scsi
level which keeps them separate. So I think the proper API should be
	scsi_proto_length()

And for LLDs that want them together they can do scsi_bufflen() + scsi_proto_length()
and for other drivers they can do it separately. Don't infect iscsi level assumptions
on the generic layer API.

Again my patch fixes this.

>> And this
>>
>> This print is correct as it covers all cases. If you want to print the adjusted
>> length then OK, you'd need to store this I guess, but store it as a different
>> variable like proto_length and print it as an additional variable.
> 
> But it is the transfer length that is sent in iSCSI header. Why do you
> want to print it as additional info? 

I want to see what was the length the app/FS sent, then as added
info how much was added for DIFF, your way there is lost information.

> for transactions that include DIF
> the length is the data + protection.
> 
> It is still one-to-one isn't it?
> 

No! the original submitted length is lost from the print

> Sagi.
> 

Shalom
Boaz
