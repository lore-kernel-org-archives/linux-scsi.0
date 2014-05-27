From: "Black, David" <david.black@emc.com>
Subject: RE: iSCSI Expected Data Transfer Length for T10-PI
Date: Tue, 27 May 2014 07:58:22 -0400
Message-ID: <8D3D17ACE214DC429325B2B98F3AE712076C662FE9@MX15A.corp.emc.com>
References: <53820C9B.3090003@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <53820C9B.3090003@dev.mellanox.co.il>
Content-Language: en-US
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Oren Duer <oren@mellanox.com>, "james.smart@emulex.com" <james.smart@emulex.com>, Or Gerlitz <ogerlitz@mellanox.com>, "cbm@chadalapaka.com" <cbm@chadalapaka.com>, "julians@infinidat.com" <julians@infinidat.com>, "meth@il.ibm.com" <meth@il.ibm.com>, "blaine@ethernetalliance.org" <blaine@ethernetalliance.org>, "Black, David" <david.black@emc.com>
List-Id: linux-scsi@vger.kernel.org

Hi Sagi,

> RFC-7143 states:
> "the Expected Data Transfer Length field contains the number of bytes of
> data involved in this SCSI operation."
> Since this field relates to *data bytes* I kept T10-PI implicit wrt this
> field. The iSCSI target calculates the
> total transfer length (data + protection) from the cdb transfer length
> field and protect bits.

That is wrong.  At the SCSI transport interface (both iSCSI and FCP are
SCSI transports), the concept of "data bytes" includes SCSI protection
information.

> In FC, the fc_dl field was updated to relate to the total number of
> transfer bytes and includes
> data and protection bytes. virtio_scsi was added with a header PI
> section (virtio_scsi_cmd_req_pi).

That is the correct approach.

At the SCSI transport interface (both FCP and iSCSI are SCSI transports),
no distinction is made between user data and protection information.
therefore, a transfer of 512 bytes of user data + 8 bytes of protection
information is a 520 byte transfer for both protocols.

The authority for this is SAM-5, or SAM-4 if one wants to refer to an
approved standard.  Neither are open to interpretation on this point.

All SCSI transports are supposed to behave the same way.  I hope this
can be corrected quickly.

Thanks,
--David


> -----Original Message-----
> From: Sagi Grimberg [mailto:sagig@dev.mellanox.co.il]
> Sent: Sunday, May 25, 2014 11:31 AM
> To: martin.petersen@oracle.com; Mike Christie; Nicholas A. Bellinger
> Cc: linux-scsi; target-devel; Oren Duer; james.smart@emulex.com; Or Gerlitz;
> cbm@chadalapaka.com; julians@infinidat.com; meth@il.ibm.com; Black, David
> Subject: iSCSI Expected Data Transfer Length for T10-PI
> 
> Hey All,
> 
> Recently, iSER end-to-end T10-PI support maid it mainline.
> I am wandering about the impact T10-PI should or shouldn't have on iSCSI
> header
> field "Expected Data Transfer Length".
> 
> RFC-7143 states:
> "the Expected Data Transfer Length field contains the number of bytes of
> data involved in this SCSI operation."
> Since this field relates to *data bytes* I kept T10-PI implicit wrt this
> field. The iSCSI target calculates the
> total transfer length (data + protection) from the cdb transfer length
> field and protect bits.
> 
> In FC, the fc_dl field was updated to relate to the total number of
> transfer bytes and includes
> data and protection bytes. virtio_scsi was added with a header PI
> section (virtio_scsi_cmd_req_pi).
> 
> So my question is, should this field be updated to explicitly include
> T10-PI bytes like the FC equivalent fc_dl?
> Or should T10-PI bytes be implicit?
> 
> I want to pin down this one to avoid a situation where the standard is
> open for interpretations.
> 
> Thanks,
> Sagi.
