From: Andre Hedrick <andre@linux-ide.org>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Mon, 1 Dec 2003 11:23:42 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.10.10312011048410.17836-100000@master.linux-ide.org>
References: <03120119384002.08627@naveenb-lnx.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from astound-64-85-224-253.ca.astound.net ([64.85.224.253]:48905
	"EHLO master.linux-ide.org") by vger.kernel.org with ESMTP
	id S263906AbTLAT1k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Dec 2003 14:27:40 -0500
In-Reply-To: <03120119384002.08627@naveenb-lnx.cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: Naveen Burmi <naveenb@cisco.com>
Cc: hch@infradead.org, linux-scsi@vger.kernel.org


Sorry spaz attack on the first reply.

Naveen, all your memcpy of buffers did was insure the content you want
down never got there.  Committing CRC32C's on the fly in a ZERO Copy call
will require the higher levels of ERL support. ERL < 1 is a "JOKE".
Sync-and-Steering with at least ERL >= 1 will allow for content in each
PDU to be independent from the other.  Additionally one can logically
retry segments and not the entire command.

If your initiator can not tell or process the difference and know to
retry, to put it nicely "EWW".  Anyone who has ever dealt with the storage
stack in Linux knows, failing commands back up to originator is a last
effort and basically hopeless.  There are no paths back for direct
notification on real or virtual HBA to the caller.  Only if you lose a
channel or device would one abort and fail itself.

Additionally, since the Cisco 4.0.0 is just a virtual HBA, where does the
Qlogic error occur?  If the target is not capable of mapping and retrying
(real disk + real hba) transport errors to notify the initiator to retry,
well lets not go there because it will hurt.

Well I think I am going off task, sigh.

Cheers,

Andre Hedrick
LAD Storage Consulting Group

On Mon, 1 Dec 2003, Naveen Burmi wrote:

> 
> Following is a simpler explanation:
> 
> iSCSI driver computes checksum on the buffer cache data, pointed to by 
> sglist. It passes the checksum and list of data buffers to TCP layer for 
> transmission to the iSCSI target. On very rare occasions data present in the 
> buffer gets corrupted, after iSCSI driver gives the computed checksum and 
> list of data buffers to TCP layers. At the iSCSI target side checksum is 
> again calculated and compared with checksum sent along with data by iSCSI 
> driver. iSCSI target detects data crc error in case of corrupted data.
> 
> Since the data buffers(present in buffer cache) has got corrupted even if 
> iSCSI initiator driver re-tries to send data and computed checksum to target 
> and if target's checksum matches with the initiator ckecksum, the garbled 
> data gets written on to the disk(scsi target).
> 
> To prevent writing garbled data onto disk(scsi target) iSCSI driver copies 
> the buffer cache data into locally allocated buffers, computes the checksum 
> and give the list of locally allocated buffers to the TCP layer  for 
> transmission of data to iSCSI target.
> 
> Thanks,
> Naveen.
> 
> 
> On Monday 01 December 2003 06:00 pm, Naveen Burmi wrote:
> > Christoph,
> >
> > You have following review comment for linux-iscsi driver:
> > "the explanation of  PREVENT_DATA_CORRUPTION does'nt make sense".
> >
> > Following is the explanation of the requirement of 
> > "PREVENT_DATA_CORRUPTION":
> >
> > In linux kernel there is a rare occurrence of data corruption. This data
> > can be buffer cache data as well as raw I/O data. Don't know the actual
> > root cause of the problem, but the fix that we put under macro
> > "PREVENT_DATA_CORRUPTION" is capable of resolving this problem.
> >
> > Following is the scenario where we have observed this problem (still
> > persist in test9, 2.6 linux kernel):
> >
> > On iSCSI target, 5428-2, upon detecting the CRC data error by the QlogicFC
> > card it generates  the sense data with sense key as HARDWARE ERROR
> > and Additional sense data as LOGICAL UNIT COMMUNICATION FAILURE.
> > Upon receving this sense data iSCSI initiator driver is not retrying this
> > command and failing the command to the upper layers of SCSI subsystem.
> > But linux SCSI subsystem does not perform any error recovery for this kind
> > of sense data.
> >
> > Following is the fix:
> > 1) Protecting the original buffer cache and raw I/O data from getting
> > garbled. This is acheived by copying the incoming I/O buffer temporarily
> > in an internal buffer and then sending the copied data down to TCP.
> >
> > 2) Before failing the scsi command to upper SCSI layers, iSCSI driver
> > is retrying the scsi command upon receiving the sense data with sense key
> > as HARDWARE ERROR.
> >
> >
> > Are you aware of this issue OR any related issue?
> >
> > Thanks,
> > Naveen.
> >
> >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

