From: Naveen Burmi <naveenb@cisco.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Mon, 1 Dec 2003 19:38:40 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <03120119384002.08627@naveenb-lnx.cisco.com>
References: <03120118001300.08627@naveenb-lnx.cisco.com>
Reply-To: naveenb@cisco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:65165 "EHLO
	sj-iport-3.cisco.com") by vger.kernel.org with ESMTP
	id S262868AbTLAOGI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Dec 2003 09:06:08 -0500
In-Reply-To: <03120118001300.08627@naveenb-lnx.cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: linux-scsi@vger.kernel.org


Following is a simpler explanation:

iSCSI driver computes checksum on the buffer cache data, pointed to by 
sglist. It passes the checksum and list of data buffers to TCP layer for 
transmission to the iSCSI target. On very rare occasions data present in the 
buffer gets corrupted, after iSCSI driver gives the computed checksum and 
list of data buffers to TCP layers. At the iSCSI target side checksum is 
again calculated and compared with checksum sent along with data by iSCSI 
driver. iSCSI target detects data crc error in case of corrupted data.

Since the data buffers(present in buffer cache) has got corrupted even if 
iSCSI initiator driver re-tries to send data and computed checksum to target 
and if target's checksum matches with the initiator ckecksum, the garbled 
data gets written on to the disk(scsi target).

To prevent writing garbled data onto disk(scsi target) iSCSI driver copies 
the buffer cache data into locally allocated buffers, computes the checksum 
and give the list of locally allocated buffers to the TCP layer  for 
transmission of data to iSCSI target.

Thanks,
Naveen.


On Monday 01 December 2003 06:00 pm, Naveen Burmi wrote:
> Christoph,
>
> You have following review comment for linux-iscsi driver:
> "the explanation of  PREVENT_DATA_CORRUPTION does'nt make sense".
>
> Following is the explanation of the requirement of 
> "PREVENT_DATA_CORRUPTION":
>
> In linux kernel there is a rare occurrence of data corruption. This data
> can be buffer cache data as well as raw I/O data. Don't know the actual
> root cause of the problem, but the fix that we put under macro
> "PREVENT_DATA_CORRUPTION" is capable of resolving this problem.
>
> Following is the scenario where we have observed this problem (still
> persist in test9, 2.6 linux kernel):
>
> On iSCSI target, 5428-2, upon detecting the CRC data error by the QlogicFC
> card it generates  the sense data with sense key as HARDWARE ERROR
> and Additional sense data as LOGICAL UNIT COMMUNICATION FAILURE.
> Upon receving this sense data iSCSI initiator driver is not retrying this
> command and failing the command to the upper layers of SCSI subsystem.
> But linux SCSI subsystem does not perform any error recovery for this kind
> of sense data.
>
> Following is the fix:
> 1) Protecting the original buffer cache and raw I/O data from getting
> garbled. This is acheived by copying the incoming I/O buffer temporarily
> in an internal buffer and then sending the copied data down to TCP.
>
> 2) Before failing the scsi command to upper SCSI layers, iSCSI driver
> is retrying the scsi command upon receiving the sense data with sense key
> as HARDWARE ERROR.
>
>
> Are you aware of this issue OR any related issue?
>
> Thanks,
> Naveen.
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

