From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 03/13] mpt3sas: SGL to PRP Translation for I/Os to NVMe  devices
Date: Tue, 08 Aug 2017 12:12:13 -0400
Message-ID: <yq1o9rq6ntu.fsf@oracle.com>
References: <1502183035-7441-1-git-send-email-suganath-prabu.subramani@broadcom.com>
        <1502183035-7441-4-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502183035-7441-4-git-send-email-suganath-prabu.subramani@broadcom.com>
        (Suganath Prabu S.'s message of "Tue, 8 Aug 2017 14:33:45 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Cc: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, linux-kernel@vger.kernel.org, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com, linux-nvme@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org


Suganath,

> +	/*
> +	 ** Below code detects gaps/holes in IO data buffers.
> +	 ** What does holes/gaps mean?
> +	 ** Any SGE except first one in a SGL starts at non NVME page size
> +	 ** aligned address OR Any SGE except last one in a SGL ends at
> +	 ** non NVME page size boundary.
> +	 **
> +	 ** Driver has already informed block layer by setting boundary rules
> +	 ** for bio merging done at NVME page size boundary calling kernel API
> +	 ** blk_queue_virt_boundary inside slave_config.
> +	 ** Still there is possibility of IO coming with holes to driver because
> +	 ** of IO merging done by IO scheduler.

All this SGL to PRP code needs to go.

If you are seeing anything that's not a valid PRP after setting the
queue virt boundary then there's a block layer bug that needs to be
debugged and fixed. Regardless of whether you are using an I/O scheduler
or not.

-- 
Martin K. Petersen	Oracle Linux Engineering
