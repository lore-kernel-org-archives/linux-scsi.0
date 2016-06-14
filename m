From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4] ibmvscsis: Initial commit of IBM VSCSI Tgt Driver
Date: Tue, 14 Jun 2016 07:57:28 -0700
Message-ID: <20160614145728.GB18075@infradead.org>
References: <1464409675.22249.237.camel@haakon3.risingtidesystems.com>
 <1465507614-29695-1-git-send-email-bryantly@linux.vnet.ibm.com>
 <c5aa5fec-3499-a899-aa22-07c655311e20@sandisk.com>
 <1465886151.5365.220.camel@haakon3.risingtidesystems.com>
 <9e27fd8d-6e9e-6ec5-abb8-49e405143e48@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9e27fd8d-6e9e-6ec5-abb8-49e405143e48@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, hch@infradead.org, mikecyr@linux.vnet.ibm.com, James.Bottomley@HansenPartnership.com, tyreld@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, akpm@linux-foundation.org, gregkh@linuxfoundation.org, joe@perches.com, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 14, 2016 at 10:46:09AM +0200, Bart Van Assche wrote:
> All what's needed is something like the (untested) patch below. As one
> can see no new function pointers have been added to target_core_fabric_ops.
> All that has been added are a few new data members. With the patch below
> ibmvscsis_modify_std_inquiry() can be left out and the target core will
> pick up the "IBM", "VOPTA", "3303 NVDISK" and "0001" strings through the
> target_core_fabric_ops instance in the ibmvscsis template. I think this is
> a much cleaner approach than keeping the ibmvscsis_modify_std_inquiry()
> function ...

If we really have to, yes.  But then again we manually allow overriding
the values from configfs, and none of this seems to be a protocol
requirement but just a workaround for a braindead AIX initiator.  So
the right thing is documentation telling people how to modify their
inquiry strings for AIX to work.
