From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5/6] vhost/scsi: Enable T10 PI IOV -> SGL memory mapping
Date: Tue, 08 Apr 2014 16:36:08 -0400
Message-ID: <53445DB8.2010705@redhat.com>
References: <1396819929-29687-1-git-send-email-nab@daterainc.com> <1396819929-29687-6-git-send-email-nab@daterainc.com> <20140407091654.GC14183@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20140407091654.GC14183@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>, "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>
List-Id: linux-scsi@vger.kernel.org

Il 07/04/2014 05:16, Michael S. Tsirkin ha scritto:
> Hmm still relying on a specific IOV layout I see :(
> It's really a violation of the spec even though it works
> fine with Linux guests.
> I know this isn't the only place this is broken but
> can't we finally fix it?
> Since you are touching this code anyway - how about
> not adding more code we need to fix later?
>
> It's not too hard - just verify total length is big enough
> (instead of an exact match), then call
> memcpy_fromiovecend/memcpy_toiovecend.
> (or memcpy_fromiovec if you don't mind that iovec is modified).
>
> This will help make sure
> we are not making interface mistakes like we did for block
> with VIRTIO_BLK_T_SCSI_CMD.

And like we were about to make here. :(

We really should fix this for kernel 3.16 and QEMU 2.1.

Paolo
