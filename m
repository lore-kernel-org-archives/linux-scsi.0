From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/2] virtio_scsi: Implement fc_host
Date: Tue, 17 Jan 2017 14:17:33 +0100
Message-ID: <4049e6cf-b398-4ebd-3248-77c333e65331@redhat.com>
References: <20170116160430.11815-1-famz@redhat.com>
 <20170116160430.11815-3-famz@redhat.com>
 <95f96b48-aa75-0094-a634-db9c13035336@redhat.com>
 <20170116172656.GB11780@lemon>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170116172656.GB11780@lemon>
Sender: linux-kernel-owner@vger.kernel.org
To: Fam Zheng <famz@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, stefanha@redhat.com, virtualization@lists.linux-foundation.org
List-Id: linux-scsi@vger.kernel.org



On 16/01/2017 18:26, Fam Zheng wrote:
>> Is the endianness correct for big-endian host here?
>
> I think so. The fc_host sysfs uses u64 to represent port_name and node_name,
> this patch does the same, so using virtio_* helpers for these fields should
> handle the endianness correctly.

I was suspicious about it because they are defined as "u8 x[8]" in the
virtio_scsi_config struct.  So you would need to read with
virtio_cread_bytes and pass the result to wwn_to_u64.

For example, if you have 0x500123456789abcd this would be

	0x50 0x01 0x23 0x45 0x67 0x89 0xab 0cd

in virtio_scsi_config, and then virtio_cread64 would read it as a
little-endian u64, 0xcdab896745230150.  Maybe your QEMU patch is also
writing things as little-endian 64-bit integers, rather than 8-element
arrays of bytes?

Paolo

> Maybe we should use u64 in struct virtio_scsi_config as well?
