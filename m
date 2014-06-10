From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH-v2 0/6] vhost/scsi: Add T10 PI SGL passthrough support
Date: Tue, 10 Jun 2014 10:03:39 +0200
Message-ID: <5396BBDB.5070107@redhat.com>
References: <1400725582-5521-1-git-send-email-nab@daterainc.com>	 <20140608160541.GA21832@redhat.com> <1402384060.5774.14.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1402384060.5774.14.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-scsi@vger.kernel.org

Il 10/06/2014 09:07, Nicholas A. Bellinger ha scritto:
>> > OK, finally went over this, looks good to me:
>> >
>> > Acked-by: Michael S. Tsirkin <mst@redhat.com>
>> >
>> > However, we really should stop making more changes
>> > before fixing ANY_LAYOUT in this driver.
>> >
>> > virtio 1.0 should be out soon and that makes ANY_LAYOUT
>> > a required feature.
>> >
> What else is required to complete the ANY_LAYOUT conversion..?

Basically, you need to stop expecting the request and response headers 
to be in a separate iov, and also vhost-scsi should not expect pi to be 
in a separate iov than the main data.  A layout that has everything in 
the same iov would be fine, and similarly for a layout that has the CDB 
in a separate iov than the rest of the header.

Paolo
