From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v2 2/3] libiscsi, iser: Adjust data_length to include
 protection information
Date: Wed, 06 Aug 2014 15:43:44 +0300
Message-ID: <53E22300.3090907@dev.mellanox.co.il>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com> <1402477799-24610-3-git-send-email-sagig@mellanox.com> <53D4CFAB.3040804@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53D4CFAB.3040804-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boaz Harrosh <openosd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi Boaz,

On 7/27/2014 1:08 PM, Boaz Harrosh wrote:
<SNIP>
>> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
>> index 26dc005..3f46234 100644
>> --- a/drivers/scsi/libiscsi.c
>> +++ b/drivers/scsi/libiscsi.c
>> @@ -338,7 +338,7 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
>>   	struct iscsi_session *session = conn->session;
>>   	struct scsi_cmnd *sc = task->sc;
>>   	struct iscsi_scsi_req *hdr;
>> -	unsigned hdrlength, cmd_len;
>> +	unsigned hdrlength, cmd_len, transfer_length;
>
> I hate that you introduced this new transfer_length variable. It does
> not exist. In BIDI supporting driver there is out_len and in_len just
> as original code.

Effectively, out_len and in_len are the same except for the bidi case.
Moreover, the hdr->data_length is exactly the command scsi data buffer
length, the bidi length is taken from scsi_in when we build the AHS for
bidi (rlen_ahdr->read_length).

So to me it is correct and makes sense. But I'm don't feel so strong
about it...

Mike what's your take on this?

>
>>   	itt_t itt;
>>   	int rc;
>>
>> @@ -391,11 +391,11 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
>>   	if (scsi_get_prot_op(sc) != SCSI_PROT_NORMAL)
>>   		task->protected = true;
>>
>> +	transfer_length = scsi_transfer_length(sc);
>> +	hdr->data_length = cpu_to_be32(transfer_length);
>>   	if (sc->sc_data_direction == DMA_TO_DEVICE) {
>> -		unsigned out_len = scsi_out(sc)->length;
>
> In light of all the comments and the obvious bugs, please just
> re do this patch. Do not just later fix this one.
>
> All you need is:
> +		unsigned out_len = scsi_transfer_length(sc ,scsi_out(sc));
>
> Also I would love if you left the addition to the user .I.E
>
> 		out_len += scsi_proto_length(sc ,scsi_out(sc));
>
> This way we can see that this addition is because of scsi_proto and that
> this particular driver puts them together in the same payload. There can be
> other DIFF supporting drivers that put the DIFF payload on another stream / another
> SG list, like the sata one, right?

I think that DIF specification says that on the wire the data and
protection are interleaved i.e. Block1, DIF1, Block2, DIF2...

So I do think that the transfer length should always include
data_length + protection_length.

>
> BTW: When reading DIFF devices, don't you have extra bits to read as well?
>       How does the DIFF read works? Please get me up to speed. I'm not familiar
>       with this protocol?
>       (I'd imagine that if say an app reads X bytes with DIFF info, it wants to
>        receive its DIFF checksome for every sector in X, where is this info
>        on the iscsi wire?)
>

The application wants to read X bytes from a DIF formatted device, the
initiator will prepare buffers for data and for DIF data (in some
implementations it can be the same buffer but not in Linux), and request
reading X+DIF_size bytes (where each block is followed by it's
corresponding integrity field) and place the data blocks in the data
buffer and the integrity fields in the DIF data buffer (usually this
is offloaded).

>>
>>   		if (sc->sc_data_direction == DMA_FROM_DEVICE)
>>   			hdr->flags |= ISCSI_FLAG_CMD_READ;
>> @@ -466,7 +466,7 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
>>   			  scsi_bidi_cmnd(sc) ? "bidirectional" :
>>   			  sc->sc_data_direction == DMA_TO_DEVICE ?
>>   			  "write" : "read", conn->id, sc, sc->cmnd[0],
>> -			  task->itt, scsi_bufflen(sc),
>> +			  task->itt, transfer_length,
>
> And this
>
> This print is correct as it covers all cases. If you want to print the adjusted
> length then OK, you'd need to store this I guess, but store it as a different
> variable like proto_length and print it as an additional variable.

But it is the transfer length that is sent in iSCSI header. Why do you
want to print it as additional info? for transactions that include DIF
the length is the data + protection.

> The current print is one-to-one with what the caller requested, FS wrote X bytes.

It is still one-to-one isn't it?

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
