From: Fam Zheng <famz@redhat.com>
Subject: Re: [PATCH 2/2] virtio_scsi: Implement fc_host
Date: Tue, 17 Jan 2017 22:05:00 +0800
Message-ID: <20170117140500.GA19638@lemon>
References: <20170116160430.11815-1-famz@redhat.com>
	<20170116160430.11815-3-famz@redhat.com>
	<95f96b48-aa75-0094-a634-db9c13035336@redhat.com>
	<20170116172656.GB11780@lemon>
	<4049e6cf-b398-4ebd-3248-77c333e65331@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <4049e6cf-b398-4ebd-3248-77c333e65331@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, stefanha@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Tue, 01/17 14:17, Paolo Bonzini wrote:
> 
> 
> On 16/01/2017 18:26, Fam Zheng wrote:
> >> Is the endianness correct for big-endian host here?
> >
> > I think so. The fc_host sysfs uses u64 to represent port_name and node_name,
> > this patch does the same, so using virtio_* helpers for these fields should
> > handle the endianness correctly.
> 
> I was suspicious about it because they are defined as "u8 x[8]" in the
> virtio_scsi_config struct.  So you would need to read with
> virtio_cread_bytes and pass the result to wwn_to_u64.
> 
> For example, if you have 0x500123456789abcd this would be
> 
> 	0x50 0x01 0x23 0x45 0x67 0x89 0xab 0cd
> 
> in virtio_scsi_config, and then virtio_cread64 would read it as a
> little-endian u64, 0xcdab896745230150.  Maybe your QEMU patch is also
> writing things as little-endian 64-bit integers, rather than 8-element
> arrays of bytes?

Yes, they all used 64-bit integers in a "less surprising" endian. I think there
is an endianness conecpt to WWN, as in 0x500123456789abcd; and there is an
native endianness to virtio, which is little-endian. If we use a "u8 x[8]" type
in the spec and want the WWN's MSB, namely the 0x50 stuff, to be the first byte,
is it worth to explicitly document that to avoid confusion?

Fam
