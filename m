From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/3] scsi: Add Hyper-V logical block provisioning quirks
Date: Wed, 22 Oct 2014 21:50:22 -0400
Message-ID: <yq1a94nwo4h.fsf@sermon.lab.mkp.net>
References: <20141010074901.GA32028@sucs.org>
 <yq1r3ya6t0i.fsf@sermon.lab.mkp.net> <20141021041707.GA11691@sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20141021041707.GA11691@sucs.org> (Sitsofe Wheeler's message of
 "Tue, 21 Oct 2014 05:17:08 +0100")
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Hannes Reinecke <hare@suse.de>, devel@linuxdriverproject.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sitsofe" == Sitsofe Wheeler <sitsofe@gmail.com> writes:

Sitsofe> 2. On top of the above, when a disk is "small" (has less than
Sitsofe>    2^32 sectors which is typically < 2 TBytes in size) READ
Sitsofe>    CAPACITY(16) won't be triggered.

static int sd_try_rc16_first(struct scsi_device *sdp)
{
        if (sdp->host->max_cmd_len < 16)
                return 0;
        if (sdp->try_rc_10_first)
                return 0;
        if (sdp->scsi_level > SCSI_SPC_2)
                return 1;
        if (scsi_device_protection(sdp))
                return 1;
        return 0;
}

-- 
Martin K. Petersen	Oracle Linux Engineering
