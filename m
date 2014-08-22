From: Juergen Gross <jgross@suse.com>
Subject: Re: [Xen-devel] [PATCH V5 2/5] Add XEN pvSCSI protocol description
Date: Fri, 22 Aug 2014 06:18:03 +0200
Message-ID: <53F6C47B.5010900@suse.com>
References: <1408354310-6362-1-git-send-email-jgross@suse.com>	<1408354310-6362-3-git-send-email-jgross@suse.com>	<20140820132503.GE3120@laptop.dumpdata.com>	<53F4AA55.3030004@suse.com> <20140821192626.GC18662@laptop.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20140821192626.GC18662@laptop.dumpdata.com>
Sender: target-devel-owner@vger.kernel.org
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-scsi@vger.kernel.org, nab@linux-iscsi.org, JBottomley@parallels.com, xen-devel@lists.xen.org, hch@infradead.org, target-devel@vger.kernel.org, david.vrabel@citrix.com, JBeulich@suse.com
List-Id: linux-scsi@vger.kernel.org

On 08/21/2014 09:26 PM, Konrad Rzeszutek Wilk wrote:
> On Wed, Aug 20, 2014 at 04:01:57PM +0200, Juergen Gross wrote:
>> On 08/20/2014 03:25 PM, Konrad Rzeszutek Wilk wrote:
>>> On Mon, Aug 18, 2014 at 11:31:47AM +0200, jgross@suse.com wrote:
...
>>>> +struct vscsiif_request {
>>>> +	uint16_t rqid;		/* private guest value, echoed in resp  */
>>>> +	uint8_t act;		/* command between backend and frontend */
>>>> +	uint8_t cmd_len;	/* valid CDB bytes */
>>>> +
>>>> +	uint8_t cmnd[VSCSIIF_MAX_COMMAND_SIZE];	/* the CDB */
>>>> +	uint16_t timeout_per_command;
>>>> +	uint16_t channel, id, lun;	/* (virtual) device specification */
>>>> +	uint16_t ref_rqid;		/* command abort reference */
>>>> +	uint8_t sc_data_direction;	/* for DMA_TO_DEVICE(1)
>>>> +					   DMA_FROM_DEVICE(2)
>>>> +					   DMA_NONE(3) requests */
>>>> +	uint8_t nr_segments;		/* Number of pieces of scatter-gather */
>>>> +#define VSCSIIF_SG_GRANT	0x80	/* flag: SG elements via grant page */
>>>> +					/* nr_segments counts grant pages with
>>>> +					   SG elements
>>>
>>> Stop missing. However I am a bit lost. It says that the 'nr_segments' will have the
>>> count of grant pages with SG elements. Does that mean the req.seg[0].gref points
>>> to an page which will have an array of grant references? And each grant reference
>>> will point to a data page? What about the 'offset' and 'length' of them?
>>>
>>> Or does it mean that the 'reg.seg[0].gref' points an page that is filled with
>>> 'struct scsiif_request_segment' ? If so, where would the could of those
>>> segments be in? In 'nr_segments'? If that is so where does the VSCSIIF_SG_GRANT
>>> go? Won't we collide?
>>
>> nr_segments (without the VSCSIIF_SG_GRANT bit) always counts the number
>> of populated seg[] entries. If VSCSIIF_SG_GRANT is set, each seg[] entry
>> references another array of struct scsiif_request_segment using a grant
>> ref, offset into the granted page and a length of the array in bytes.
>
> Shouldn't there be a comment about that? The blkif.h has a pretty lengthy
> one when it comes to indirect descriptors that could be copied as it
> sounds exactly like the same thing.

I already added the following:

/*
  * Request a SCSI operation specified via a CDB in vscsiif_request.cmnd.
  * The target is specified via channel, id and lun.
  * The operation to be performed is specified via a CDB in cmnd[], the 
length
  * of the CDB is in cmd_len. sc_data_direction specifies the direction 
of data
  * (to the device, from the device, or none at all).
  * If data is to be transferred to or from the device the buffer(s) in the
  * guest memory is/are specified via one or multiple scsiif_request_segment
  * descriptors each specifying a memory page via a grant_ref_t, a 
offset into
  * the page and the length of the area in that page. All 
scsiif_request_segment
  * areas concatenated form the resulting data buffer used by the operation.
  * If the number of scsiif_request_segment areas is not too large (less 
than
  * or equal VSCSIIF_SG_TABLESIZE) the areas can be specified directly 
in the
  * seg[] array and the number of valid scsiif_request_segment elements 
is to be
  * set in nr_segments.
  * If "feature-sg-grant" in the Xenstore is set it is possible to 
specify more
  * than VSCSIIF_SG_TABLESIZE scsiif_request_segment elements via 
indirection.
  * The maximum number of allowed scsiif_request_segment elements is the 
value
  * of the "feature-sg-grant" entry from Xenstore. When using 
indirection the
  * seg[] array doesn't contain specifications of the data buffers, but
  * references to scsiif_request_segment arrays, which in turn reference the
  * data buffers. While nr_segments holds the number of populated seg[] 
entries
  * (plus the set VSCSIIF_SG_GRANT bit), the number of 
scsiif_request_segment
  * elements referencing the target data buffers is calculated from the 
lengths
  * of the seg[] elements (the sum of all valid seg[].length divided by the
  * size of one scsiif_request_segment structure).
  */
#define VSCSIIF_ACT_SCSI_CDB           1

>>
>> The resulting number of struct scsiif_request_segment is the sum of
>> seg[0..nr_segments-1].length / sizeof(struct scsiif_request_segment).
>>
>
> Where the nr_segments can only go Up to VSCSIIF_SG_TABLESIZE, so the max
> total SG entries you can is 13312 ( 4096 / 8 = 512 max per page, times
> 26).

In theory, yes. SG_ALL (being 128 today) is limiting this value.


Juergen
