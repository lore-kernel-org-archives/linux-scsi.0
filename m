From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: scsi: pm8001: fix double free in pm8001_pci_probe
Date: Thu, 10 Aug 2017 20:05:37 -0400
Message-ID: <yq1poc32cku.fsf@oracle.com>
References: <1502192430-12440-1-git-send-email-bianpan2016@163.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502192430-12440-1-git-send-email-bianpan2016@163.com> (Pan
        Bian's message of "Tue, 8 Aug 2017 19:40:30 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Pan Bian <bianpan2016@163.com>
Cc: Jack Wang <jinpu.wang@profitbricks.com>, lindar_liu@usish.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Pan,

> In function pm8001_pci_probe(), on errors that the control flow jumps to
> label err_out_ha_free, function pm8001_free() is called. In pm8001_free(),
> scsi_host_put() is called to release shost, which keeps the return value
> of scsi_host_alloc(). After pm8001_free() returns, kfree() is called to
> free shost again, resulting in a double free bug. This patch removes
> scsi_host_put() from pm8001_free() and explicitly calls scsi_host_put()
> to release Scsi_Host in need.

Applied to 4.14/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
