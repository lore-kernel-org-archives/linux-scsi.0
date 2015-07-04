From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH RFC] target: Use scsi helpers to build the sense data
 correctly
Date: Sat, 4 Jul 2015 13:48:03 +0300
Message-ID: <5597B9E3.70901@dev.mellanox.co.il>
References: <1435590325-23381-1-git-send-email-sagig@mellanox.com>
 <20150703161236.GA32744@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150703161236.GA32744@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagig@mellanox.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: linux-scsi@vger.kernel.org

On 7/3/2015 7:12 PM, Christoph Hellwig wrote:
> On Mon, Jun 29, 2015 at 06:05:25PM +0300, Sagi Grimberg wrote:
>> Instead of open coding the sense buffer construction, use
>> scsi scsi_build_sense_buffer() and scsi_set_sense_information()
>> helpers.
>>
>> This patch also fixes wrong setting of descriptor format sense data
>> for t10-pi integrity errors.
>
> This looks good in general, but we'd need to move this functions to
> the scsi common module first now that the target code doesn't use
> scsi_mod.ko. (Oh, for some reason 4.2 still builds scsi_common.c into
> scsi_mod.ko, but in the long run it shouldn't).

Yes I figured that these functions need to move to scsi_common.[ch]

>
> Whie we're at it I'd also really love to Barts sense handling
> updates to go in:
>
> https://github.com/bvanassche/linux/commit/c8e3ccce0753522cff50987db8e411be2b452cdd
> https://github.com/bvanassche/linux/commit/50e0e2c6681091cda23e677fe9b6fbd2c70d99b1
> https://github.com/bvanassche/linux/commit/02b27ec5c94117a976e16421556c1cb7287b6635
>
> Bart, any chance you could resend them?
>

Bart, would you prefer to re-send your changes on top of v1 of this one?
It should be easy enough.

The modification needed is that struct sense_info needs a desc_format
bool to indicate if the sense data is constructed in a descriptor
format sense data or not.
