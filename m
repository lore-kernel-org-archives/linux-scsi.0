From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 08/10] [scsi] mpt2sas: Get IOC_FACTS information using handshake protocol only after HBA card gets into READY or Operational state.
Date: Thu, 21 Aug 2014 16:47:11 -0400
Message-ID: <yq1sikpr2nk.fsf@sermon.lab.mkp.net>
References: <1407835788-38001-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1407835788-38001-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	(Sreekanth Reddy's message of "Tue, 12 Aug 2014 14:59:48 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: martin.petersen@oracle.com, jejb@kernel.org, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

Sreekanth,

+	if (((ioc_state & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_READY) ||
+	    (ioc_state & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_OPERATIONAL)
+		return 0;

I find the following easier to read:

	switch (ioc_state & MPI2_IOC_STATE_MASK) {
        case MPI2_IOC_STATE_READY:
        case MPI2_IOC_STATE_OPERATIONAL:
             return 0;
	}

but that's just personal preference...

+	if (ioc_state & MPI2_DOORBELL_USED) {
+		dhsprintk(ioc, printk(MPT2SAS_INFO_FMT
+		    "unexpected doorbell activ!e\n", ioc->name));

Typo.

+	if ((ioc_state & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_FAULT) {

ioc_state & MPI2_IOC_STATE_MASK again. Maybe you should just introduce a
variable for that and save a bunch of parentheses?

Otherwise OK.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
